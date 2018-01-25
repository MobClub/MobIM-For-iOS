//
//  MOBIMOtherUserViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMOtherUserViewController.h"
#import "MOBIMBaseSwitchCell.h"
#import "MOBIMBaseButtonCell.h"
#import "MOBIMOtherUserCell.h"
#import "UIColor+MOBIMExtentions.h"
#import "MOBIMGConst.h"
#import "MOBIMUserChatRoomController.h"
#import "MOBIMSessionModel.h"
#import "MOBIMBaseSectionCell.h"
#import "MOBIMVCard.h"
#import "MOBIMUserManager.h"
#import "UIViewController+MOBIMToast.h"

#define KMOBIMBlackUserTag 9999999

@interface MOBIMOtherUserViewController ()

@property (nonatomic, strong) MOBIMOtherUserCell *otherUserCell;
@property (nonatomic, strong) MOBIMBaseSwitchCell *disturCell;
@property (nonatomic, strong) MOBIMBaseSwitchCell *blackCell;
@property (nonatomic, strong) MOBIMBaseButtonCell *sendCell;

@property (nonatomic, strong) MOBIMBaseSectionCell *section1Cell;
@property (nonatomic, strong) MOBIMBaseSectionCell *section2Cell;
@property (nonatomic, strong) MOBIMBaseSectionCell *section3Cell;

@property (nonatomic, strong) MOBIMVCard *userCard;

@property (nonatomic, strong) NSArray *cellArray;

@end

@implementation MOBIMOtherUserViewController

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

- (MOBIMBaseSectionCell*)section1Cell
{
    if (!_section1Cell)
    {
        _section1Cell = [[MOBIMBaseSectionCell alloc] init];
    }
    return _section1Cell;
}


- (MOBIMBaseSectionCell*)section2Cell
{
    if (!_section2Cell)
    {
        _section2Cell = [[MOBIMBaseSectionCell alloc] init];
    }
    return _section2Cell;
}

- (MOBIMBaseSectionCell*)section3Cell
{
    if (!_section3Cell)
    {
        _section3Cell = [[MOBIMBaseSectionCell alloc] init];
    }
    return _section3Cell;
}

- (MOBIMOtherUserCell*)otherUserCell
{
    if (!_otherUserCell)
    {
        _otherUserCell = [[MOBIMOtherUserCell alloc] init];
    }
    return _otherUserCell;
}

- (MOBIMBaseSwitchCell*)disturCell
{
    if (!_disturCell)
    {
        _disturCell = [[MOBIMBaseSwitchCell alloc] init];
    }
    return _disturCell;
}

- (MOBIMBaseSwitchCell*)blackCell
{
    if (!_blackCell) {
        _blackCell = [[MOBIMBaseSwitchCell alloc] init];
    }
    return _blackCell;
}

- (MOBIMBaseButtonCell*)sendCell
{
    if (!_sendCell)
    {
        _sendCell = [[MOBIMBaseButtonCell alloc] init];
    }
    return _sendCell;
}


- (void)loadData
{

    MOBIMVCard *vcard  = [[MOBIMUserManager sharedManager] fetchOrCreateUserVcardWithUserId:self.otherUser.appUserId];
    self.userCard = vcard;
    
    
    if (self.hiddenSendMessageButton == YES)
    {
        self.cellArray=@[
                         self.section1Cell,
                         self.otherUserCell,
                         self.section2Cell,
                         self.disturCell,
                         self.blackCell
                         ];
    }else{
        self.cellArray=@[
                         self.section1Cell,
                         self.otherUserCell,
                         self.section2Cell,
                         self.disturCell,
                         self.blackCell,
                         self.section3Cell,
                         self.sendCell
                         ];
    }

}


