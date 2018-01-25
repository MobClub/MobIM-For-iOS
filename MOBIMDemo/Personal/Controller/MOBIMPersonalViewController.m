//
//  MOBIMPersonalViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMPersonalViewController.h"
#import "MOBIMPersonalAvatarCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "MOBIMGConst.h"
#import "UIColor+MOBIMExtentions.h"
#import "MOBIMPersonalIdCell.h"
#import "MOBIMEditUserNickNameViewController.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMBlackViewController.h"
#import "MOBIMAvatarSelectViewController.h"

#import "MOBIMPersonalIdCell.h"
#import "MOBIMPersonalNickCell.h"
#import "MOBIMPersonalAvatarCell.h"
#import "MOBIMPersonalBlackCell.h"
#import "MOBIMBaseSectionCell.h"
#import "UIView+MOBIMExtention.h"
#import "UIViewController+MOBIMToast.h"
#import "MOBIMUserManager.h"

#define KPersonalInfoId  @"PersonalInfoId"

#define KMOBIMPersonalAvatarCell @"KMOBIMPersonalAvatarCell"
#define KMOBIMPersonalNickCell @"MOBIMPersonalNickCell"
#define KMOBIMPersonalIdCell @"KMOBIMPersonalIdCell"
#define KMOBIMPersonalBlackCell @"KMOBIMPersonalBlackCell"

#define KCellKey @"KCellKey"
#define KCellHeight @"KCellHeight"
#define KCellCanClicked @"KCellCanClicked"




@interface MOBIMPersonalViewController ()

@property (nonatomic, strong) NSArray *cellTagArray;

//用户id
@property (nonatomic, strong) MOBIMPersonalIdCell *personalIdCell;

//用户昵称
@property (nonatomic, strong) MOBIMPersonalNickCell *nickCell;

//头像
@property (nonatomic, strong) MOBIMPersonalAvatarCell *avatarCell;

//黑名单
@property (nonatomic, strong) MOBIMPersonalBlackCell *blackCell;

@property (nonatomic, strong) MOBIMBaseSectionCell *section1Cell;
@property (nonatomic, strong) MOBIMBaseSectionCell *section2Cell;
@property (nonatomic, strong) MOBIMBaseSectionCell *section3Cell;

//当前用户
@property (nonatomic, strong) MOBIMUser *currentUser;


@property (nonatomic, assign) BOOL isMenuShowing;


@end

@implementation MOBIMPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadData];
    [self loadUI];
}
- (void)dealloc{
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

- (MOBIMUser*)currentUser
{
    return [MOBIMUserManager sharedManager].currentUser;
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

- (MOBIMPersonalIdCell*)personalIdCell
{
    if (!_personalIdCell)
    {
        _personalIdCell = [[MOBIMPersonalIdCell alloc] init];
    }
    return _personalIdCell;
}

- (MOBIMPersonalNickCell*)nickCell
{
    if (!_nickCell)
    {
        _nickCell = [[MOBIMPersonalNickCell alloc] init];
    }
    return _nickCell;
}

- (MOBIMPersonalAvatarCell*)avatarCell
{
    if (!_avatarCell)
    {
        _avatarCell = [[MOBIMPersonalAvatarCell alloc] init];
    }
    return _avatarCell;
}

- (MOBIMPersonalBlackCell*)blackCell
{
    if (!_blackCell)
    {
        _blackCell = [[MOBIMPersonalBlackCell alloc] init];
    }
    return _blackCell;
}



- (void)loadData
{
    self.cellTagArray = @[
                          self.section1Cell,
                          self.avatarCell,
                          self.section2Cell,
                          self.nickCell,
                          self.personalIdCell,
                          self.section3Cell,
                          self.blackCell
                          ];
    
    
}

- (void)loadUI
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillHide) name:UIMenuControllerWillHideMenuNotification object:nil];
    
    [self setCustomTitle:@"我的"];

    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = MOBIMRGB(0xEFEFF3);
    self.tableView.scrollEnabled = NO;
    
    
    self.textView.backgroundColor=[UIColor clearColor];
    self.textView.textColor = MOBIMRGB(0xA6A6B2);
//    self.textView.frame = CGRectMake(0, 0, MOIMDevice_Width, 120);
    
    self.textView.userInteractionEnabled = NO;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.bottom.mas_equalTo(-44);
        make.height.mas_equalTo(120);
    }];
    
    //self.textView.frame.size.height = 120;
    
    MOBIMWEAKSELF
    [self.personalIdCell setLongPressCompletionBlock:^(UILongPressGestureRecognizer *recognizer) {
        [weakSelf showMenuViewController:weakSelf.personalIdCell.desLabel];
    }];

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
    return [self.cellTagArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return [[self.cellTagArray[indexPath.section][indexPath.row] objectForKey:KCellHeight] floatValue];
    UITableViewCell *cell = self.cellTagArray[indexPath.row];
    if (cell == self.avatarCell)
    {
        return 76;
    }
    else if (cell == self.section1Cell)
    {
        return 10;
    }
    else if ([cell isKindOfClass:[MOBIMBaseSectionCell class]])
    {
        return 5;
    }
    return 50;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = self.cellTagArray[indexPath.row];
    if (cell == self.avatarCell)
    {
        MOBIMPersonalAvatarCell *realCell = (MOBIMPersonalAvatarCell*)cell;
        [realCell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.currentUser.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
    }
    else if (cell == self.personalIdCell)
    {

        self.personalIdCell.desLabel.text = [MOBIMUserManager sharedManager].currentUser.appUserId;
        self.personalIdCell.lineLabel.hidden = YES;
        
    }else if (cell == self.nickCell)
    {
        
        self.nickCell.nickNameLabel.text = [MOBIMUserManager sharedManager].currentUser.nickname;
        
    }
    
    
    if (cell == nil)
    {
        return [UITableViewCell new];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = self.cellTagArray[indexPath.row];
    if (cell == self.avatarCell)
    {
        MOBIMAvatarSelectViewController *vc = [[MOBIMAvatarSelectViewController alloc] init];
        [vc setItemSeletectedBlock:^(NSString *avatarPath) {
            [self.avatarCell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarPath] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (cell == self.nickCell)
    {
        MOBIMEditUserNickNameViewController *vc = [[MOBIMEditUserNickNameViewController alloc] init];
        vc.editDes = self.nickCell.nickNameLabel.text;
        [vc setModifiedSucessBlock:^(NSString *nickName) {
            self.nickCell.nickNameLabel.text = nickName;
        }];
        vc.canEdit = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (cell == self.blackCell)
    {
        MOBIMBlackViewController *vc = [[MOBIMBlackViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

}


- (void)showMenuViewController:(UIView *)showInView
{
    if (self.isMenuShowing==YES)
    {
        return;
    }
    
    self.isMenuShowing = YES;
    [self becomeFirstResponder];
    UIMenuItem *copyMenuItem   = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage:)];
    [[UIMenuController sharedMenuController] setMenuItems:@[copyMenuItem]];
    [[UIMenuController sharedMenuController] setTargetRect:showInView.frame inView:showInView.superview ];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)copyMessage:(UIMenuItem *)copyMenuItem
{
    UIPasteboard *pasteboard  = [UIPasteboard generalPasteboard];
    
    NSString *userId = self.personalIdCell.desLabel.text;
    if (userId.length > 0)
    {
        pasteboard.string = userId;
        
        [self showToastMessage:@"用户ID已复制"];
    }
}

- (void)menuControllerWillHide
{
    self.isMenuShowing = NO;
}

- (BOOL) canBecomeFirstResponder{
    return YES;
}



@end
