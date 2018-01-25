//
//  MOBIMBaseEditDesCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOBIMBaseEditDesCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *tipLabel;
@property (nonatomic, weak) IBOutlet UITextView *desTextView;
@property (nonatomic, weak) IBOutlet UILabel *placeholderLabel;


@end
