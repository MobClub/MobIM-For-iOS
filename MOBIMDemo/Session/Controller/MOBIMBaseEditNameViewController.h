//
//  MOBIMBaseEditNameViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewController.h"
#import "MOBIMBaseEditNameCell.h"

typedef void(^MOBIMBaseEditNameViewControllerFinishBlock)(NSString *name);

@interface MOBIMBaseEditNameViewController : MOBIMBaseViewController


@property (nonatomic, strong) MOBIMBaseEditNameCell *editDesCell;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *editDes;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *dateDes;

@property (nonatomic, assign) BOOL canEdit;


@property (nonatomic, copy) MOBIMBaseEditNameViewControllerFinishBlock nameViewControllerFinishBlock;


- (void)setEditText:(NSString *)text;

//名称输入限长度
- (int)nameLimitLength;

////输入的文字不能为空
//- (NSString *)emptyInputText;

- (void)finishedClicked:(UIButton*)button;

@end

