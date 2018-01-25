//
//  AppDelegate.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/1.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "AppDelegate.h"
#import "MOBIMTabBarController.h"
#import "MOBIMUser.h"
#import "MOBIMUserManager.h"
#import "MOBIMModelTools.h"


#import "MOBIMVoiceConverter.h"
#import "MOBIMAudioManager.h"
#import "MOBIMFileManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//无自有用户体系---注册账户
- (void)registerUserWithCompletion:(void (^)(NSDictionary *user))completionHandler
{
    [MOBFHttpService sendHttpRequestByURLString:MOBIMNetworkUrl(@"/register")
                                         method:@"GET"
                                     parameters:@{@"appkey": @"moba6b6c6d6"}
                                        headers:nil
                                       onResult:^(NSHTTPURLResponse *response, NSData *responseData) {
                                           NSDictionary *responseDict = [MOBFJson objectFromJSONData:responseData];
                                           NSInteger status = [responseDict[@"status"] integerValue];
                                           if (status == 200)
                                           {
                                               
                                               
                                               NSDictionary *resDict = responseDict[@"res"];
                                               if (resDict && resDict.allKeys.count > 0)
                                               {
                                                   if (completionHandler) {
                                                       completionHandler(resDict);
                                                   }
                                               }
                                               //NSLog(@"mobuser -- %@ -- %@--", resDict,[NSThread currentThread]);
                                               
                                           }
                                           
                                       }
                                        onFault:^(NSError *error) {
                                            //NSLog(@"%@", error);
                                        }
                               onUploadProgress:nil];
    
    
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    
    MOBIMUser *cacheUser = [[MOBIMUserManager sharedManager] currentUser];
    
    //自动下载语音
    [[MOBIMMessageManager sharedManager] registerDownMessageAudioFile];
    
    
    if (!cacheUser) {
        
        [self registerUserWithCompletion:^(NSDictionary *user) {
            
            //对接MOBIMSDK 用户体系
            [MobSDK setUserWithUid:[NSString stringWithFormat:@"%@",user[@"id"]]
                          nickName:user[@"nickname"]
                            avatar:user[@"avatar"]
                          userData:nil];
            
            [MOBIMModelTools curUserWithDict:user];

            
        }];
        
    }else{
        
        
        //对接MOBIMSDK 用户体系
        [MobSDK setUserWithUid:cacheUser.appUserId
                      nickName:cacheUser.nickname
                        avatar:cacheUser.avatar
                      userData:nil];
        
    }
    
    
    //通知
    {
        float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
        if (sysVersion>=8.0) {

            UIUserNotificationType type=UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings=[UIUserNotificationSettings settingsForTypes:type categories:nil];
            [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
        }
    }

    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [MOBIMTabBarController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    //清理
    [MagicalRecord cleanUp];
    
}



@end

