//
//  MOBIMEmotionCell.h
//  YHExpressionKeyBoard
//
//  Created by hower on 2017/10/17.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MOBIMEmotion;
@interface MOBIMEmotionCell : UICollectionViewCell

@property (nonatomic, strong) MOBIMEmotion *emotion;
@property (nonatomic, strong) UIButton *emotionButton;
@property (nonatomic, assign) BOOL isDelete;

//空白cell,没有emoij,没有自定义图片
- (BOOL)noEmotionImage;

@end
