//
//  MOBIMSessionModel.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MOBIMGConst.h"

@interface MOBIMSessionModel : NSObject

@property (nonatomic, copy) NSString *avatarPath;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSNumber  *unreadCount;

@property (nonatomic, assign) MOBIMChatRoomType  chatRoomType;



@end
