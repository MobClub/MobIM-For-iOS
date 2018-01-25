//
//  MOBIMContactsSearchResultViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewController.h"
#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

//联系人搜索管理
@interface MOBIMContactsSearchResultViewController : UITableViewController


//搜索文字
@property (nonatomic, strong) NSString *searchText;

//联系人dictionary
@property (nonatomic, strong) NSDictionary *friendsDict;

@property (nonatomic, weak) UIViewController *rootViewConroller;


@end
