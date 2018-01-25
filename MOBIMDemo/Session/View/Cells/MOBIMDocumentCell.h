//
//  MOBIMDocumentCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOBIMBaseMessageCell.h"

@protocol MOBIMDocumentCellDelegate <NSObject>

- (void)selectBtnClicked:(id)sender;

@end


@class MOBIMFileModel;
@interface MOBIMDocumentCell : MOBIMBaseMessageCell


@property (nonatomic, weak) id<MOBIMDocumentCellDelegate> delegate;

@property (nonatomic, strong) MOBIMFileModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) UIButton *selectBtn;


@end
