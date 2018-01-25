//
//  MOBIMChatInputBoxMoreViewItem.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatInputBoxMoreViewItem.h"
#import "Masonry.h"

@interface MOBIMChatInputBoxMoreViewItem()

@property (nonatomic, strong, readwrite) UIButton *button;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, assign, readwrite) MOBIMChatInputBoxMoreViewItemType moreViewItemType;

@end

@implementation MOBIMChatInputBoxMoreViewItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.button];
        [self addSubview:self.titleLabel];
    }
    return self;
}


- (void)setTitle:(NSString*)title imageName:(NSString*)imageName moreViewItemType:(MOBIMChatInputBoxMoreViewItemType)moreViewItemType
{
    [self.button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.titleLabel setText:title];
    self.moreViewItemType = moreViewItemType;
    
    [self loadUI];
}


- (void)loadUI
{
    MOBIMWEAKSELF
    //布局
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf).offset(0);
        make.width.height.mas_equalTo(60);
        
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(0);
        make.width.equalTo(weakSelf).offset(0);
        make.height.mas_equalTo(12);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
}

- (UIButton *) button
{
    if (_button == nil)
    {
        _button = [[UIButton alloc] init];
//        [_button.layer setMasksToBounds:YES];
//        [_button.layer setCornerRadius:4.0f];
//        [_button.layer setBorderWidth:0.5f];
 //       [_button.layer setBorderColor:[UIColor grayColor].CGColor];
    }
    return _button;
}

- (UILabel *) titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_titleLabel setTextColor:[UIColor grayColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}





@end
