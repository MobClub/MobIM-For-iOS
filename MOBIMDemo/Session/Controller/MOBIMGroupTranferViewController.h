//
//  MOBIMGroupTranferViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewController.h"

@interface MOBIMGroupTranferViewController : MOBIMBaseViewController

@property (nonatomic, strong) MIMGroup *groupInfo;
@property (nonatomic, weak) IBOutlet UITableView *tableView;


@end
