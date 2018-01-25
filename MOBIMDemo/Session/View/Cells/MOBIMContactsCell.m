//
//  MOBIMContactsCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMContactsCell.h"
#import "MOBIMGConst.h"
#import "UIView+MOBIMExtention.h"

@implementation MOBIMContactsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    self.lineLabel.backgroundColor = KMOBIMCommonLineColor;
    [self.avatarView setRoundedCornersSize:46.0f];
}

@end
