//
//  MOBIMContactViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMContactViewController.h"
#import "MOBIMContactsSearchResultViewController.h"
#import "MOBIMContactsCell.h"
#import "MOBIMUserModel.h"
#import "MOBIMGConst.h"
#import "Masonry.h"
#import "UIColor+MOBIMExtentions.h"
#import "MOBIMOtherUserViewController.h"
#import "MOBIMGroupsViewController.h"
#import "MOBIMTipsViewController.h"
#import "MOBIMMessageUserModel.h"


@interface MOBIMContactViewController () <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating>

//搜索控制器
@property (nonatomic, strong) UISearchController *searchController;

//分段数据
@property (nonatomic, strong) NSMutableArray *sectionArray;

//分段标题
@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;


@end

@implementation MOBIMContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
    [self loadUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (UITableView*)tableView
{
    if (!_tableView)
    {
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

    NSMutableArray *newSectionArray = [NSMutableArray new];
    _sectionTitlesArray = [NSMutableArray new];
    
    //操作相关
    NSMutableArray *operrationModels = [NSMutableArray new];
    NSArray *dicts = @[
                       @{@"name" : @"群组", @"imageName" : @"avatar_group"},
                       @{@"name" : @"提醒号", @"imageName" : @"tips_avatar"}];
    for (NSDictionary *dict in dicts)
    {
        MOBIMUserModel *model = [MOBIMUserModel new];
        model.nickname = dict[@"name"];
        model.avatar = dict[@"imageName"];
        [operrationModels addObject:model];
    }
    
    [newSectionArray insertObject:operrationModels atIndex:0];
    [self.sectionTitlesArray insertObject:@"" atIndex:0];
    
    MOBIMWEAKSELF
    //用户数据相关
    [[MOBIMUserManager sharedManager] fetchContacts:^(NSMutableArray<MOBIMUser *> *contacts, NSError *error) {
        NSMutableArray *users = [NSMutableArray new];
        
        if ([contacts count] > 0) {
            [users addObjectsFromArray:contacts];
        }
        
        //测试
        [weakSelf.sectionTitlesArray insertObject:@"已添加用户" atIndex:1];
        [newSectionArray insertObject:users atIndex:1];
        
    }];

    
    self.sectionArray = newSectionArray;
}

- (void)loadUI
{
    
    [self setCustomTitle:@"通讯录"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContactSucessNtf:) name:KMOBIMUserAddContactSucessNtf object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContactSucessNtf:) name:KMOBIMUserDeleteContactSucessNtf object:nil];

    //搜索控件
    self.title = @"通讯录";
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:[MOBIMContactsSearchResultViewController new]];
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
    searchBar.placeholder = @"输入用户ID添加聊天对象";
    
    UIImage *searchBarBg = [self GetImageWithColor:MOBIMRGB(0xEFEFF3) andHeight:44];
    //设置背景图片
    [searchBar setBackgroundImage:searchBarBg];
    //设置背景色
    [searchBar setBackgroundColor:[UIColor clearColor]];
    //设置文本框背景
//    [searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
    searchBar.delegate =self ;
    
    UITextField * searchField = [searchBar valueForKey:@"_searchField"];
    if (searchField)
    {
//        [searchField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    }


    
    //表控件
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMContactsCell" bundle:nil] forCellReuseIdentifier:KMOBIMContactsCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMContactsCell" bundle:nil] forCellReuseIdentifier:KMOBIMContactsOperationCellId];

    
    //表布局
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.leading.mas_offset(0);
    }];
}

