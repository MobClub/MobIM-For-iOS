//
//  MOBIMBaseTitleStyleCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOBIMBaseMessageCell.h"
#import "MOBIMGConst.h"


@interface MOBIMBaseTitleStyleCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *desLabel;
@property (nonatomic, weak) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, weak) IBOutlet UILabel *lineLabel;

@property (nonatomic, assign) BOOL showArrow;


@property (nonatomic, copy) MOBIMLongPressCompletionBlock longPressCompletionBlock;



@end
