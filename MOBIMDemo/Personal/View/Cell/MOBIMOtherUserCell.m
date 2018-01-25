//
//  MOBIMOtherUserCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMOtherUserCell.h"
#import "MOBIMGConst.h"
#import "UIView+MOBIMExtention.h"

@implementation MOBIMOtherUserCell

- (instancetype)init
{
    MOBIMOtherUserCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MOBIMOtherUserCell" owner:self options:nil] lastObject];
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
    
    self.userIdLabel.textColor = KMOBIMDesColor;
    [self.avatarImageView setRoundedCornersSize:46.0];
}

@end
