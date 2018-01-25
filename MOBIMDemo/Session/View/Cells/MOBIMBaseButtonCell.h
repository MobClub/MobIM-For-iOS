//
//  MOBIMBaseButtonCell.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseMessageCell.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

typedef void(^MOBIMButtonClickCompletionBlock)();

#pragma clang diagnostic pop


@interface MOBIMBaseButtonCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, copy) MOBIMButtonClickCompletionBlock buttonClickCompletion;

@end
