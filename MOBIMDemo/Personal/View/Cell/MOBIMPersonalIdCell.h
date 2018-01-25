//
//  MOBIMPersonalIdCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOBIMGConst.h"

@interface MOBIMPersonalIdCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *desLabel;
@property (nonatomic, weak) IBOutlet UILabel *lineLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;


@property (nonatomic, copy) MOBIMLongPressCompletionBlock longPressCompletionBlock;

@end
