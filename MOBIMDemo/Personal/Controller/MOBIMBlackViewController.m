//
//  MOBIMBlackViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBlackViewController.h"
#import "MOBIMBlackCell.h"
#import "MOBIMBaseSectionCell.h"
#import "UIViewController+MOBIMToast.h"
#import "MOBIMOtherUserViewController.h"

@interface MOBIMBlackViewController ()
@property (nonatomic, strong) MOBIMBaseSectionCell *section1Cell;

@end

@implementation MOBIMBlackViewController


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
    // Do any additional setup after loading the view from its nib.
    
    
    [self loadUI];
    [self loadData];
    
    
}


- (void)loadData
{

    
    MOBIMWEAKSELF

    [[MobIM getUserManager] getBlackListWithResultHandler:^(NSArray<MIMUser *> *blackList, MIMError *error) {

        [weakSelf performMainBlock:^{

            if (error)
            {
                [self showToastMessage:error.errorDescription];
                return ;
            }
            
            //存储
            for (MIMUser *user in blackList)
            {

                NSPredicate *groupUserPredicate = [NSPredicate predicateWithFormat:@" currentUserId = %@ AND userId = %@",[MOBIMUserManager sharedManager].currentUser.appUserId,user.appUserId];
                MOBIMVCard *vcard  = [MOBIMVCard MR_findFirstWithPredicate:groupUserPredicate sortedBy:nil ascending:YES];
                
                if (vcard == nil)
                {
                    vcard = [MOBIMVCard MR_createEntity];
                    vcard.currentUserId = [MOBIMUserManager sharedManager].currentUser.appUserId;
                    vcard.userId = user.appUserId;
                    
                    vcard.nickname = user.nickname;
                    vcard.avatar = user.avatar;
                }
                
                vcard.black = YES;
            }
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            [self.dataArray addObjectsFromArray:blackList];

            [self.tableView reloadData];
        }];
    }];
    
}

- (void)loadUI
{
    self.title = @"黑名单";
    self.tableView.tableHeaderView = self.section1Cell;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMBlackCell" bundle:nil] forCellReuseIdentifier:KMOBIMBlackCellTag];
    self.tableView.backgroundColor = MOBIMRGB(0xEFEFF3);

}


- (void)deleteMessage:(UIButton*)button
{
    MOBIMUser *model = self.dataArray[button.tag];
    
    
    //防止多次点击，崩溃问题
    self.tableView.userInteractionEnabled = NO;
    
    MOBIMWEAKSELF
    [[MOBIMUserManager sharedManager] removeBlackUser:model.appUserId completion:^(MOBIMVCard *vcard, MIMError *error) {
        
        if (error)
        {
            [self showToastMessage:error.errorDescription];
            return ;
        }
        [weakSelf.dataArray removeObject:model];
        
        [self.tableView reloadData];
        [weakSelf showToastSucessMessage:@"移除成功！"];
        
        weakSelf.tableView.userInteractionEnabled = YES;
        
    }];
    
}

#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOBIMBlackCell *cell = [tableView dequeueReusableCellWithIdentifier:KMOBIMBlackCellTag];
    [cell.deleteButton addTarget:self action:@selector(deleteMessage:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteButton.tag = indexPath.row;
    
    MIMUser *model = self.dataArray[indexPath.row];

    
    //考虑自己的用户体系，获取用户信息
    [[MOBIMUserManager sharedManager] fetchUserInfo:model.appUserId needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
        if (user)
        {
            cell.nameLabel.text = user.nickname;
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
        }
    }];
    
    if (self.dataArray.count == (indexPath.row + 1))
    {
        cell.lineLabel.hidden = YES;
    }
    else
    {
        cell.lineLabel.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MIMUser *user = self.dataArray[indexPath.row];

    
    NSString *curUserId = [MOBIMUserManager currentUserId];
    //登录用户
    if (curUserId && user.appUserId && [curUserId isEqualToString:user.appUserId])
    {
        return ;
    }
    
    if (user && user.userType == MIMUserTypeNormal)
    {
        MOBIMOtherUserViewController *vc = [[MOBIMOtherUserViewController alloc] init];
        vc.otherUser = [MOBIMUserManager userSdkToUserModel:user];
        vc.userId = user.appUserId;
        
        [self.navigationController pushViewController:vc animated:YES];

    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//
//}

@end
