//
//  MOBIMBaseAvatarAddCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/29.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseAvatarAddCell.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMGConst.h"

@implementation MOBIMBaseAvatarAddCell

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
    self.hasAddLabel.textColor = KMOBIMDesColor;
    self.hasAddLabel.hidden = YES;
    self.addButton.layer.masksToBounds = YES;
    self.addButton.layer.cornerRadius = 2;
    self.addButton.backgroundColor = MOBIMRGB(0x00C59C );
    
}

@end

