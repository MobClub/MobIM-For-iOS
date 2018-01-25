//
//  MOBIMTabBarController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMTabBarController.h"
#import "MOBIMNavigationController.h"
#import "MOBIMBaseViewController.h"
#import "MOBIMBadgeView.h"
#import "MOBIMGConfigManager.h"


 NSString *const KMOBIMItemTitle = @"KMOBIMItemTitle";
 NSString *const KMOBIMItemIcon = @"KMOBIMItemIcon";
 NSString *const KMOBIMItemSelectedIcon = @"KMOBIMItemSelectedIcon";
 NSString *const KMOBIMItemControllerClass = @"KMOBIMItemClass";
 NSString *const KMOBIMItemTitleColor = @"KMOBIMItemTitleColor";
 NSString *const KMOBIMItemTitleSelectedColor = @"KMOBIMItemTitleSelectedColor";



@interface MOBIMTabBarController ()

@property (nonatomic, copy) NSArray *tabItems;

/**
 是否加载过监听
 */
@property (nonatomic) BOOL hasAppear;

//底部未读总数
@property (nonatomic, strong) MOBIMBadgeView *unreadLabel;

//需要删除的会话id
@property (nonatomic, strong) NSString *conversationId;


@end

@implementation MOBIMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self loadUI];
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if (!self.hasAppear)
    {
        self.hasAppear = YES;
        [self registerListener];
        
        
        //获取黑名单
//        [[MOBIMUserManager sharedManager] fetchBlackList:^(NSArray<MIMUser *> *blackUsers, MIMError *error) {
//
//        }];
    }
    
}

- (void)registerListener
{
    MOBIMWEAKSELF
    NSInteger unreadCount = [[MobIM getChatManager] getAllUnreadMessagesOnResultChanged:^(NSInteger totalUnreadMessage) {
        
        [weakSelf reloadSessionUnReadMessage:totalUnreadMessage];
    }];
    [weakSelf reloadSessionUnReadMessage:unreadCount];

    
    //监听消息
    [[MobIM getChatManager] onMessageReceivedWithIdentifier:@"GlobalNum1" messageHandler:^(MIMMessage *message) {
        
        
        if (message.conversationType == MIMConversationTypeNotice && [message.body isKindOfClass:[MIMNoticeMessageBody class]])
        {
            MIMNoticeMessageBody *messageBody = (MIMNoticeMessageBody*)message.body;
            NSString *textContent = nil;
            NSString *curUserId = [MOBIMUserManager currentUserId];
            
            //            self.conversationId = message.conversationId;
            
            switch (messageBody.noticeType) {
                case MIMNoticeTypeGroupDisbanded:
                {
                    if (curUserId && message.ext && message.ext[@"id"] && message.ext[@"owner"] )
                    {
                        
                        textContent = [NSString stringWithFormat:@"你所在的群组\"%@\"已被解散",message.ext[@"name"]];
                        
                        if (message.conversationId) {
                            [[MobIM getChatManager] deleteLocalConversationsByIds:@[message.conversationId]];
                        }
                        
                        [weakSelf performMainBlock:^{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:textContent delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                            alertView.tag = KMOBIMGroupDisbandedTag;
                            [alertView show];
                        }];
                        
                    }
                }
                    break;
                case MIMNoticeTypeMemberRemoved:
                {
                    
                    
                    textContent = [NSString stringWithFormat:@"你已被移除出群组: %@",message.ext[@"name"]];
                    
                    if (message.conversationId) {
                        [[MobIM getChatManager] deleteLocalConversationsByIds:@[message.conversationId]];
                    }
                    
                    [weakSelf performMainBlock:^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:textContent delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                        alertView.tag = KMOBIMGroupMemberRemovedTag;
                        
                        [alertView show];
                    }];
                    
                    
                }
                    break;
                default:
                    break;
            }
        }
        }];
    
    
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

- (void)performMainBlock:(void(^)())block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

