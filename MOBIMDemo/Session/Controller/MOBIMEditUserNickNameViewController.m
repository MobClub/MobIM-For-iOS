//
//  MOBIMEditUserNickNameViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMEditUserNickNameViewController.h"
#import "MOBIMUserManager.h"
#import "UIViewController+MOBIMToast.h"

@interface MOBIMEditUserNickNameViewController ()

@end

@implementation MOBIMEditUserNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadUI
{
    [super loadUI];
    self.title = @"修改昵称";
    self.editDesCell.desTextField.placeholder = @"请输入昵称";
    self.editDesCell.tipLabel.text = @"昵称不得超过10个字";
    self.canEdit = YES;
}


- (void)finishedClicked:(UIButton*)button
{
    if (self.editDesCell.desTextField.text.length < 1) {
        
        [self showToastMessage:@"请输入昵称"];
        
        return;
    }
    [super finishedClicked:button];
    
    MOBIMWEAKSELF
    [[MOBIMUserManager sharedManager] modifyCurrentUserNickname:self.editDesCell.desTextField.text completion:^(NSString *nickName,NSError *error) {
        
        [weakSelf performMainBlock:^{
            
            if (!error)
            {
                //保存数据
                [MOBIMUserManager sharedManager].currentUser.nickname = self.editDesCell.desTextField.text;
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                
                if (weakSelf.modifiedSucessBlock) {
                    weakSelf.modifiedSucessBlock(self.editDesCell.desTextField.text);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self showToastMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
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
