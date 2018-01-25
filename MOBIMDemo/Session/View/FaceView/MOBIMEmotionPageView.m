//
//  MOBIMEmotionPageView.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMEmotionPageView.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMEmotionMenuButton.h"
#import "MOBIMEmotionButton.h"
#import "MOBIMGConst.h"
#import "MOBIMGConst.h"

@interface MOBIMEmotionPageView ()

@property (nonatomic, weak) UIButton *deleteBtn;

@end

@implementation MOBIMEmotionPageView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"emotion_delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        self.deleteBtn       =  deleteBtn;
    }
    return self;
}


#pragma mark - Private

- (void)deleteBtnClicked:(UIButton *)deleteBtn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMEmotionDidDeleteNotification object:nil];// 通知出去
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions                   = emotions;
    NSUInteger count            = emotions.count;
    for (int i = 0; i < count; i ++)
    {
        MOBIMEmotionButton *button = [[MOBIMEmotionButton alloc] init];
        [self addSubview:button];
        button.emotion          = emotions[i];
        [button addTarget:self action:@selector(emotionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat inset            = 15;
    NSUInteger count         = self.emotions.count;
    CGFloat btnW             = (self.width - 2*inset)/MOBIMEmotionMaxCols;
    CGFloat btnH             = (self.height - 2*inset)/MOBIMEmotionMaxRows;
    for (int i = 0; i < count; i ++)
    {
        MOBIMEmotionButton *btn = self.subviews[i + 1];//因为已经加了一个deleteBtn了
        btn.width            = btnW;
        btn.height           = btnH;
        btn.x                = inset + (i % MOBIMEmotionMaxCols)*btnW;
        btn.y                = inset + (i / MOBIMEmotionMaxCols)*btnH;
    }
    self.deleteBtn.width     = btnW;
    self.deleteBtn.height    = btnH;
    self.deleteBtn.x         = inset + (count%MOBIMEmotionMaxCols)*btnW;
    self.deleteBtn.y         = inset + (count/MOBIMEmotionMaxCols)*btnH;
}


- (void)emotionBtnClicked:(MOBIMEmotionButton *)button
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[KMOBIMSelectEmotionKey]  = button.emotion;
    [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMEmotionDidSelectNotification object:nil userInfo:userInfo];
}


@end
