//
//  MOBIMGroupTranferViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMGroupTranferViewController.h"
#import "MOBIMBaseViewSelectCell.h"
#import "MOBIMGConst.h"
#import "MOBIMUser.h"
#import "MOBIMBaseButtonCell.h"
#import "MOBIMGroupTranferViewController.h"
#import "UIColor+MOBIMExtentions.h"
#import "MOBIMBaseSectionCell.h"
#import "UIViewController+MOBIMToast.h"

@interface MOBIMGroupTranferViewController ()

//最后一个选中的 中的button
@property (nonatomic, strong) UIButton *lastSelectedButton;

//确认转让
@property (nonatomic, strong) MOBIMBaseButtonCell *buttonCell;

@property (nonatomic, strong) MOBIMBaseSectionCell *section1Cell;



@end

@implementation MOBIMGroupTranferViewController

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
    self.title = @"选择新群主";
    [self.buttonCell.button setTitle:@"确认转让" forState:UIControlStateNormal];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = MOBIMRGB(0xEFEFF3);
    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMBaseViewSelectCell" bundle:nil] forCellReuseIdentifier:KMOBIMBaseViewSelectCellTag];
    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMBaseButtonCell" bundle:nil] forCellReuseIdentifier:KMOBIMBaseButtonCellTag];
    
    
    self.tableView.tableHeaderView = self.section1Cell;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MOIMDevice_Width, 65)];
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:self.buttonCell];
    self.tableView.tableFooterView = footerView;

}


- (void)loadData
{
    if ([_groupInfo.membersList.allObjects count] > 0) {
        self.dataArray=[NSMutableArray arrayWithArray:_groupInfo.membersList.allObjects];

    }

    [self.dataArray enumerateObjectsUsingBlock:^(MIMUser*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.appUserId isEqualToString:[MOBIMUserManager currentUserId]]) {
            [self.dataArray removeObject:obj];
            
            *stop = YES;
        }
    }];
    
}


- (MOBIMBaseButtonCell *)buttonCell
{
    if (_buttonCell==nil) {
        _buttonCell = [[MOBIMBaseButtonCell alloc] init];
        [_buttonCell.button addTarget:self action:@selector(confirmTranferClicked:) forControlEvents:UIControlEventTouchUpInside];
        _buttonCell.frame=CGRectMake(0, 10, MOIMDevice_Width, 45);
    }
    return _buttonCell;
}

- (MOBIMBaseSectionCell *)section1Cell
{
    if (!_section1Cell) {
        _section1Cell = [[MOBIMBaseSectionCell alloc] init];
        
    }
    return _section1Cell;
}



- (void)confirmTranferClicked:(UIButton*)button
{
    if (!self.lastSelectedButton)
    {
        [self showAlertWithText:@"请选择新群主"];
        
        return;
    }
    
    
    
    
    MIMUser *model = self.dataArray[_lastSelectedButton.tag];
    
    MOBIMWEAKSELF
    [[MobIM getGroupManager] transferGroup:_groupInfo.groupId to:model.appUserId resultHandler:^(MIMGroup *group, MIMError *error) {
        
        if (error) {
            [weakSelf showToastMessage:error.errorDescription];
            return ;
        }
        
        [weakSelf performMainBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMUserGroupTransferSucessNtf object:group];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
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


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOBIMBaseViewSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:KMOBIMBaseViewSelectCellTag];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selectedButton.tag = indexPath.row;

    MIMUser *model = self.dataArray[indexPath.row];
    
    //考虑自己的用户体系，获取用户信息
    [[MOBIMUserManager sharedManager] fetchUserInfo:model.appUserId needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
        if (user) {
            cell.nameLabel.text = user.nickname;
            [cell.headImageVIew sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
            
        }
    }];


    
    if (indexPath.row != [self.dataArray count]-1)
    {
        cell.bottomLineLabel.hidden = NO;
        
    }
    else
    {
        cell.bottomLineLabel.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MOBIMBaseViewSelectCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    self.lastSelectedButton.selected = NO;
    self.lastSelectedButton = cell.selectedButton;

    cell.selectedButton.selected =  !cell.selectedButton.selected;
    
}

@end
