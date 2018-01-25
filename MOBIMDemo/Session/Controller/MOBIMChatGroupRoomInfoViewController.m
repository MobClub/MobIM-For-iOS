//
//  MOBIMChatGroupRoomInfoViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatGroupRoomInfoViewController.h"
#import "MOBIMBaseAvatarCell.h"
#import "MOBIMBaseTitleStyleCell.h"
#import "MOBIMBaseSwitchCell.h"
#import "MOBIMBaseDesCell.h"
#import "MOBIMGConst.h"
#import "Masonry.h"
#import "UIColor+MOBIMExtentions.h"
#import "MOBIMBaseButtonCell.h"
#import "MOBIMGroupTranferViewController.h"
#import "MOBIMGroupDeleteMemeberViewController.h"
#import "MOBIMGroupAddMemeberViewController.h"
#import "MOBIMBaseEditDesViewController.h"
#import "MOBIMGroupEditNoticeViewController.h"
#import "MOBIMGroupEditIntroductionViewController.h"
#import "MOBIMBaseEditNickNameViewController.h"
#import "MOBIMBaseEditGroupNameViewController.h"
#import "MOBIMMessageGroupModel.h"
#import "MOBIMBaseSectionCell.h"
#import "MOBIMVCard.h"
#import "MOBIMUser.h"
#import "MOBIMUserManager.h"
#import "UIViewController+MOBIMToast.h"
#import "MOBIMGroupShowMemebersController.h"




@interface MOBIMChatGroupRoomInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

//头像
@property (nonatomic, strong) MOBIMBaseAvatarCell  *avatarCell;

//群名
@property (nonatomic, strong) MOBIMBaseTitleStyleCell  *groupNameCell;

//群id
@property (nonatomic, strong) MOBIMBaseTitleStyleCell  *groupIdCell;

//群简介
@property (nonatomic, strong) MOBIMBaseDesCell  *introductionCell;

//群通知
@property (nonatomic, strong) MOBIMBaseDesCell  *noticeCell;

//用户在群中的昵称
@property (nonatomic, strong) MOBIMBaseTitleStyleCell  *nicknameCell;

//群消息免打扰
@property (nonatomic, strong) MOBIMBaseSwitchCell  *disturbCell;

//群转让
@property (nonatomic, strong) MOBIMBaseTitleStyleCell  *tranferCell;

//解散或退群
@property (nonatomic, strong) MOBIMBaseButtonCell  *deleteCell;

//@property (nonatomic, strong) MOBIMMessageGroupModel *groupModel;

@property (nonatomic, strong) MOBIMBaseSectionCell *section1Cell;
@property (nonatomic, strong) MOBIMBaseSectionCell *section2Cell;
@property (nonatomic, strong) MOBIMBaseSectionCell *section3Cell;
@property (nonatomic, strong) MOBIMBaseSectionCell *section4Cell;
@property (nonatomic, strong) MOBIMBaseSectionCell *section5Cell;


//界面布局数组
@property (nonatomic, strong) NSArray *cellTagArray;

//是否显示 menu
@property (nonatomic, assign) BOOL isMenuShowing;

//群主id
@property (nonatomic, strong) NSString *owerId;

//组id
@property (nonatomic, strong) NSString *groupId;

//用户名片(群组中)
@property (nonatomic, strong) MIMVCard *myGroupVcard;

//群名片（相对于用户）
//@property (nonatomic, strong) MOBIMVCard *groupVcard;

@property (nonatomic, assign) BOOL isGroupRoomOwer;

//群组中的昵称
@property (nonatomic, strong) NSString *nickName;


@end

@implementation MOBIMChatGroupRoomInfoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    MOBIMWEAKSELF
    [[MobIM getGroupManager] getGroupInfoWithGroupId:_groupInfo.groupId options:MIMGroupInfoOptionMembers|MIMGroupInfoOptionDescription resultHandler:^(MIMGroup *group, MIMError *error) {

        if (!error)
        {
            weakSelf.groupInfo = group;
            [weakSelf performMainBlock:^{
                [weakSelf loadData];
                [weakSelf.tableView reloadData];
            }];
        }
        else
        {
            [weakSelf performMainBlock:^{

                [weakSelf showToastMessage:error.errorDescription];
            }];
        }

    }];
    
    [self loadUI];

    [self loadData];
}


