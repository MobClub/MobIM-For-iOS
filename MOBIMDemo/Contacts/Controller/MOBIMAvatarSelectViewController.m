//
//  MOBIMAvatarSelectViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/29.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMAvatarSelectViewController.h"
#import "MOBIMAvatarFLowLayout.h"
#import "MOBIMSelectAvatarCell.h"
#import "MOBIMGConst.h"
#import "MOBIMUserManager.h"
#import "UIImageView+MOBIMRoundedExtension.h"
#import "UIViewController+MOBIMToast.h"

#define KMOBIMSelectAvatarTag @"KMOBIMSelectAvatarTag"

@interface MOBIMAvatarSelectViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MOBIMAvatarFLowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cellsArray;
@end

@implementation MOBIMAvatarSelectViewController

- (NSMutableArray *)cellsArray
{
    if (!_cellsArray)
    {
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
    self.cellsArray = [NSMutableArray array];
    
    [self.cellsArray addObject:@"http://download.sdk.mob.com/e72/83d/e247e8b45bd557f70ac6dcc0cb.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/7b6/264/2c4a9fef9ffa03e5deb5973ab9.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/bbd/480/d993f23339944e4de27e4b0a12.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/3a6/b11/ba6a81f2c13fb0ba3b96d99619.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/a0b/7d0/0520d3554a69ad50a3b87d1760.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/510/deb/0c0731ac543eb71311c482a2e2.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/7d7/e2b/91d898dfde6fb787ab3d926f9d.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/29f/06f/e6a941cd02e3f29465cd438d16.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/167/bc4/38197ca7950aec7020d516fbb2.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/f57/a5e/72ecd0c6ca96361c7f3bcd7144.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/e31/c6e/315fdfa6abc4b17d8c139605de.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/cc3/00e/dedc8bf1514d6c6a5e456fba74.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/f22/154/e27eaf3fc3e24047bd5d4ec3a8.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/d33/6f9/c15ee2d2f01aba51d33985e6c5.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/cc6/115/2628761069dd35867eda68fe2a.png"];
    [self.cellsArray addObject:@"http://download.sdk.mob.com/047/a51/38cfad789e9808443d11f2f9be.png"];
    
    [_collectionView reloadData];
}

- (void)loadUI
{
    self.title = @"选择你的头像";
    MOBIMAvatarFLowLayout *layout = [[MOBIMAvatarFLowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    layout.delegate = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MOBIMSelectAvatarCell" bundle:nil] forCellWithReuseIdentifier:KMOBIMSelectAvatarTag];
    
    _collectionView.backgroundColor = MOBIMRGB(0xEFEFF3);

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
    MOBIMSelectAvatarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KMOBIMSelectAvatarTag forIndexPath:indexPath];
    
    
    NSString *path = [self.cellsArray objectAtIndex:indexPath.row];
    [cell.avatarImageView rounded_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar] radius:cell.avatarImageView.width];

    
//    cell.avatarImageView.image = [UIImage imageNamed:self.cellsArray[indexPath.row]];
//    cell.model = self.cellsArray[indexPath.item];
//    cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.width/2.0;
//    cell.avatarImageView.layer.masksToBounds = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *path = [self.cellsArray objectAtIndex:indexPath.row];

    [self showToastWithIndeterminateHUDMode];
    MOBIMWEAKSELF
    [[MOBIMUserManager sharedManager] modifyCurrentUserAvatarPath:path completion:^(NSString *avatarPath,NSError *error) {
        
        [weakSelf performMainBlock:^{
            
            if (!error)
            {
                [MOBIMUserManager sharedManager].currentUser.avatar = path;
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                
                
                if (weakSelf.itemSeletectedBlock)
                {
                    weakSelf.itemSeletectedBlock(path);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
                [weakSelf dismissToast];

            }
            else
            {
                [weakSelf showToastMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
            
            
        }];

        
    }];

}

@end
