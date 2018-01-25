//
//  MOBIMBaseViewSelectCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MOBIMBaseViewSelectCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *selectedButton;
@property (nonatomic, weak) IBOutlet UIImageView *headImageVIew;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *bottomLineLabel;


@end
