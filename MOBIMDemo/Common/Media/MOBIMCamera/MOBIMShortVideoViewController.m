//
//  MOBIMShortVideoViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/30.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMShortVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MOBIMShortAVPlayer.h"
#import "MOBIMProgressView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MOBIMGConst.h"
#import "Masonry.h"
#import "UIViewController+MOBIMToast.h"
#import "MOBIMGConst.h"
#import "AppDelegate.h"

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface MOBIMShortVideoViewController ()<AVCaptureFileOutputRecordingDelegate>
//轻触拍照，按住摄像
@property (strong, nonatomic)  UILabel *labelTipTitle;

//视频输出流
@property (strong, nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;
//图片输出流
//@property (strong, nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
//负责从AVCaptureDevice获得输入数据
@property (strong, nonatomic) AVCaptureDeviceInput *captureDeviceInput;
//后台任务标识
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (assign, nonatomic) UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier;

@property (strong, nonatomic)  UIImageView *focusCursor; //聚焦光标

//负责输入和输出设备之间的数据传递
@property (nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property (nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic)  UIButton *btnBack;
//重新录制
@property (strong, nonatomic)  UIButton *btnAfresh;
//确定
@property (strong, nonatomic)  UIButton *btnEnsure;
//摄像头切换
@property (strong, nonatomic)  UIButton *btnCamera;

@property (strong, nonatomic)  UIImageView *bgView;
//记录录制的时间 默认最大60秒
@property (assign, nonatomic) NSInteger seconds;

//记录需要保存视频的路径
@property (strong, nonatomic) NSURL *saveVideoUrl;

//是否在对焦
@property (assign, nonatomic) BOOL isFocus;
//@property (strong, nonatomic)  NSLayoutConstraint *afreshCenterX;
//@property (strong, nonatomic)  NSLayoutConstraint *ensureCenterX;
//@property (strong, nonatomic)  NSLayoutConstraint *backCenterX;

//视频播放
@property (strong, nonatomic) MOBIMShortAVPlayer *player;

@property (strong, nonatomic)  MOBIMProgressView *progressView;

//是否是摄像 YES 代表是录制  NO 表示拍照
@property (assign, nonatomic) BOOL isVideo;

@property (strong, nonatomic) UIImage *takeImage;
@property (strong, nonatomic) UIImageView *takeImageView;
@property (strong, nonatomic) UIImageView *imgRecord;


@end

//时间大于这个就是视频，否则为拍照
#define TimeMax 1

@implementation MOBIMShortVideoViewController

- (void)dealloc{
    [self removeNotification];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor grayColor];
    [self loadUI];
    
    
    //UIImage *image = [UIImage imageNamed:@"sc_btn_take.png"];
    //self.backCenterX.constant = -(SCREEN_WIDTH/2/2)-image.size.width/2/2;
    
    
    if (self.maxSeconds == 0) {
        self.maxSeconds = 60;
    }
    
    
    [self performSelector:@selector(hiddenTipsLabel) withObject:nil afterDelay:4];
    
}


- (void)loadUI
{
    
    self.bgView = [[UIImageView alloc] init];
    [self.view addSubview:self.bgView];
    
//    self.bgView.image = [UIImage imageNamed:@"navbartop"];
    
    
    //摄像头切换
    self.btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnCamera setBackgroundImage:[UIImage imageNamed:@"btn_video_flip_camera.png"] forState:UIControlStateNormal];
    [self.btnCamera addTarget:self action:@selector(onCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnCamera];
    
    //聚焦
    self.focusCursor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hVideo_focusing"]];
    self.focusCursor.frame= CGRectMake(0, 0, 60, 60);
    [self.view addSubview:self.focusCursor];
    
    self.takeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hVideo_take"]];
    [self.view addSubview:self.focusCursor];
    
    self.labelTipTitle = [[UILabel alloc] init];
    self.labelTipTitle.font=[UIFont systemFontOfSize:13];
    self.labelTipTitle.backgroundColor=[UIColor clearColor];
    self.labelTipTitle.textColor = [UIColor lightGrayColor];
    self.labelTipTitle.text =@"轻触拍照，按住摄像";
    [self.view addSubview:self.labelTipTitle];
    
    
    self.btnBack = [[UIButton alloc] init];
    [self.btnBack setImage:[UIImage imageNamed:@"hVideo_back"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(onCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnBack];
    
    
    self.btnEnsure = [[UIButton alloc] init];
    [self.btnEnsure setBackgroundImage:[UIImage imageNamed:@"hVideo_confirm"] forState:UIControlStateNormal];
    [self.btnEnsure addTarget:self action:@selector(onEnsureAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnEnsure];
    
    self.btnAfresh = [[UIButton alloc] init];
    [self.btnAfresh setBackgroundImage:[UIImage imageNamed:@"hVideo_cancel"] forState:UIControlStateNormal];
    [self.view addSubview:self.btnAfresh];
    [self.btnAfresh addTarget:self action:@selector(onAfreshAction:) forControlEvents:UIControlEventTouchUpInside];
    

    
    self.imgRecord = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hVideo_take"]];
    self.imgRecord.userInteractionEnabled = YES;
    [self.view addSubview:self.imgRecord];
    
    
    
    
    self.progressView=[[MOBIMProgressView alloc] init];
    self.progressView.layer.cornerRadius = self.progressView.frame.size.width/2;
    self.progressView.backgroundColor = [UIColor colorWithRed:174/255.0 green:178/255.0 blue:172/255.0 alpha:1];
    self.progressView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.progressView];
    self.progressView.hidden = YES;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo((MOBIM_iPhoneX?(MOBIM_StatusBarHeight):0));
        make.bottom.mas_equalTo(-MOBIM_TabbarSafeBottomMargin);
        //NSLog(@"----%f",MOBIM_TabbarSafeBottomMargin);
    }];
    
    //布局
    [self.btnCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.trailing.mas_equalTo(-15);
        make.top.mas_equalTo(23 + (MOBIM_iPhoneX?(MOBIM_StatusBarHeight):0));
    }];
    
    MOBIMWEAKSELF
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(120);
        make.bottom.mas_equalTo(-28 - MOBIM_TabbarSafeBottomMargin);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        
    }];
    
    
    [self.imgRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.progressView.mas_centerX);
        make.bottom.mas_equalTo(-52 - MOBIM_TabbarSafeBottomMargin);
        make.width.height.mas_equalTo(67);
    }];
    
    [self.btnEnsure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.progressView.mas_centerX);
        make.bottom.mas_equalTo(-52 - MOBIM_TabbarSafeBottomMargin);
        make.width.height.mas_equalTo(67);
    }];
    
    [self.btnAfresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.progressView.mas_centerX);
        make.bottom.mas_equalTo(-52 - MOBIM_TabbarSafeBottomMargin);
        make.width.height.mas_equalTo(67);
    }];
    
    [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerY.equalTo(weakSelf.progressView.mas_centerY);
        make.leading.mas_equalTo(68);
    }];
    
    self.focusCursor.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)hiddenTipsLabel {
    self.labelTipTitle.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self customCamera];
    [self.session startRunning];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.focusCursor.hidden = NO;
    [self setFocusCursorWithPoint:self.bgView.center];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.session stopRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)customCamera {
    
    //初始化会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc] init];
    //设置分辨率 (设备支持的最高分辨率)
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    }
    //取得后置摄像头
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    //初始化输入设备
    NSError *error = nil;
    if (captureDevice) {
        self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    }
    if (error) {
        //MOBIMLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    //添加音频
    error = nil;
    AVCaptureDeviceInput *audioCaptureDeviceInput = nil;
    if (audioCaptureDevice)
    {
       audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    }
    if (error) {
        MOBIMLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
//        return;
    }
    
    //输出对象
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];//视频输出
    
    //将输入设备添加到会话
    if ([self.session canAddInput:self.captureDeviceInput]) {
        
        if (self.captureDeviceInput)
        {
            [self.session addInput:self.captureDeviceInput];
        }
        
        if (audioCaptureDeviceInput) {
            [self.session addInput:audioCaptureDeviceInput];
        }
        //设置视频防抖
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
        
        //处理按钮不能点击
    }
    else
    {
        self.imgRecord.userInteractionEnabled = NO;

    }
    
    //将输出设备添加到会话 (刚开始 是照片为输出对象)
    if (self.captureMovieFileOutput && [self.session canAddOutput:self.captureMovieFileOutput]) {
        [self.session addOutput:self.captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0 , self.view.width, self.view.height - (MOBIM_iPhoneX?(MOBIM_StatusBarHeight):0) - MOBIM_TabbarSafeBottomMargin);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    [self.bgView.layer addSublayer:self.previewLayer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
}



- (IBAction)onCancelAction:(UIButton *)sender {
    
    MOBIMWEAKSELF
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf dismissToast];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] view] == self.imgRecord) {
        MOBIMLog(@"开始录制");
        //根据设备输出获得连接
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeAudio];
        //根据连接取得设备输出的数据
        if (![self.captureMovieFileOutput isRecording]) {
            //如果支持多任务则开始多任务
            if ([[UIDevice currentDevice] isMultitaskingSupported]) {
                self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            }
            
            //同事删除临时文件
            if (self.saveVideoUrl) {
                [[NSFileManager defaultManager] removeItemAtURL:self.saveVideoUrl error:nil];
            }
            //预览图层和视频方向保持一致
            connection.videoOrientation = [self.previewLayer connection].videoOrientation;
            NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
            MOBIMLog(@"save path is :%@",outputFielPath);
            NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
            
            //删除上次的遗留文件
            if ([[NSFileManager defaultManager] fileExistsAtPath:outputFielPath]) {
                [[NSFileManager defaultManager] removeItemAtURL:fileUrl error:nil];
            }
            
            MOBIMLog(@"fileUrl:%@",fileUrl);
            [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
        } else {
            [self.captureMovieFileOutput stopRecording];
        }
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] view] == self.imgRecord) {
        MOBIMLog(@"结束触摸");
        if (!self.isVideo) {
            [self performSelector:@selector(endRecord) withObject:nil afterDelay:0.3];
        } else {
            [self endRecord];
        }
    }
}

