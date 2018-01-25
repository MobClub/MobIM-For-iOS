//
//  MOBIMBaseMessageCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseMessageCell.h"
#import "UIView+MOBIMExtention.h"
#import "Masonry.h"
#import "MOBIMGConst.h"

@interface MOBIMBaseMessageCell ()

@property (nonatomic, weak) UIView *topLine;


@end

@implementation MOBIMBaseMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    [self topLine];
    [self bottomLine];
    
    _topLineStyle = MOBIMBaseMessageCellLineStyleNone;
    _bottomLineStyle = MOBIMBaseMessageCellLineStyleNone;
    _leftFreeSpace = 15;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    MOBIMWEAKSELF
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(weakSelf.height - weakSelf.bottomLine.height);
    }];
    
    //self.topLine.y = 0;
    //self.bottomLine.y = self.height - self.bottomLine.height;
    [self setBottomLineStyle:_bottomLineStyle];
    [self setTopLineStyle:_topLineStyle];
    
    [self.contentView bringSubviewToFront:self.bottomLine];
    
}

- (void)setTopLineStyle:(MOBIMBaseMessageCellLineStyle)topLineStyle
{
    _topLineStyle = topLineStyle;
    if (topLineStyle == MOBIMBaseMessageCellLineStyleDefault) {
        self.topLine.x = _leftFreeSpace;
        self.topLine.width = self.width - _leftFreeSpace;
        [self.topLine setHidden:NO];
    } else if (topLineStyle == MOBIMBaseMessageCellLineStyleFill){
        self.topLine.x = 0;
        self.topLine.width = self.width;
        self.topLine.hidden = NO;
    } else if (topLineStyle == MOBIMBaseMessageCellLineStyleNone){
        self.topLine.hidden = YES;
    }
}

- (void)setBottomLineStyle:(MOBIMBaseMessageCellLineStyle)bottomLineStyle
{
    MOBIMWEAKSELF
    _bottomLineStyle = bottomLineStyle;
    if (bottomLineStyle == MOBIMBaseMessageCellLineStyleDefault) {
//        self.bottomLine.x = _leftFreeSpace;
//        self.bottomLine.width = self.width - _leftFreeSpace - _rightFreeSpace;
//        self.bottomLine.hidden = NO;
        
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(_leftFreeSpace);
            make.width.mas_offset(weakSelf.width - _leftFreeSpace - _rightFreeSpace);
        }];
        
    } else if (bottomLineStyle == MOBIMBaseMessageCellLineStyleFill) {
        //self.bottomLine.x = 0;
        //self.bottomLine.width = self.width;
        
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(0);
            make.width.mas_offset(weakSelf.width);
        }];
        self.bottomLine.hidden = NO;
    } else if (bottomLineStyle == MOBIMBaseMessageCellLineStyleNone) {
        self.bottomLine.hidden = YES;
    }
}


#pragma mark - getter and setter

- (UIView *)bottomLine
{
    if (nil == _bottomLine) {
        UIView *line = [[UIView alloc] init];
        line.height = 0.5f;
        line.backgroundColor = MOBIMRGB(0xE6E6EC);
        
//        line.backgroundColor = [UIColor redColor];
//        line.alpha = 0.4;
        [self.contentView addSubview:line];
//        [self addSubview:line];

        _bottomLine = line;
    }
    return _bottomLine;
}

- (UIView *)topLine
{
    if (nil == _topLine) {
        UIView *line = [[UIView alloc] init];
        line.height = 0.5f;
        line.backgroundColor = MOBIMRGB(0xE6E6EC);
        line.alpha = 0.4;
        [self.contentView addSubview:line];
//        [self addSubview:line];
        _topLine = line;
    }
    return _topLine;
}


@end
