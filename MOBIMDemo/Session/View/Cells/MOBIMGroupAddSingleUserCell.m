//
//  MOBIMGroupAddSingleUserCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMGroupAddSingleUserCell.h"

@implementation MOBIMGroupAddSingleUserCell

- (instancetype)init
{
    MOBIMGroupAddSingleUserCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MOBIMGroupAddSingleUserCell" owner:self options:nil] lastObject];
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


- (void)loadUI
{
    
    [self.avatarView setRoundedCornersSize:46.0];
}


@end