- (void)endRecord {
    [self.captureMovieFileOutput stopRecording];//停止录制
}

- (IBAction)onAfreshAction:(UIButton *)sender {
    MOBIMLog(@"重新录制");
    [self recoverLayout];
}

- (IBAction)onEnsureAction:(UIButton *)sender {
    MOBIMLog(@"确定 这里进行保存或者发送出去");
    if (self.saveVideoUrl) {
        MOBIMWEAKSELF
        [self showToastWithStatus:@"视频处理中..."];
        ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:self.saveVideoUrl completionBlock:^(NSURL *assetURL, NSError *error) {
            MOBIMLog(@"outputUrl:%@", weakSelf.saveVideoUrl);
            if (weakSelf.lastBackgroundTaskIdentifier!= UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:weakSelf.lastBackgroundTaskIdentifier];
            }
            if (error) {
                MOBIMLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
                [weakSelf showAllTextDialog:[MOBIMAppDelegate window] Text:@"保存视频到相册发生错误"];
            } else {
                
                //转换压缩文件
                                [self getFileSize:[self.saveVideoUrl path]];
                                [self convertMp4:self.saveVideoUrl.path finished:^(NSString *path) {
                
                                    if (weakSelf.takeBlock) {
                                        weakSelf.takeBlock(path);
                                    }
                                    // 删除原录制的文件
                                    if ([[NSFileManager defaultManager] fileExistsAtPath:self.saveVideoUrl.path]) {
                                        [[NSFileManager defaultManager] removeItemAtPath:self.saveVideoUrl.path error:nil];
                                    }
                                }];
                
                
                
                MOBIMLog(@"成功保存视频到相簿.");
                [weakSelf onCancelAction:nil];
            }
        }];
    } else {
        //照片
        UIImageWriteToSavedPhotosAlbum(self.takeImage, self, nil, nil);
        if (self.takeBlock) {
            self.takeBlock(self.takeImage);
        }
        
        [self onCancelAction:nil];
    }
}



