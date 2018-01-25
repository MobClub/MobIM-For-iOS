//
//  MOBIMFaceCollectionView.h
//  YHExpressionKeyBoard
//
//  Created by hower on 2017/10/16.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOBIMEmotionCell;
typedef void(^MOBIMFaceCollectionViewCellDidTapBlock)(MOBIMEmotionCell *cell);

@interface MOBIMFaceCollectionView : UICollectionView

@property  (nonatomic, copy) MOBIMFaceCollectionViewCellDidTapBlock tapBlock;
@end
