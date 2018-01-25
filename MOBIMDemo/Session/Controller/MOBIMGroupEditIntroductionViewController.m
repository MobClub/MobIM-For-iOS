//
//  MOBIMGroupEditIntroductionViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMGroupEditIntroductionViewController.h"
#import "MOBIMGConst.h"
#import "UIViewController+MOBIMToast.h"

@interface MOBIMGroupEditIntroductionViewController ()

@end

@implementation MOBIMGroupEditIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"简介";
    self.editDesCell.tipLabel.text = @"群简介不得超过140个字";
}

- (NSString *)placeholderText
{
    return @"输入群简介，不得超过140个字";
}


- (void)sendEditText:(NSString *)text
{
    
}

- (void)finishedClicked:(UIButton*)button
{
    [super finishedClicked:button];
    
    
    //网络请求
    MOBIMWEAKSELF
    [[MobIM getGroupManager] updateGroupDesc:self.editDesCell.desTextView.text withGroupId:_groupInfo.groupId resultHandler:^(MIMGroup *group, MIMError *error) {
        
        
        [weakSelf performMainBlock:^{
            if (error) {
                [weakSelf showToastMessage:error.errorDescription];
                return ;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMGroupIntroductionModifiedSucessNtf object:group];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];

        
    }];

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
