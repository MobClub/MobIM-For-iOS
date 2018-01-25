//
//  MOBIMBaseAvatarCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/29.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseButtonAvatarCell.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMGConst.h"

@implementation MOBIMBaseButtonAvatarCell

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
    [self.avatarButton setRoundedCornersSize:46];
    
    self.lineLabel.backgroundColor = KMOBIMCommonLineColor;
    
}

@end
