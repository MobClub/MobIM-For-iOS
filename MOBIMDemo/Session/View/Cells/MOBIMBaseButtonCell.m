//
//  MOBIMBaseButtonCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseButtonCell.h"
#import "MOBIMGConst.h"

@implementation MOBIMBaseButtonCell


- (instancetype)init
{
    MOBIMBaseButtonCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MOBIMBaseButtonCell" owner:self options:nil] lastObject];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadUI
{
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 2;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.button.backgroundColor = MOBIMRGB(0x00C59C );
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(UIButton*)button
{
    if (self.buttonClickCompletion)
    {
        self.buttonClickCompletion();
    }
        
}

@end
