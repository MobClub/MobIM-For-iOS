//
//  MOBIMGroupEditNoticeViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMGroupEditNoticeViewController.h"
#import "MOBIMGConst.h"
#import "UIViewController+MOBIMToast.h"

@interface MOBIMGroupEditNoticeViewController ()

@end

@implementation MOBIMGroupEditNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公告";
    self.editDesCell.tipLabel.text = @"群公告不得超过140个字";

}

- (NSString *)placeholderText
{
    return @"输入公告，不得超过140个字";
}

- (void)sendEditText:(NSString *)text
{
    
}

- (void)finishedClicked:(UIButton*)button
{
    [super finishedClicked:button];
    
    MOBIMWEAKSELF
    [[MobIM getGroupManager] updateGroupNotice:self.editDesCell.desTextView.text withGroupId:_groupInfo.groupId resultHandler:^(MIMGroup *group, MIMError *error) {
        
    
        [self performMainBlock:^{
            
            if (error) {
                [weakSelf showToastMessage:error.errorDescription];
                return ;
            }
            
            weakSelf.groupInfo = group;

            [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMGroupDeleteMemebersSucessNtf object:_groupInfo];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
    /*
    [[MOBIMGroupManager sharedManager] modifyGroupNotice:self.editDesCell.desTextView.text groupId:_groupInfo.groupId completion:^(NSString *groupId, NSString *notice, NSError *error) {
        
        _groupInfo.notice = weakSelf.editDesCell.desTextView.text;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMGroupDeleteMemebersSucessNtf object:_groupInfo];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
     */

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
