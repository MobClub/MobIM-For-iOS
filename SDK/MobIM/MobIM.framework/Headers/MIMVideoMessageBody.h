//
//  MIMVideoMessageBody+CoreDataClass.h
//  MobIM
//
//  Created by youzu on 2017/9/12.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIMFileMessageBody.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 视频消息体类
 */
@interface MIMVideoMessageBody : MIMFileMessageBody

/**
 视频时长,以秒为单位
 */
@property (nonatomic) int64_t duration;

/**
 缩略图的本地路径
 */
@property (nullable, nonatomic, copy) NSString *thumbnailLocalPath;

/**
 缩略图的远程路径
 */
@property (nullable, nonatomic, copy) NSString *thumbnailRemotePath;

# pragma mark - Transient

/**
 缩略图的尺寸
 */
@property (nonatomic, assign) CGSize thumbnailSize;

/**
 初始化视频消息体

 @param thumbnailImage 视频某一帧的图片
 @param localPath 视频文件本地路径
 @return 视频消息体实例
 */
+ (instancetype)bodyWithThumbnailImage:(UIImage *)thumbnailImage localPath:(NSString *)localPath;


@end

NS_ASSUME_NONNULL_END
