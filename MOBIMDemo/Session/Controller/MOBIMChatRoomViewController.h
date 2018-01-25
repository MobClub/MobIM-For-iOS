//
//  MOBIMChatRoomViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewController.h"
#import "MOBIMMessageGroupModel.h"
#import "MOBIMGConst.h"
#import "MOBIMBaseChatMessageCell.h"

@interface MOBIMChatRoomViewController : MOBIMBaseViewController<MOBIMBaseChatMessageCellDelegate>

//消息的发送者
- (NSString *)from;

//消息的接受者
- (NSString *)to;

//进入加载本地缓存数据
- (NSArray*)cacheData:(MIMMessage*)lastMessage pageSize:(NSUInteger)pageSize;

//会话类型
- (MIMConversationType)currentMIMChatType;

//聊天室类型
- (MOBIMChatRoomType)chatRoomType;


//头像点击
- (void)headImageClicked:(NSString *)userId;

- (MOBIMMessageStyle)messageStyle;

- (BOOL)showInputBox;

- (void)handleNoticeMessageSucess:(MIMMessage*)message;

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) NSString *conversationId;



@end
