//
//  MOBIMGroupsSearchResultViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/29.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMGroupsSearchResultViewController.h"
#import "MOBIMGConst.h"
#import "UIColor+MOBIMExtentions.h"
#import "MOBIMBaseAvatarAddCell.h"
#import "Masonry.h"
#import "UIView+MOBIMExtention.h"
#import "UIViewController+MOBIMToast.h"

@interface MOBIMGroupsSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UILabel *emptyView;
//搜索出来的用户
@property (nonatomic, strong) NSMutableArray *filterArray;
@end

@implementation MOBIMGroupsSearchResultViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self loadUI];
    
    //    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//网络搜索
- (void)setSearchText:(NSString *)searchText
{
    [self.filterArray removeAllObjects];
    self.emptyView.hidden = YES;
    
    [self.tableView reloadData];
    
    _searchText = searchText;
    if (_searchText.length <= 0)
    {
        return;
    }
    
    if (!self.filterArray)
    {
        self.filterArray = [NSMutableArray new];
    }
    
    [self showToastWithIndeterminateHUDMode];
    MOBIMWEAKSELF
    [[MobIM getGroupManager] findGroupBy:searchText resultHandler:^(MIMGroup *group, MIMError *error) {
        
        
        [weakSelf performMainBlock:^{


            
            if (error && error.errorCode != MIMErrorGroupNotExists)
            {
                [weakSelf showToastMessage:error.errorDescription];
                return ;
            }
            
            //群组不存在
            if (error.errorCode == MIMErrorGroupNotExists)
            {
                [weakSelf.filterArray removeAllObjects];
            }
            
            if (group)
            {
                [weakSelf.filterArray removeAllObjects];
                [weakSelf.filterArray addObject:group];
            }
            
            [weakSelf reloadFilterArray];
            
            [weakSelf dismissToast];
            
        }];


    }];


}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
- (void)performMainBlock:(void(^)())block
{
    dispatch_async(dispatch_get_main_queue(), block);
}
#pragma clang diagnostic pop

- (void)reloadFilterArray{
    
    //处理显示
    
    if ([self.filterArray count] < 1 && self.searchText.length > 0)
    {
        self.emptyView.hidden = NO;
    }
    else
    {
        self.emptyView.hidden = YES;
        
    }
    
    [self.tableView reloadData];
}


- (void)loadData
{
    if ([self.filterArray count] < 1 && self.searchText.length > 0)
    {
        self.emptyView.hidden = NO;
    }
    else
    {
        self.emptyView.hidden = YES;
        
    }
}

- (void)loadUI
{
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMBaseAvatarAddCell" bundle:nil] forCellReuseIdentifier:KMOBIMBaseAvatarAddCellTag];
    self.tableView.backgroundColor = MOBIMRGB(0xEFEFF3);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.leading.trailing.mas_equalTo(0);
//        make.top.mas_equalTo(64);
//    }];
    
    
    self.emptyView.hidden = YES;
    [self.emptyView setText:@"未找到此群组ID"];
//    self.emptyView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.emptyView];
    
    MOBIMWEAKSELF
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(236);
        make.centerX.equalTo(weakSelf.view);
        make.width.mas_offset(200);
        make.height.mas_offset(21);
    }];
}

//- (UITableView*)tableView
//{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.backgroundColor = MOBIMRGB(0xEFEFF3);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.delegate=self;
//        _tableView.dataSource=self;
//    }
//    return _tableView;
//}

- (UILabel*)emptyView
{
    if (!_emptyView) {
        _emptyView = [UILabel new];
        _emptyView.font = [UIFont systemFontOfSize:18.0];
        _emptyView.numberOfLines = 1;
        _emptyView.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _emptyView.textAlignment = NSTextAlignmentCenter;
        _emptyView.textColor = KMOBIMDesColor;
    }
    return _emptyView;
}


- (void)joinGroup:(UIButton*)button
{
    NSUInteger index = button.tag;
    MIMGroup *groupModel = self.filterArray[index];

    MOBIMWEAKSELF
    [[MobIM getGroupManager] joinToGroup:groupModel.groupId resultHandler:^(MIMGroup *group, MIMError *error) {
        
        [weakSelf performMainBlock:^{
            
            if (error)
            {
                
                //超过上限
                if (error.errorCode == MIMErrorGroupMembersUpperLimit)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"加入群失败，群成员已满！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                    [alertView show];
                }
                else
                {
                    [self showToastMessage:error.errorDescription];
                }
                
                return ;
            }
        
            if (group && group.groupId)
            {
                [weakSelf.joinedGroupsDict setValue:group.groupId forKey:group.groupId];
                
                //通知联系人界面,添加联系人
                [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMGroupUserJoinSucessNtf object:group];
                [weakSelf.tableView reloadData];
                

            }
            
        }];
        
    }];
    
}



#pragma mark - tableview delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filterArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOBIMBaseAvatarAddCell *cell = [tableView dequeueReusableCellWithIdentifier:KMOBIMBaseAvatarAddCellTag];
    [cell.addButton addTarget:self action:@selector(joinGroup:) forControlEvents:UIControlEventTouchUpInside];
    cell.addButton.tag = indexPath.row;

    
    MIMGroup *model = self.filterArray[indexPath.row];
    [cell.avatarButton setBackgroundImage:[UIImage imageNamed:@"avatar_group"] forState:UIControlStateNormal];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%d人)",model.groupName,model.membersCount];
    cell.hasAddLabel.text = @"已加入";
    
    //横线显示
    if (self.filterArray.count == (indexPath.row + 1))
    {
        cell.lineLabel.hidden = YES;
    }
    else
    {
        cell.lineLabel.hidden = NO;
    }
    
    //是否为已添加群组
    if (self.joinedGroupsDict[model.groupId])
    {
        cell.addButton.hidden = YES;
        cell.hasAddLabel.hidden = NO;
    }
    else
    {
        cell.addButton.hidden = NO;
        cell.hasAddLabel.hidden = YES;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

//    [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMGroupCreateSucessNtf object:group];
//    UIViewController *rootViewController = weakSelf.navigationController.viewControllers.firstObject;
//    if (rootViewController) {
//        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
//    }
}


//索引列点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index

{
    
    return index;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


@end
