//
//  MOBIMPersonalBlackCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMPersonalBlackCell.h"

@implementation MOBIMPersonalBlackCell


- (instancetype)init
{
    MOBIMPersonalBlackCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MOBIMPersonalBlackCell" owner:self options:nil] lastObject];
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

@end