#pragma clang diagnostic pop

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*)tabItems
{
    if (!_tabItems) {
        _tabItems=@[
                    @{KMOBIMItemTitle:@"会话",
                      KMOBIMItemIcon:@"tabbar_session",
                      KMOBIMItemSelectedIcon:@"tabbar_session_hl",
                      KMOBIMItemControllerClass:@"MOBIMSessionViewController"
                      },
                    @{KMOBIMItemTitle:@"通讯录",
                      KMOBIMItemIcon:@"tabbar_contacts",
                      KMOBIMItemSelectedIcon:@"tabbar_contacts_hl",
                      KMOBIMItemControllerClass:@"MOBIMContactViewController"
                      },
                    @{KMOBIMItemTitle:@"我的",
                      KMOBIMItemIcon:@"tabbar_my",
                      KMOBIMItemSelectedIcon:@"tabbar_my_hl",
                      KMOBIMItemControllerClass:@"MOBIMPersonalViewController"
                      }];
    }
    return _tabItems;
}

- (void)loadData
{
    [self tabItems];
}

- (void)loadUI
{
    [self loadTabItems];
    
}
- (void)loadTabItems
{
    if (self.tabItems.count>0) {
        
        
        [self.tabItems enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull itemDict, NSUInteger idx, BOOL * _Nonnull stop) {
            Class class= NSClassFromString(itemDict[KMOBIMItemControllerClass]);
            UIViewController *viewController = nil;
            if (!class)
            {
                viewController = [UIViewController new];
            }
            else
            {
                viewController=[(MOBIMBaseViewController*)[class alloc] init];
            }
            MOBIMNavigationController *navigationController = [[MOBIMNavigationController alloc] initWithRootViewController:viewController];
            [self setTabBarItem:itemDict navigationController:navigationController];
            [self addChildViewController:navigationController];
        }];
    }
    
}

- (void)setTabBarItem:(NSDictionary*)itemDict navigationController:(UINavigationController*)navigationController
{
    UITabBarItem *item = navigationController.tabBarItem;
    item.title = itemDict[KMOBIMItemTitle];
    item.image = [UIImage imageNamed:itemDict[KMOBIMItemIcon]];
    item.selectedImage = [[UIImage imageNamed:itemDict[KMOBIMItemSelectedIcon]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MOBIMRGB(0xA6A6B2),NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MOBIMRGB(0x29C18B),NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
}

- (void)reloadSessionUnReadMessage:(long long)unreadMessage
{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMessage;
    
    
    if (![self.unreadLabel superview]) {
        
        [self.tabBar addSubview:self.unreadLabel];
    }
    self.unreadLabel.hidden=unreadMessage<1;
    self.unreadLabel.badgeTextColor = [UIColor whiteColor];
    self.unreadLabel.badgeAlignment = MOBIMBadgeAlignmentTop|MOBIMBadgeAlignmentLeft;
    
    if (unreadMessage > 99)
    {
        self.unreadLabel.badgeType = MOBIMBadgeTypeNumber;
        _unreadLabel.badgeText = @"99+";
        self.unreadLabel.hidden = NO;
        self.unreadLabel.specificText = @"99+";
    }
    else if (unreadMessage < 99 && unreadMessage > 0)
    {
        self.unreadLabel.badgeType = MOBIMBadgeTypeNumber;
        _unreadLabel.badgeText = [NSString stringWithFormat:@"%lld", unreadMessage];
        self.unreadLabel.hidden = NO;
        
    }
    else
    {
        self.unreadLabel.hidden = YES;
    }
    
    
    float percentX = 0.18;
    CGRect tabFrame = self.tabBar.frame;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.05 * tabFrame.size.height);
    self.unreadLabel.frame = CGRectMake(x, y, 40, 16);

    
}

- (MOBIMBadgeView *)unreadLabel
{
    if (_unreadLabel == nil) {
        
        _unreadLabel= [[MOBIMBadgeView alloc] init];
        _unreadLabel.backgroundColor = [UIColor clearColor];
        _unreadLabel.badgeBackgroundColor = MOBIMRGB(0xFF624D);
        _unreadLabel.badgeTextFont = [UIFont boldSystemFontOfSize:11];
        _unreadLabel.userInteractionEnabled = NO;
    }
    
    
    return _unreadLabel;
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (KMOBIMGroupDisbandedTag == alertView.tag || KMOBIMGroupMemberRemovedTag == alertView.tag) {
        MOBIMBaseViewController *vc = [[MOBIMGConfigManager sharedManager] curViewController];
        if (vc && [vc respondsToSelector:@selector(willBackToRootWithAlertTag:)]) {
            BOOL will = [vc willBackToRootWithAlertTag:alertView.tag];
            if (will) {
                [self.selectedViewController popToRootViewControllerAnimated:YES];
            }
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