- (void)loadUI
{
    self.title = _otherUser.nickname;
    
    self.disturCell.nameLabel.text = @"消息免打扰";
    self.blackCell.nameLabel.text = @"黑名单";
    
//    if (self.userCard.black)
//    {
//        [self.sendCell.button setTitle:@"添加好友" forState:UIControlStateNormal];
//
//    }
//    else
//    {
        [self.sendCell.button setTitle:@"发送消息" forState:UIControlStateNormal];

//    }
    
    self.disturCell.lineLabel.hidden = NO;
    self.blackCell.lineLabel.hidden = YES;
    
    
    _tableView.backgroundColor = MOBIMRGB(0xEFEFF3);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.otherUserCell.userIdLabel.text = [NSString stringWithFormat:@"用户ID：%@",self.otherUser.appUserId];


    
    
    self.otherUserCell.nameLabel.text = _otherUser.nickname;
    [self.otherUserCell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_otherUser.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
    
    
    [[MOBIMUserManager sharedManager] fethNetUserInfo:_otherUser.appUserId completion:^(MOBIMUser *user, NSError *error) {
        
        if (!error)
        {
            _otherUser = [MOBIMUserManager userToUserModel:user];
            
            self.otherUserCell.nameLabel.text = _otherUser.nickname;
            [self.otherUserCell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_otherUser.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
        }

    }];;

    
    
    self.disturCell.switchControl.on =self.userCard.noDistribMessage;
    self.blackCell.switchControl.on = self.userCard.black;
    
    MOBIMWEAKSELF
    [self.sendCell setButtonClickCompletion:^{
        [weakSelf sendMessage];
    }];
    
    
    [self.disturCell.switchControl addTarget:self action:@selector(disturChanged:) forControlEvents:UIControlEventValueChanged];
    [self.blackCell.switchControl addTarget:self action:@selector(disturChanged:) forControlEvents:UIControlEventValueChanged];

}


- (void)disturChanged:(UISwitch*)switchControl
{
    if (self.disturCell.switchControl == switchControl) {
        
        MOBIMWEAKSELF
        if (switchControl.on)
        {
            [[MOBIMUserManager sharedManager] addUserDisturb:self.otherUser.appUserId completion:^(MOBIMVCard *vcard, NSError *error) {
                
                if (vcard)
                {
                    weakSelf.userCard = vcard;
                }
            }];
        }
        else
        {
            [[MOBIMUserManager sharedManager] removeUserDisturb:self.otherUser.appUserId completion:^(MOBIMVCard *vcard, NSError *error) {
                
                if (vcard)
                {
                    weakSelf.userCard = vcard;
                }
            }];
        }

    }
    else if (self.blackCell.switchControl == switchControl)
    {
        if (switchControl.on) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确认将TA加入黑名单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.tag = KMOBIMBlackUserTag;
            [alertView show];
        }else{
            
            //移除黑名单
            MOBIMWEAKSELF
            [[MOBIMUserManager sharedManager] removeBlackUser:_otherUser.appUserId completion:^(MOBIMVCard *vcard, MIMError *error) {
                
                
                [weakSelf performMainBlock:^{
                    
                    if (error)
                    {
                        
                        [weakSelf showToastMessage:error.errorDescription];
                        return ;
                    }
                    
                    [weakSelf.sendCell.button setTitle:@"发送消息" forState:UIControlStateNormal];
                    weakSelf.userCard = vcard;
                    self.blackCell.switchControl.on = NO;
                    
                }];
            }];
        }

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == KMOBIMBlackUserTag)
    {
        MOBIMWEAKSELF
        if (buttonIndex == 1)
        {
            [[MOBIMUserManager sharedManager] addBlackUser:_otherUser.appUserId completion:^(MOBIMVCard *vcard, MIMError *error) {
                
                if (error)
                {
                    [weakSelf performMainBlock:^{
                        
                        [weakSelf showToastMessage:error.errorDescription];
                        self.blackCell.switchControl.on = NO;
                    }];
                    return ;
                }
//                [weakSelf.sendCell.button setTitle:@"添加好友" forState:UIControlStateNormal];
                weakSelf.userCard = vcard;
                
            }];
        }
        else
        {
            self.blackCell.switchControl.on = NO;
        }

    }
    
//    else
//        //移除黑名单
//        MOBIMWEAKSELF
//        [[MOBIMUserManager sharedManager] removeBlackUser:_otherUser.appUserId completion:^(MOBIMVCard *vcard, MIMError *error) {
//
//
//            [weakSelf performMainBlock:^{
//
//                if (error) {
//
//                    [weakSelf showToastMessage:error.errorDescription];
//                    return ;
//                }
//
//                [weakSelf.sendCell.button setTitle:@"发送消息" forState:UIControlStateNormal];
//
//                weakSelf.userCard = vcard;
//                self.blackCell.switchControl.on = NO;
//
//            }];
//        }];
//    }
}




- (void)sendMessage
{

    
    UIViewController *rootView = [self.navigationController viewControllers].firstObject;
    [rootView.navigationController popToRootViewControllerAnimated:NO];
    
    MOBIMUserChatRoomController *roomViewController=[MOBIMUserChatRoomController new];
    roomViewController.contact = _otherUser;
    roomViewController.otherUserId = self.otherUser.appUserId;
    [rootView.navigationController pushViewController:roomViewController animated:YES];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    long count = [self.cellArray count];
    return count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.cellArray[indexPath.row];
    
    if (cell == self.otherUserCell)
    {
        return 76;
    }
    else if (cell == self.sendCell)
    {
        return 55;
    }
    else if ([cell isKindOfClass:[MOBIMBaseSectionCell class]])
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
    
    UITableViewCell *cell = self.cellArray[indexPath.row];
    
//    if (cell == self.otherUserCell) {
//        [self.otherUserCell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.otherUser.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
//    }
//
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
