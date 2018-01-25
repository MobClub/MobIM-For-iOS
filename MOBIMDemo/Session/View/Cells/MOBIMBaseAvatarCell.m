////
////  MOBIMBaseAvatarCell.m
////  MOBIMDemo
////
////  Created by hower on 2017/9/27.
////  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseAvatarCell.h"
#import "Masonry.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMGConst.h"
#import "MOBIMGroupModel.h"
#import "MOBIMAvatarFLowLayout.h"
#import "MOBIMGroupDeleteMemeberViewController.h"
#import "MOBIMGroupAddMemeberViewController.h"
#import "MOBIMSelectTitleAvatarCell.h"
#import "UIImage+MOBIMExtension.h"
#import "UIImageView+MOBIMRoundedExtension.h"

//群组相关
#define KMOBIMGroupUsersShowMaxCount 8 //详情页最多显示多少成员
#define KMOBIMGroupUsersShowColMaxCount 5 //每一行，显示多少列
#define KMOBIMGroupUsersShowColOffset 10 //每一列 offset
#define KMOBIMGroupUsersShowRowOffset 10 //每一行 offset
#define KMOBIMGroupUsersShowHeadTailOffset 15 //每一行，显示多少列

#define KMOBIMGroupUsersShowLabelHeight 20 //每一行，显示多少列
#define KMOBIMGroupUsersShowAllLabelHeight 60

#define KMOBIMSelectTitleAvatarTag @"KMOBIMSelectTitleAvatarTag"


@interface MOBIMBaseAvatarCell()<UICollectionViewDataSource,UICollectionViewDelegate,MOBIMAvatarFLowLayoutDelegate>

@property (nonatomic, strong) MIMGroup *groupModel;

@property (nonatomic, assign) BOOL isGroupOwer;
@property (nonatomic, assign) BOOL needShowAll;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *showAllButton;


@property (nonatomic, strong) NSMutableArray *userModels;

@end

@implementation MOBIMBaseAvatarCell


//- (instancetype)init
//{
//    MOBIMBaseAvatarCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MOBIMBaseAvatarCell" owner:self options:nil] lastObject];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    return cell;
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        [self loadUI];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self loadUI];

}

- (void)loadUI
{
    
    
    MOBIMAvatarFLowLayout *layout = [[MOBIMAvatarFLowLayout alloc]init];
    CGRect rect = self.bounds;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height- 15) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.contentView addSubview:_collectionView];
    layout.delegate = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MOBIMSelectTitleAvatarCell" bundle:nil] forCellWithReuseIdentifier:KMOBIMSelectTitleAvatarTag];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.trailing.leading.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
}

- (UIButton *)showAllButton
{
    if (!_showAllButton) {
        _showAllButton = [UIButton new];
        [_showAllButton setTitle:@"查看全部用户" forState:UIControlStateNormal];
        _showAllButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _showAllButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_showAllButton addTarget:self action:@selector(showAll) forControlEvents:UIControlEventTouchUpInside];
        [_showAllButton setTitleColor:MOBIMRGB(0x00C59C) forState:UIControlStateNormal];
        _showAllButton.hidden = YES;
    }
    
    _showAllButton.frame=CGRectMake(0, self.calHeight - KMOBIMGroupUsersShowAllLabelHeight, MOIMDevice_Width, KMOBIMGroupUsersShowAllLabelHeight);

    return _showAllButton;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//可以考虑使用collection 来制作,暂时简单处理
- (void)setDataModel:(MIMGroup*)groupModel isGroupOwer:(BOOL)isGroupOwer
{
    _isGroupOwer = isGroupOwer;
    _groupModel = groupModel;
    
    
    //过滤群主自己
    NSMutableArray *mutbleMemebers = [NSMutableArray arrayWithArray:groupModel.membersList.allObjects];
    for (MIMUser *user  in mutbleMemebers) {
        if ([user.appUserId isEqualToString:[MOBIMUserManager currentUserId]])
        {
            [mutbleMemebers removeObject:user];
            break;
        }
    }
    NSInteger count = mutbleMemebers.count;

    
    NSArray *memebers = mutbleMemebers;
    BOOL showAll = NO;
    if (count >= KMOBIMGroupUsersShowMaxCount)
    {
        if (isGroupOwer)
        {
            memebers = [mutbleMemebers subarrayWithRange:NSMakeRange(0, KMOBIMGroupUsersShowMaxCount)];
            if (count >= KMOBIMGroupUsersShowMaxCount + 1) {
                showAll = YES;
            }
        }
        else
        {
            if (memebers.count >= (KMOBIMGroupUsersShowMaxCount+1)) {
                memebers = [mutbleMemebers subarrayWithRange:NSMakeRange(0, KMOBIMGroupUsersShowMaxCount+1)];
            }
            
            if (count >= KMOBIMGroupUsersShowMaxCount + 2) {
                showAll = YES;
            }
        }
    }
    
    //变化结构
    {
        NSMutableArray *userModels = [NSMutableArray new];
        //组合对象
        [memebers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            MOBIMUserModel *userModel =  [MOBIMUserManager userSdkToUserModel:obj];
            [userModels addObject:userModel];
        }];
        
        
        MOBIMUserModel *userModel = [MOBIMUserModel new];
        userModel.avatar = @"chat_adduser";
        userModel.extDict = @{@"operaton":@"0"};
        //添加用户
        
        [userModels addObject:userModel];
        
        if (_isGroupOwer == YES) {
            MOBIMUserModel *userModel = [MOBIMUserModel new];
            userModel.avatar = @"chat_deleteuser";
            userModel.extDict = @{@"operaton":@"1"};
            [userModels addObject:userModel];
            
        }
        
        self.userModels = userModels;
        [self.collectionView reloadData];
    }
    
    //查看全部
    if (showAll) {

        if (![self.showAllButton superview]) {
            [self.contentView addSubview:self.showAllButton];
            self.showAllButton.hidden = NO;
        }
        
    }

    
}

