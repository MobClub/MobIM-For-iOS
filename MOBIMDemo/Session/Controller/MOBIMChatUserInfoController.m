//
//  MOBIMChatUserInfoController.m
//  MOBIMDemo
//
//  Created by hower on 2017/10/14.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatUserInfoController.h"
#import "MOBIMBaseAvatarCell.h"
#import "MOBIMBaseSwitchCell.h"

#import "UIViewController+MOBIMToast.h"

@interface MOBIMChatUserInfoController ()
@property (nonatomic, strong) MOBIMBaseAvatarCell  *avatarCell;
@property (nonatomic, strong) MOBIMBaseSwitchCell  *disturbCell;

@end

@implementation MOBIMChatUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

