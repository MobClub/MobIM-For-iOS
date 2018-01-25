//
//  MOBIMSelectAvatarCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/29.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMSelectAvatarCell.h"
#import "UIView+MOBIMExtention.h"

@implementation MOBIMSelectAvatarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
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
    //[self.avatarImageView setRoundedCornersSize:46];
//    self.avatarImageView.layer.cornerRadius = 46.0;
//    self.avatarImageView.layer.masksToBounds = YES;
}

@end