- (NSString *)nickName
{
    if (self.myGroupVcard) {
        
        return self.myGroupVcard.groupNickname;
    }
    
    
    
    return _nickName;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}



- (MOBIMBaseSectionCell *)section1Cell
{
    if (!_section1Cell) {
        _section1Cell = [[MOBIMBaseSectionCell alloc] init];

    }
    return _section1Cell;
}


- (MOBIMBaseSectionCell *)section2Cell
{
    if (!_section2Cell) {
        _section2Cell = [[MOBIMBaseSectionCell alloc] init];
    }
    return _section2Cell;
}


- (MOBIMBaseSectionCell *)section3Cell
{
    if (!_section3Cell) {
        _section3Cell = [[MOBIMBaseSectionCell alloc] init];
    }
    return _section3Cell;
}

- (MOBIMBaseSectionCell *)section4Cell
{
    if (!_section4Cell) {
        _section4Cell = [[MOBIMBaseSectionCell alloc] init];
    }
    return _section4Cell;
}

- (MOBIMBaseSectionCell *)section5Cell
{
    if (!_section5Cell) {
        _section5Cell = [[MOBIMBaseSectionCell alloc] init];
    }
    return _section5Cell;
}


- (BOOL)isGroupRoomOwer
{
    if (self.groupInfo.owner.appUserId && [MOBIMUserManager currentUserId] && [self.groupInfo.owner.appUserId isEqualToString:[MOBIMUserManager currentUserId]]) {
        
        return YES;
    }
    
    return NO;
}

- (void)loadCellsData
{
    if (self.isGroupRoomOwer == YES) {
        
        
        
        self.cellTagArray = @[
                              self.section1Cell,
                              self.avatarCell,
                              self.section2Cell,
                              self.groupNameCell,
                              self.groupIdCell,
                              self.introductionCell,
                              self.noticeCell,
                              self.section3Cell,
                              self.nicknameCell,
                              self.disturbCell,
                              self.section4Cell,
                              self.tranferCell,
                              self.section5Cell,
                              self.deleteCell
                              ];
        
    }
    else
    {
        self.cellTagArray = @[
                              self.section1Cell,
                              self.avatarCell,
                              self.section2Cell,
                              self.groupNameCell,
                              self.groupIdCell,
                              self.introductionCell,
                              self.noticeCell,
                              self.section3Cell,
                              self.nicknameCell,
                              self.disturbCell,
                              self.section5Cell,
                              self.deleteCell
                              ];
    }
}

- (void)loadData
{

    self.myGroupVcard = [[MobIM getGroupManager] getVCardWithGroupId:_groupInfo.groupId];
    
    self.groupNameCell.nameLabel.text = @"名称";
    self.groupIdCell.nameLabel.text = @"群组ID (长按可复制)";
    self.introductionCell.nameLabel.text = @"简介";
    self.noticeCell.nameLabel.text = @"公告";
    self.nicknameCell.nameLabel.text = @"我在本群昵称";
    self.disturbCell.nameLabel.text = @"消息免打扰";
    self.tranferCell.nameLabel.text = @"群组转让";
    
    
    self.noticeCell.textView.userInteractionEnabled = NO;
    self.introductionCell.textView.userInteractionEnabled = NO;
    
    _groupId = _groupInfo.groupId;
    
    
    
    [self loadCellsData];
    
    
    
    //[self.avatarCell setDataModel:_groupInfo isGroupOwer:[self isGroupRoomOwer]];
    //_avatarCell.frame = CGRectMake(0, 0, self.view.frame.size.width, _avatarCell.calHeight);
    
    //self.groupNameCell.desLabel.text = _groupInfo.groupName;
    self.groupNameCell.lineLabel.hidden = NO;
    
    //_groupIdCell.desLabel.text = _groupInfo.groupId;
    self.groupIdCell.lineLabel.hidden = NO;

    //_introductionCell.textView.text = _groupInfo.groupDesc;
    _introductionCell.lineLabel.hidden = NO;

    
    //_noticeCell.textView.text = _groupInfo.groupNotice;
    _noticeCell.lineLabel.hidden = YES;
    
    _nicknameCell.lineLabel.hidden = NO;

    
    _tranferCell.lineLabel.hidden = YES;
    _tranferCell.desLabel.hidden = YES;
    
    self.owerId = _groupInfo.owner.muid;
    

    
    
    
    for (MIMUser *user in _groupInfo.membersList.allObjects) {
        if ([user.appUserId isEqualToString:[MOBIMUserManager currentUserId]]) {
            self.nickName = user.nickname;
            break;
        }
    }
}


