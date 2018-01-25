//
//  MOBIMBlackCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBlackCell.h"
#import "MOBIMGConst.h"
#import "UIView+MOBIMExtention.h"

@implementation MOBIMBlackCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.deleteButton.layer.masksToBounds = YES;
    self.deleteButton.layer.cornerRadius = 2;
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 36/2.0;
    self.lineLabel.backgroundColor = KMOBIMCommonLineColor;
//    [self.avatarImageView setRoundedCornersSize:46];
    self.deleteButton.backgroundColor = KMOBIMCommonButtonColor;
    
}
@end
