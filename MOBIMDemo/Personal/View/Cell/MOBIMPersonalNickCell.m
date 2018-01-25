//
//  MOBIMMyNickCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMPersonalNickCell.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMGConst.h"


@implementation MOBIMPersonalNickCell


- (instancetype)init
{
    MOBIMPersonalNickCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MOBIMPersonalNickCell" owner:self options:nil] lastObject];
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
    
    self.lineLabel.backgroundColor = KMOBIMCommonLineColor;
    self.nickNameLabel.textColor = KMOBIMDesColor;
}

@end
