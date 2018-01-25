//
//  MOBIMBaseEditNickNameViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseEditNickNameViewController.h"
#import "MOBIMGConst.h"
#import "UIViewController+MOBIMToast.h"

@interface MOBIMBaseEditNickNameViewController ()

@end

@implementation MOBIMBaseEditNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.title = @"我在本群的昵称";
    self.title = _userGroupCard.groupNickname ? _userGroupCard.groupNickname : @"我在本群的昵称";
    self.editDesCell.desTextField.placeholder = @"输入我在本群昵称，不得超过10个字";
    self.editDesCell.tipLabel.text = @"我在本群昵称不得超过10个字";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishedClicked:(UIButton*)button
{
    [super finishedClicked:button];
    
    
    MOBIMWEAKSELF
    [[MobIM getGroupManager] updateGroupNickname:self.editDesCell.desTextField.text inGroup:_groupInfo.groupId resultHandler:^(MIMVCard *card, MIMError *error) {
        
        [self performMainBlock:^{
            
            if (error) {
                [self showToastMessage:error.errorDescription];

                return ;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMGroupUserNicknameModifiedSucessNtf object:card];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];

        
    }];
    
    
    /*
    [[MOBIMGroupManager sharedManager] userModifyNicknameInGroup:self.editDesCell.desTextField.text groupId:_groupInfo.groupId completion:^(NSString *groupId, NSString *nickName, NSError *error) {
        
        _userGroupCard.nickname = weakSelf.editDesCell.desTextField.text;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [[NSNotificationCenter defaultCenter] postNotificationName:KMOBIMGroupUserNicknameModifiedSucessNtf object:_userGroupCard];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
     */

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
