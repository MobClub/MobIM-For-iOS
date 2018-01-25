//
//  MOBIMGConfigManager.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/18.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMGConfigManager.h"
#import <UIKit/UIKit.h>

@implementation MOBIMGConfigManager
+ (instancetype)sharedManager {
    static  MOBIMGConfigManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (UIImage *)blueImage
{
    if (!_blueImage) {
        //        CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
        //        UIGraphicsBeginImageContext(rect.size);
        //        CGContextRef context = UIGraphicsGetCurrentContext();
        //        CGContextSetFillColorWithColor(context, [color CGColor]);
        //        CGContextFillRect(context, rect);
        //        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        //        UIGraphicsEndImageContext();
        
        
        UIImage *bgImage = [[UIImage imageNamed:@"navbartop"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        self.blueImage = bgImage;
        
    }
    return _blueImage;
}

- (UIImage *)whiteImage
{
    if (!_whiteImage) {
        CGRect rect = CGRectMake(0.0f, 0.0f, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(context, rect);
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.whiteImage = theImage;
        
    }
    return _whiteImage;
}

/** 是否是第一次打开*/
- (BOOL)isfirstLanch{
    
    if (![MOBIMUserManager currentUserId])
    {
        return YES;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *myFile = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_first.plist",[MOBIMUserManager currentUserId]]];
    
    //    UCSLog(@"DocumentPath:%@", myFile);
    NSDictionary *dic=[[NSDictionary alloc]initWithContentsOfFile:myFile];
    if (dic)
    {
        NSString*path=[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSDictionary*dic_system=[NSDictionary dictionaryWithContentsOfFile:path];
        NSString *latestVersion=[dic_system objectForKey:@"CFBundleShortVersionString"];
        NSString * versionInPlist=[dic objectForKey:@"latestVersion"];
        
        //NSLog(@"检查是否是第一次登录: 最新版本号:%@  plist里的版本号:%@",latestVersion,versionInPlist);
        return [versionInPlist isEqualToString:latestVersion]?NO:YES;
    }else
    {
        return YES;
    }
}
// 设置已经打开过
- (void)setHasLanch{
    
    if ([MOBIMUserManager currentUserId])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [paths objectAtIndex:0];
        NSString *myFile = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_first.plist",[MOBIMUserManager currentUserId]]];
        NSString*path=[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSDictionary*dic_system=[NSDictionary dictionaryWithContentsOfFile:path];
        NSString *latestVersion=[dic_system objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *newDic=[[NSDictionary alloc]initWithObjectsAndKeys:latestVersion,@"latestVersion",nil];
        [newDic writeToFile:myFile atomically:YES];
    }

}


+ (float)safeBottomHeight
{
    if ([UIScreen mainScreen].bounds.size.height == 812) {
        return 32;
    }
    return 0;
}
@end