- (NSURL *)convertMp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    MOBIMLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    MOBIMLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    MOBIMLog(@"completed.");
                } break;
                default: {
                    MOBIMLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            MOBIMLog(@"timeout.");
        }
        if (wait) {
            wait = nil;
        }
    }
    
    return mp4Url;
}

// file size
- (CGFloat)getFileSize:(NSString *)path
{
    NSDictionary *outputFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    //    ICLog(@"file size : %f",[outputFileAttributes fileSize]/1024.0/1024.0);
    return [outputFileAttributes fileSize]/1024.0/1024.0;
}

// convert and compress video
- (NSString *)convertMp4:(NSString *)path finished:(TakeOperationSureBlock)finish
{
    NSURL *url = [NSURL fileURLWithPath:path];
    // 获取文件资源
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    // 导出资源属性
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    // 是否包含中分辨率，如果是低分辨率AVAssetExportPresetLowQuality则不清晰
    if ([presets containsObject:AVAssetExportPresetMediumQuality]) {
        // 重定义资源属性
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        // 压缩后的文件路径
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
        NSString *videoName = [formatter stringFromDate:[NSDate date]];
        NSString *outPutPath = [self videoPathWithFileName:videoName];
        exportSession.outputURL = [NSURL fileURLWithPath:outPutPath];
        exportSession.shouldOptimizeForNetworkUse = YES;// 是否对网络进行优化
        exportSession.outputFileType = AVFileTypeMPEG4; // 转成MP4
        
        
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        // 导出
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    MOBIMLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    MOBIMLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getFileSize:outPutPath];
                        // 这里完成了压缩
                        if (finish) finish(outPutPath);
                        
                    });
                } break;
                default: {
                    MOBIMLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            MOBIMLog(@"timeout.");
        }
        if (wait) {
            wait = nil;
        }
            
        return outPutPath;
    }
    return nil;
}

