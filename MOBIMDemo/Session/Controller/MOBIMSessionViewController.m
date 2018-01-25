//
//  MOBIMSessionViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMSessionViewController.h"
#import "MOBIMSessionCell.h"
#import "MOBIMChatRoomViewController.h"
#import "MOBIMChatRoomGroupController.h"
#import "MOBIMTipsViewController.h"
#import "MOBIMBaseSectionCell.h"
#import "MOBIMUserChatRoomController.h"
#import "MOBIMUser.h"
#import "MOBIMUserManager.h"
#import "MOBIMGroupModel.h"
#import "MOBIMTipsDetailViewController.h"
#import "MOBIMAvatarButton.h"
#import "MOBIMTipsModel.h"
#import "UIViewController+MOBIMToast.h"
#import "MOBIMGConfigManager.h"
#import "MOBIMNetworkErrorView.h"

static NSString *const KMOBIMSessionCellId = @"KMOBIMSessionCellId";

@interface MOBIMSessionViewController ()<UITableViewDelegate,UITableViewDataSource>

//顶部间隔试图
@property (nonatomic, strong) MOBIMBaseSectionCell *section1Cell;
@property (nonatomic, strong) MOBIMNetworkErrorView *disconnectView;

@property (nonatomic, strong) UIView *headView;


/**
 指令运作队列
 */
@property (nonatomic) dispatch_queue_t commandQueue;

/**
 获取应用配置信号量
 */
@property (nonatomic) dispatch_semaphore_t configSemaphore;

/**
 是否加载过监听
 */
@property (nonatomic) BOOL hasAppear;


/**
 scoket 状态  0-失败,1-成功, 2-连接中
 */
@property (nonatomic) int connectState;

@end

@implementation MOBIMSessionViewController

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.hasAppear)
    {
        self.hasAppear = YES;
        [self registerListener];
    }
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}

- (void)registerListener
{
    [self converstionChanged];
    MOBIMWEAKSELF
    [MobIM onConnected:^(MIMUser * _Nonnull currentUser) {
        weakSelf.connectState = 1;

        [weakSelf performMainBlock:^{
            weakSelf.tableView.tableHeaderView = weakSelf.section1Cell;

        }];
    }];
    
    [MobIM onConnecting:^(MIMUser * _Nonnull currentUser) {
        
        weakSelf.connectState = 2;
        [weakSelf performSelector:@selector(delayShowConnectioning) withObject:nil afterDelay:0.03];


    }];
    
    [MobIM onDisConnected:^(MIMError * _Nullable error) {
        
        weakSelf.connectState = 0;

        [weakSelf performMainBlock:^{
            [weakSelf.disconnectView setTitle:@"连接已断开..."];
            weakSelf.tableView.tableHeaderView = weakSelf.disconnectView;
        }];

    }];
}

