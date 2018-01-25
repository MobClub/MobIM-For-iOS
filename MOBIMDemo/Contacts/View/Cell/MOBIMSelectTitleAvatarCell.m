//
//  MOBIMSelectTitleAvatarCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/19.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMSelectTitleAvatarCell.h"
#import "UIView+MOBIMExtention.h"

@implementation MOBIMSelectTitleAvatarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.avatarImageView.layer.masksToBounds = YES;
//    self.avatarImageView.layer.cornerRadius = 2;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //[self.avatarImageView setRoundedCornersSize:self.avatarImageView.size.width];
    /*self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.size.width/2.0;
    self.avatarImageView.layer.shouldRasterize = YES;
    self.avatarImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
     */
}

@end
