//
//  MOBIMSessionCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOBIMSessionModel.h"

@class MOBIMBadgeView;
@interface MOBIMSessionCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *avatarView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *desLabel;
@property (nonatomic, strong) MOBIMBadgeView *unreadLabel;

//@property (nonatomic, strong) UIButton *deleteButton;
//@property (nonatomic, strong) UIButton *markButton;

- (void)setDataModel:(MIMConversation*)sessionModel;

@end
