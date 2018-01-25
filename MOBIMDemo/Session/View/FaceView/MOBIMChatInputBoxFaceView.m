//
//  MOBIMChatInputBoxFaceView.m
//  YHExpressionKeyBoard
//
//  Created by hower on 2017/10/16.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatInputBoxFaceView.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMFaceCollectionView.h"
#import "MOBIMEmotionCell.h"
#import "MOBIMFaceManager.h"
#import "MOBIMChatBoxMenuView.h"
#import "MOBIMGConst.h"
#import "MOBIMEmotion.h"

#define MOBIMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define MOIMDevice_Width  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度
#define MOIMDevice_Height [[UIScreen mainScreen] bounds].size.height //主屏幕的高度


#define KMOBIMTopLineH  0.5
#define kOnePageCount 20

#define KMOBIMMaxColCount 7.0
#define KMOBIMPageControlheight  20
#define bottomViewH 36.0



@interface MOBIMChatInputBoxFaceView ()<UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UIView *topLine;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) MOBIMChatBoxMenuView *menuView;

//表情视图
@property (nonatomic, strong) MOBIMFaceCollectionView *collectionView;
@property (nonatomic, strong) NSArray *emotionGroups;
@property (nonatomic, strong) NSArray<NSNumber *> *emotionGroupPageIndexs;
@property (nonatomic, strong) NSArray<NSNumber *> *emotionGroupPageCounts;
@property (nonatomic, assign) NSInteger emotionGroupTotalPageCount;
@property (nonatomic, assign) NSInteger currentPageIndex;

@end

@implementation MOBIMChatInputBoxFaceView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        [self loadData];
        [self loadGroupFaces];
        [self loadUI];
        
    }
    return self;
    
}

- (void)loadUI
{
    self.backgroundColor = MOBIMColor(237, 237, 246);
    
    
    MOBIMChatBoxMenuView *menuView = [[MOBIMChatBoxMenuView alloc] init];
    [menuView setDelegate:self];
    _menuView.backgroundColor = KMOBIMCommonKeyboardColor;
    [self addSubview:menuView];
    _menuView = menuView;
    
    [self loadData];
    [self topLine];
    //添加表情视图
    [self loadCollectionView];
    
    [self pageControl];
    
}


- (void)loadData
{
    //获取分组数据
    [self loadGroupFaces];
    
}

- (void)loadCollectionView
{
    CGFloat itemWidth = (MOIMDevice_Width - 10 * 2) / KMOBIMMaxColCount;
    
    CGFloat itemHeight = (self.height - bottomViewH - KMOBIMPageControlheight) / 3.0;
    //itemWidth = CGFloatPixelRound(itemWidth);
    CGFloat padding = (MOIMDevice_Width - KMOBIMMaxColCount * itemWidth) / 2.0;
    //CGFloat paddingLeft  = CGFloatPixelRound(padding);
    CGFloat paddingLeft  = padding;
    
    CGFloat paddingRight = MOIMDevice_Width - paddingLeft - itemWidth * 7;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight);
    
    
    _collectionView = [[MOBIMFaceCollectionView alloc] initWithFrame:CGRectMake(0, 0, MOIMDevice_Width, itemHeight * 3) collectionViewLayout:layout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_collectionView registerClass:[MOBIMEmotionCell class] forCellWithReuseIdentifier:@"MOBIMEmotionCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.top = 5;
    [self addSubview:_collectionView];
    
    [_collectionView  setTapBlock:^(MOBIMEmotionCell *cell){
        
//        NSLog(@"emotion ---- %@ :%@    :%@",cell.emotion.face_id,cell.emotion.face_name,cell.emotion.code);

        if (cell.isDelete) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMEmotionDidDeleteNotification object:nil];// 通知出去
        }else{
            if (cell.emotion.code || cell.emotion.face_name) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMEmotionDidSelectNotification object:nil userInfo:cell.emotion];
            }

        }
    }];
    
    if ([_emotionGroups count]>0 && [_emotionGroups[0] count]>0) {
        
        self.pageControl.numberOfPages = ((NSNumber *)_emotionGroupPageCounts[0]).integerValue;
        [self.pageControl setCurrentPage:((NSNumber *)_emotionGroupPageIndexs[0]).integerValue];
    }
    
}

