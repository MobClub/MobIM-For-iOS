//
//  UIImageView+MOBIMRoundedExtension.m
//  MOBIMDemo
//
//  Created by hower on 27/11/2017.
//  Copyright © 2017 hower. All rights reserved.
//

#import "UIImageView+MOBIMRoundedExtension.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import "MOBIMImageManager.h"
#import "UIImage+MOBIMExtension.h"
#import "NSString+MOBIMExtension.h"

static char imageURLKey;
static char TAG_ACTIVITY_INDICATOR;
static char TAG_ACTIVITY_STYLE;
static char TAG_ACTIVITY_SHOW;

@implementation UIImageView(MOBIMRoundedExtension)

- (void)rounded_setImageWithURL:(NSURL *)url  radius:(CGFloat)cornerRadius{
    [self rounded_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil radius:cornerRadius];
}

- (void)rounded_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder  radius:(CGFloat)cornerRadius{
    [self rounded_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil radius:cornerRadius];
}

- (void)rounded_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options  radius:(CGFloat)cornerRadius{
    [self rounded_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil radius:cornerRadius];
}

- (void)rounded_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock  radius:(CGFloat)cornerRadius{
    [self rounded_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock radius:cornerRadius];
}

- (void)rounded_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock  radius:(CGFloat)cornerRadius{
    [self rounded_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock radius:cornerRadius];
}

- (void)rounded_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock  radius:(CGFloat)cornerRadius{
    [self rounded_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock radius:cornerRadius];
}

- (void)rounded_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock  radius:(CGFloat)cornerRadius {
    [self rounded_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    
    if (url) {
        
        // check if activityView is enabled or not
        if ([self showActivityIndicatorView]) {
            [self addActivityIndicator];
        }
        __weak __typeof(self)wself = self;

        UIImage *image = nil;
        NSString *fileKey = [[NSString md5:url.path] stringByAppendingString:@"_rounded"];
        if ((image = [[MOBIMImageManager sharedManager] roundedImageFileKey:fileKey]))
        {
            dispatch_main_sync_safe(^{
                if (!wself) return;
            
                if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                }
            });

            return;
        }
        
        
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [wself removeActivityIndicator];
            if (!wself) return;
            
            //处理圆角图片
            if (image) {
                
                image = [image roundedCornerImageWithCornerRadius:image.size.width];
                
                NSString *fileKey = [[NSString md5:url.path] stringByAppendingString:@"_rounded"];
                //写入
                [[MOBIMImageManager sharedManager] saveRoundedImage:image fileKey:fileKey radius:image.size.width];
 
            }
            
            
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock)
                {
                    completedBlock(image, error, cacheType, url);
                    return;
                }
                else if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            [self removeActivityIndicator];
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)rounded_setImageWithPreviousCachedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock  radius:(CGFloat)cornerRadius{
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    [self rounded_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock radius:cornerRadius];
}

- (NSURL *)rounded_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)rounded_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs  radius:(CGFloat)cornerRadius{
    [self rounded_cancelCurrentAnimationImagesLoad];
    __weak __typeof(self)wself = self;
    
    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];
    
    for (NSURL *logoImageURL in arrayOfURLs) {
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:logoImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    [currentImages addObject:image];
                    
                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        [operationsArray addObject:operation];
    }
    
    [self sd_setImageLoadOperation:[NSArray arrayWithArray:operationsArray] forKey:@"UIImageViewAnimationImages"];
}

- (void)rounded_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)rounded_cancelCurrentAnimationImagesLoad{
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}


#pragma mark -
- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)setShowActivityIndicatorView:(BOOL)show{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_SHOW, [NSNumber numberWithBool:show], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)showActivityIndicatorView{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_SHOW) boolValue];
}

- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_STYLE, [NSNumber numberWithInt:style], OBJC_ASSOCIATION_RETAIN);
}

- (int)getIndicatorStyle{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_STYLE) intValue];
}

- (void)addActivityIndicator {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[self getIndicatorStyle]];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        
        dispatch_main_async_safe(^{
            [self addSubview:self.activityIndicator];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
        });
    }
    
    dispatch_main_async_safe(^{
        [self.activityIndicator startAnimating];
    });
    
}

- (void)removeActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}

@end
