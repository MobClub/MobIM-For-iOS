//
//  MOBIMBaseSectionCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/1.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseSectionCell.h"
#import "MOBIMGConst.h"

@implementation MOBIMBaseSectionCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userInteractionEnabled = NO;
        self.backgroundColor = MOBIMRGB(0xEFEFF3);

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
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
