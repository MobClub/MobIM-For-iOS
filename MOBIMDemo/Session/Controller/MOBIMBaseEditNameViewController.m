//
//  MOBIMBaseEditNameViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseEditNameViewController.h"
#import "UIColor+MOBIMExtentions.h"
#import "MOBIMBaseEditNameCell.h"
#import "MOBIMUserManager.h"

@interface MOBIMBaseEditNameViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@property (nonatomic, assign) BOOL isEditStatus;
@end

@implementation MOBIMBaseEditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadUI];
    [self loadData];
    
}

- (MOBIMBaseEditNameCell *)editDesCell
{
    if (!_editDesCell) {
        _editDesCell = [[MOBIMBaseEditNameCell alloc] init];
        _editDesCell.backgroundColor = MOBIMRGB(0xEFEFF3);
        _editDesCell.desTextField.delegate = self;
    }
    
    return _editDesCell;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        //        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
        _tableView.backgroundColor = MOBIMRGB(0xEFEFF3);
        
    }
    return _tableView;
}


- (void)loadData
{
    self.isEditStatus = NO;
    self.editDesCell.desTextField.text =  self.editDes;
    //    self.editDesCell.desTextField.text = self.dateDes;
}

- (void)loadUI
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.leading.mas_offset(0);
    }];
    
    [self.editDesCell.desTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    self.editDesCell.desTextField.userInteractionEnabled = NO;
    if (self.canEdit == YES) {
        
        [self setupNavButton:MOBIMTopButtonStatusRightEditor];

    }
    
}




- (void)editClicked:(UIButton*)button
{
    self.isEditStatus = YES;
    self.editDesCell.tipLabel.hidden = NO;
    [self setupNavButton:MOBIMTopButtonStatusLeftCancel];
    [self setupNavButton:MOBIMTopButtonStatusRightDone];
    
    self.editDesCell.desTextField.userInteractionEnabled = YES;
    [self.editDesCell.desTextField becomeFirstResponder];

}


- (void)setupNavButton:(MOBIMTopButtonStatus)status
{
    switch (status) {
        case MOBIMTopButtonStatusRightEditor:
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:@"编辑" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, KMOBIMNavRightOffset);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
            break;
        case MOBIMTopButtonStatusRightDone:
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            [button setTitleColor:KMOBIMCommonButtonColor forState:UIControlStateNormal];
            [button setTitle:@"完成" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(finishedClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, KMOBIMNavRightOffset);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
            break;
        case MOBIMTopButtonStatusLeftCancel:
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:@"取消" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.contentEdgeInsets = UIEdgeInsetsMake(0, KMOBIMNavLeftTitleOffset, 0, 0);
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
            break;
        default:
            break;
    }
}

- (void)cancelClicked:(UIButton*)button
{
    
    [self setupNavButton:MOBIMTopButtonStatusRightEditor];
    
    [self setupNavBack];
    
    self.isEditStatus = YES;
    self.editDesCell.desTextField.userInteractionEnabled = NO;
    self.editDesCell.tipLabel.hidden = YES;
    self.editDesCell.desTextField.text = self.editDes;
    
    [self.editDesCell.desTextField resignFirstResponder];
}

- (void)finishedClicked:(UIButton*)button
{

    [self setupNavButton:MOBIMTopButtonStatusRightEditor];
    
    [self setupNavBack];
    
    //网络处理
    self.isEditStatus = YES;
    self.editDesCell.desTextField.userInteractionEnabled = NO;
    [self.editDesCell.desTextField resignFirstResponder];
    self.editDesCell.tipLabel.hidden = YES;
    
    //保存数据
//    [MOBIMUserManager sharedManager].currentUser.nickname = info.avatar;
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
}

- (void)setEditText:(NSString *)text
{
    
}

#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editDesCell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (int)nameLimitLength
{
    return 10;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.editDesCell.desTextField)
    {
        if (textField.text.length > self.nameLimitLength) {
            textField.text = [textField.text substringToIndex:self.nameLimitLength];
        }
    }
}

@end

