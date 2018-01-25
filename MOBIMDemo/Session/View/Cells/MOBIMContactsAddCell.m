//
//  MOBIMContactsAddCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMContactsAddCell.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMGConst.h"
#import "UIImageView+WebCache.h"

@implementation MOBIMContactsAddCell

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
    [self.avatarView setRoundedCornersSize:46];
    
    self.lineLabel.backgroundColor = KMOBIMCommonLineColor;
    self.hasAddLabel.textColor = KMOBIMDesColor;
    self.hasAddLabel.hidden = YES;
    
}

- (void)setDataModel:(MOBIMUserModel*)userModel
{
    //_avatarView.image=[UIImage imageNamed:userModel.avatar];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:userModel.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
    _nameLabel.text=userModel.nickname;
}

@end

