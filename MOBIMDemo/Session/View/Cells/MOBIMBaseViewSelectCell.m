//
//  MOBIMBaseViewSelectCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewSelectCell.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMGConst.h"

@implementation MOBIMBaseViewSelectCell

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
    [self.headImageVIew setRoundedCornersSize:46];
    
    self.bottomLineLabel.backgroundColor = KMOBIMCommonLineColor;
    
}



@end