#pragma mark - Private Method

- (NSString *)videoPathWithFileName:(NSString *)videoName fileDir:(NSString *)fileDir {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreatDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreatDir) {
            return nil;
        }
    }
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",videoName,KMOBIMChatMessageVideoType]];
}

// video的路径
- (NSString *)videoPathWithFileName:(NSString *)videoName
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:KMOBIMChatMessageVideoPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreatDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreatDir) {
            return nil;
        }
    }
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",videoName,KMOBIMChatMessageVideoType]];
}



//前后摄像头的切换
- (IBAction)onCameraAction:(UIButton *)sender {
    MOBIMLog(@"切换摄像头");
    AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;//前
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;//后
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.session beginConfiguration];
    //移除原有输入对象
    [self.session removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.session canAddInput:toChangeDeviceInput]) {
        [self.session addInput:toChangeDeviceInput];
        self.captureDeviceInput = toChangeDeviceInput;
    }
    //提交会话配置
    [self.session commitConfiguration];
}

- (void)onStartTranscribe:(NSURL *)fileURL {
    if ([self.captureMovieFileOutput isRecording]) {
        -- self.seconds;
        if (self.seconds > 0) {
            if (self.maxSeconds - self.seconds >= TimeMax && !self.isVideo) {
                self.isVideo = YES;//长按时间超过TimeMax 表示是视频录制
                self.progressView.timeMax = self.seconds;
                
                if (self.btnBack.hidden == NO) {
                    self.btnBack.hidden = YES;

                    MOBIMWEAKSELF
                    self.imgRecord.image = [UIImage imageNamed:@"hVideo_takemax"];
                    [self.imgRecord mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(weakSelf.progressView.mas_centerX);
                        make.bottom.mas_equalTo(-28 - MOBIM_TabbarSafeBottomMargin);
                        make.width.height.mas_equalTo(120);
                    }];
                }
            }
            [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
        } else {
            if ([self.captureMovieFileOutput isRecording]) {
                [self.captureMovieFileOutput stopRecording];
            }
        }
    }
}


#pragma mark - 视频输出代理
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    MOBIMLog(@"开始录制...");
    self.seconds = self.maxSeconds;
    [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
}


- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    MOBIMLog(@"视频录制完成.");
    [self changeLayout];
    if (self.isVideo) {
        self.saveVideoUrl = outputFileURL;
        if (!self.player) {
            self.player = [[MOBIMShortAVPlayer alloc] initWithFrame:CGRectMake(0, 0, self.bgView.bounds.size.width, self.bgView.bounds.size.height) withShowInView:self.bgView url:outputFileURL];
        } else {
            if (outputFileURL) {
                self.player.videoUrl = outputFileURL;
                self.player.hidden = NO;
            }
        }
    } else {
        //照片
        self.saveVideoUrl = nil;
        [self videoHandlePhoto:outputFileURL];
    }
    
}

- (void)videoHandlePhoto:(NSURL *)url {
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    NSError *error = nil;
    CMTime time = CMTimeMake(0,30);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actucalTime; //缩略图实际生成的时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        MOBIMLog(@"截取视频图片失败:%@",error.localizedDescription);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    if (image) {
        MOBIMLog(@"视频截取成功");
    } else {
        MOBIMLog(@"视频截取失败");
    }
    
    
    self.takeImage = image;//[UIImage imageWithCGImage:cgImage];
    
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    
    if (!self.takeImageView) {
        self.takeImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.takeImageView];
    }
    self.takeImageView.hidden = NO;
    self.takeImageView.image = self.takeImage;
}

#pragma mark - 通知

