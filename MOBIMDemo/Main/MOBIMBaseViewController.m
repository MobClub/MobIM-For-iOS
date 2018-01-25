//
//  MOBIMBaseViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseViewController.h"
#import "MOBIMGConst.h"
#import "MOBIMGConfigManager.h"

@interface MOBIMBaseViewController ()

@property (nonatomic, strong) UILabel *customTitleLabel;
@end

@implementation MOBIMBaseViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}


- (void)loadData
{

}


- (void)loadUI
{

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    if ([self.navigationController.viewControllers count] > 1)
    {
        [self.navigationController.navigationBar setBackgroundImage:[[MOBIMGConfigManager sharedManager] whiteImage] forBarMetrics:UIBarMetricsDefault];

    }
    else
    {

        [self.navigationController.navigationBar setBackgroundImage:[[MOBIMGConfigManager sharedManager] blueImage] forBarMetrics:UIBarMetricsDefault];

    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = MOBIMRGB(0xEFEFF3);
    
    //返回按钮设置
    if ([self.navigationController.childViewControllers count]>1) {
        
        [self setupNavBack];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[MOBIMGConfigManager sharedManager] setCurViewController:self];
}

- (void)setupNavBack
{
    // 左上角的返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.backgroundColor = [UIColor redColor];
    backButton.size = CGSizeMake(50, 50);
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    // 让按钮内部的所有内容左对齐
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton addTarget:self action:@selector(backCLick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, KMOBIMNavOffset, 0, 0); // 这里微调返回键的位置可以让它看上去和左边紧贴
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backCLick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showAlertWithText:(NSString*)text
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (float)currentStatusBarHeight
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

- (float)currentNavBarHeight
{
    return self.navigationController.navigationBar.frame.size.height;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (float)safeBottomHeight
{
    return MOBIM_TabbarSafeBottomMargin;
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

- (void)performMainBlock:(void(^)())block
{
    dispatch_async(dispatch_get_main_queue(), block);
}
#pragma clang diagnostic pop

- (UILabel *)customTitleLabel
{
    if (!_customTitleLabel) {
        _customTitleLabel = [UILabel new];
        _customTitleLabel.textColor = [UIColor whiteColor];
        _customTitleLabel.backgroundColor = [UIColor clearColor];
        _customTitleLabel.font = [UIFont systemFontOfSize:17.0f];
        
    }

    return _customTitleLabel;
}

- (void)setCustomTitle:(NSString*)title
{
    self.customTitleLabel.text = title;
    [self.customTitleLabel sizeToFit];
    self.navigationItem.titleView = self.customTitleLabel;
    
}

- (BOOL)willBackToRootWithAlertTag:(NSInteger)tag
{
    return NO;
}
@end