//防止启动的时候，有“连接中...”  一闪而过
- (void)delayShowConnectioning
{
    MOBIMWEAKSELF
    if (weakSelf.connectState == 2) {
        
        [self performMainBlock:^{
            [weakSelf.disconnectView setTitle:@"连接中..."];
            weakSelf.tableView.tableHeaderView = weakSelf.disconnectView;
        }];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.commandQueue = dispatch_queue_create("MOBIMSessionVCCommandQueue", DISPATCH_QUEUE_SERIAL);


    [self loadUI];
    [self loadData];
    
}


- (MOBIMBaseSectionCell *)section1Cell
{
    if (!_section1Cell) {
        _section1Cell = [[MOBIMBaseSectionCell alloc] init];
    }
    return _section1Cell;
}

- (MOBIMNetworkErrorView *)disconnectView
{
    if (!_disconnectView) {
        _disconnectView = [[MOBIMNetworkErrorView alloc] initWithFrame:CGRectMake(0, 10, MOIMDevice_Width, 40.0f+10.0f)];
        
    }
    return _disconnectView;
}


- (void)loadData
{
    
    
    MOBIMWEAKSELF
    //第一次安装应用时获取离线消息
    if ([[MOBIMGConfigManager sharedManager] isfirstLanch]) {
        
        // 设置程序已经使用过
        [[MOBIMGConfigManager sharedManager] setHasLanch];
        

        [[MobIM getChatManager] getConversationListOnCompletion:^(NSArray<MIMConversation *> *conversationList, MIMError *error) {
            
            if (error)
            {
                [weakSelf performMainBlock:^{
                    [weakSelf showToastMessage:error.errorDescription];
                }];
            }
            else{
                
                dispatch_async(self.commandQueue, ^{
                    
                    
                    if (conversationList) {
                        [weakSelf.dataArray removeAllObjects];
                        [weakSelf.dataArray addObjectsFromArray:conversationList];


                    }
                    
                    
                    [weakSelf performMainBlock:^{
                        
                        //处理提醒号相关
                        [conversationList enumerateObjectsUsingBlock:^(MIMConversation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (obj.conversationType == MIMConversationTypeSystem) {
                                
                                [MOBIMUserManager saveUserToAppTipUser:obj.fromUserInfo];
                                
                            }
                        }];
                        [weakSelf.tableView reloadData];
                    }];
                    
                    
                    
                });
                
                
            }
            
            
        }];
    }
    else
    {
        [[MobIM getChatManager] getLocalConversationList:^(NSArray<MIMConversation *> *conversationList) {
            
            dispatch_async(self.commandQueue, ^{
                
                
                if (conversationList) {
                    [weakSelf.dataArray removeAllObjects];
                    //            [weakSelf.dataArray addObjectsFromArray:[[conversationList reverseObjectEnumerator] allObjects]];
                    
                    [weakSelf.dataArray addObjectsFromArray:conversationList];
                    
                }
                
                
                [weakSelf performMainBlock:^{
                    
                    //处理提醒号相关
                    [conversationList enumerateObjectsUsingBlock:^(MIMConversation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.conversationType == MIMConversationTypeSystem) {
                            
                            [MOBIMUserManager saveUserToAppTipUser:obj.fromUserInfo];
                            
                        }
                    }];
                    [weakSelf.tableView reloadData];
                }];
                
                
                
            });
            
        }];
       
        
    }

    

    

}


- (void)loadUI
{
//    self.title=@"会话";
    [self setCustomTitle:@"会话"];
    
    //顶部间隔设置
    self.tableView.tableHeaderView = self.section1Cell ;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(0);
    }];
    
    //注册 MOBIMSessionCell
    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMSessionCell" bundle:nil] forCellReuseIdentifier:KMOBIMSessionCellId];

    

    
