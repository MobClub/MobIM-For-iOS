//
//  MOBIMChatMessagePhotoCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatMessagePhotoCell.h"
#import "MOBIMImageManager.h"
#import "MOBIMFileManager.h"
#import "UIView+MOBIMExtention.h"

@interface MOBIMChatMessagePhotoCell ()

@property (nonatomic, strong) UIButton *imageButton;

@end

@implementation MOBIMChatMessagePhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageButton];
    }
    return self;
}



#pragma mark - Private Method

- (void)setModelFrame:(MOBIMChatMessageFrame *)modelFrame
{
    [super setModelFrame:modelFrame];
    
    
    if (modelFrame.modelNew) {
        
        
        UIImage *image =nil;
        //数据model
        MIMMessage *message = modelFrame.modelNew;
        MIMImageMessageBody *body = (MIMImageMessageBody*)message.body;
        
        if (message.direction == MIMMessageDirectionSend) {
            
            MOBIMImageManager *manager = [MOBIMImageManager sharedManager];
            //优先考虑本地发送的本地图片
            image = [manager imageWithLocalPath:modelFrame.messageExt.localFilePath1];
            if (image) {
                [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
            }
            
            //优先考虑IMSDK本地的本地图片
            image = [manager imageWithLocalPath:body.localPath];
            if (image) {
                [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
            }
            
            if (!image && body.thumbnailRemotePath) {
                [self.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:body.thumbnailRemotePath] forState:UIControlStateNormal];
            }
        }
        else
        {
            //优先获取本地缓存的缩略图
            if (!image && body.thumbnailRemotePath) {
                [self.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:body.thumbnailRemotePath] forState:UIControlStateNormal];
            }
        }
        

        
        
        self.imageButton.frame = modelFrame.picViewF;
        self.bubbleView.userInteractionEnabled = _imageButton.imageView.image != nil;
        self.bubbleView.frame = modelFrame.bubbleViewF;
        
    }

}

- (void)imageBtnClick:(UIButton *)btn
{
    if (btn.currentBackgroundImage == nil) {
        return;
    }
    
    CGRect smallRect = [UIView photoFramInWindow:btn];
    CGRect bigRect   = [UIView photoLargerInWindow:btn];
    
    if (self.photoClickCompletion)
    {
        self.photoClickCompletion(self.modelFrame,self.imageButton , smallRect, bigRect);
    }
}



#pragma mark - Getter

- (UIButton *)imageButton
{
    if (nil == _imageButton) {
        _imageButton = [[UIButton alloc] init];
        [_imageButton addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imageButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _imageButton.layer.masksToBounds = YES;
        _imageButton.layer.cornerRadius = 5;
        _imageButton.clipsToBounds = YES;
    }
    return _imageButton;
}


@end

