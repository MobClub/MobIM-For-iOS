//
//  MOBIMBaseEditNameCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseEditNameCell.h"

@implementation MOBIMBaseEditNameCell

- (instancetype)init
{
    MOBIMBaseEditNameCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MOBIMBaseEditNameCell" owner:self options:nil] lastObject];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
