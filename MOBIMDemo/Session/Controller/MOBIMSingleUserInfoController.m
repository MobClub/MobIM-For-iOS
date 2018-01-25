//
//  MOBIMSingleUserInfoController.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMSingleUserInfoController.h"
#import "MOBIMBaseSectionCell.h"
#import "MOBIMGroupAddSingleUserCell.h"
#import "MOBIMBaseSwitchCell.h"
#import "MOBIMVCard.h"
#import "MOBIMGroupCreateAddMemebersController.h"
#import "UIViewController+MOBIMToast.h"

#define KMOBIMBlackUserTag 9999999


@interface MOBIMSingleUserInfoController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) MOBIMBaseSectionCell *section1Cell;
@property (nonatomic, strong) MOBIMBaseSectionCell *section2Cell;

//头像
@property (nonatomic, strong) MOBIMGroupAddSingleUserCell  *avatarCell;

//群消息免打扰
@property (nonatomic, strong) MOBIMBaseSwitchCell  *disturbCell;

//界面布局数组
//@property (nonatomic, strong) NSArray *cellTagArray;


//黑名单
@property (nonatomic, strong) MOBIMBaseSwitchCell *blackCell;

//用户名片
@property (nonatomic, strong) MOBIMVCard *userCard;


@property (nonatomic, strong) NSArray *cellArray;

@end

@implementation MOBIMSingleUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self loadUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadUI
{
    [super loadUI];
    
    self.title = @"聊天详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.disturbCell.switchControl addTarget:self action:@selector(disturChanged:) forControlEvents:UIControlEventValueChanged];
    [self.blackCell.switchControl addTarget:self action:@selector(disturChanged:) forControlEvents:UIControlEventValueChanged];
    [self.avatarCell.addButton addTarget:self action:@selector(createGroup) forControlEvents:UIControlEventTouchUpInside];
    
    self.disturbCell.nameLabel.text = @"消息免打扰";
    self.blackCell.nameLabel.text = @"黑名单";
    
    self.avatarCell.nameLabel.text = _otherUserModel.nickname;
    [self.avatarCell.avatarView sd_setImageWithURL:[NSURL URLWithString:_otherUserModel.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
    
    
    [[MOBIMUserManager sharedManager] fethNetUserInfo:_otherUserModel.appUserId completion:^(MOBIMUser *user, NSError *error) {
        self.avatarCell.nameLabel.text = user.nickname;
        [self.avatarCell.avatarView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
        
        
    }];;

    
    self.disturbCell.switchControl.on =self.userCard.noDistribMessage;
    self.blackCell.switchControl.on = self.userCard.black;
    
}

- (void)loadData
{
    [super loadData];
    self.cellArray=@[
                     self.section1Cell,
                     self.avatarCell,
                     self.section2Cell,
                     self.disturbCell,
                     self.blackCell,
                     ];
    
    MOBIMVCard *vcard  = [[MOBIMUserManager sharedManager] fetchOrCreateUserVcardWithUserId:self.otherUserModel.appUserId];
    self.userCard = vcard;
}

- (void)createGroup
{
    MOBIMGroupCreateAddMemebersController *vc = [[MOBIMGroupCreateAddMemebersController alloc] init];
    vc.groupName = @"群组";
    
    [[MOBIMUserManager sharedManager] fetchUserInfo:_otherUserModel.appUserId needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
        
        vc.otherUser = user;
        
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UISwitch
- (void)disturChanged:(UISwitch*)switchControl
{
    if (self.disturbCell.switchControl == switchControl) {
        
        MOBIMWEAKSELF
        if (switchControl.on)
        {
            [[MOBIMUserManager sharedManager] addUserDisturb:self.otherUserModel.appUserId completion:^(MOBIMVCard *vcard, NSError *error) {
                
                if (vcard)
                {
                    weakSelf.userCard = vcard;
                }
            }];
        }
        else
        {
            [[MOBIMUserManager sharedManager] removeUserDisturb:self.otherUserModel.appUserId completion:^(MOBIMVCard *vcard, NSError *error) {
                
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
            [[MOBIMUserManager sharedManager] removeBlackUser:_otherUserModel.appUserId completion:^(MOBIMVCard *vcard, MIMError *error) {
                
                
                [weakSelf performMainBlock:^{
                    
                    if (error) {
                        
                        [weakSelf showToastMessage:error.errorDescription];
                        return ;
                    }
                    
                    weakSelf.userCard = vcard;
                    self.blackCell.switchControl.on = NO;
                    
                }];
            }];
        }
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == KMOBIMBlackUserTag && buttonIndex == 1)
    {
        //菊花转
        [self showToastWithIndeterminateHUDMode];
        
        MOBIMWEAKSELF
        [[MOBIMUserManager sharedManager] addBlackUser:_otherUserModel.appUserId completion:^(MOBIMVCard *vcard, MIMError *error) {
            
            if (error) {
                [weakSelf performMainBlock:^{
                    [weakSelf showToastMessage:error.errorDescription];
                    
                    self.blackCell.switchControl.on = NO;
                }];
                return ;
            }
            weakSelf.userCard = vcard;
            
            
            [weakSelf dismissToast];
        }];
    }

}



- (MOBIMBaseSectionCell *)section1Cell
{
    if (!_section1Cell) {
        _section1Cell = [[MOBIMBaseSectionCell alloc] init];
        //        _section2Cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
        
    }
    return _section1Cell;
}


- (MOBIMGroupAddSingleUserCell *)avatarCell
{
    if (!_avatarCell) {
        _avatarCell = [[MOBIMGroupAddSingleUserCell alloc] init];
    }
    
    return _avatarCell;
}


- (MOBIMBaseSwitchCell *)disturbCell
{
    if (!_disturbCell) {
        _disturbCell = [[MOBIMBaseSwitchCell alloc] init];
    }
    
    return _disturbCell;
}

- (MOBIMBaseSwitchCell *)blackCell
{
    if (!_blackCell) {
        _blackCell = [[MOBIMBaseSwitchCell alloc] init];
    }
    return _blackCell;
}

- (MOBIMBaseSectionCell *)section2Cell
{
    if (!_section2Cell) {
        _section2Cell = [[MOBIMBaseSectionCell alloc] init];
    }
    return _section2Cell;
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
    
    if (cell == self.avatarCell) {
        return 96;
    }
    else if (cell == self.disturbCell || cell == self.blackCell)
    {
        return 55;
    }
    else if (cell == self.section1Cell)
    {
        return 15;
    }
    return 5;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = self.cellArray[indexPath.row];

    
    return cell;
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