- (void)reloadMemebers:(MIMGroup*)groupInfo
{
    if ([groupInfo.membersList count] != groupInfo.membersCount && [groupInfo.membersList count] > 0)
    {
        self.title = [NSString stringWithFormat:@"群组详情(%zd人)",[groupInfo.membersList count]];

    }
    else
    {
        self.title = [NSString stringWithFormat:@"群组详情(%d人)",groupInfo.membersCount];

    }

}

- (void)loadUI
{
    [self reloadMemebers:self.groupInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillHide) name:UIMenuControllerWillHideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupTransferSucessNtf:) name:KMOBIMUserGroupTransferSucessNtf object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupNameModifiedSucessNtf:) name:KMOBIMGroupNameModifiedSucessNtf object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupIntroductionModifiedSucessNtf:) name:KMOBIMGroupIntroductionModifiedSucessNtf object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupNoticeModifiedSucessNtf:) name:KMOBIMGroupNoticeModifiedSucessNtf object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupAddMemebersSucessNtf:) name:KMOBIMGroupAddMemebersSucessNtf object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupDeleteMemebersSucessNtf:) name:KMOBIMGroupDeleteMemebersSucessNtf object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupUserNicknameModifiedSucessNtf:) name:KMOBIMGroupUserNicknameModifiedSucessNtf object:nil];





    _tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;


    MOBIMWEAKSELF
    [self.avatarCell setPlusCompletion:^{
        //添加
        if (weakSelf.groupInfo.membersCount >= 50) {
            [weakSelf showAlertWithText:@"群成员已满，不可再进行添加~" tag:0];
            return ;
        }

        MOBIMGroupAddMemeberViewController *vc = [[MOBIMGroupAddMemeberViewController alloc] init];
        vc.groupInfo = weakSelf.groupInfo;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];


    self.avatarCell.selectionStyle = UITableViewCellSeparatorStyleNone;
    [self.avatarCell setDeleteCompletion:^{
        //删除

        MOBIMGroupDeleteMemeberViewController *vc = [[MOBIMGroupDeleteMemeberViewController alloc] init];
        vc.groupInfo = weakSelf.groupInfo;
        vc.conversationId = weakSelf.conversationId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];


    [self.avatarCell setShowAllCompletion:^{
        MOBIMGroupShowMemebersController *vc = [[MOBIMGroupShowMemebersController alloc] init];
        vc.groupInfo = weakSelf.groupInfo;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];


    [self.disturbCell.switchControl addTarget:self action:@selector(disturChanged:) forControlEvents:UIControlEventValueChanged];


    [self.deleteCell setButtonClickCompletion:^{

        if (weakSelf.isGroupRoomOwer == YES) {
            [weakSelf showAlertWithText:@"您是此群的群主，删除并退出后此群将会解散，确认删除退出？" tag:KMOBIMOwerDeleteTag];
        }
        else
        {
            [weakSelf showAlertWithText:@"删除并退出后你将不再是此群的成员，确认删除退出？" tag:KMOBIMUnOwerDeleteTag];
        }

    }];
    
}


- (void)groupUserNicknameModifiedSucessNtf:(NSNotification*)notification
{
    if (notification.object && [notification.object isKindOfClass:[MIMVCard class]]) {
        MIMVCard *userVcard =(MIMVCard*) notification.object;
        
        if ([userVcard.groupId isEqualToString:_groupInfo.groupId])
        {
            self.myGroupVcard = userVcard;

            // 刷新界面
            [self.tableView reloadData];
        }
    }
}


- (void)groupDeleteMemebersSucessNtf:(NSNotification*)notification
{
    if (notification.object && [notification.object isKindOfClass:[MIMGroup class]]) {
        MIMGroup *newGroup =(MIMGroup*) notification.object;
        
        if ([newGroup.groupId isEqualToString:self.groupId])
        {
            // 刷新界面
            if (_groupInfo != newGroup) {
                self.groupInfo = newGroup;
            }
            [self reloadMemebers:self.groupInfo];

            [self.tableView reloadData];

        }
    }
}


- (void)groupNameModifiedSucessNtf:(NSNotification*)notification
{
    if (notification.object && [notification.object isKindOfClass:[MIMGroup class]]) {
        MIMGroup *newGroup =(MIMGroup*) notification.object;
        
        //更新数据
        self.groupInfo = newGroup;
        
        // 刷新界面
        [self.tableView reloadData];
    }
}

- (void)groupIntroductionModifiedSucessNtf:(NSNotification*)notification
{
    if (notification.object && [notification.object isKindOfClass:[MIMGroup class]]) {
        MIMGroup *newGroup =(MIMGroup*) notification.object;
        
        //更新数据
        self.groupInfo = newGroup;
        
        // 刷新界面
        [self.tableView reloadData];
    }
}


- (void)groupNoticeModifiedSucessNtf:(NSNotification*)notification
{
    if (notification.object && [notification.object isKindOfClass:[MIMGroup class]]) {
        MIMGroup *newGroup =(MIMGroup*) notification.object;
        
        //更新数据
        self.groupInfo = newGroup;
        
        // 刷新界面
        [self.tableView reloadData];
    }
}

- (void)groupAddMemebersSucessNtf:(NSNotification*)notification
{
    if (notification.object && [notification.object isKindOfClass:[MIMGroup class]]) {
        MIMGroup *newGroup =(MIMGroup*) notification.object;
        
        if ([newGroup.groupId isEqualToString:self.groupId])
        {
            // 刷新界面
            if (_groupInfo != newGroup) {
                self.groupInfo = newGroup;
            }
            
            [self reloadMemebers:self.groupInfo];

            [self.tableView reloadData];
            
        }
    }
}

- (void)groupTransferSucessNtf:(NSNotification*)notification
{
    if (notification.object && [notification.object isKindOfClass:[MIMGroup class]]) {
        MIMGroup *newGroup =(MIMGroup*) notification.object;
        
        if ([newGroup.groupId isEqualToString:self.groupId])
        {
            
            self.owerId = newGroup.owner.appUserId;
            self.groupInfo = newGroup;
            [self reloadMemebers:self.groupInfo];
            [self loadCellsData];

            // 刷新界面
            [self.tableView reloadData];
            
        }
        
    }
}


- (void)showAlertWithText:(NSString*)text tag:(NSInteger)tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认删除", nil];
    alertView.tag = tag;
    [alertView show];
    
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == KMOBIMOwerDeleteTag && buttonIndex==1)
    {
        MOBIMWEAKSELF
        [[MobIM getGroupManager] exitGroupWithGroupId:_groupInfo.groupId  resultHandler:^(MIMGroup *group, MIMError *error) {
            
            //清理本地缓存数据
            if (weakSelf.conversationId)
            {
                [[MobIM getChatManager] deleteLocalConversationsByIds:@[weakSelf.conversationId]];
            }
            
            [self performMainBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMDisbandGroupSucessNtf object:_groupInfo.groupId];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        }];


    }
    else if (alertView.tag == KMOBIMUnOwerDeleteTag && buttonIndex==1)
    {
        MOBIMWEAKSELF
        [[MobIM getGroupManager] exitGroupWithGroupId:_groupInfo.groupId  resultHandler:^(MIMGroup *group, MIMError *error) {
            
            //清理本地缓存数据
            if (weakSelf.conversationId)
            {
                [[MobIM getChatManager] deleteLocalConversationsByIds:@[weakSelf.conversationId]];
            }
            
            [self performMainBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMDisbandGroupSucessNtf object:_groupInfo.groupId];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        }];

        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    long count = [self.cellTagArray count];
    return count;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.cellTagArray[indexPath.row];

    if (cell == self.avatarCell) {
        return [self.avatarCell calHeight];
    }
    else if (cell == self.introductionCell || cell == self.noticeCell)
    {
        return 104;
    }
    else if (self.section1Cell == cell)
    {
        return 15;
    }
    else if (self.section2Cell == cell)
    {
        return 5;
    }
    else if (self.section3Cell == cell)
    {
        return 10;
    }
    else if (self.section4Cell == cell)
    {
        return 10;
    }
    else if (self.section5Cell == cell)
    {
        return 10;
    }
     return 50;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = self.cellTagArray[indexPath.row];
    MOBIMBaseAvatarCell *avatarCell = self.avatarCell;
    if (cell == self.introductionCell)
    {

        _introductionCell.textView.text = _groupInfo.groupDesc;

    }
    else if (cell == self.noticeCell)
    {

        _noticeCell.textView.text = _groupInfo.groupNotice;

    }
    else if (cell == self.groupIdCell) {
        self.groupIdCell.lineLabel.hidden = NO;
        self.groupIdCell.showArrow = NO;
        self.groupIdCell.desLabel.text = _groupInfo.groupId;
    }
    else if (cell ==self.tranferCell)
    {

    }
    else if (cell == self.nicknameCell) {
        self.nicknameCell.lineLabel.hidden = NO;

        _nicknameCell.desLabel.text = self.nickName;
    }
    else if (cell ==self.groupNameCell)
    {
        self.groupNameCell.lineLabel.hidden = NO;
        self.groupNameCell.desLabel.text = _groupInfo.groupName;

    }
    else if (cell ==self.disturbCell)
    {
        self.disturbCell.switchControl.on = self.myGroupVcard.isDisturb;
        
    }
    else if (cell ==avatarCell)
    {
        [avatarCell  setDataModel:_groupInfo isGroupOwer:self.isGroupRoomOwer];
        
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    //MOBIMMessageUserModel *model = self.dataArray[indexPath.row];
    UITableViewCell *cell = self.cellTagArray[indexPath.row];
    if (cell == self.introductionCell) {
        MOBIMGroupEditIntroductionViewController *vc = [[MOBIMGroupEditIntroductionViewController alloc] init];
        vc.groupInfo = _groupInfo;
        
        vc.canEdit = self.isGroupRoomOwer;
        //vc.dateDes = _groupInfo.editIntroductionDate;
        vc.editDes = _groupInfo.groupDesc;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if (cell == self.noticeCell) {
        MOBIMGroupEditNoticeViewController *vc = [[MOBIMGroupEditNoticeViewController alloc] init];
        vc.groupInfo = _groupInfo;

        vc.canEdit = self.isGroupRoomOwer;
        
        //vc.dateDes = _groupInfo.editIntroductionDate;
        vc.editDes = _groupInfo.groupNotice;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (cell ==self.tranferCell)
    {
        MOBIMGroupTranferViewController *roomViewController=[MOBIMGroupTranferViewController new];
        roomViewController.groupInfo= _groupInfo;
        [self.navigationController pushViewController:roomViewController animated:YES];
    }
    else if (cell == self.nicknameCell) {
        
        /*
        if (self.myGroupVcard == nil) {
            _myGroupVcard = [MOBIMVCard MR_createEntity];
            _myGroupVcard.currentUserId = [MOBIMUserManager sharedManager].currentUser.appUserId;
            _myGroupVcard.uId = _groupInfo.groupId;
            _myGroupVcard.roomId = _groupInfo.groupId;
            _myGroupVcard.userId = [MOBIMUserManager sharedManager].currentUser.appUserId;
            _myGroupVcard.nickname = [MOBIMUserManager sharedManager].currentUser.nickname;
            
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
         */
        
        MOBIMBaseEditNickNameViewController *vc = [[MOBIMBaseEditNickNameViewController alloc] init];
        vc.groupInfo= _groupInfo;
        
        vc.userGroupCard = self.myGroupVcard;
        vc.canEdit = YES;
        
        vc.editDes = self.nickName;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (cell ==self.groupNameCell)
    {
        MOBIMBaseEditGroupNameViewController *vc = [[MOBIMBaseEditGroupNameViewController alloc] init];
        vc.groupInfo = _groupInfo;
        vc.canEdit = self.isGroupRoomOwer;
        vc.editDes = _groupInfo.groupName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



- (void)showMenuViewController:(UIView *)showInView
{
    if (self.isMenuShowing == YES) {
        return;
    }
    
    
    self.isMenuShowing = YES;
    UIMenuItem *copyMenuItem   = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage:)];
    [[UIMenuController sharedMenuController] setMenuItems:@[copyMenuItem]];
    [[UIMenuController sharedMenuController] setTargetRect:showInView.frame inView:showInView.superview ];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)copyMessage:(UIMenuItem *)copyMenuItem
{
        UIPasteboard *pasteboard  = [UIPasteboard generalPasteboard];
    if (self.groupInfo.groupId.length > 0) {
        pasteboard.string         = self.groupInfo.groupId;
        
        [self showToastMessage:@"群组ID已复制"];
        
    }
}

- (void)menuControllerWillHide
{
    self.isMenuShowing = NO;
}
     
- (BOOL) canBecomeFirstResponder{
    return YES;
}

#pragma mark UISwitch
- (void)disturChanged:(UISwitch*)switchControl
{
    [[MobIM getGroupManager] setGroupToDisturbByGroupId:_groupInfo.groupId isDisturb:switchControl.on];
    
}

- (MOBIMBaseAvatarCell *)avatarCell
{
    if (!_avatarCell) {
        _avatarCell = [[MOBIMBaseAvatarCell alloc] init];
    }
    
    return _avatarCell;
}

- (MOBIMBaseTitleStyleCell *)groupNameCell
{
    if (!_groupNameCell) {
        _groupNameCell = [[MOBIMBaseTitleStyleCell alloc] init];
    }
    
    return _groupNameCell;
}

- (MOBIMBaseTitleStyleCell *)groupIdCell
{
    if (!_groupIdCell) {
        
        MOBIMWEAKSELF
        _groupIdCell = [[MOBIMBaseTitleStyleCell alloc] init];
        [_groupIdCell setLongPressCompletionBlock:^(UILongPressGestureRecognizer *recognizer) {
            [weakSelf showMenuViewController:weakSelf.groupIdCell.desLabel];

        }];
        _groupIdCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return _groupIdCell;
}


- (MOBIMBaseDesCell *)introductionCell
{
    if (!_introductionCell) {
        _introductionCell = [[MOBIMBaseDesCell alloc] init];
    }
    
    return _introductionCell;
}

- (MOBIMBaseDesCell *)noticeCell
{
    if (!_noticeCell) {
        _noticeCell = [[MOBIMBaseDesCell alloc] init];
    }

    return _noticeCell;
}

- (MOBIMBaseTitleStyleCell *)nicknameCell
{
    if (!_nicknameCell) {
        _nicknameCell = [[MOBIMBaseTitleStyleCell alloc] init];
    }
    
    return _nicknameCell;
}



- (MOBIMBaseSwitchCell *)disturbCell
{
    if (!_disturbCell) {
        _disturbCell = [[MOBIMBaseSwitchCell alloc] init];
    }
    
    return _disturbCell;
}

- (MOBIMBaseTitleStyleCell *)tranferCell
{
    if (!_tranferCell) {
        _tranferCell = [[MOBIMBaseTitleStyleCell alloc] init];
    }
    
    return _tranferCell;
}

- (MOBIMBaseButtonCell *)deleteCell
{
    if (!_deleteCell) {
        _deleteCell = [[MOBIMBaseButtonCell alloc] init];
    }
    
    return _deleteCell;
}

- (BOOL)willBackToRootWithAlertTag:(NSInteger)tag
{
    return YES;
}

@end
