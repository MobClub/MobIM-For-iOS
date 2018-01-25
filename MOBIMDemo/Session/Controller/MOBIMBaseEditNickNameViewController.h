//
//  MOBIMBaseEditNickNameViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseEditNameViewController.h"
#import "MOBIMVCard.h"

@interface MOBIMBaseEditNickNameViewController : MOBIMBaseEditNameViewController
@property (nonatomic, strong) MIMGroup *groupInfo;

//用户在群中的名片信息
@property (nonatomic, strong) MIMVCard *userGroupCard;


@end
