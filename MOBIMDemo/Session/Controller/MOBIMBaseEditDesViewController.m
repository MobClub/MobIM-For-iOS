//
//  MOBIMBaseEditDesViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseEditDesViewController.h"
#import "MOBIMBaseEditDesCell.h"
#import "Masonry.h"
#import "MOBIMGConst.h"




@interface MOBIMBaseEditDesViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>


@property (nonatomic, assign) BOOL isEditStatus;

@end

@implementation MOBIMBaseEditDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadUI];
    [self loadData];

}

- (MOBIMBaseEditDesCell *)editDesCell
{
    if (!_editDesCell) {
        _editDesCell = [[MOBIMBaseEditDesCell alloc] init];
        _editDesCell.backgroundColor = MOBIMRGB(0xEFEFF3);
        _editDesCell.desTextView.delegate = self;

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
    self.editDesCell.desTextView.text =  self.editDes;
    self.editDesCell.dateLabel.text = self.dateDes;
}

- (void)loadUI
{
    [self.view addSubview:self.tableView];

    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.leading.mas_offset(0);
    }];
    

    if (self.canEdit == YES) {
        
        [self setupNavButton:MOBIMTopButtonStatusRightEditor];

    }
    
    self.editDesCell.desTextView.delegate = self;
    self.editDesCell.desTextView.userInteractionEnabled = NO;

}


- (void)editClicked:(UIButton*)button
{
    self.isEditStatus = YES;
    self.editDesCell.dateLabel.hidden = YES;
    self.editDesCell.tipLabel.hidden = NO;
    [self setupNavButton:MOBIMTopButtonStatusLeftCancel];
    [self setupNavButton:MOBIMTopButtonStatusRightDone];
    
    self.editDesCell.desTextView.userInteractionEnabled = YES;

    [self.editDesCell.desTextView becomeFirstResponder];

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
    self.editDesCell.desTextView.userInteractionEnabled = NO;
    self.editDesCell.dateLabel.hidden = NO;
    self.editDesCell.tipLabel.hidden = YES;
    self.editDesCell.desTextView.text = self.editDes;

    [self.editDesCell.desTextView resignFirstResponder];
    self.editDesCell.placeholderLabel.hidden = self.editDesCell.desTextView.text.length > 0;

}

- (void)finishedClicked:(UIButton*)button
{
    
    [self setupNavButton:MOBIMTopButtonStatusRightEditor];
    
    [self setupNavBack];
    //网络处理
    self.isEditStatus = YES;
    self.editDesCell.desTextView.userInteractionEnabled = NO;
    [self.editDesCell.desTextView resignFirstResponder];
    self.editDesCell.dateLabel.hidden = NO;
    self.editDesCell.tipLabel.hidden = YES;

    self.editDesCell.dateLabel.text = [[NSDate date] description];
    
    self.editDesCell.placeholderLabel.hidden = self.editDesCell.desTextView.text.length > 0;
}

- (void)sendEditText:(NSString *)text
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
    return 170;
}


- (int)desLimitLength
{
    return 140;
}

- (NSString *)placeholderText
{
    return @"请输入消息...";
}

- (void)textViewDidChange:(UITextView *)textView{

    if (textView == self.editDesCell.desTextView) {
        
        self.editDesCell.placeholderLabel.text =  textView.text.length == 0 ? self.placeholderText : @"";
        self.editDesCell.placeholderLabel.hidden = textView.text.length > 0;

        if (textView.text.length > self.desLimitLength) { // 限制140字内
            textView.text = [textView.text substringToIndex:self.desLimitLength];
        }
    }
    
}

@end
