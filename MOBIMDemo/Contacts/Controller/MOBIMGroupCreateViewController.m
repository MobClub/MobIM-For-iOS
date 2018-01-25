//
//  MOBIMGroupCreateViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/29.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMGroupCreateViewController.h"
#import "MOBIMBaseTextFiledCell.h"
#import "MOBIMBaseButtonCell.h"
#import "MOBIMGroupCreateAddMemebersController.h"
#import "UIViewController+MOBIMToast.h"
#import "MOBIMBaseSectionCell.h"

@interface MOBIMGroupCreateViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) NSArray *cellArray;

@property (nonatomic, strong) MOBIMBaseButtonCell *inviteCell;
@property (nonatomic, strong) MOBIMBaseTextFiledCell *nameCell;
@property (nonatomic, strong) MOBIMBaseTextFiledCell *introductionCell;
@property (nonatomic, strong) MOBIMBaseSectionCell *section1Cell;
@property (nonatomic, strong) MOBIMBaseSectionCell *section2Cell;

@end

@implementation MOBIMGroupCreateViewController


- (MOBIMBaseSectionCell*)section1Cell
{
    if (!_section1Cell)
    {
        _section1Cell = [[MOBIMBaseSectionCell alloc] init];
    }
    return _section1Cell;
}

- (MOBIMBaseSectionCell*)section2Cell
{
    if (!_section2Cell)
    {
        _section2Cell = [[MOBIMBaseSectionCell alloc] init];
    }
    return _section2Cell;
}

- (MOBIMBaseButtonCell*)inviteCell
{
    if (!_inviteCell)
    {
        _inviteCell = [[MOBIMBaseButtonCell alloc] init];
    }
    return _inviteCell;
}



- (MOBIMBaseTextFiledCell*)nameCell
{
    if (!_nameCell)
    {
        _nameCell = [[MOBIMBaseTextFiledCell alloc] init];
    }
    return _nameCell;
}


- (MOBIMBaseTextFiledCell*)introductionCell
{
    if (!_introductionCell)
    {
        _introductionCell = [[MOBIMBaseTextFiledCell alloc] init];
    }
    return _introductionCell;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadData];
    [self loadUI];
}

- (void)loadData
{
    self.cellArray = @[self.section1Cell,self.nameCell,self.introductionCell,self.section2Cell,self.inviteCell];
}

- (void)loadUI
{
    self.title = @"新建群组";
    self.nameCell.nameLabel.text = @"名称";
    self.introductionCell.nameLabel.text = @"简介";
    self.nameCell.textField.placeholder = @"输入本群昵称，不得超过10个字";
    self.introductionCell.textField.placeholder = @"输入本群简介，不得超过140个字";
    [self.inviteCell.button setTitle:@"邀请好友" forState:UIControlStateNormal];
    [self.inviteCell.button addTarget:self action:@selector(inviteClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nameCell.lineLabel.hidden = NO;
    
    [self.nameCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.introductionCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}



- (void)inviteClicked:(UIButton*)button
{
//    if (self.nameCell.textField.text.length <=0) {
//        [self showToastMessage:@"请输入群名"];
//        return;
//    }
    
    
    
    MOBIMGroupCreateAddMemebersController *vc = [[MOBIMGroupCreateAddMemebersController alloc] init];
    vc.groupName = self.nameCell.textField.text;
    vc.introduction = self.introductionCell.textField.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.cellArray[indexPath.row];
    if (self.section1Cell == cell || self.section2Cell == cell)
    {
        return 10;
    }
    else if (self.inviteCell == cell)
    {
        return 70;
    }
    return 50;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.cellArray[indexPath.row];

}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nameCell.textField)
    {
        if (textField.text.length > 10)
        {
            textField.text = [textField.text substringToIndex:10];
        }
    }
    else  if (textField == self.introductionCell.textField)
    {
        if (textField.text.length > 140)
        {
            textField.text = [textField.text substringToIndex:140];
        }
    }
}

@end
