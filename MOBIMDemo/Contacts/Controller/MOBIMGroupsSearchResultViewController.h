//
//  MOBIMGroupsSearchResultViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/29.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewController.h"
#import <UIKit/UIKit.h>

@interface MOBIMGroupsSearchResultViewController : UITableViewController

//搜索文字
@property (nonatomic, copy) NSString *searchText;

//我的群组dictonary
@property (nonatomic, strong) NSMutableDictionary *joinedGroupsDict;


@end
