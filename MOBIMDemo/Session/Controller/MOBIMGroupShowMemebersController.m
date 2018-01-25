//
//  MOBIMGroupShowMemebersController.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/19.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMGroupShowMemebersController.h"
#import "MOBIMAvatarFLowLayout.h"
#import "MOBIMSelectTitleAvatarCell.h"
#import "MOBIMGConst.h"
#import "MOBIMUserManager.h"
#import "MOBIMUserModel.h"
#import "MOBIMUser.h"
#import "UIView+MOBIMExtention.h"
#import "Masonry.h"
#import "MOBIMGroupDeleteMemeberViewController.h"
#import "MOBIMGroupAddMemeberViewController.h"
#import "UIImageView+MOBIMRoundedExtension.h"

#define KMOBIMSelectTitleAvatarTag @"KMOBIMSelectTitleAvatarTag"



@interface MOBIMGroupShowMemebersController ()<UICollectionViewDataSource,UICollectionViewDelegate,MOBIMAvatarFLowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cellsArray;
@property (nonatomic, strong) NSString *owerId;
@property (nonatomic, strong) NSString *groupId;
@end

@implementation MOBIMGroupShowMemebersController

- (NSMutableArray *)cellsArray
{
    if (!_cellsArray) {
        _cellsArray = [NSMutableArray array];
    }
    return _cellsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadUI];
    [self loadData];
    
}

- (void)loadData
{
//    self.cellsArray = [NSMutableArray array];
//    for (int i=0; i<30; i++) {
//        if (i%2 == 0) {
//            [self.cellsArray addObject:@"mayun"];
//        }else{
//            [self.cellsArray addObject:@"mahuateng"];
//
//        }
//    }
    
    self.owerId = _groupInfo.owner.appUserId;
    self.groupId = _groupInfo.groupId;
    
    NSMutableArray *userModels = [NSMutableArray new];
    //组合对象
    NSArray *allUsers = _groupInfo.membersList.allObjects;
    [allUsers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MOBIMUserModel *userModel =  [MOBIMUserManager userSdkToUserModel:obj];
//        if (![userModel.appUserId isEqualToString:[MOBIMUserManager currentUserId]]) {
            [userModels addObject:userModel];
//        }
    }];
    
    
    MOBIMUserModel *userModel = [MOBIMUserModel new];
    userModel.avatar = @"chat_adduser";
    userModel.extDict = @{@"operaton":@"1"};
    //添加用户
    
    [userModels addObject:userModel];
    
    if (self.isGroupRoomOwer == YES) {
        MOBIMUserModel *userModel = [MOBIMUserModel new];
        userModel.avatar = @"chat_deleteuser";
        userModel.extDict = @{@"operaton":@"2"};
        [userModels addObject:userModel];

    }
    
    //删除用户
    
    self.cellsArray = userModels;
    
    [_collectionView reloadData];
}

- (BOOL)isGroupRoomOwer
{
    if (self.groupInfo.owner.appUserId && [MOBIMUserManager currentUserId] && [self.groupInfo.owner.appUserId isEqualToString:[MOBIMUserManager currentUserId]]) {
        
        return YES;
    }
    
    return NO;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadMemebers:(MIMGroup*)groupInfo
{
    self.title = [NSString stringWithFormat:@"%d人",groupInfo.membersCount];

}

- (void)loadUI
{
    [self reloadMemebers:_groupInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupAddMemebersSucessNtf:) name:KMOBIMGroupAddMemebersSucessNtf object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupDeleteMemebersSucessNtf:) name:KMOBIMGroupDeleteMemebersSucessNtf object:nil];

    
    MOBIMAvatarFLowLayout *layout = [[MOBIMAvatarFLowLayout alloc]init];
    
    CGRect rect = self.view.bounds;
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 15, rect.size.width, rect.size.height- 15) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    layout.delegate = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MOBIMSelectTitleAvatarCell" bundle:nil] forCellWithReuseIdentifier:KMOBIMSelectTitleAvatarTag];
    
    //_collectionView.backgroundColor = MOBIMRGB(0xEFEFF3);
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.trailing.leading.mas_offset(0);
        make.top.mas_offset(10);
        make.bottom.mas_offset(0);
        
    }];
}


- (void)groupAddMemebersSucessNtf:(NSNotification*)notification
{
    if (notification.object && [notification.object isKindOfClass:[MIMGroup class]]) {
        MIMGroup *transferGroup =(MIMGroup*) notification.object;
        
        if (transferGroup.groupId == self.groupId)
        {
            // 刷新界面
            if (_groupInfo != transferGroup) {
                self.groupInfo = transferGroup;
            }
            [self reloadMemebers:_groupInfo];

            [self.collectionView reloadData];
            
        }
    }
}

- (void)groupDeleteMemebersSucessNtf:(NSNotification*)notification
{
    if (notification.object && [notification.object isKindOfClass:[MIMGroup class]]) {
        MIMGroup *transferGroup =(MIMGroup*) notification.object;
        
        if (transferGroup.groupId == self.groupId)
        {
            // 刷新界面
            if (_groupInfo != transferGroup) {
                self.groupInfo = transferGroup;
            }
            [self reloadMemebers:_groupInfo];

            [self.collectionView reloadData];
            
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    _collectionView.mj_footer.hidden = self.shops.count == 0;
    return self.cellsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MOBIMSelectTitleAvatarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KMOBIMSelectTitleAvatarTag forIndexPath:indexPath];
    
    MOBIMUserModel *model = self.cellsArray[indexPath.row];
    
    if (model.extDict) {
        cell.nameLabel.text = model.nickname;
        cell.avatarImageView.image = [UIImage imageNamed:model.avatar];
    }else{
        
        //考虑自己的用户体系，获取用户信息
        [[MOBIMUserManager sharedManager] fetchUserInfo:model.appUserId needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
            if (user) {
                cell.nameLabel.text = user.nickname;
                [cell.avatarImageView rounded_setImageWithURL:[NSURL URLWithString:user.avatar] radius:cell.avatarImageView.width];
                
                
            }
        }];


    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MOBIMUserModel *model = self.cellsArray[indexPath.row];
    if ([model.extDict[@"operaton"] intValue] == 2) {
        //删除
        
        MOBIMGroupDeleteMemeberViewController *vc = [[MOBIMGroupDeleteMemeberViewController alloc] init];
        vc.groupInfo = self.groupInfo;
        vc.conversationId = self.conversationId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.extDict[@"operaton"] intValue] == 1) {
        MOBIMGroupAddMemeberViewController *vc = [[MOBIMGroupAddMemeberViewController alloc] init];
        vc.groupInfo = self.groupInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" uId = %@ AND userId = %@",_groupInfo.groupId,[MOBIMUserManager sharedManager].currentUser.userId];
//    self.myGroupVcard = [MOBIMVCard MR_findFirstWithPredicate:predicate sortedBy:nil ascending:YES];
    
}

#pragma mark - MOBIMAvatarFLowLayoutDelegate
- (CGFloat)flowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout heightForRowAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth
{
    return itemWidth + 20;
}

- (CGFloat)columnCountInFLowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout
{
    return 5;
}

- (CGFloat)columnMarginInFLowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout
{
    return 10;
}

- (CGFloat)rowMarginInFLowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout
{
    return 10;
}

- (UIEdgeInsets)edgeInsetsInFLowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}
@end
