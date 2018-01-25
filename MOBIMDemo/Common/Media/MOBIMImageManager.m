//
//  MOBIMImageManager.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMImageManager.h"
#import "MOBIMChatMessageFrame.h"
#import "UIImage+MOBIMExtension.h"
#import "NSString+MOBIMExtension.h"
#import "MOBIMFileManager.h"

#define kArrowMe @"Chat/ArrowMe"
#define KMOBIMPic @"Chat/MyPic"
#define KMOBIMPicRounded @"Chat/MyPic/Rounded"

#define kVideoPic @"Chat/VideoPic"
#define kVideoImageType @"png"
#define kDeliver @"Deliver"

static UIImage *_failedImage;

@interface MOBIMImageManager ()

@property (nonatomic, strong) NSCache *videoImageCache;
@property (nonatomic, strong) NSCache *imageChacheMe;
@property (nonatomic, strong) NSCache *imageChacheYou;
@property (nonatomic, strong) NSCache *photoCache;

@end

@implementation MOBIMImageManager

+ (instancetype)sharedManager
{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(clearCaches) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        _failedImage  = [UIImage imageNamed:@"icon_album_picture_fail_big"];
    });
    return _instance;
}


- (void)clearCaches
{
    [self.videoImageCache removeAllObjects];
    [self.imageChacheMe removeAllObjects];
    [self.imageChacheYou removeAllObjects];
    [self.photoCache removeAllObjects];
}



/**
 *  保存图片到沙盒
 *
 *  @param image 图片
 *
 *  @return 图片路径
 */
- (NSString *)saveImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 图片名称, 当前时间
    NSString *fileName = [NSString stringWithFormat:@"%@%@",[NSString currentName],@".png"];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:chachePath childFolder:KMOBIMPic];
    NSString *filePath = [mainFilePath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:filePath atomically:NO];
    return filePath;
}


- (NSString *)saveRoundedImage:(UIImage *)image fileKey:(NSString*)fileKey radius:(CGFloat)cornerRadius
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 图片名称, 当前时间
    NSString *fileName = [NSString stringWithFormat:@"%@%@",fileKey,@".png"];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:chachePath childFolder:KMOBIMPicRounded];
    NSString *filePath = [mainFilePath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:filePath atomically:NO];
    
    return filePath;
}

- (UIImage *)roundedImageFileKey:(NSString *)fileKey
{
    if ([self.photoCache objectForKey:fileKey]) {
        return [self.photoCache objectForKey:fileKey];
    }
    
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [NSString stringWithFormat:@"%@%@",fileKey,@".png"];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:chachePath childFolder:KMOBIMPicRounded];
    NSString *filePath = [mainFilePath stringByAppendingPathComponent:fileName];

    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    if (image) {
        [self.photoCache setObject:image forKey:fileKey];
    } else {
        image = _failedImage;
        if (image) {
            [self.photoCache setObject:image forKey:fileKey];
        }
    }
    return image;
}

// 使用文件名为key
- (UIImage *)imageWithLocalPath:(NSString *)localPath
{
    if ([self.photoCache objectForKey:localPath.lastPathComponent]) {
        return [self.photoCache objectForKey:localPath.lastPathComponent];
    } else if (![localPath hasSuffix:@".png"]) {
        return nil;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
    if (image) {
        [self.photoCache setObject:image forKey:localPath.lastPathComponent];
    } else {
        image = _failedImage;
        if (image) {
            [self.photoCache setObject:image forKey:localPath.lastPathComponent];
        }
    }
    return image;
}

- (void)clearReuseImageMessage:(MOBIMChatMessageModel *)message
{
    NSString *path = message.mediaPath;
    NSString *videoPath = message.mediaPath;// 这是整个路径
    [self.photoCache removeObjectForKey:path.lastPathComponent];
    [self.imageChacheMe removeObjectForKey:path.lastPathComponent];
    [self.imageChacheYou removeObjectForKey:path.lastPathComponent];
    [self.videoImageCache removeObjectForKey:[[[videoPath stringByDeletingPathExtension] stringByAppendingPathExtension:kVideoPic] lastPathComponent]];
}


- (void)fileManagerWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreateDir) {
            //MOBIMLog(@"create folder failed");
            return ;
        }
    }
}

- (void)saveArrowMeImage:(UIImage *)image
           withMediaPath:(NSString *)mediPath
{
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:mediPath atomically:NO];
}

// 路径cache/MyPic
- (NSString *)createFolderPahtWithMainFolder:(NSString *)mainFolder
                                 childFolder:(NSString *)childFolder
{
    NSString *path = [mainFolder stringByAppendingPathComponent:childFolder];
    [self fileManagerWithPath:path];
    return path;
}