- (void)loadGroupFaces
{
    //emoji
    _emotionGroups = [MOBIMFaceManager emojiGroups];
    
    NSMutableArray *indexs = [NSMutableArray new];
    NSUInteger index = 0;
    for (NSDictionary *group in _emotionGroups)
    {
        [indexs addObject:@(index)];
        NSUInteger count = ceil([group[@"groupemotions"] count] / (float)kOnePageCount);
        if (count == 0) count = 1;
        index += count;
    }
    _emotionGroupPageIndexs = indexs;
    
    
    //表情组总页数
    NSMutableArray *pageCounts = [NSMutableArray new];
    _emotionGroupTotalPageCount = 0;
    for (NSDictionary *group in _emotionGroups)
    {
        NSUInteger pageCount = ceil([group[@"groupemotions"] count] / (float)kOnePageCount);
        if (pageCount == 0) pageCount = 1;
        [pageCounts addObject:@(pageCount)];
        _emotionGroupTotalPageCount += pageCount;
    }
    _emotionGroupPageCounts = pageCounts;
    
}

- (UIView *)topLine
{
    if (nil == _topLine)
    {
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MOIMDevice_Width,KMOBIMTopLineH)];
        [self addSubview:topLine];
        topLine.backgroundColor = MOBIMColor(188.0, 188.0, 188.0);
        _topLine = topLine;
    }
    return _topLine;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.menuView.width         = self.width;
    self.menuView.height        = bottomViewH;
    self.menuView.x             = 0;
    self.menuView.y             = self.height - self.menuView.height;
    
    self.pageControl.width          = self.width;
    self.pageControl.height         = KMOBIMPageControlheight;
    self.pageControl.x              = 0;
    self.pageControl.y              = self.menuView.y - KMOBIMPageControlheight;
    
//    self.pageControl.backgroundColor = [UIColor redColor];
    CGFloat itemHeight = (self.height - self.menuView.height - KMOBIMPageControlheight) / 3.0;
    _collectionView.frame = CGRectMake(0, 0, MOIMDevice_Width, itemHeight * 3);
}

- (UIPageControl *)pageControl
{
    if (nil == _pageControl)
    {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        _pageControl = pageControl;
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.userInteractionEnabled = NO;
        
        [self addSubview:pageControl];
    }
    return _pageControl;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = round(scrollView.contentOffset.x / scrollView.width);
    if (page < 0) page = 0;
    else if (page >= _emotionGroupTotalPageCount) page = _emotionGroupTotalPageCount - 1;
    if (page == _currentPageIndex) return;
    _currentPageIndex = page;
    NSInteger curGroupIndex = 0, curGroupPageIndex = 0, curGroupPageCount = 0;
    for (NSInteger i = _emotionGroupPageIndexs.count - 1; i >= 0; i--)
    {
        NSNumber *pageIndex = _emotionGroupPageIndexs[i];
        if (page >= pageIndex.unsignedIntegerValue) {
            curGroupIndex = i;
            curGroupPageIndex = ((NSNumber *)_emotionGroupPageIndexs[i]).integerValue;
            curGroupPageCount = ((NSNumber *)_emotionGroupPageCounts[i]).integerValue;
            break;
        }
    }
    
//    _pageControl.backgroundColor = [UIColor redColor];
    _pageControl.numberOfPages = curGroupPageCount;
    [_pageControl setCurrentPage:_currentPageIndex - curGroupPageIndex];
    
}

#pragma mark -MOBIMEmotionCell
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _emotionGroupTotalPageCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kOnePageCount + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MOBIMEmotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MOBIMEmotionCell" forIndexPath:indexPath];
    if (indexPath.row == kOnePageCount) {
        cell.isDelete = YES;
        cell.emotion = nil;
    } else {
        cell.isDelete = NO;
        cell.emotion = [self _emotionForIndexPath:indexPath];
        
//        NSLog(@"emotion ---- %@ :%@    :%@",cell.emotion.face_id,cell.emotion.face_name,cell.emotion.code);
    }
    
    
//    if (indexPath.row %2== 0) {
//        cell.contentView.backgroundColor = [UIColor redColor];
//    }
    return cell;
}

- (MOBIMEmotion *)_emotionForIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    for (NSInteger i = _emotionGroupPageIndexs.count - 1; i >= 0; i--)
    {
        NSNumber *pageIndex = _emotionGroupPageIndexs[i];
        if (section >= pageIndex.unsignedIntegerValue) {
            NSDictionary *group = _emotionGroups[i];
            NSUInteger page = section - pageIndex.unsignedIntegerValue;
            NSUInteger index = page * kOnePageCount + indexPath.row;
            
            // transpose line/row
            NSUInteger ip = index / kOnePageCount;
            NSUInteger ii = index % kOnePageCount;
            NSUInteger reIndex = (ii % 3) * 7 + (ii / 3);
            index = reIndex + ip * kOnePageCount;
            
            if (index < [group[@"groupemotions"] count]) {
                return group[@"groupemotions"][index];
            } else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (void)emotionMenu:(MOBIMChatBoxMenuView *)menu didSelectButton:(MOBIMEmotionMenuButtonType)buttonType
{
    
}

@end

