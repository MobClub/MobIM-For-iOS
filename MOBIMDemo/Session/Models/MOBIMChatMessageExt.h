//
//  MOBIMChatMessageExt.h
//  MOBIMDemo
//
//  Created by hower on 2017/10/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOBIMChatMessageExt : NSObject

//每条消息创建时候的天
@property (nonatomic, assign)int day;

//控制消息是否显示时间
@property (nonatomic, assign) BOOL showDate;

//要显示的时间
@property (nonatomic, strong) NSString *showDateString;

//本地文件路径1(对于只有一个文件附件类型-图片，语音，文件)
@property (nonatomic, strong) NSString *localFilePath1;

//本地文件路径2(对于有两个文件附件类型-视频)
@property (nonatomic, strong) NSString *localFilePath2;


//可能需要对通知消息进行特殊处理
@property (nonatomic, strong) NSString *textContent;


@end
