//
//  MOBIMTipsViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/30.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatRoomViewController.h"

@interface MOBIMTipsDetailViewController : MOBIMChatRoomViewController

@property (nonatomic, strong) MIMUser *tipsModel;
@property (nonatomic, strong) NSString *tipsId;

@end