// 使用文件名作为key
- (UIImage *)videoConverPhotoWithVideoPath:(NSString *)videoPath
                                      size:(CGSize)imageSize
                                  isSender:(BOOL)isSender
{
    if (!videoPath) return nil;
    NSString *trueFileName = [[[videoPath stringByDeletingPathExtension] stringByAppendingPathExtension:kVideoImageType] lastPathComponent];
    if ([self.videoImageCache objectForKey:trueFileName]) {
        return [self.videoImageCache objectForKey:trueFileName];
    }
    UIImage *videoImg = [self videoImageWithFileName:trueFileName];
    if (videoImg) {
        UIImage *addImage = [UIImage addImage2:[UIImage imageNamed:@"App_video_play_btn_bg"] toImage:videoImg];
        [self.videoImageCache setObject:addImage forKey:trueFileName];
        return addImage;
    }
    UIImage *resultImg = [UIImage videoFramerateWithPath:videoPath];
//    UIImage *videoArrowImage = [UIImage makeArrowImageWithSize:imageSize image:thumbnailImage isSender:isSender];
//    UIImage *resultImg = [UIImage addImage2:[UIImage imageNamed:@"App_video_play_btn_bg"] toImage:videoArrowImage];
    if (resultImg) {
        [self.videoImageCache setObject:resultImg forKey:trueFileName];
        [self saveVideoImage:resultImg fileName:trueFileName];
    }
    return resultImg;
}
/// video first cover image
- (UIImage *)videoConverPhotoWithVideoPath:(NSString *)videoPath
                                  isSender:(BOOL)isSender
{
    if (!videoPath) return nil;
    NSString *trueFileName = [[[videoPath stringByDeletingPathExtension] stringByAppendingPathExtension:kVideoImageType] lastPathComponent];
    if ([self.videoImageCache objectForKey:trueFileName]) {
        return [self.videoImageCache objectForKey:trueFileName];
    }
    UIImage *videoImg = [self videoImageWithFileName:trueFileName];
    if (videoImg) {
        UIImage *addImage = [UIImage addImage2:[UIImage imageNamed:@"App_video_play_btn_bg"] toImage:videoImg];
        [self.videoImageCache setObject:addImage forKey:trueFileName];
        return addImage;
    }
    UIImage *resultImg = [UIImage videoFramerateWithPath:videoPath];
    if (resultImg) {
        [self.videoImageCache setObject:resultImg forKey:trueFileName];
        [self saveVideoImage:resultImg fileName:trueFileName];
    }
    return resultImg;
}


// 发送图片的地址
- (NSString *)sendImagePath:(NSString *)imgName
{
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [NSString stringWithFormat:@"%@",imgName];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:chachePath childFolder:KMOBIMPic];
    NSString *filePath = [mainFilePath stringByAppendingPathComponent:fileName];
    return filePath;

}

/// save video image in sandbox
- (void)saveVideoImage:(UIImage *)image
              fileName:(NSString *)fileName
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:chachePath childFolder:kVideoPic];
    NSString *filePath = [mainFilePath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:filePath atomically:NO];
}

// get videoImage from sandbox
- (UIImage *)videoImageWithFileName:(NSString *)fileName
{
    return [UIImage imageWithContentsOfFile:[self videoImagePath:fileName]];
}

- (NSString *)videoImagePath:(NSString *)fileName
{
    NSString *path = [[MOBIMFileManager cacheDirectory] stringByAppendingPathComponent:kVideoPic];
    [self fileManagerWithPath:path];
    NSString *fullPath = [path stringByAppendingPathComponent:fileName];
    return fullPath;
}


// 保存接收到图片   fileKey-small.png
- (NSString *)receiveImagePathWithFileKey:(NSString *)fileKey
                                     type:(NSString *)type
{
    // 目前是png，以后说不定要改
    NSString *fileName = [NSString stringWithFormat:@"%@-%@%@",fileKey,type,@".png"];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:[MOBIMFileManager cacheDirectory] childFolder:KMOBIMPic];
    return [mainFilePath stringByAppendingPathComponent:fileName];
}

// get image with imgName
- (NSString *)imagePathWithName:(NSString *)imageName
{
    return [[[MOBIMFileManager cacheDirectory] stringByAppendingPathComponent:KMOBIMPic] stringByAppendingPathComponent:imageName];
}


// origin image path


- (NSString *)originImgPathWithImageURLString:(NSString*)URLString
{
    return [[MOBIMImageManager sharedManager] receiveImagePathWithFileKey:[NSString md5:URLString] type:@"origin"];

}

// small image path
- (NSString *)smallImgPath:(NSString *)fileKey
{
    return [[MOBIMImageManager sharedManager] receiveImagePathWithFileKey:fileKey type:@"small"];
}


- (NSString *)delieveImagePath:(NSString *)fileKey
{
    NSString *fileName = [NSString stringWithFormat:@"%@%@",fileKey,@".png"];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:[MOBIMFileManager cacheDirectory] childFolder:kDeliver];
    return [mainFilePath stringByAppendingPathComponent:fileName];
}

- (NSString *)deliverFilePath:(NSString *)name
                         type:(NSString *)type
{
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",name,type];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:[MOBIMFileManager cacheDirectory] childFolder:kDeliver];
    return [mainFilePath stringByAppendingPathComponent:fileName];
}


#pragma mark - Getter and Setter

- (NSCache *)videoImageCache
{
    if (nil == _videoImageCache) {
        _videoImageCache = [[NSCache alloc] init];
    }
    return _videoImageCache;
}

- (NSCache *)imageChacheMe
{
    if (nil == _imageChacheMe) {
        _imageChacheMe = [[NSCache alloc] init];
    }
    return _imageChacheMe;
}

- (NSCache *)imageChacheYou
{
    if (nil == _imageChacheYou) {
        _imageChacheYou = [[NSCache alloc] init];
    }
    return _imageChacheYou;
}

- (NSCache *)photoCache
{
    if (nil == _photoCache) {
        _photoCache = [[NSCache alloc] init];
    }
    return _photoCache;
}



@end
