//
//  MOBIMChatMessageVideoCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatMessageVideoCell.h"
#import "MOBIMImageManager.h"
#import "MOBIMFileManager.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMVideoManager.h"
#import "MOBIMAVPlayer.h"
#import "MOBIMZacharyPlayManager.h"
#import "MOBIMChatMessageTools.h"

@interface MOBIMChatMessageVideoCell ()

@property (nonatomic, strong) UIButton *imageBtn;

@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *videoDurationLabel;


@end

@implementation MOBIMChatMessageVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageBtn];
        [self.contentView addSubview:self.playBtn];
        [self.contentView addSubview:self.videoDurationLabel];

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModelFrame:(MOBIMChatMessageFrame *)modelFrame
{
    [super setModelFrame:modelFrame];
    
    if (modelFrame.modelNew) {
        MIMMessage *message = modelFrame.modelNew;
        MIMVideoMessageBody *body = (MIMVideoMessageBody*)message.body;
        
        MOBIMImageManager *manager = [MOBIMImageManager sharedManager];
        UIImage *image = nil;
        if (message.direction == MIMMessageDirectionSend) {
            
            //优先考虑本地发送的本地图片
            image = [manager imageWithLocalPath:modelFrame.messageExt.localFilePath2];
            if (image) {
                [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
            }
            
            //优先考虑IMSDK本地的本地图片
            image = [manager imageWithLocalPath:body.thumbnailLocalPath];
            if (image) {
                [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
            }
            
        }
        

        
        //优先获取本地缓存的缩略图
        if (!image && body.thumbnailRemotePath) {
            [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:body.thumbnailRemotePath] forState:UIControlStateNormal];
        }
        

        self.imageBtn.frame = modelFrame.picViewF;
        self.bubbleView.userInteractionEnabled = image != nil;
        self.bubbleView.frame = modelFrame.bubbleViewF;
        [self.imageBtn setImage:image forState:UIControlStateNormal];
        self.topBtn.frame = CGRectMake(0, 0, _imageBtn.width, _imageBtn.height);
        
        self.playBtn.center = self.imageBtn.center;
        
        _videoDurationLabel.frame = CGRectMake(CGRectGetMinX(modelFrame.picViewF)+5, CGRectGetMaxY(modelFrame.picViewF) - 20, CGRectGetWidth(modelFrame.picViewF)-10, 20);
        
        NSString *duraStr = [MOBIMChatMessageTools timeDurationFormatter:[(MIMVoiceMessageBody*)message.body duration]];

        _videoDurationLabel.text = duraStr;
        
        
        
    }

}



- (void)imageBtnClick:(UIButton *)btn
{
    BOOL isLocalUrl = NO;

    MIMMessage *message = self.modelFrame.modelNew;
    MIMVideoMessageBody *body = (MIMVideoMessageBody*)message.body;
    
    NSString *path = nil;
    BOOL hasFile = [MOBIMFileManager fileExistsAtPath:self.modelFrame.messageExt.localFilePath1];
    if (!hasFile)
    {
        hasFile = [MOBIMFileManager fileExistsAtPath:body.localPath];
        if (hasFile) {
            path = body.localPath;
        }
    }
    else
    {
        path = self.modelFrame.messageExt.localFilePath1;
    }
    
    if (hasFile)
    {
        
        isLocalUrl = YES;
    }
    else
    {
        path = body.remotePath;
        isLocalUrl = NO;
    }
    
    
    //__block NSString *path = [[MOBIMVideoManager sharedManager] videoPathForMP4:self.modelFrame.model.mediaPath];
    
    if (self.videoClickCompletion && path) {
        self.videoClickCompletion(self.modelFrame, path, self.imageBtn.currentBackgroundImage,isLocalUrl);
    }
    //[self videoPlay:path];
}

- (void)videoPlay:(NSString *)path
{
    MOBIMAVPlayer *player = [[MOBIMAVPlayer alloc] initWithPlayerURL:[NSURL fileURLWithPath:path]];
    [player presentFromVideoView:self.imageBtn toContainer:MOIMAPP_RootViewController.view animated:YES completion:nil];
}

#pragma mark - videoPlay

- (void)firstPlay
{
    
}


- (void)stopVideo {
    _topBtn.hidden = NO;
}

- (void)dealloc {
    [[MOBIMZacharyPlayManager sharedInstance] cancelAllVideo];
}

#pragma mark - Getter

- (UIButton *)imageBtn
{
    if (nil == _imageBtn) {
        _imageBtn = [[UIButton alloc] init];
        [_imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imageBtn.layer.masksToBounds = YES;
        _imageBtn.layer.cornerRadius = 5;
        _imageBtn.clipsToBounds = YES;
    }
    return _imageBtn;
}

- (UIButton *)topBtn
{
    if (!_topBtn) {
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topBtn addTarget:self action:@selector(firstPlay) forControlEvents:UIControlEventTouchUpInside];
        _topBtn.layer.masksToBounds = YES;
        _topBtn.layer.cornerRadius = 5;
    }
    return _topBtn;
}


- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.userInteractionEnabled = NO;
        _playBtn.frame = CGRectMake(0, 0, 38, 38);
        [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    return _playBtn;
}


- (UILabel *)videoDurationLabel
{
    if (!_videoDurationLabel) {
        _videoDurationLabel = [[UILabel alloc] init];
        _videoDurationLabel.font=[UIFont systemFontOfSize:12];
        _videoDurationLabel.backgroundColor=[UIColor clearColor];
        _videoDurationLabel.textAlignment = NSTextAlignmentRight;
        _videoDurationLabel.textColor = [UIColor whiteColor];
    }
    return _videoDurationLabel;
}



@end
