//
//  MOBIMDocumentViewController.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseChatMessageCell.h"
#import "MOBIMBaseViewController.h"

@protocol MOBIMDocumentViewControllerDelegate <NSObject>

- (void)selectedFileName:(NSString *)fileName;

@end

@interface MOBIMDocumentViewController : MOBIMBaseViewController

@property (nonatomic, weak) id <MOBIMDocumentViewControllerDelegate>delegate;


@end
