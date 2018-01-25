//
//  MOBIMDocumentViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMDocumentViewController.h"
#import "UIColor+MOBIMExtentions.h"
#import "MOBIMGConst.h"
#import "MOBIMDocumentCell.h"
#import "MOBIMFileManager.h"
#import "Masonry.h"
#import "MOBIMIDocumentReaderController.h"
#import "MOBIMImageManager.h"
#import "MOBIMGConst.h"
#import "MOBIMFileManager.h"
#import "MOBIMFileModel.h"
#import "NSString+MOBIMExtension.h"
#import "MOBIMBaseSectionCell.h"
#import "UIViewController+MOBIMToast.h"

@interface MOBIMDocumentViewController ()<UITableViewDataSource,UITableViewDelegate,MOBIMDocumentViewControllerDelegate,MOBIMDocumentCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, weak) UIButton *rightBtn;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) MOBIMBaseSectionCell *section1Cell;

/**
 指令运作队列
 */
@property (nonatomic) dispatch_queue_t commandQueue;

@end

@implementation MOBIMDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commandQueue = dispatch_queue_create("MOBIMDocumentViewController", DISPATCH_QUEUE_SERIAL);

    [self setupNav];
    
    [self setupSubviews];
    
    [self loadData];
    
}

- (MOBIMBaseSectionCell *)section1Cell
{
    if (!_section1Cell) {
        _section1Cell = [[MOBIMBaseSectionCell alloc] init];
        //        _section2Cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
        
    }
    return _section1Cell;
}

#pragma mark - NAV

- (void)setupNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择文件";
    
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightButton setTitleColor:KMOBIMCommonButtonColor forState:UIControlStateNormal];

    [rightButton addTarget:self action:@selector(rightBarButtonClicked)forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.rightBtn = rightButton;
    
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
//    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(leftBarButtonClicked)forControlEvents:UIControlEventTouchUpInside];
//    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    // 左上角的返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.size = CGSizeMake(50, 50);
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    // 让按钮内部的所有内容左对齐
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton addTarget:self action:@selector(leftBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, KMOBIMNavOffset, 0, 0); // 这里微调返回键的位置可以让它看上去和左边紧贴
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

#pragma mark - Event

- (void)rightBarButtonClicked
{
    if (!self.name) return;
    
    CGFloat size = [MOBIMFileManager fileSizeWithPath:self.filePath];
    if (size >= KMOBIMMaxFileLength) {
        [self showAlertWithText:@"所选文件已超出最大文件限制无法进行发送，请重新进行选择"];
        
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(selectedFileName:)]) {
        [self.delegate selectedFileName:self.filePath];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)leftBarButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData
{
    
    dispatch_async(self.commandQueue, ^{

        NSString *mainFilePath = [MOBIMFileManager fileMainPath];
        NSDirectoryEnumerator * enumer = [[NSFileManager defaultManager] enumeratorAtPath:[MOBIMFileManager fileMainPath]];
        NSString *name;
        while (name = [enumer nextObject]) {
            if ([name isEqualToString:@".DS_Store"]) continue;
            if (![[name pathExtension] isEqualToString:@"DS_Store"]&&[name length]>0) {
                
                NSString *filePath = [mainFilePath stringByAppendingPathComponent:name];
                NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
                id firstData = [fileInfo objectForKey:NSFileModificationDate];
                NSString *dateStr = [NSString stringWithFormat:@"%@",firstData];
                if (dateStr && dateStr.length >= 19) {
                    
                    dateStr = [dateStr substringToIndex:18];
                }
                
                MOBIMFileModel *model = [MOBIMFileModel new];
                model.name = name;
                model.filePath = filePath;
                model.date = dateStr;
                
                [self.dataArr addObject:model];
                
            }
        }
        
    });
    
}


#pragma mark - UI

- (void)setupSubviews
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MOIMDevice_Width, MOIMDevice_Height-64) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate   = self;
    [self.view addSubview:tableView];
    tableView.backgroundColor = MOBIMRGB(0xEFEFF3);

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = self.section1Cell;

    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.leading.bottom.mas_equalTo(0);
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOBIMDocumentCell *cell = [MOBIMDocumentCell cellWithTableView:tableView];
    cell.delegate = self;
    MOBIMFileModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    
    if (([self.dataArr count]-1) == indexPath.row)
    {
        cell.bottomLineStyle = MOBIMBaseMessageCellLineStyleNone;
    }
    else
    {
        cell.bottomLineStyle = MOBIMBaseMessageCellLineStyleDefault;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MOBIMFileModel *model = self.dataArr[indexPath.row];
    
    MOBIMIDocumentReaderController *readController = [[MOBIMIDocumentReaderController alloc] init];
    readController.filePath              = model.filePath;
    readController.orgName               = model.name;
    [self.navigationController pushViewController:readController animated:YES];
    
}

#pragma mark - MOBIMDocumentCellDelegate

- (void)selectBtnClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    MOBIMDocumentCell *cell = (MOBIMDocumentCell *)[[button superview] superview];
    NSIndexPath *curIndexPath = [self.tableView indexPathForCell:cell];
    
    for (int row = 0; row < self.dataArr.count; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        if (curIndexPath != indexPath) {
            MOBIMDocumentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.selectBtn.selected = NO;
        }
    }
    
    MOBIMFileModel *model = self.dataArr[curIndexPath.row];

    
    self.name = model.name;
    self.filePath = model.filePath;
    button.selected = !button.selected;
    if (button.selected) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.rightBtn setTitleColor:MOBIMRGB(0x018eb0) forState:UIControlStateNormal];

    }else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark - Getter

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
