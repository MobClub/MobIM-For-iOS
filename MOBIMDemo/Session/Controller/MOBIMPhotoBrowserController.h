//
//  ICPhotoBrowserController.h
//  XZ_WeChat
//
//  Created by hower on 17/10/12.
//  Copyright © 2017年 MOB All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOBIMPhotoBrowserController : UIViewController

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong,) UIImageView *imageView;


- (instancetype)initWithImage:(UIImage *)image;

/**
 *param  thumnailImage  缩略图
 *param  image  原图
 *param  imageUrl  网络原图地址
 **/
- (instancetype)initWithThumnailImage:(UIImage *)thumnailImage image:(UIImage*)image imageUrl:(NSString*)imageUrl;

@end
