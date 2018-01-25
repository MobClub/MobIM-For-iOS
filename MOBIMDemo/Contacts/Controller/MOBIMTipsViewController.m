//
//  MOBIMTipsViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/1.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMTipsViewController.h"

#import "UIColor+MOBIMExtentions.h"
#import "MOBIMBaseButtonAvatarCell.h"
#import "MOBIMChatRoomViewController.h"
#import "MOBIMOtherUserViewController.h"
#import "MOBIMTipsDetailViewController.h"
#import "MOBIMBaseSectionCell.h"


@interface MOBIMTipsViewController ()
@property (nonatomic, strong) MOBIMBaseSectionCell *section1Cell;

@end

@implementation MOBIMTipsViewController

- (MOBIMBaseSectionCell *)section1Cell
{
    if (!_section1Cell) {
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
//    for (int i=0; i<20; i++) {
//        MOBIMTipsModel *model=[[MOBIMTipsModel alloc] init];
//        model.avatarPath = @"mayun";
//        model.name =[NSString stringWithFormat:@"高额%d",i];
//        [self.dataArray addObject:model];
//    }
    
//    [[MOBIMUserManager sharedManager] fetchTipUsers:^(NSArray<MOBIMUser *> *tipUsers, NSError *error) {
//
//        [self.dataArray addObjectsFromArray:tipUsers];
//
//    }];
    
    NSArray *noticers = [[MobIM getUserManager] getLocalNoticers];
    if (noticers)
    {
        [self.dataArray addObjectsFromArray:noticers];
    }
    
    [self.tableView reloadData];
}

- (void)loadUI
{
    self.title = @"提醒号";
    self.tableView.tableHeaderView = self.section1Cell;
    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMBaseButtonAvatarCell" bundle:nil] forCellReuseIdentifier:KMOBIMBaseButtonAvatarCellTag];
    self.tableView.backgroundColor = MOBIMRGB(0xEFEFF3);
    
}


- (void)avatarClicked:(UIButton*)button
{
//    MOBIMMessageUserModel *userModel = [[MOBIMMessageUserModel alloc] init];
//    userModel.photoId = @"mayun";
//    userModel.nName = @"提醒号";
//    userModel.eId = @"xxxx6666";
//
//    MOBIMOtherUserViewController *vc = [[MOBIMOtherUserViewController alloc] init];
//    vc.otherUserModel = userModel;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - (tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOBIMBaseButtonAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:KMOBIMBaseButtonAvatarCellTag];
    //cell.model = self.dataArray[indexPath.row];
    [cell.avatarButton addTarget:self action:@selector(avatarClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.avatarButton.tag = indexPath.row;
    
    MIMUser *model = self.dataArray[indexPath.row];
    [cell.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"tips_avatar"] ];
    
    if (self.dataArray.count == (indexPath.row + 1))
    {
        cell.lineLabel.hidden = YES;
    }
    else
    {
        cell.lineLabel.hidden = NO;
    }
    cell.nameLabel.text = model.nickname;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MIMUser *model = self.dataArray[indexPath.row];

    MOBIMTipsDetailViewController *vc=[MOBIMTipsDetailViewController new];
    vc.tipsModel = model;
    [self.navigationController pushViewController:vc animated:YES];
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
