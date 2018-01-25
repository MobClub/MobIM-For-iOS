//
//  MOBIMShortVideoViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/30.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^TakeOperationSureBlock)(id item);

@interface MOBIMShortVideoViewController : UIViewController


@property (copy, nonatomic) TakeOperationSureBlock takeBlock;

@property (assign, nonatomic) NSInteger maxSeconds;
@end

