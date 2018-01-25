//
//  MOBIMEmotionPageView.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MOBIMEmotionMaxRows 3
#define MOBIMEmotionMaxCols 7
#define MOBIMEmotionPageSize ((MOBIMEmotionMaxRows * MOBIMEmotionMaxCols) - 1)

@interface MOBIMEmotionPageView : UIView

@property (nonatomic, strong) NSArray *emotions;


@end
