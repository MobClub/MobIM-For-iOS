//
//  MOBIMFaceCollectionView.m
//  YHExpressionKeyBoard
//
//  Created by hower on 2017/10/16.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMFaceCollectionView.h"
#import "MOBIMMagnifierView.h"
#import "MOBIMEmotionCell.h"
#import "UIView+MOBIMExtention.h"

@interface MOBIMFaceCollectionView()

@property (nonatomic, strong) MOBIMMagnifierView *magnifier;
@property (nonatomic, strong) MOBIMEmotionCell *curMagnifierCell;

@property (nonatomic, strong) NSTimer *backspaceTimer;
@property (nonatomic, assign) BOOL touchMoved;

@end


@implementation MOBIMFaceCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = [UIView new];
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.clipsToBounds = NO;
    self.canCancelContentTouches = NO;
    self.multipleTouchEnabled = NO;
    
    _magnifier = [[MOBIMMagnifierView alloc] initWithImage:[UIImage imageNamed:@"emoticon_keyboard_magnifier"]];
    _magnifier.frame = CGRectMake(0, 0, 64, 91);
    _magnifier.hidden = YES;
    [self addSubview:_magnifier];
    return self;
}

- (void)dealloc {
    [self endBackspaceTimer];
}



- (MOBIMEmotionCell *)cellForTouches:(NSSet<UITouch *> *)touches {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    if (indexPath) {
        MOBIMEmotionCell *cell = (id)[self cellForItemAtIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)showMagnifierForCell:(MOBIMEmotionCell*)cell
{
    if (cell.isDelete || cell.noEmotionImage) {
        [self hideMagnifier];
        return;
    }
    CGRect rect = [cell convertRect:cell.bounds toView:self];
    _magnifier.size = CGSizeMake(64, 91);
    _magnifier.centerX = CGRectGetMidX(rect);
    _magnifier.bottom = CGRectGetMaxY(rect) - 9;
    _magnifier.hidden = NO;
    
    _magnifier.emotion = cell.emotion;
}

- (void)startBackspaceTimer {
    [self endBackspaceTimer];
    
    _backspaceTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(backSpaceTimer) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_backspaceTimer forMode:NSRunLoopCommonModes];

}

- (void)backSpaceTimer
{
    if (_curMagnifierCell.isDelete) {
        
        if (self.tapBlock) {
            [[UIDevice currentDevice] playInputClick];
            self.tapBlock(_curMagnifierCell);
        }
    }
}

- (void)endBackspaceTimer {

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startBackspaceTimer) object:nil];
    [_backspaceTimer invalidate];
    _backspaceTimer = nil;
    
}


- (void)hideMagnifier {
    _magnifier.hidden = YES;
}



#pragma mark -touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    _touchMoved = NO;
    MOBIMEmotionCell *cell = [self cellForTouches:touches];
    [self showMagnifierForCell:cell];
    if (!cell.isDelete && !cell.noEmotionImage) {
        [[UIDevice currentDevice] playInputClick];
    }
    
    _curMagnifierCell = cell;
    
    if (cell.isDelete) {
        [self endBackspaceTimer];
        [self performSelector:@selector(startBackspaceTimer) withObject:nil afterDelay:0.5];
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchMoved = YES ;
    if (_curMagnifierCell && _curMagnifierCell.isDelete) {
        return;
    }

    MOBIMEmotionCell *cell = [self cellForTouches:touches];
    if (cell != _curMagnifierCell) {
        if (!_curMagnifierCell.isDelete && !cell.isDelete) {
            _curMagnifierCell = cell;
        }
        [self showMagnifierForCell:cell];
    }

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideMagnifier];
    [self endBackspaceTimer];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MOBIMEmotionCell *cell = [self cellForTouches:touches];
    if ((!_touchMoved && cell.isDelete) || (!_curMagnifierCell.isDelete && !cell.noEmotionImage )) {

        if (self.tapBlock) {
            [[UIDevice currentDevice] playInputClick];
            self.tapBlock(_curMagnifierCell);
        }
    }
    [self hideMagnifier];
    [self endBackspaceTimer];
}

@end
