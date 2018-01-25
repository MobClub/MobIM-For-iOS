//
//  MOBIMGroupAddMemeberViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMGroupAddMemeberViewController.h"
#import "MOBIMBaseViewSelectCell.h"
#import "MOBIMGConst.h"
#import "MOBIMUser.h"
#import "MOBIMBaseButtonCell.h"
#import "UIColor+MOBIMExtentions.h"
#import "UIViewController+MOBIMToast.h"

@interface MOBIMGroupAddMemeberViewController ()

//界面中手动选中的成员dict ,内容为用户的userId
@property (nonatomic, strong) NSMutableDictionary *selectedMembersDict;

//组成员的dict ,内容为用户的userId
@property (nonatomic, strong) NSMutableDictionary *membersDict;

@end

@implementation MOBIMGroupAddMemeberViewController


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
    self.title = @"添加成员";
    self.tableView.backgroundColor = MOBIMRGB(0xEFEFF3);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMBaseViewSelectCell" bundle:nil] forCellReuseIdentifier:KMOBIMBaseViewSelectCellTag];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    button.titleLabel.font=[UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, KMOBIMNavRightOffset);

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (void)loadData
{
    // 初始化
    self.selectedMembersDict = [NSMutableDictionary new];
    self.membersDict = [NSMutableDictionary new];
    self.dataArray=[NSMutableArray arrayWithCapacity:3];
    
    
    //设置 membersDict
    NSArray *members = _groupInfo.membersList.allObjects;
    [members enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MIMUser *user = (MIMUser*)obj;
        [self.membersDict setObject:user.appUserId forKey:user.appUserId];
    }];
    
    
    //[self.dataArray addObjectsFromArray:[MOBIMUser MR_findAll]];
    //用户数据相关
    MOBIMWEAKSELF
    [[MOBIMUserManager sharedManager] fetchContacts:^(NSMutableArray<MOBIMUser *> *contacts, NSError *error) {
        NSMutableArray *users = [NSMutableArray new];
        [users addObjectsFromArray:contacts];
        
        //测试
        if ([users count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:contacts];
        }
    }];
    
}



- (void)confirmDeleteClicked:(UIButton*)button
{
    if (self.selectedMembersDict.count < 1) {
        [self showAlertWithText:@"请选择成员"];
        
        return;
    }
    
    NSMutableArray *lastMembers = [NSMutableArray new];
    MOBIMWEAKSELF
    [self.selectedMembersDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSInteger row =  [key intValue];
        MOBIMUser *model = weakSelf.dataArray[row];

        [lastMembers addObject:model.appUserId];
    }];
    //开始添加操作
    //[lastMembers addObjectsFromArray:_groupInfo.membersList.allObjects];
    
    
    //网络处理添加的成员
    
    [[MobIM getGroupManager] addGroupMembers:lastMembers toGroup:_groupInfo.groupId resultHandler:^(MIMGroup *group, MIMError *error) {
        
        if (error) {
            [weakSelf showToastMessage:error.errorDescription];
            return ;
        }
        
        [self performMainBlock:^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMGroupAddMemebersSucessNtf object:group];
            
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOBIMBaseViewSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:KMOBIMBaseViewSelectCellTag];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.selectedButton.tag = indexPath.row;
    
    MOBIMUser *model = self.dataArray[indexPath.row];
    [cell.headImageVIew sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
    cell.nameLabel.text = model.nickname;
    
    
    if (indexPath.row != [self.dataArray count]-1)
    {
        cell.bottomLineLabel.hidden = YES;
        
    }
    else
    {
        cell.bottomLineLabel.hidden = NO;
    }
    if (self.membersDict[model.appUserId] || self.selectedMembersDict[model.appUserId]) {
        cell.selectedButton.selected = YES;
    }else{
        cell.selectedButton.selected = NO;

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MOBIMBaseViewSelectCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    MOBIMUser *model = self.dataArray[indexPath.row];

    
    if (self.membersDict[model.appUserId]) {
        cell.selectedButton.selected = YES;
        
        return;
    }
    
    if (([self.membersDict count] + _groupInfo.membersCount) > 50) {
        [self showToastMessage:@"群成员已满，不可再进行添加~"];
        return;
    }
    
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
