//
//  MOBIMMyAvatarCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMPersonalAvatarCell.h"
#import "MOBIMGConst.h"
#import "UIView+MOBIMExtention.h"


@implementation MOBIMPersonalAvatarCell


- (instancetype)init
{
    MOBIMPersonalAvatarCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MOBIMPersonalAvatarCell" owner:self options:nil] lastObject];
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
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
    [self.avatarImageView setRoundedCornersSize:46];
    

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
