//
//  MOBIMBaseEditGroupNameViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseEditGroupNameViewController.h"
#import "UIViewController+MOBIMToast.h"

@interface MOBIMBaseEditGroupNameViewController ()

@end

@implementation MOBIMBaseEditGroupNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = _groupInfo.groupName ? _groupInfo.groupName : @"群名";
    
    self.editDesCell.desTextField.placeholder = @"输入群名，不得超过10个字";
    self.editDesCell.tipLabel.text = @"群名不得超过10个字";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishedClicked:(UIButton*)button
{
    if (self.editDesCell.desTextField.text.length < 1) {
        
        [self showToastMessage:@"请输入群名称"];
        return;
    }
    
    MOBIMWEAKSELF
    [[MobIM getGroupManager] updateGroupName:self.editDesCell.desTextField.text withGroupId:_groupInfo.groupId resultHandler:^(MIMGroup *group, MIMError *error) {
        
        [weakSelf performMainBlock:^{
            
            [super finishedClicked:button];
            [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMGroupNameModifiedSucessNtf object:_groupInfo];
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }];
        
    }];

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

