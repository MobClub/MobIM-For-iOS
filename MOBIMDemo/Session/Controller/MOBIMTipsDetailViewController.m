//
//  MOBIMTipsDetailViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/30.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMTipsDetailViewController.h"
#import "MOBIMChatMessageTipsCell.h"
#import "Masonry.h"
#import "MOBIMChatMessageFrame.h"
#import "MOBIMChatMessageFrame+MOBIMExtension.h"
#import "UIViewController+MOBIMToast.h"

#define KMOBIMChatMessageTipsDetailCellTag  @"KMOBIMChatMessageTipsDetailCellTag"

@interface MOBIMTipsDetailViewController ()

@end

@implementation MOBIMTipsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)loadData
{
    [super loadData];
}

- (void)loadUI
{
    [super loadUI];
    self.title = _tipsModel.nickname ? _tipsModel.nickname : @"通知提醒";

    if (!self.tipsModel)
    {
        self.view.userInteractionEnabled = NO;
        
        [self showToastMessage:@"信息错误"];
    }
}

- (MIMConversationType)currentMIMChatType
{
    return MIMConversationTypeSystem;
}

- (MOBIMChatRoomType)chatRoomType
{
    return MOBIMChatRoomTypeTips;
}


- (NSString *)from
{
    return [MOBIMUserManager sharedManager].currentUser.appUserId;
}

- (NSString *)to
{
    return _tipsModel.appUserId;
}

- (MOBIMMessageStyle)messageStyle
{
    return MOBIMMessageStyleTips;
}

- (BOOL)showInputBox
{
    
    return NO;
}


@end
