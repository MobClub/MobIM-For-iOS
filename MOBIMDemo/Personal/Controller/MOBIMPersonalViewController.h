//
//  MOBIMPersonalViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOBIMBaseViewController.h"


@interface MOBIMPersonalViewController : MOBIMBaseViewController
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UITextView *textView;
@end
