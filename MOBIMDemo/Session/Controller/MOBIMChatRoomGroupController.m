//
//  MOBIMChatRoomGroupController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatRoomGroupController.h"
#import "MOBIMChatGroupRoomInfoViewController.h"
#import "MOBIMOtherUserViewController.h"
#import "UIViewController+MOBIMToast.h"

@interface MOBIMChatRoomGroupController ()
- (void)groupInfoSeleted;

@property (nonatomic, assign) BOOL enabledGroup;

@end

@implementation MOBIMChatRoomGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadUI];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([_groupInfo.membersList count] != _groupInfo.membersCount && [_groupInfo.membersList count] > 0)
    {
        self.title = [NSString stringWithFormat:@"%@ (%zd人)",_groupInfo.groupName,[_groupInfo.membersList count]];
        
    }
    else
    {
        self.title = [NSString stringWithFormat:@"%@ (%d人)",_groupInfo.groupName,_groupInfo.membersCount];
        
    }
}

- (void)loadData
{
    [super loadData];
    
    MOBIMWEAKSELF
    [[MobIM getGroupManager] getGroupInfoWithGroupId:_groupInfo.groupId options:MIMGroupInfoOptionMembers|MIMGroupInfoOptionDescription resultHandler:^(MIMGroup *group, MIMError *error) {
        
        if (!error)
        {
            weakSelf.groupInfo = group;
        }
        else if (error.errorCode == 100006)
        {
            weakSelf.view.userInteractionEnabled = NO;
            [weakSelf showAlertWithText:error.errorDescription];
            
            weakSelf.enabledGroup = NO;
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        
    }];
}


- (void)loadUI
{
    [super loadUI];
    
    self.title = _groupInfo.groupName;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 50, 50);
    [button setImage:[UIImage imageNamed:@"room_group"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(groupInfoSeleted) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, KMOBIMNavRightOffset);

    
    if (!self.groupInfo && !_groupId)
    {
        self.view.userInteractionEnabled = NO;
        button.userInteractionEnabled = NO;
        
        [self showToastMessage:@"群组信息错误"];
    }
    
    
}

- (NSArray*)cacheData:(MIMMessage*)lastMessage pageSize:(NSUInteger)pageSize;
{
    return  [[MobIM getChatManager] fetchGroupChatMessagesByGroupId:self.to lastMessage:lastMessage pageSize:pageSize];
}


- (MIMConversationType)currentMIMChatType
{
    return MIMConversationTypeGroup;
}

- (MOBIMChatRoomType)chatRoomType
{
    return MOBIMChatRoomTypeGroup;
}

- (NSString *)from
{
    return [MOBIMUserManager sharedManager].currentUser.appUserId;
}

- (NSString *)to
{
    return _groupInfo.groupId;
}

- (void)groupInfoSeleted
{
    NSString *conversationId = self.conversationId ;
    MOBIMChatGroupRoomInfoViewController *viewController = [[MOBIMChatGroupRoomInfoViewController alloc] init];
    viewController.conversationId = conversationId;
    viewController.groupInfo = self.groupInfo;
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)handleNoticeMessageSucess:(MIMMessage*)message
{
    MOBIMWEAKSELF
    [[MobIM getGroupManager] getGroupInfoWithGroupId:_groupInfo.groupId options:MIMGroupInfoOptionMembers|MIMGroupInfoOptionDescription resultHandler:^(MIMGroup *group, MIMError *error) {
        
        if (!error)
        {
            weakSelf.groupInfo = group;
        }
        else
        {
            [weakSelf showToastMessage:error.errorDescription];
        }
        
    }];
}


- (void)headImageClicked:(NSString *)userId
{
    MOBIMOtherUserViewController  *viewController = [[MOBIMOtherUserViewController alloc] init];
    
    //获取成员
    MOBIMWEAKSELF
    [[MOBIMUserManager sharedManager] fetchUserInfo:userId needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
        
        if (!error)
        {
            //传递个人信息
            viewController.otherUser = [MOBIMUserManager userToUserModel:user];
            
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        }

    }];
    
}

@end
