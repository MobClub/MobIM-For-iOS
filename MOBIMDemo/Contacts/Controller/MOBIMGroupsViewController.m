//
//  MOBIMGroupsViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/29.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMGroupsViewController.h"
#import "MOBIMGroupsSearchResultViewController.h"
#import "MOBIMBaseButtonAvatarCell.h"
#import "MOBIMGroupModel.h"
#import "MOBIMGConst.h"
#import "Masonry.h"
#import "UIColor+MOBIMExtentions.h"
#import "MOBIMOtherUserViewController.h"
#import "MOBIMChatRoomGroupController.h"
#import "MOBIMChatRoomViewController.h"
#import "MOBIMAvatarButton.h"
#import "MOBIMGroupCreateViewController.h"


@interface MOBIMGroupsViewController () <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating>

//搜索控制器
@property (nonatomic, strong) UISearchController *searchController;

//分段数据
@property (nonatomic, strong) NSMutableArray *sectionArray;

//分段titles
@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;

//最后存储的数据列表
@property (nonatomic, strong) NSMutableArray *lastGroups;

@end

@implementation MOBIMGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
    [self loadUI];
}


- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = MOBIMRGB(0xEFEFF3);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}


- (void)loadData
{
    self.sectionTitlesArray = [NSMutableArray new];
    self.sectionArray = [NSMutableArray new];
    self.lastGroups = [NSMutableArray new];

    MOBIMWEAKSELF
    [[MobIM getGroupManager] getUserGroupsWithResultHandler:^(NSArray<MIMGroup *> *groupList, MIMError *error) {
        
        [weakSelf.lastGroups addObjectsFromArray:groupList];
        [weakSelf sortByGroups:self.lastGroups];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    
}

- (void)loadUI
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupUserJoinSucessNtf:) name:KMOBIMGroupUserJoinSucessNtf object:nil];

    
    self.title = @"群组";
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:[MOBIMGroupsSearchResultViewController new]];
    self.searchController.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;

    
    UISearchBar *searchBar = self.searchController.searchBar;
    CGRect rect = searchBar.frame;
    rect.size.height = 44;
    searchBar.frame = rect;
    
    searchBar.barStyle=UIBarStyleDefault;
    searchBar.translucent=YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"输入群组ID添加群组";
    
    UIImage *searchBarBg = [self GetImageWithColor:MOBIMRGB(0xEFEFF3) andHeight:44];
    //设置背景图片
    [searchBar setBackgroundImage:searchBarBg];
    //设置背景色
    [searchBar setBackgroundColor:[UIColor clearColor]];
    
    UITextField * searchField = [searchBar valueForKey:@"_searchField"];
    if (searchField)
    {
        //        [searchField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    }
    
    //设置文本框背景
    //    [searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
    
    
    //    searchBar.tintColor =MOBIMRGB(0xEFEFF3);
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];

    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMBaseButtonAvatarCell" bundle:nil] forCellReuseIdentifier:KMOBIMGroupsAddOperationCellTag];
    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMBaseButtonAvatarCell" bundle:nil] forCellReuseIdentifier:KMOBIMGroupsAddCellTag];

    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.leading.mas_offset(0);
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}



//添加好友成功通知
- (void)groupUserJoinSucessNtf:(NSNotification*)notification
{
    if ([notification.object isKindOfClass:[MIMGroup class]]) {
        
        [self.lastGroups addObject:notification.object];
        [self sortByGroups:self.lastGroups];
        [self.tableView reloadData];

    }
}


//对数据进行排序
- (void)sortByGroups:(NSMutableArray*)groups
{
    NSMutableArray *resultsectionTitlesArray = [NSMutableArray new];
    
    NSMutableArray *temp = [NSMutableArray new];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
    
    NSMutableArray *resultGroups = [NSMutableArray new];
    [resultGroups addObjectsFromArray:groups];
    
//    if ([groups count] > 1) {
//        [resultGroups addObjectsFromArray:[groups subarrayWithRange:NSMakeRange(0, 1)]];
//    }
    
    //排序
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    for (NSUInteger index = 0; index<numberOfSections; index++)
    {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    // insert Groups info into newSectionArray
    for (MIMGroup *model in resultGroups)
    {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(groupName)];
        [newSectionArray[sectionIndex] addObject:model];
    }
    
    //sort the Group of each section
    for (NSUInteger index=0; index<numberOfSections; index++)
    {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(groupName)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0)
        {
            [temp addObject:arr];
        } else {
            [resultsectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];
    
    
    
    //操作相关
    NSMutableArray *operrationModels = [NSMutableArray new];
    
    NSArray *dicts = @[
                       @{@"groupName" : @"新建群组", @"imageName" : @"addgroup_blue"}
                       ];
    for (NSDictionary *dict in dicts)
    {
        MOBIMGroupModel *model = [MOBIMGroupModel new];
        model.name = dict[@"groupName"];
        model.avatarPath = dict[@"imageName"];
        [operrationModels addObject:model];
    }
    
    [newSectionArray insertObject:operrationModels atIndex:0];
    [resultsectionTitlesArray insertObject:@"" atIndex:0];
    
    self.sectionArray = newSectionArray;
    self.sectionTitlesArray = resultsectionTitlesArray;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0)
    {
        
        MOBIMGroupsSearchResultViewController *resultController = (MOBIMGroupsSearchResultViewController*)_searchController.searchResultsController;
        [resultController setSearchText:nil];
        
    }
}

