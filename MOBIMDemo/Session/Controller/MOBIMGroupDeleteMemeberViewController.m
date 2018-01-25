//
//  MOBIMGroupDeleteMemeberViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMGroupDeleteMemeberViewController.h"
#import "MOBIMBaseViewSelectCell.h"
#import "MOBIMGConst.h"
#import "MOBIMBaseButtonCell.h"
#import "UIColor+MOBIMExtentions.h"
#import "UIViewController+MOBIMToast.h"

@interface MOBIMGroupDeleteMemeberViewController ()

//底部删除按钮
@property (nonatomic, strong) MOBIMBaseButtonCell *buttonCell;

//选中的成员
@property (nonatomic, strong) NSMutableDictionary *selectedMembersDict;


@end

@implementation MOBIMGroupDeleteMemeberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
    [self loadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadUI
{
    self.title = @"删除成员";
    self.tableView.backgroundColor = MOBIMRGB(0xEFEFF3);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMBaseViewSelectCell" bundle:nil] forCellReuseIdentifier:KMOBIMBaseViewSelectCellTag];
    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMBaseButtonCell" bundle:nil] forCellReuseIdentifier:KMOBIMBaseButtonCellTag];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MOIMDevice_Width, 65)];
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:self.buttonCell];
    self.tableView.tableFooterView = footerView;
    
}


- (void)loadData
{
    self.selectedMembersDict = [NSMutableDictionary new];
    self.dataArray=[NSMutableArray arrayWithCapacity:3];
    
//    [self.dataArray addObjectsFromArray:_groupInfo.grou];

    if ([_groupInfo.membersList count] > 0) {
        
        self.dataArray=[NSMutableArray arrayWithArray:_groupInfo.membersList.allObjects];
        
        [self.dataArray enumerateObjectsUsingBlock:^(MIMUser*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.appUserId isEqualToString:[MOBIMUserManager currentUserId]]) {
                [self.dataArray removeObject:obj];
                
                *stop = YES;
            }
        }];
    }
}


- (MOBIMBaseButtonCell *)buttonCell
{
    if (_buttonCell==nil) {
        _buttonCell = [[MOBIMBaseButtonCell alloc] init];
        [_buttonCell.button addTarget:self action:@selector(confirmDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
        _buttonCell.frame=CGRectMake(0, 10, MOIMDevice_Width, 45);
        [_buttonCell.button setTitle:@"删除" forState:UIControlStateNormal];
    }
    return _buttonCell;
}


- (void)confirmDeleteClicked:(UIButton*)button
{
    if (self.selectedMembersDict.count < 1) {
        [self showAlertWithText:@"请选择成员"];

        return;
    }
    
    NSMutableArray *lastMemebers = [NSMutableArray new];
    MOBIMWEAKSELF
    [self.selectedMembersDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSInteger row =  [key intValue];
        MOBIMUser *model = weakSelf.dataArray[row];

        [lastMemebers addObject:model.appUserId];

    }];
    
    //网络删除
    [[MobIM getGroupManager] deleteGroupMembers:lastMemebers inGroup:_groupInfo.groupId resultHandler:^(MIMGroup *group, MIMError *error) {
        
        if (!error)
        {
            if ([group.membersList count] <= 1)
            {
                //清理本地缓存数据
                if (weakSelf.conversationId)
                {
                    [[MobIM getChatManager] deleteLocalConversationsByIds:@[weakSelf.conversationId]];
                }
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"群成员已被全部删除，群组已自动解散~" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                alertView.tag = KMOBIMOwerDeleteMemeberTag;
                [alertView show];
                
                return ;
            }
            [weakSelf performMainBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMGroupDeleteMemebersSucessNtf object:_groupInfo];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }];
        }
        else
        {
            [weakSelf showToastMessage:error.errorDescription];
        }
        

    }];
    
    
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == KMOBIMOwerDeleteMemeberTag)
    {
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMDisbandGroupSucessNtf object:_groupInfo.groupId];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOBIMBaseViewSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:KMOBIMBaseViewSelectCellTag];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selectedButton.tag = indexPath.row;
    
    if (indexPath.row != [self.dataArray count]-1)
    {
        cell.bottomLineLabel.hidden = NO;
        
    }
    else
    {
        cell.bottomLineLabel.hidden = YES;
    }
    
    
    if (self.selectedMembersDict && self.selectedMembersDict[[NSNumber numberWithInteger:indexPath.row]])
    {
        cell.selectedButton.selected = YES;
    }
    else
    {
        cell.selectedButton.selected = NO;
    }
    

    MIMUser *model = self.dataArray[indexPath.row];
    [[MOBIMUserManager sharedManager] fetchUserInfo:model.appUserId needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
        if (user) {
            cell.nameLabel.text = user.nickname;
            [cell.headImageVIew sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
            
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MOBIMBaseViewSelectCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.selectedButton.selected =  !cell.selectedButton.selected;
    
    if (cell.selectedButton.selected) {
        [self.selectedMembersDict setObject:[NSNumber numberWithBool:cell.selectedButton.selected] forKey:[NSNumber numberWithInteger:cell.selectedButton.tag]];
    }
    else
    {
        [self.selectedMembersDict removeObjectForKey:[NSNumber numberWithInteger:cell.selectedButton.tag]];
    }

}

@end