//添加好友成功通知
- (void)addContactSucessNtf:(NSNotification*)notification
{
    if ([notification.object isKindOfClass:[MOBIMUser class]]) {
        
        NSMutableArray *users = nil;
        if ([self.sectionArray count] > 1 && self.sectionArray[1])
        {
            users = [NSMutableArray arrayWithArray:self.sectionArray[1]];
            [users addObject:notification.object];

            self.sectionArray[1] = users;
        }else{
            users = [NSMutableArray new];
            [users addObject:notification.object];
            [self.sectionArray addObject:users];
            [self.sectionTitlesArray insertObject:@"已添加用户" atIndex:1];
        }
        
        [self.tableView reloadData];
    }
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



#pragma mark - UISearchBarDelegate

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
        if (searchBar.text.length == 0)
        {
         
            MOBIMContactsSearchResultViewController *resultController = (MOBIMContactsSearchResultViewController*)_searchController.searchResultsController;
            [resultController setSearchText:nil];
            
        }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    MOBIMContactsSearchResultViewController *resultController = (MOBIMContactsSearchResultViewController*)_searchController.searchResultsController;
    [resultController setSearchText:nil];
}

#pragma mark - tableview delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOBIMContactsCell *cell = nil;
    
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:KMOBIMContactsOperationCellId];
        MOBIMUserModel *contactsModel = self.sectionArray[indexPath.section][indexPath.row];
        cell.avatarView.image=[UIImage imageNamed:contactsModel.avatar];
        cell.nameLabel.text=contactsModel.nickname;
        return cell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:KMOBIMContactsCellId];

    MOBIMUser *contactsModel = self.sectionArray[indexPath.section][indexPath.row];
    if (([self.sectionArray[indexPath.section] count]-1) == indexPath.row)
    {
        cell.lineLabel.hidden = YES;
    }
    else
    {
        cell.lineLabel.hidden = NO;
    }
     
    [cell.avatarView sd_setImageWithURL:[NSURL URLWithString:contactsModel.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
    cell.nameLabel.text=contactsModel.nickname;
    
//    MOBIMLog(@"line %@" , cell.nameLabel);
    MOBIMLog(@"line %@" , cell.avatarView);
//    cell.nameLabel.backgroundColor = [UIColor redColor];

    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [self.sectionTitlesArray objectAtIndex:section];
//}


//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.sectionTitlesArray;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section > 0)
    {
        
        MOBIMUser *model = self.sectionArray[indexPath.section][indexPath.row];
        
        MOBIMOtherUserViewController *vc = [[MOBIMOtherUserViewController alloc] init];
        vc.otherUser = [MOBIMUserManager userToUserModel:model];
        vc.userId = model.appUserId;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            MOBIMGroupsViewController *vc = [[MOBIMGroupsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 1)
        {
            MOBIMTipsViewController *vc = [[MOBIMTipsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
    


//索引列点击事件
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//
//{
//
//    return index;
//}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *sectionNameLabel = [[UILabel alloc] init];
    sectionNameLabel.font=[UIFont systemFontOfSize:12];
    sectionNameLabel.backgroundColor=[UIColor clearColor];
    sectionNameLabel.textColor = KMOBIMDateColor;
    sectionNameLabel.text =@"    已添加的用户";
    
    return sectionNameLabel;
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


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchText = searchBar.text;
    
    
    MOBIMContactsSearchResultViewController *resultController = (MOBIMContactsSearchResultViewController*)_searchController.searchResultsController;
    resultController.rootViewConroller = self;
    
    //将联系的的userid 过滤成dictionary ，方便后面显示已添加用户
    NSMutableDictionary *friendsDict = [NSMutableDictionary new];
    if ([self.sectionArray count] > 1 && [self.sectionArray[1] count]>0)
    {
        for (MOBIMUser *user in self.sectionArray[1])
        {
            [friendsDict setObject:user.appUserId forKey:user.appUserId];
        }
    }
    //联系人
    resultController.friendsDict = friendsDict;

    //搜索文字
    resultController.searchText = searchText;

}

//数据处理
- (NSArray*)filterDataArray:(NSString*)searchText
{
    //考虑使用T9 算法来检索查询
    NSMutableArray *filterArray = [NSMutableArray arrayWithCapacity:3];
    NSArray *rowArray = self.sectionArray[1];
    [rowArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        MOBIMUserModel *model = obj;
        if ([model.nickname containsString:searchText])
        {
            
            [filterArray addObject:model];
        }
    }];
    
    return filterArray;
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
