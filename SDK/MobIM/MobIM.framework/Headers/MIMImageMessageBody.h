//
//  MIMImageMessageBody+CoreDataClass.h
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
 图片消息体类
 */
@interface MIMImageMessageBody : MIMFileMessageBody

/**
 缩略图本地路径
 */
@property (nullable, nonatomic, copy, readonly) NSString *thumbnailLocalPath;

/**
 缩略图远程路径
 */
@property (nullable, nonatomic, copy, readonly) NSString *thumbnailRemotePath;

/**
 图片尺寸, 原始图片和缩略图尺寸一致,公用一个属性
 */
@property (nonatomic, assign) CGSize size;

/**
 初始化图片消息体
 
 @param aData 图片数据
 @return 图片消息体实例
 */
+ (instancetype)bodyWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
