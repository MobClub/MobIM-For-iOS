//
//  MOBIMBaseAvatarCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/29.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOBIMAvatarButton.h"

@interface MOBIMBaseButtonAvatarCell : UITableViewCell


@property (nonatomic, weak) IBOutlet MOBIMAvatarButton *avatarButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *lineLabel;

@end
