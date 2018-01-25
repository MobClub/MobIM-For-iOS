//
//  MOBIMEmoticonsView.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^emoticonsViewWithButtonPressedBlock)(UIImage * image, NSString * imageName);


@interface MOBIMEmoticonsView : UIView

/**
 *  设置block回调
 *
 *  @param buttonPressedBlock 返回代码块
 */
- (void)emoticonsViewWithButtonPressedBlockHandle:(emoticonsViewWithButtonPressedBlock)buttonPressedBlock;

@end
