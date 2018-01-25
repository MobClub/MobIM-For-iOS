//
//  MOBIMAvatarFLowLayout.h
//  MOBIMDemo
//
//  Created by hower on 2017/9/29.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MOBIMAvatarFLowLayout;

@protocol MOBIMAvatarFLowLayoutDelegate <NSObject>

@required

@optional
- (CGFloat)flowLayout:(MOBIMAvatarFLowLayout *)MOBIMAvatarFLowLayout heightForRowAtIndexPath:(NSInteger)index itemWidth:(CGFloat)itemWidth;
- (CGFloat)columnCountInFLowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout;
- (CGFloat)columnMarginInFLowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout;
- (CGFloat)rowMarginInFLowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout;
- (UIEdgeInsets)edgeInsetsInFLowLayout:(MOBIMAvatarFLowLayout *) MOBIMAvatarFLowLayout;

@end

@interface MOBIMAvatarFLowLayout : UICollectionViewLayout
@property (nonatomic , weak) id<MOBIMAvatarFLowLayoutDelegate> delegate;
@end