- (float)calHeight
{
    
    //过滤群主自己
    NSMutableArray *memebers = [NSMutableArray arrayWithArray:_groupModel.membersList.allObjects];
    for (MIMUser *user  in memebers) {
        if (user.appUserId == _groupModel.owner.appUserId)
        {
            [memebers removeObject:user];
            break;
        }
    }
    
    NSUInteger count = [memebers count];
    
    if (count > KMOBIMGroupUsersShowMaxCount)
    {
        count = KMOBIMGroupUsersShowMaxCount;
    }
    
    NSUInteger lastCount = count;
    if (_isGroupOwer)
    {
        lastCount +=2;
    }
    else
    {
        lastCount +=1;
    }
    
    
    //计算行数
    NSUInteger rows = lastCount/KMOBIMGroupUsersShowColMaxCount + ((lastCount%KMOBIMGroupUsersShowColMaxCount == 0) ? 0 : 1);
    float avatarHeight = (MOIMDevice_Width - 2*KMOBIMGroupUsersShowHeadTailOffset - (KMOBIMGroupUsersShowColMaxCount-1)*KMOBIMGroupUsersShowColOffset)/KMOBIMGroupUsersShowColMaxCount;

    if ([memebers count] < KMOBIMGroupUsersShowMaxCount) {
        return KMOBIMGroupUsersShowRowOffset+rows*(KMOBIMGroupUsersShowRowOffset+avatarHeight+KMOBIMGroupUsersShowLabelHeight) + 15;

    }
    return KMOBIMGroupUsersShowRowOffset+rows*(KMOBIMGroupUsersShowRowOffset+avatarHeight+KMOBIMGroupUsersShowLabelHeight)+KMOBIMGroupUsersShowAllLabelHeight - 15;
}

- (void)plusClick
{
    if (self.plusCompletion) {
        self.plusCompletion();
    }
    
}

- (void)showAll
{
    if (self.showAllCompletion) {
        self.showAllCompletion();
    }
    
}


- (void)deleteClick
{
    if (self.deleteCompletion) {
        self.deleteCompletion();
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    _collectionView.mj_footer.hidden = self.shops.count == 0;
    return self.userModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MOBIMSelectTitleAvatarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KMOBIMSelectTitleAvatarTag forIndexPath:indexPath];
    
    MOBIMUserModel *model = self.userModels[indexPath.row];
    

    if (model.extDict) {
        cell.nameLabel.text = model.nickname;
//        cell.avatarImageView.layer.masksToBounds = YES;
//        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.width/2.0f;
        cell.avatarImageView.image = [UIImage imageNamed:model.avatar];

    }else{
        
        //考虑自己的用户体系，获取用户信息
        [[MOBIMUserManager sharedManager] fetchUserInfo:model.appUserId needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
            if (user) {
                cell.nameLabel.text = user.nickname;
                [cell.avatarImageView rounded_setImageWithURL:[NSURL URLWithString:user.avatar]  radius:cell.avatarImageView.size.width];
                
            }
        }];
        
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > (self.userModels.count - 1))
    {
        return;
    }
    MOBIMUserModel *model = self.userModels[indexPath.row];
    if ([model.extDict[@"operaton"] intValue] == 1) {
        
        if (self.deleteCompletion) {
            self.deleteCompletion();
        }
        
    }else if ([model.extDict[@"operaton"] intValue] == 0) {
        
        if (self.plusCompletion) {
            self.plusCompletion();
        }
        
    }
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" uId = %@ AND userId = %@",_groupInfo.groupId,[MOBIMUserManager sharedManager].currentUser.userId];
    //    self.myGroupVcard = [MOBIMVCard MR_findFirstWithPredicate:predicate sortedBy:nil ascending:YES];
    
}

#pragma mark - MOBIMAvatarFLowLayoutDelegate
- (CGFloat)flowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout heightForRowAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth
{
    return itemWidth + KMOBIMGroupUsersShowLabelHeight;
}

- (CGFloat)columnCountInFLowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout
{
    return KMOBIMGroupUsersShowColMaxCount;
}

- (CGFloat)columnMarginInFLowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout
{
    return KMOBIMGroupUsersShowColOffset;
}

- (CGFloat)rowMarginInFLowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout
{
    return KMOBIMGroupUsersShowRowOffset;
}

- (UIEdgeInsets)edgeInsetsInFLowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

@end

