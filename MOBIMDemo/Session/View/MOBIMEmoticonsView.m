////
////  MOBIMEmoticonsView.m
////  MOBIMDemo
////
////  Created by hower on 2017/9/25.
////  Copyright © 2017年 MOB. All rights reserved.
////
//
//#import "MOBIMEmoticonsView.h"
//#import "MOBIMEmotion.h"
//#import "MOBIMEmotionCell.h"
//
//@interface MOBIMEmoticonsView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
//
////视图集合
//@property (nonatomic, strong) UICollectionView * collectionView;
//
////存储表情的数组
//@property (nonatomic, strong) NSArray * emoticons;
//
////回调代码块
//@property (nonatomic, copy)emoticonsViewWithButtonPressedBlock pressBlock;
//
//@end
//
//
//
//@implementation MOBIMEmoticonsView
//
////用纯代码创建的时候走的创建方法
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame])
//    {
//        [self viewInit];
//    }
//
//    return self;
//}
//
////用xib或者storyboard创建的时候走的创建方法
//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    [self viewInit];
//}
//
//
//- (void)emoticonsViewWithButtonPressedBlockHandle:(emoticonsViewWithButtonPressedBlock)buttonPressedBlock
//{
//    self.pressBlock = buttonPressedBlock;
//}
//
//- (void)viewInit
//{
//    //配置collectionView
//    [self loadCollectionView];
//
//    //注册cell
//    [self registerClassWithCell];
//
//    //加载数组
//    self.emoticons = [self loadEmoticons];
//
//    //贴到视图上
//    [self addSubview:self.collectionView];
//
//    //开始适配
//    [self layoutCollectionView];
//}
//
//
//#pragma mark - 表情数组的加载
///**
// *  加载表情数据
// *
// *  @return 返回存储表情的数组
// */
//-(NSArray *)loadEmoticons
//{
//    //路径
//    NSString * path = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
//
//    //加载数据
//    NSArray * emoticons = [NSArray arrayWithContentsOfFile:path];
//
//    //整合的数组
//    NSMutableArray * mutableEmoticons = [NSMutableArray array];
//
//    //可变数组进行数据整合
//    for (NSDictionary * infoDict in emoticons)
//    {
//        //字典转模型
//        MOBIMEmotion * emoticon = [MOBIMEmotion emoticonWithDictionary:infoDict];
//
//        //可变数组添加
//        [mutableEmoticons addObject:emoticon];
//    }
//
//    return [NSArray arrayWithArray:mutableEmoticons];
//}
//
//
///**
// *  注册各种cell
// */
//- (void)registerClassWithCell
//{
//    //注册cell,让cell的重用标识符是@“Emoticon”
//    [self.collectionView registerClass:[MOBIMEmotionCell class] forCellWithReuseIdentifier:@"MOBIMEmotionCell"];
//}
//
//
//- (void)layoutCollectionView
//{
//    //水平适配
//    NSArray * horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)];
//    [self addConstraints:horizontal];
//
//    //垂直适配
//    NSArray * verital = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)];
//    [self addConstraints:verital];
//}
//
//
///**
// *  配置集合视图(CollectionView)
// */
//- (void)loadCollectionView
//{
//    //集合视图的布局对象，必须有！如果不想设置其他的属性，就只有这句init即可
//    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//
//    //水平滚动，也就说布局是竖直优先
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//
//    //初始化集合视图(UICollenctionView)
//    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
//
//    //手动适配屏幕
//    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
//
//    //分页显示，否则太滑，继承于ScrollView
//    [self.collectionView setPagingEnabled:YES];
//
//    //默认是黑色的
//    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//
//    //不显示水平滚动栏
//    self.collectionView.showsHorizontalScrollIndicator = NO;
//
//    //设置代理和数据源
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//}
//
//
//#pragma mark - UICollectionView DateSource
////返回几个组，也是分组的，默认也是1，这个和UITableView一致
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//
////返回组中的数据的个数
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return self.emoticons.count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    //获取数据
//    MOBIMEmotion * emoticon = self.emoticons[indexPath.row];
//
//    //创建cell
//    MOBIMEmotionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MOBIMEmotionCell" forIndexPath:indexPath];
//
//    //避免强引用循环
//    __weak __block MOBIMEmoticonsView * copy_self = self;
//
//    //对cell设置进行的回调
//    [cell emotionButtonClickBlockHandle:^(UIImage *buttonImage, NSString *imageName) {
//
//        //如果上报代码块存在
//        if (copy_self.pressBlock)
//        {
//            copy_self.pressBlock(buttonImage,imageName);
//        }
//
//    }];
//
//    //设置数据
//    [cell setInformationWithEmoticon:emoticon];
//
//    return  cell;
//}
//
//#pragma mark - UICollectionView DelegateFlowLayout
//
////每个item的大小(可以根据indexPath定制)
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(30, 30);
//}
//
////每组距离边界的大小，逆时针，上，左，下，右
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(20, 20, 20, 20);
//}
//
//@end