//注册通知
- (void)setupObservers
{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
}

//进入后台就退出视频录制
- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self onCancelAction:nil];
}

/**
 *  给输入设备添加通知
 */
- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
- (void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
- (void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
- (void)deviceConnected:(NSNotification *)notification{
    MOBIMLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
- (void)deviceDisconnected:(NSNotification *)notification{
    MOBIMLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
- (void)areaChange:(NSNotification *)notification{
    MOBIMLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
- (void)sessionRuntimeError:(NSNotification *)notification{
    MOBIMLog(@"会话发生错误.");
}



/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        //自动白平衡
        if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        //自动根据环境条件开启闪光灯
        if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        MOBIMLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
- (void)setFlashMode:(AVCaptureFlashMode )flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}
/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
- (void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}
/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
- (void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}
/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        //        if ([captureDevice isFocusPointOfInterestSupported]) {
        //            [captureDevice setFocusPointOfInterest:point];
        //        }
        //        if ([captureDevice isExposurePointOfInterestSupported]) {
        //            [captureDevice setExposurePointOfInterest:point];
        //        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

/**
 *  添加点按手势，点按时聚焦
 */
- (void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.bgView addGestureRecognizer:tapGesture];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    if ([self.session isRunning]) {
        
        
        self.focusCursor.hidden = NO;
        CGPoint point= [tapGesture locationInView:self.bgView];
        //将UI坐标转化为摄像头坐标
        CGPoint cameraPoint= [self.previewLayer captureDevicePointOfInterestForPoint:point];
        [self setFocusCursorWithPoint:point];
        [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
    }
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
- (void)setFocusCursorWithPoint:(CGPoint)point{
    if (!self.isFocus) {
        self.isFocus = YES;
        self.focusCursor.center=point;
        self.focusCursor.transform = CGAffineTransformMakeScale(1.25, 1.25);
        self.focusCursor.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.focusCursor.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(onHiddenFocusCurSorAction) withObject:nil afterDelay:0.5];
        }];
    }
}

- (void)onHiddenFocusCurSorAction {
    self.focusCursor.alpha=0;
    self.isFocus = NO;
}

//拍摄完成时调用
- (void)changeLayout {
    self.imgRecord.hidden = YES;
    self.btnCamera.hidden = YES;
    self.btnAfresh.hidden = NO;
    self.btnEnsure.hidden = NO;
    self.btnBack.hidden = YES;
    if (self.isVideo) {
        [self.progressView clearProgress];
    }
    
    //self.afreshCenterX.constant = -(SCREEN_WIDTH/2/2);
    //self.ensureCenterX.constant = SCREEN_WIDTH/2/2;
    
    MOBIMWEAKSELF
    float centerX = -MOIMDevice_Width/2/2;
    [self.btnEnsure mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.progressView.mas_centerX).offset(centerX);
    }];
    
    [self.btnAfresh mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.progressView.mas_centerX).offset(-centerX);
    }];
    
    self.imgRecord.image = [UIImage imageNamed:@"hVideo_take"];
    [self.imgRecord mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.progressView.mas_centerX);
        make.bottom.mas_equalTo(-56 - MOBIM_TabbarSafeBottomMargin);
        make.width.height.mas_equalTo(67);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    [self.session stopRunning];
}


//重新拍摄时调用
- (void)recoverLayout {
    if (self.isVideo) {
        self.isVideo = NO;
        [self.player stopPlayer];
        self.player.hidden = YES;
    }
    [self.session startRunning];
    
    if (!self.takeImageView.hidden) {
        self.takeImageView.hidden = YES;
    }
    //    self.saveVideoUrl = nil;
    
    //self.afreshCenterX.constant = 0;
    //self.ensureCenterX.constant = 0;
    
    MOBIMWEAKSELF
    [self.btnEnsure mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.progressView.mas_centerX);
    }];
    
    [self.btnAfresh mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.progressView.mas_centerX);
        
    }];
    
    self.imgRecord.image = [UIImage imageNamed:@"hVideo_take"];
    [self.imgRecord mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.progressView.mas_centerX);
        make.bottom.mas_equalTo(-56 - MOBIM_TabbarSafeBottomMargin);
        make.width.height.mas_equalTo(67);
    }];
    
    self.imgRecord.hidden = NO;
    self.btnCamera.hidden = NO;
    self.btnAfresh.hidden = YES;
    self.btnEnsure.hidden = YES;
    self.btnBack.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}


@end

