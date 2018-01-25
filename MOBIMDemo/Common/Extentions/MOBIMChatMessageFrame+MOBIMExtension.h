//
//  MOBIMChatMessageFrame+Extension.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOBIMChatMessageFrame.h"

@interface MOBIMChatMessageFrame(MOBIMExtension)

/**
 *  创建一条本地消息
 *
 *  @param type    消息类型
 *  @param content 文本消息内容
 *  @param path    图片音频本地路径
 *
 *  @return 一条消息的ICMessageFrame
 */

+ (MOBIMChatMessageFrame *)createMessageNewFrame:(MIMConversationType )type
                                     bodyType:(MIMMessageBodyType)bodyType
                                      content:(NSString *)content
                                         path:(NSString *)path
                                         from:(NSString *)from
                                           to:(NSString *)to
                                      fileKey:(NSString *)fileKey
                                     isSender:(BOOL)isSender
                     receivedSenderByYourself:(BOOL)receivedSenderByYourself;

+ (MOBIMChatMessageFrame *)createMessageNewFrame:(MIMConversationType )type
                                        bodyType:(MIMMessageBodyType)bodyType
                                         content:(NSString *)content
                                            path:(NSString *)path
                                            from:(NSString *)from
                                              to:(NSString *)to
                                         fileKey:(NSString *)fileKey
                                        isSender:(BOOL)isSender
                        receivedSenderByYourself:(BOOL)receivedSenderByYourself
                                        filedata:(NSData*)data;



@end