- (void)avatarClicked:(UIButton*)button
{
    
//    NSIndexPath *indexPath = button.indexPath;

//    MOBIMMessageUserModel *userModel = [[MOBIMMessageUserModel alloc] init];
//    userModel.photoId = @"mayun";
//    userModel.nName = @"提醒号";
//    userModel.eId = @"xxxx6666";
//
//    MOBIMOtherUserViewController *vc = [[MOBIMOtherUserViewController alloc] init];
//    vc.otherUserModel = userModel;
//    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - tableview delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.sectionArray count] >= section)
    {
        return [self.sectionArray[section] count];
    }
    return 0;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *sectionNameLabel = [[UILabel alloc] init];
    sectionNameLabel.font=[UIFont systemFontOfSize:12];
    sectionNameLabel.backgroundColor=[UIColor clearColor];
    sectionNameLabel.textColor = KMOBIMDateColor;
    sectionNameLabel.text = [NSString stringWithFormat:@"    %@",[self.sectionTitlesArray objectAtIndex:section]];
    
    return sectionNameLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    MOBIMBaseButtonAvatarCell *cell = nil;
    
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:KMOBIMGroupsAddOperationCellTag];
        MOBIMGroupModel *model = self.sectionArray[indexPath.section][indexPath.row];
        [cell.avatarButton setBackgroundImage:[UIImage imageNamed:model.avatarPath] forState:UIControlStateNormal];
        cell.nameLabel.text=model.name;
        return cell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:KMOBIMGroupsAddCellTag];
    MIMGroup *model = self.sectionArray[indexPath.section][indexPath.row];
    
    
    [cell.avatarButton setBackgroundImage:[UIImage imageNamed:@"avatar_group"] forState:UIControlStateNormal];
    [cell.avatarButton addTarget:self action:@selector(avatarClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([model.membersList count] != model.membersCount && [model.membersList count] > 0)
    {
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%zd人)",model.groupName,[model.membersList count]];
        
    }
    else
    {
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%d人)",model.groupName,model.membersCount];
        
    }
    
//    cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%d人)",model.groupName,model.membersCount];
    cell.avatarButton.indexPath = indexPath;

    if (([self.sectionArray[indexPath.section] count]-1) == indexPath.row)
    {
        cell.lineLabel.hidden = YES;
    }
    else
    {
        cell.lineLabel.hidden = NO;
    }

    if (indexPath.section == 0)
    {
        cell.avatarButton.userInteractionEnabled = NO;
    }
    else
    {
        cell.avatarButton.userInteractionEnabled = YES;

    }

    
    
//    MOBIMUserModel *model = self.sectionArray[indexPath.section][indexPath.row];
//    [cell setDataModel:model];
    
    
    //    NSLog(@"line %@" , cell.nameLabel);
//    NSLog(@"line %@" , cell.avatarView);
    //    cell.nameLabel.backgroundColor = [UIColor redColor];
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [self.sectionTitlesArray objectAtIndex:section];
//}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionTitlesArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0)
    {
        
        if ([self.sectionArray count] > 1 && [[self.sectionArray objectAtIndex:1]  count] > 10)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"新建群数已达到建群上限（10个群组），无法再进行新建！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        
        //新建群组
        MOBIMGroupCreateViewController *vc = [[MOBIMGroupCreateViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    //进入群组
    MIMGroup *model = self.sectionArray[indexPath.section][indexPath.row];

    
    MOBIMChatRoomGroupController *roomViewController=[MOBIMChatRoomGroupController new];
    roomViewController.groupId = model.groupId;
    roomViewController.groupInfo = model;
    [self.navigationController pushViewController:roomViewController animated:YES];
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
    if (section == 0)
    {
        return 0;
    }
    return 25;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    MOBIMGroupsSearchResultViewController *resultController = (MOBIMGroupsSearchResultViewController*)_searchController.searchResultsController;
    [resultController setSearchText:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchText = searchBar.text;
    MOBIMGroupsSearchResultViewController *resultController = (MOBIMGroupsSearchResultViewController*)_searchController.searchResultsController;
    
    //groups
    NSMutableDictionary *joinedGroupsDict = [NSMutableDictionary new];
    
    if ([self.sectionArray count] > 1)
    {
        NSArray *subArray = [self.sectionArray subarrayWithRange:NSMakeRange(1, self.sectionArray.count- 1)];
        for (NSArray *sectionArray in subArray)
        {
            
            for (MIMGroup *group in sectionArray)
            {
                [joinedGroupsDict setObject:group.groupId forKey:group.groupId];
            }
        }
    }

    
    //我的群组
    resultController.joinedGroupsDict = joinedGroupsDict;
    
    //搜索文字
    resultController.searchText = searchText;

}


@end
