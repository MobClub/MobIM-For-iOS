//
//  MOBIMChatMessageFileCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatMessageFileCell.h"
#import "MOBIMImageManager.h"
#import "MOBIMFileManager.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMFileButton.h"
#import "NSDictionary+MOBIMExtention.h"
#import "MOBIMDownloadManager.h"

@interface MOBIMChatMessageFileCell ()

@property (nonatomic, strong) MOBIMFileButton *fileButton;


@end

@implementation MOBIMChatMessageFileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.fileButton];
    }
    return self;
}


- (void)setModelFrame:(MOBIMChatMessageFrame *)modelFrame
{
    [super setModelFrame:modelFrame];
    
    self.fileButton.frame = modelFrame.picViewF;
    
    
    if (modelFrame.modelNew) {
        
        self.fileButton.modelFrame = modelFrame;
        
        MIMMessage *message = modelFrame.modelNew;
        MIMFileMessageBody *body = (MIMFileMessageBody*)message.body;
        
        
        BOOL hasFile = [MOBIMFileManager fileExistsAtPath:modelFrame.messageExt.localFilePath1];
        
        if (!hasFile)
        {
            hasFile = [MOBIMFileManager fileExistsAtPath:body.localPath];
        }
        
        if (!hasFile)
        {
            NSString *destination = nil;
            if (body.remotePath) {
                destination = [MOBIMFileManager fileLocalPathWithURLString:body.remotePath];
                hasFile = [MOBIMFileManager fileExistsAtPath:destination];
            }
        }
        
        if (hasFile) {
            if (message.direction == MIMMessageDirectionSend) {
                if (body.downloadStatus == MIMMessageStatusSucceed) {
                    self.fileButton.identLabel.text = @"已发送";
                } else {
                    self.fileButton.identLabel.text = @"未发送";
                }
            } else {
                self.fileButton.identLabel.text = @"已下载";
            }
        } else {
            if (message.direction == MIMMessageDirectionSend) {
                if (body.downloadStatus == MIMMessageStatusSucceed) {
                    self.fileButton.identLabel.text = @"已发送";
                } else {
                    self.fileButton.identLabel.text = @"未发送";
                }
            } else {
                self.fileButton.identLabel.text = @"未下载";
            }
        }
        
    }else{
//        self.fileButton.messageModel = modelFrame.model;

        
//        if ([MOBIMFileManager fileExistsAtPath:[self localFilePath]]) {
//            if (modelFrame.model.isSender) {
//                if (modelFrame.model.deliveryState == MOBIMChatMessageDeliveryState_Delivered) {
//                    self.fileButton.identLabel.text = @"已发送";
//                } else {
//                    self.fileButton.identLabel.text = @"未发送";
//                }
//            } else {
//                self.fileButton.identLabel.text = @"已下载";
//            }
//        } else {
//            if (modelFrame.model.isSender) {
//                if (modelFrame.model.deliveryState == MOBIMChatMessageDeliveryState_Delivered) {
//                    self.fileButton.identLabel.text = @"已发送";
//                } else {
//                    self.fileButton.identLabel.text = @"未发送";
//                }
//            } else {
//                self.fileButton.identLabel.text = @"未下载";
//            }
//        }
    }
}


#pragma mark - Event

- (void)fileBtnClicked:(UIButton *)fileBtn
{

    
    MIMMessage *message = self.modelFrame.modelNew;
    MIMFileMessageBody *body = (MIMFileMessageBody*)message.body;
    // 如果文件存在就直接打开，否者下载
    
    //下载
    NSString *remotePath = body.remotePath;
    //网络下载 音频，缓存本地
    NSString *destination = nil;
    if (remotePath) {
        destination = [MOBIMFileManager fileLocalPathWithURLString:remotePath];
    }
    
    NSString *path = nil;
    BOOL hasFile = [MOBIMFileManager fileExistsAtPath:self.modelFrame.messageExt.localFilePath1];
    
    if (!hasFile)
    {
        hasFile = [MOBIMFileManager fileExistsAtPath:body.localPath];
        path = body.localPath;

        
        //本地下载的缓存
        if ([MOBIMFileManager fileExistsAtPath:destination]) {
            
            hasFile = YES;
            path = destination;
        }
    }
    else
    {
        path = self.modelFrame.messageExt.localFilePath1;
    }
    

    if (hasFile) {
        
        if (self.fileClickCompletion) {
            self.fileClickCompletion(self.modelFrame, path, fileBtn);
        }
        return;
    }
    

    
    if (destination) {
        
        MOBIMWEAKSELF
        [[MOBIMDownloadManager instance] downloadFileWithURLString:remotePath destination:destination progress:^(NSProgress * _Nonnull progress, MOBIMDownloadResponse * _Nonnull response) {
            
            weakSelf.fileButton.progressView.progress = progress.completedUnitCount;
            
        } success:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull url) {
            
            [[MobIM getChatManager] updateAttachDownloadStatus:MIMDownloadStatusSucceed withMessage:weakSelf.modelFrame.modelNew];
            weakSelf.fileButton.progressView.hidden = YES;
            weakSelf.fileButton.identLabel.text = @"已下载";
            
            
        } faillure:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
        
        self.fileButton.progressView.hidden = NO;
    }

}



#pragma mark - Getter

- (MOBIMFileButton *)fileButton
{
    if (!_fileButton) {
        _fileButton = [MOBIMFileButton buttonWithType:UIButtonTypeCustom];
        [_fileButton addTarget:self action:@selector(fileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fileButton;
}

@end
