//
//  MOBIMBaseAvatarCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

typedef void(^MOBIMGroupPlusCompletionBlock)();
typedef void(^MOBIMGroupDeleteCompletionBlock)();
typedef void(^MOBIMGroupShowAllCompletionBlock)();

#pragma clang diagnostic pop

@interface MOBIMBaseAvatarCell : UITableViewCell

- (void)setDataModel:(MIMGroup*)groupModel isGroupOwer:(BOOL)isGroupOwer;

@property (nonatomic, copy) MOBIMGroupPlusCompletionBlock plusCompletion;
@property (nonatomic, copy) MOBIMGroupDeleteCompletionBlock deleteCompletion;
@property (nonatomic, copy) MOBIMGroupShowAllCompletionBlock showAllCompletion;

@property (nonatomic, assign) float calHeight;

@end
