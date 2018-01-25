//
//  MOBIMImageManager.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MOBIMChatMessageModel.h"
#import "MOBIMChatMessageFrame.h"

@interface MOBIMImageManager : NSObject


+ (instancetype)sharedManager;


- (void)clearReuseImageMessage:(MOBIMChatMessageModel *)message;


//清除缓存
- (void)clearCaches;

/**
 *  get image from local path
 *
 *  @param localPath 路径
 *
 *  @return 图片
 */
- (UIImage *)imageWithLocalPath:(NSString *)localPath;


/**
 *  保存图片到沙盒
 *
 *  @param image 图片
 *
 *  @return 图片路径
 */
- (NSString *)saveImage:(UIImage *)image;

/**
 *  创建图片的保存路径
 *
 *  @param mainFolder  主地址
 *  @param childFolder 子地址
 *
 *  @return 地址
 */
- (NSString *)createFolderPahtWithMainFolder:(NSString *)mainFolder
                                 childFolder:(NSString *)childFolder;


//网络地址获取图片地址
- (NSString *)originImgPathWithImageURLString:(NSString*)URLString;



#pragma mark - 视频图片处理相关

// 发送图片的地址
- (NSString *)sendImagePath:(NSString *)imgName;

/// video first cover image
- (UIImage *)videoConverPhotoWithVideoPath:(NSString *)videoPath
                                      size:(CGSize)imageSize
                                  isSender:(BOOL)isSender;

- (UIImage *)videoConverPhotoWithVideoPath:(NSString *)videoPath
                                  isSender:(BOOL)isSender;


// 保存接收到图片 small-fileKey.png
- (NSString *)receiveImagePathWithFileKey:(NSString *)fileKey
                                     type:(NSString *)type;

// 小图路径
- (NSString *)smallImgPath:(NSString *)fileKey;



// get image with imgName
- (NSString *)imagePathWithName:(NSString *)imageName;

// get videoImage from sandbox
- (UIImage *)videoImageWithFileName:(NSString *)fileName;

// 送达号
- (NSString *)delieveImagePath:(NSString *)fileKey;
- (NSString *)deliverFilePath:(NSString *)name
                         type:(NSString *)type;

- (NSString *)videoImagePath:(NSString *)fileName;

//圆角图片存储的地址
- (UIImage *)roundedImageFileKey:(NSString *)fileKey;
- (NSString *)saveRoundedImage:(UIImage *)image fileKey:(NSString*)fileKey radius:(CGFloat)cornerRadius;

@end
