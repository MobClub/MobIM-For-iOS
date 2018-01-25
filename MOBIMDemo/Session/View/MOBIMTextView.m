//
//  MOBIMTextView.m
//  MOBIMDemo
//
//  Created by hower on 14/12/2017.
//  Copyright © 2017 hower. All rights reserved.
//

#import "MOBIMTextView.h"
#import <UIKit/UIResponder.h>

@implementation MOBIMTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




- (BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    
    if (self.isCellLongPress == YES)
    {
        return NO;
    }

    if (self.text.length < 1)
    {
        if (action ==@selector(paste:))
        {
            return YES;
        }
        return NO;
    }
    
    if (self.text.length > 0)
    {
        
        if (self.selectedRange.length > 0)
        {
            if (action == @selector(cut:) || action == @selector(copy:) || action == @selector(paste:))
            {
                return YES;
            }
        }
        else
        {

            if (action == @selector(select:) || action == @selector(selectAll:) || action == @selector(paste:))
            {
                return YES;
            }
        }

    }
    
    return NO;
    
//    if (action ==@selector(copy:) ||
//
//       action ==@selector(selectAll:)||
//
//       action ==@selector(cut:)||
//
//       action ==@selector(select:)||
//
//       action ==@selector(paste:)) {
//
//        if (self.selectedRange.length > 0) {
//            return YES;
//        }
//
//        return [super canPerformAction:action withSender:sender];
//
//    }
//
//    return NO;
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
