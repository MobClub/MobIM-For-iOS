//
//  MOBIMEditUserNickNameViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseEditNameViewController.h"


typedef void (^MOBIMNickNameModifiedSucessBlock)(NSString *nickName);

@interface MOBIMEditUserNickNameViewController : MOBIMBaseEditNameViewController

@property (nonatomic, copy) MOBIMNickNameModifiedSucessBlock modifiedSucessBlock;
@end
