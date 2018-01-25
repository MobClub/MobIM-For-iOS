//
//  MOBIMAvatarSelectViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/29.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewController.h"

typedef void (^MOBIMAvatarSelectItemSelectedBlock)(NSString *avatarPath);


@interface MOBIMAvatarSelectViewController : MOBIMBaseViewController

@property (nonatomic, copy) MOBIMAvatarSelectItemSelectedBlock itemSeletectedBlock;
@end
