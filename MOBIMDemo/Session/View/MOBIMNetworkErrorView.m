//
//  MOBIMNetworkErrorView.m
//  MOBIMDemo
//
//  Created by hower on 05/12/2017.
//  Copyright © 2017 hower. All rights reserved.
//

#import "MOBIMNetworkErrorView.h"

@interface MOBIMNetworkErrorView()

@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MOBIMNetworkErrorView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        [self loadUI];
    }
    
    return self;
}

- (void)loadUI
{
    self.backgroundColor = MOBIMColor(255, 223, 224);
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"button_retry_comment"];
    
    [self addSubview:imgView];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _titleLabel.textColor = MOBIMColor(126, 102, 106);

    [self addSubview:_titleLabel];
    
    
    //布局
    MOBIMWEAKSELF
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_offset(30);
        make.centerY.mas_equalTo(weakSelf);
        make.width.height.mas_equalTo(20);
    }];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(15);
        make.leading.mas_offset(75);
        make.centerY.mas_equalTo(weakSelf);
        make.height.mas_equalTo(21);
    }];

}

- (void)setTitle:(NSString*)title
{
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
