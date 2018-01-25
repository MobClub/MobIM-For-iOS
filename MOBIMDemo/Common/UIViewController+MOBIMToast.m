//
//  UIViewController+MOBIMToast.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/18.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "UIViewController+MOBIMToast.h"
#import "MBProgressHUD.h"
#import "MOBIMGConst.h"

@implementation UIViewController(MOBIMToast)


- (BOOL)isShowingToast {
    return [MBProgressHUD HUDForView:self.view];
}

- (void)showToastWithIndeterminateHUDMode
{
    [self hidePreviousHud];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self configHUD:hud];
}


- (void)showToastMessage:(NSString *)message
{
    [self showToastMessage:message completion:nil];
}

- (void)showToastMessage:(NSString *)message completion:(MOBIMToastCompletionBlock)completion
{
    [self hidePreviousHud];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
    if (completion) {
        hud.completionBlock = ^(){
            completion();
        };
    }
    [self configHUD:hud];
    [hud hideAnimated:YES afterDelay:MOBIMToastTimeInterval];
}

- (void)showToastWithStatus:(NSString *)status
{
    [self hidePreviousHud];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = status;
    [self configHUD:hud];
}

- (void)dismissToast
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        if (hud)
        {
            [hud hideAnimated:YES];
        }
    });
}

#pragma mark - private
- (void)hidePreviousHud
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (hud)
    {
        [hud hideAnimated:NO];
    }
}

- (void)configHUD:(MBProgressHUD *)hud
{
    hud.label.font = [UIFont systemFontOfSize:14.0];
    hud.removeFromSuperViewOnHide = YES;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.75];
    hud.margin = 15.0;
}


- (void)showToastSucessMessage:(NSString *)message
{
    [self hidePreviousHud];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.detailsLabel.text = message;
    [self configHUD:hud];
    hud.customView = [self createSucessView:message];
    
    [hud hideAnimated:YES afterDelay:MOBIMToastTimeInterval];
    
}

- (UIView *)createSucessView:(NSString*)message
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saveimagesucess"]];
    
    
    return imageView;
}

- (void)showAllTextDialog:(UIView *)view  Text:(NSString *)text{
    if (!view) {
        return;
    }
    if ([view isKindOfClass:[UITableView class]]) {
        view = view.superview;
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.margin = 12.f;
    HUD.detailsLabel.text = text;
    HUD.detailsLabel.font = [UIFont systemFontOfSize:14.0f];
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    //    HUD.yOffset = 150.0f;
    //    HUD.xOffset = 100.0f;
    
    [HUD hideAnimated:YES afterDelay:MOBIMToastTimeInterval];

}

@end
