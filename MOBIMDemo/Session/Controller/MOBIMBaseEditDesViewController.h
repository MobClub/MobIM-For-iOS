//
//  MOBIMBaseEditDesViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewController.h"
#import "MOBIMBaseEditDesCell.h"

@interface MOBIMBaseEditDesViewController : MOBIMBaseViewController

@property (nonatomic, strong) MOBIMBaseEditDesCell *editDesCell;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *editDes;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *dateDes;


@property (nonatomic, assign) BOOL canEdit;

- (void)sendEditText:(NSString *)text;

- (void)finishedClicked:(UIButton*)button;

- (int)desLimitLength;

- (NSString *)placeholderText;
@end