//    UIButton *btn =[UIButton new];
//    btn.frame = CGRectMake(100, 100, 100, 100);
//    [self.view addSubview:btn];
//    btn.backgroundColor=[UIColor redColor];
//    [btn addTarget:self action:@selector(converstionChanged) forControlEvents:UIControlEventTouchUpInside];
    
    //[self performSelector:@selector(converstionChanged) withObject:nil afterDelay:0.02];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)converstionChanged
{
    
    //监听消息,变化时
    MOBIMWEAKSELF
    
    [self performMainBlock:^{
        //监听消息,变化时
        [[MobIM getChatManager] onLocalConversationListResultChanged:^(MIMConversation *changedConversation, NSFetchedResultsChangeType changeType) {
            
            if (changeType != NSFetchedResultsChangeDelete)
            {
                
                dispatch_async(weakSelf.commandQueue, ^{
                    
                    [weakSelf handleComeMessage:changedConversation];
                    
                });
            }
            else
            {
                
                MOBIMWEAKSELF
                dispatch_async(weakSelf.commandQueue, ^{
                    
                    [weakSelf deleteMessageWithSession:changedConversation];
                    
                });
            }
        }];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleComeMessage:(MIMConversation *)conversation
{
    __block MIMConversation *findConversation = nil;
    //内存数据处理
    NSMutableArray *sessions = [NSMutableArray arrayWithArray:self.dataArray];
    [sessions enumerateObjectsUsingBlock:^(MIMConversation *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.conversationId && conversation.conversationId &&  [obj.conversationId isEqualToString:conversation.conversationId]) {
            
            findConversation = obj;
            *stop = YES;
        }
    }];
    
    if (findConversation)
    {
        
        [sessions removeObject:findConversation];
        
    }
    else
    {
        findConversation = conversation;
    }
    
    [sessions insertObject:findConversation atIndex:0];
    
    
    self.dataArray = sessions;
    
    [self performMainBlock:^{
        [self.tableView reloadData];
        
    }];
}


#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOBIMSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:KMOBIMSessionCellId];
    [cell setDataModel:self.dataArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    MIMConversation *sessionModel = self.dataArray[indexPath.row];
    if (sessionModel.conversationId)
    {
        
        [[MobIM getChatManager] updateMessagesToReadedInConversation:sessionModel];
    }
    
    if (sessionModel.conversationType == MIMConversationTypeSystem)
    {
      
        
        MOBIMTipsDetailViewController *roomViewController=[MOBIMTipsDetailViewController new];
        roomViewController.tipsModel = sessionModel.fromUserInfo;
        roomViewController.tipsId = sessionModel.fromUserInfo.appUserId;
        [self.navigationController pushViewController:roomViewController animated:YES];
        
    }
    else if (sessionModel.conversationType == MIMConversationTypeGroup || sessionModel.conversationType == MIMConversationTypeNotice)
    {
        MOBIMChatRoomGroupController *vc = [MOBIMChatRoomGroupController new];
        vc.groupInfo = sessionModel.fromGroupInfo;
        vc.groupId = sessionModel.fromGroupInfo.groupId;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sessionModel.conversationType == MIMConversationTypeSingle)
    {

        
        MOBIMUserChatRoomController *vc = [MOBIMUserChatRoomController new];
        vc.contact = [MOBIMUserManager userSdkToUserModel:sessionModel.fromUserInfo];
        vc.otherUserId = sessionModel.fromUserInfo.appUserId;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    /*
    //好友会话
    if (session.chatRoomType == MOBIMChatRoomTypeChat) {
        
        NSPredicate *groupUserPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND userId = %@",[MOBIMUserManager sharedManager].currentUser.userId,session.userId];
        MOBIMUser *user  = [MOBIMUser MR_findFirstWithPredicate:groupUserPredicate sortedBy:nil ascending:YES];
        //MOBIMUserModel *contactModel = [MOBIMUserManager userToUserModel:user];
        
        MOBIMUserChatRoomController *vc = [MOBIMUserChatRoomController new];
        vc.contact = user;
        vc.otherUserId = session.userId;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if (session.chatRoomType == MOBIMChatRoomTypeGroup){
      //群组会话
        NSPredicate *groupUserPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND groupId = %@",[MOBIMUserManager sharedManager].currentUser.userId,session.roomId];
        MOBIMGroup *group  = [MOBIMGroup MR_findFirstWithPredicate:groupUserPredicate sortedBy:nil ascending:YES];
        //MOBIMGroupModel *groupModel = [MOBIMUserManager groupToGroupModel:group];
        
        MOBIMChatRoomGroupController *vc = [MOBIMChatRoomGroupController new];
        vc.groupInfo = group;
        vc.groupId = session.roomId;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if (session.chatRoomType == MOBIMChatRoomTypeTips){
        //系统提示
        
        NSPredicate *groupUserPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND userId = %@",[MOBIMUserManager sharedManager].currentUser.userId,session.userId];
        MOBIMUser *user  = [MOBIMUser MR_findFirstWithPredicate:groupUserPredicate sortedBy:nil ascending:YES];
        //MOBIMUserModel *contactModel = [MOBIMUserManager userToUserModel:user];
        
        MOBIMTipsModel *tipsModel = [MOBIMTipsModel new];
        tipsModel.uId = user.userId;
        tipsModel.name = user.nickname;
        tipsModel.avatar = user.avatar;
        
        MOBIMTipsDetailViewController *roomViewController=[MOBIMTipsDetailViewController new];
        //roomViewController.chatRoomType = _otherUserCell.chatRoomType;
        roomViewController.tipsModel = tipsModel;
        roomViewController.tipsId = session.userId;
        [self.navigationController pushViewController:roomViewController animated:YES];
    }
     */
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置删除按钮
    MOBIMWEAKSELF
    UITableViewRowAction * deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf deleteMessage:indexPath];
    }];
    
    return  @[deleteRowAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

#pragma mark --删除与标记
- (void)deleteMessage:(NSIndexPath*)indexPath
{

    MOBIMWEAKSELF
    dispatch_async(self.commandQueue, ^{
        
        MIMConversation *session = weakSelf.dataArray[indexPath.row];
        
        [weakSelf deleteMessageWithSession:session];
        
    });

}

- (void)deleteMessageWithSession:(MIMConversation*)session
{
    //内存数据处理
    NSMutableArray *sessions = [NSMutableArray arrayWithArray:self.dataArray];
    [sessions removeObject:session];
    self.dataArray = sessions;
    
    //数据库处理
    [[MobIM getChatManager] deleteLocalConversations:@[session]];
    
    MOBIMWEAKSELF
    [self performMainBlock:^{
        
        [weakSelf.tableView reloadData];
        
    }];
}



@end

