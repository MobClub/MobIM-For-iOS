//
//  MOBIMGroupCreateAddMemebersController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/29.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMGroupCreateAddMemebersController.h"
#import "MOBIMBaseViewSelectCell.h"
#import "MOBIMGConst.h"
#import "MOBIMBaseButtonCell.h"
#import "UIColor+MOBIMExtentions.h"
#import "MOBIMUser.h"
#import "UIViewController+MOBIMToast.h"
#import "MOBIMBaseSectionCell.h"
#import "MOBIMChatRoomGroupController.h"

@interface MOBIMGroupCreateAddMemebersController ()
@property (nonatomic, strong) NSMutableDictionary *selectedMembersDict;
@property (nonatomic, strong) MOBIMBaseButtonCell *createCell;

@property (nonatomic, strong) MOBIMBaseSectionCell *section1Cell;



@end

@implementation MOBIMGroupCreateAddMemebersController

- (MOBIMBaseSectionCell*)section1Cell
{
    if (!_section1Cell)
    {
        _section1Cell = [[MOBIMBaseSectionCell alloc] init];
    }
    return _section1Cell;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择联系人";
    
    [self loadData];
    [self loadUI];
}

- (MOBIMBaseButtonCell*)createCell
{
    if (!_createCell)
    {
        _createCell = [[MOBIMBaseButtonCell alloc] init];
    }
    return _createCell;
}


- (void)loadData
{
    self.selectedMembersDict = [NSMutableDictionary new];
    self.dataArray=[NSMutableArray arrayWithCapacity:3];
    self.tableView.tableHeaderView = self.section1Cell;
    
    self.createCell.frame = CGRectMake(0, 0, self.view.bounds.size.width, 65);
    
    
    MOBIMWEAKSELF
    //用户数据相关
    
    [[MOBIMUserManager sharedManager] fetchContacts:^(NSMutableArray<MOBIMUser *> *contacts, NSError *error) {
        
        NSMutableArray *users = [NSMutableArray new];
        [users addObjectsFromArray:contacts];
        
        //测试
        if ([users count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:contacts];
            
        }
    }];
    
    
}

- (void)loadUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMBaseViewSelectCell" bundle:nil] forCellReuseIdentifier:KMOBIMBaseViewSelectCellTag];

    self.tableView.tableFooterView = self.createCell;
    [self.createCell.button setTitle:@"确认新建群" forState:UIControlStateNormal];
    [self.createCell.button addTarget:self action:@selector(confirmClicked:) forControlEvents:UIControlEventTouchUpInside];
}



- (void)confirmClicked:(UIButton*)button
{
    if (!_otherUser)
    {
        if (self.selectedMembersDict.count < 1)
        {
            [self showAlertWithText:@"请选择成员"];
            
            return;
        }
    }
    

    
    NSMutableArray *seletedmembers = [NSMutableArray array];
    MOBIMWEAKSELF
    [self.selectedMembersDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        BOOL selected = [obj boolValue];
        if (selected) {
            NSInteger row =  [key intValue];
            [seletedmembers addObject:weakSelf.dataArray[row]];
        }
    }];
    
    if (_otherUser)
    {
        
        [seletedmembers addObject:_otherUser];
    }
    
    
    NSMutableArray *selectedUserIds = [NSMutableArray new];
    [seletedmembers enumerateObjectsUsingBlock:^(MOBIMUser *user, NSUInteger idx, BOOL * _Nonnull stop) {
        if (user.appUserId) {
            
            [selectedUserIds addObject:user.appUserId];
        }
    }];
    
    
    
    if (self.groupName.length <= 0)
    {
        self.groupName = @"群组";
    }
    
    
    [self showToastWithIndeterminateHUDMode];
    [[MobIM getGroupManager] createGroupWithGroupName:self.groupName groupDesc:self.introduction groupNoti:nil groupMembers:selectedUserIds resultHandler:^(MIMGroup *group, MIMError *error) {
        
        [self performMainBlock:^{
            if (error)
            {
                [weakSelf showToastMessage:error.errorDescription];
            }
            else
            {
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMGroupCreateSucessNtf object:group];
                UIViewController *rootViewController = self.navigationController.viewControllers.firstObject;
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                
                //进入群组聊天页面
                {
                    //群组会话
                    MOBIMChatRoomGroupController *groupVC = [MOBIMChatRoomGroupController new];
                    groupVC.groupInfo = group;
                    groupVC.groupId = group.groupId;
                    
                    
                    [rootViewController.navigationController pushViewController:groupVC animated:YES];
                }
                
                [weakSelf dismissToast];
                
            }
        }];

        
    }];
        
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOBIMBaseViewSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:KMOBIMBaseViewSelectCellTag];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selectedButton.tag = indexPath.row;
    
    if (indexPath.row != [self.dataArray count]-1) {
        cell.bottomLineLabel.hidden = NO;
    }
    else
    {
        cell.bottomLineLabel.hidden = YES;
    }
    
    MOBIMUser *model = self.dataArray[indexPath.row];

    
    
    if (self.selectedMembersDict && self.selectedMembersDict[[NSNumber numberWithInteger:indexPath.row]])
    {
        cell.selectedButton.selected = YES;
    }
    else
    {
        cell.selectedButton.selected = NO;
    }
    
    if (_otherUser)
    {
        if ([_otherUser.appUserId isEqualToString:model.appUserId])
        {
            //图片显示不一样
            cell.selectedButton.selected = YES;
            
        }
    }
    
    [cell.headImageVIew sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
    cell.nameLabel.text = model.nickname;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_otherUser)
    {
        MOBIMUser *model = self.dataArray[indexPath.row];
        if ([_otherUser.appUserId isEqualToString:model.appUserId])
        {
            return;
        }
    }
    
    MOBIMBaseViewSelectCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.selectedButton.selected =  !cell.selectedButton.selected;
    
    if (cell.selectedButton.selected)
    {
        [self.selectedMembersDict setObject:[NSNumber numberWithBool:cell.selectedButton.selected] forKey:[NSNumber numberWithInteger:cell.selectedButton.tag]];
    }
    else
    {
        [self.selectedMembersDict removeObjectForKey:[NSNumber numberWithInteger:cell.selectedButton.tag]];
    }
    
    NSString *title = ([self.selectedMembersDict count]>0) ? [NSString stringWithFormat:@"确认建群 (%ld人)",[self.selectedMembersDict count]] :@"确认建群";
    [self.createCell.button setTitle:title forState:UIControlStateNormal];
}

@end
