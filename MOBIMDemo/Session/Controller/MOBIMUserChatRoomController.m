//
//  MOBIMUserChatRoomController.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/12.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMUserChatRoomController.h"
#import "MOBIMOtherUserViewController.h"
#import "MOBIMSingleUserInfoController.h"
#import "MOBIMUserManager.h"
#import "UIViewController+MOBIMToast.h"

@interface MOBIMUserChatRoomController ()

- (void)otherUserInfo;

@end

@implementation MOBIMUserChatRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //如果 contact 为空，动态获取用户信息
    
}

- (void)loadUI
{
    [super loadUI];
    
    MOBIMWEAKSELF
    [[MOBIMUserManager sharedManager] fetchUserInfo:_contact.appUserId needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
        if (user)
        {
            weakSelf.title = user.nickname;

        }            

    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 50, 50);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, KMOBIMNavRightOffset);
    [button setImage:[UIImage imageNamed:@"room_other"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(otherUserInfo) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = KMOBIMCommonKeyboardColor;
    
    if (!self.contact && !_otherUserId)
    {
        self.view.userInteractionEnabled = NO;
        button.userInteractionEnabled = NO;
        button.enabled = NO;
        
        [self showToastMessage:@"用户信息错误"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSArray*)cacheData:(MIMMessage*)lastMessage pageSize:(NSUInteger)pageSize
{
    
    return  [[MobIM getChatManager] fetchSingleChatMessagesByOtherId:self.to lastMessage:lastMessage pageSize:pageSize];
}


- (NSString *)from
{
    return [MOBIMUserManager sharedManager].currentUser.appUserId;
}

- (NSString *)to
{
    return _contact.appUserId;
}

- (MIMConversationType)currentMIMChatType
{
    return MIMConversationTypeSingle;

}



- (void)otherUserInfo
{
    
    MOBIMSingleUserInfoController *vc = [MOBIMSingleUserInfoController new];
    vc.otherUserModel = _contact;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headImageClicked:(NSString *)userId
{
    
    MOBIMOtherUserViewController  *viewController = [[MOBIMOtherUserViewController alloc] init];
    viewController.hiddenSendMessageButton = YES;
    viewController.otherUser = _contact;

    //传递个人信息
    [self.navigationController pushViewController:viewController animated:YES];
}

@end

