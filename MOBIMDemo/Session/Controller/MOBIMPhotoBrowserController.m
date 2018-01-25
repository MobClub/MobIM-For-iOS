//
//  ICPhotoBrowserController.m
//  XZ_WeChat
//
//  Created by hower on 17/10/12.
//  Copyright © 2017年 MOB All rights reserved.
//

#import "MOBIMPhotoBrowserController.h"
#import "UIView+MOBIMExtention.h"
#import "MBProgressHUD.h"
#import "UIViewController+MOBIMToast.h"
#import "MOBIMDownloadManager.h"
#import "MOBIMImageManager.h"

@interface MOBIMPhotoBrowserController ()<UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *moreImageButton;

@property (nonatomic, assign) BOOL isDowning;


// 缩放比例
@property (nonatomic, assign) int scale;

@end

@implementation MOBIMPhotoBrowserController


- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        [self setupUI];
        self.image  = image;
        self.view.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
        tap.numberOfTapsRequired    = 1;
        [self.view addGestureRecognizer:tap];
    }
    return self;
}


- (instancetype)initWithThumnailImage:(UIImage *)thumnailImage image:(UIImage*)image imageUrl:(NSString*)imageUrl
{
    if (self = [super init]) {
        [self setupUI];
        
        if (image) {
            self.image  = image;
        }else if (thumnailImage){
            self.image  = thumnailImage;

            //网络下载
            NSString *destination = [[MOBIMImageManager sharedManager] originImgPathWithImageURLString:imageUrl];
            
            MOBIMWEAKSELF
            [[MOBIMDownloadManager instance] downloadFileWithURLString:imageUrl destination:destination progress:^(NSProgress * _Nonnull progress, MOBIMDownloadResponse * _Nonnull response) {
                
            } success:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull url) {
                
                weakSelf.isDowning = NO;
                //更新图片
                
                weakSelf.image = [[MOBIMImageManager  sharedManager] imageWithLocalPath:destination];
                
            } faillure:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                
            }];
            
        }
        self.view.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
        tap.numberOfTapsRequired    = 1;
        [self.view addGestureRecognizer:tap];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scale = 2;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapAction:)];
    tap.numberOfTapsRequired    = 1;
    [self.imageView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *twiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTwiceAction:)];
    twiceTap.numberOfTapsRequired    = 2;
    [self.imageView addGestureRecognizer:twiceTap];
    
    // 如果确认双击手势失败后才执行单击手势
    [tap requireGestureRecognizerToFail:twiceTap];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureLongAction:)];
    [self.imageView addGestureRecognizer:longGesture];
    
    
    
}


#pragma mark - Event

- (void)gestureTapAction:(UITapGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)gestureTwiceAction:(UITapGestureRecognizer *)gesture
{
    if (self.isDowning) {
        return;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.transform = CGAffineTransformMakeScale(self.scale, self.scale);
    }];
    self.scale = self.scale == 1 ? 2:1;
    UIEdgeInsets insets = self.scrollView.contentInset;
    CGFloat appHeight   = [UIScreen mainScreen].bounds.size.height;
    if (self.imageView.height > appHeight) {
        CGFloat margin = (self.imageView.height - appHeight)*0.5;
        self.scrollView.contentInset = UIEdgeInsetsMake(margin, self.imageView.width/4.0, margin, self.imageView.width/4.0);
    } else {
         self.scrollView.contentInset = UIEdgeInsetsMake(insets.top, self.imageView.width/4.0, insets.bottom, self.imageView.width/4.0);
    }
}

- (void)gestureLongAction:(UILongPressGestureRecognizer *)gesture
{
    if (self.isDowning) {
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        [actionSheet showInView:self.view];
    }
}

- (void)viewTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UI

- (void)setupUI
{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    [self.view addSubview:self.moreImageButton];
    self.moreImageButton.frame =CGRectMake(self.view.bounds.size.width- 20 -30, 25, 30, 30)  ;
    [self.moreImageButton addTarget:self action:@selector(moreImageClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    self.scrollView.frame = self.view.bounds;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 2.0;
    
}

- (void)loadingOrgImage
{
}



- (void)moreImageClicked:(UIButton*)button
{
    
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    CGFloat offsetX = (scrollView.width - view.width) * 0.5;
    CGFloat offsetY = (scrollView.height - view.height) * 0.5;
    
    offsetX = offsetX > 0 ? offsetX : 0;
    offsetY = offsetY > 0 ? offsetY : 0;
    view.x = 0, view.y = 0;
    scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.width - self.imageView.width) * 0.5;
    CGFloat offsetY = (scrollView.height - self.imageView.height) * 0.5;
    
    offsetX = offsetX > 0 ? offsetX : 0;
    offsetY = offsetY > 0 ? offsetY : 0;
    scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX);
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        MOBIMLog(@"保存图片失败");
    } else {
        MOBIMLog(@"保存图片成功");
        //显示
        [self showToastSucessMessage:@"保存图片成功"];
        
    }
}





#pragma mark - Getter And Setter

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
    
    // 设置图片位置
    CGFloat height       = self.scrollView.bounds.size.width * image.size.height / image.size.width;
    self.imageView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, height);
    if (height < self.scrollView.bounds.size.height) {
        CGFloat margin   = (self.scrollView.bounds.size.height - height) * 0.5;
        self.scrollView.contentInset = UIEdgeInsetsMake(margin, 0, margin, 0);
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, height);
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;

    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}


- (UIButton *)moreImageButton
{
    if (!_moreImageButton) {
        _moreImageButton = [[UIButton alloc] init];
        [_moreImageButton setBackgroundImage:[UIImage imageNamed:@"chat_morephotos"] forState:UIControlStateNormal];
    }
    return _moreImageButton;
}



@end
