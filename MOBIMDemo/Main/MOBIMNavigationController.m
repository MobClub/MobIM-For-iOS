//
//  MOBIMSuperViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMNavigationController.h"

@interface MOBIMNavigationController ()


@end

@implementation MOBIMNavigationController

/*
UIImage *origImage = [UIImage imageNamed:@"fanhui_black"];

//系统返回按钮处的title偏移到可视范围之外
//iOS11 和 iOS11以下分别处理
UIOffset offset = currentSystemVersion.floatValue >= 11.0 ? UIOffsetMake(-200, 0) : UIOffsetMake(0, -80);

[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsCompact];

[[UINavigationBar appearance] setBackIndicatorImage:origImage];
[[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:origImage];
*/



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed=YES;
    }
    [super pushViewController:viewController animated:YES];
    
}





#pragma mark - Action
//- (void)backButtonAction:(UIBarButtonItem *)sender {
//    if ([self.topViewController respondsToSelector:@selector(backButtonAction:)]) {
//        [self.topViewController performSelector:@selector(backButtonAction:) withObject:sender];
//    }
//}
//
//#pragma mark - Getters
//- (UIBarButtonItem *)backBarButtonItem {
//    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction:)];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setBackgroundColor:[UIColor greenColor]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
