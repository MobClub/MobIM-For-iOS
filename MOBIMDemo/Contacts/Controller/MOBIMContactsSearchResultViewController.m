

//
//  MOBIMContactsSearchResultViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMContactsSearchResultViewController.h"
#import "UIColor+MOBIMExtentions.h"
#import "MOBIMContactsAddCell.h"
#import "MOBIMUserChatRoomController.h"
#import "UIViewController+MOBIMToast.h"
#import "MOBIMTipsDetailViewController.h"



@interface MOBIMContactsSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UILabel *emptyView;

//搜索出来的用户
@property (nonatomic, strong) NSMutableArray *filterArray;
@end

@implementation MOBIMContactsSearchResultViewController

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
    MOBIMWEAKSELF

    [weakSelf.filterArray removeAllObjects];
    self.emptyView.hidden = YES;
    [self.tableView reloadData];
    
    _searchText = searchText;
    if (_searchText.length <= 0)
    {
        
        return;
    }
    
    [self showToastWithIndeterminateHUDMode];
    [[MOBIMUserManager sharedManager] fetchUserInfo:searchText completion:^(MOBIMUser *user, NSError *error) {
        
        [weakSelf performMainBlock:^{
            
            //用户不存在
//            if (error.code == 5110212)
//            {
//                [weakSelf.filterArray removeAllObjects];
//            }
            
            if (error)
            {
                [weakSelf showToastMessage:error.userInfo[NSLocalizedDescriptionKey]];
                return ;
            }
            else
            {
                MOBIMUserModel *userModel = [MOBIMUserManager userToUserModel:user];
                if (user)
                {
                    [weakSelf.filterArray removeAllObjects];
                    [weakSelf.filterArray addObject:userModel];
                }
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

- (void)reloadFilterArray
{
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
    self.filterArray = [NSMutableArray new];
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
    //表视图
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MOBIMContactsAddCell" bundle:nil] forCellReuseIdentifier:KMOBIMContactsAddCellTag];
    self.tableView.backgroundColor = MOBIMRGB(0xEFEFF3);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //未找到
    self.emptyView.hidden = YES;
    [self.emptyView setText:@"未找到此用户ID"];
    [self.view addSubview:self.emptyView];
    
    MOBIMWEAKSELF
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(236);
        make.centerX.equalTo(weakSelf.view);
        make.width.mas_offset(200);
        make.height.mas_offset(21);
    }];
    
}


- (UILabel*)emptyView
{
    if (!_emptyView)
    {
        _emptyView = [UILabel new];
        _emptyView.font = [UIFont systemFontOfSize:18.0];
        _emptyView.numberOfLines = 1;
        _emptyView.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _emptyView.textAlignment = NSTextAlignmentCenter;
        _emptyView.textColor = KMOBIMDesColor;
    }
    return _emptyView;
}


- (void)addFriend:(UIButton*)button
{
    NSUInteger index = button.tag;
    MOBIMUserModel *userModel = self.filterArray[index];
    userModel.isConact = YES;
    
    //本地缓存搜索
    MOBIMUser *user = [[MOBIMUserManager sharedManager] userFindFirstOrCreateWithUserModel:userModel];
    if (user)
    {
        [self.friendsDict setValue:user.appUserId forKey:user.appUserId];
        
        
        [self showToastMessage:@"添加成功!"];
        
        //通知联系人界面,添加联系人
        [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMUserAddContactSucessNtf object:user];
        [self.tableView reloadData];

    }
}

#pragma mark - tableview delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filterArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MOBIMContactsAddCell *cell = [tableView dequeueReusableCellWithIdentifier:KMOBIMContactsAddCellTag];
    [cell.addButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    cell.addButton.tag = indexPath.row;
    
    MOBIMUserModel *model = self.filterArray[indexPath.row];
    [cell setDataModel:model];
    
    //横线显示
    if (self.filterArray.count == (indexPath.row + 1))
    {
        cell.lineLabel.hidden = YES;
    }
    else
    {
        cell.lineLabel.hidden = NO;
    }
    
    
    //是否为已添加用户
    if (self.friendsDict[model.appUserId])
    {
        cell.addButton.hidden = YES;
        cell.hasAddLabel.hidden = NO;
    }
    else if ([self canAddFriend:model] == NO)
    {
        cell.addButton.hidden = YES;
        cell.hasAddLabel.hidden = YES;
    }
    else
    {
        cell.addButton.hidden = NO;
        cell.hasAddLabel.hidden = YES;
    }

    
    return cell;
}


- (BOOL)canAddFriend:(MOBIMUserModel*)modelUser
{
    NSString *curUserId = [MOBIMUserManager currentUserId];

    //登录用户
    if (curUserId && modelUser.appUserId && [curUserId isEqualToString:modelUser.appUserId])
    {
        return NO;
    }
    
    //提醒号
    __block BOOL willAdd = NO;
    [[MOBIMUserManager sharedManager] fetchUserInfo:modelUser.appUserId needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
        
        if (user)
        {
            willAdd = (user.userType == MIMUserTypeNormal);
        }
            
        
    }];
    
    return willAdd;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MOBIMUserModel *model = self.filterArray[indexPath.row];
    
    
    NSString *curUserId = [MOBIMUserManager currentUserId];
    //登录用户
    if (curUserId && model.appUserId && [curUserId isEqualToString:model.appUserId])
    {
        return ;
    }
    
    if (model && model.userType == MIMUserTypeNormal)
    {
        MOBIMUserChatRoomController *vc = [MOBIMUserChatRoomController new];
        vc.contact = model;
        vc.otherUserId = model.appUserId;
        
        [self.rootViewConroller.navigationController pushViewController:vc animated:YES];

    }

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
    return 20;
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

