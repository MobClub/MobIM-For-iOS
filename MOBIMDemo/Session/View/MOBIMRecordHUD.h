//
//  MOBIMRecordHUD.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOBIMRecordHUD;
typedef void (^MOBIMRecordHUDOverMaxTimeBlock)(MOBIMRecordHUD *recordHUD);


@interface MOBIMRecordHUD : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, copy) MOBIMRecordHUDOverMaxTimeBlock maxTimeBlock;

- (void) voiceRecordSoShort;
- (void) voiceWillDragout:(BOOL)inside;
- (void) voiceDidCancelRecording;
- (void) voiceDidStartRecording;
- (void) voiceDidSend;

@end
