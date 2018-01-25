//
//  MOBIMChatMessageFrame.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatMessageFrame.h"
#import "MOBIMGConst.h"
#import "NSString+MOBIMExtension.h"
#import "MOBIMImageManager.h"
#import "UIImage+MOBIMExtension.h"
#import "MOBIMVideoManager.h"
#import "MOBIMFaceManager.h"

//图片的最大宽度
static CGFloat maxImageWidth    = 214.0f;
//static CGFloat minImageWidth    = 116.0f;

static CGFloat maxImageHeight = 219.0f;
static CGFloat minImageHeight = 123.0f;


@interface MOBIMChatMessageFrame()

@property (nonatomic, assign) BOOL hasCacheHeight;


@end
@implementation MOBIMChatMessageFrame


#define KMOBIMLabelInset 20


- (CGFloat)calCellHeight:(int)style
{
    if (!_hasCacheHeight) {
        
        if (self.modelNew) {
            [self resetHeightWithMessage:self.modelNew messageStyle:style];
        }else{
            
        }
    }

    
    return _cellHeight;
}


// 缩放，临时的方法
- (CGSize)handleImage:(CGSize)retSize
{
    CGFloat scaleH = 0.22;
    CGFloat scaleW = 0.38;
    CGFloat height = 0;
    CGFloat width = 0;
    if (retSize.height / MOIMDevice_Height + 0.16 > retSize.width / MOIMDevice_Width) {
        height = MOIMDevice_Height * scaleH;
        width = retSize.width / retSize.height * height;
    } else {
        width = MOIMDevice_Width * scaleW;
        height = retSize.height / retSize.width * width;
    }
    return CGSizeMake(width, height);
}



- (void)resetHeightWithMessage:(MIMMessage *)model messageStyle:(int)style
{
    
    CGFloat headToView    = 15;
    CGFloat headToBubble  = 5;
    CGFloat headWidth     = 46;
    CGFloat cellMargin    = 10;
    CGFloat bubblePadding = 10;
    CGFloat chatLabelMax  = MOIMDevice_Width - headWidth - 90;
    CGFloat fileBubbleMax  = MOIMDevice_Width - 2*(headWidth + headToView);

    CGFloat chatAudioChangeMax  = MOIMDevice_Width - 2*66 - 85-30;
    
    CGFloat arrowWidth    = 6;      // 气泡箭头
    CGFloat topViewH      = 5;
    CGFloat cellMinW      = 60;     // cell的最小宽度值,针对文本
    CGFloat picOffset      = 5;
    
    CGFloat topDateHeight = self.messageExt.showDate ? 15 : 0;
    if (topDateHeight) {
        cellMargin= 0;
    }
    
    //消息body 类型
    MIMMessageBodyType type = model.body.type;
    
    CGSize timeSize  = CGSizeMake(0, 0);
    if (_modelNew.direction == MIMMessageDirectionSend) {
        cellMinW = timeSize.width + arrowWidth + bubblePadding*2;
        CGFloat headX = MOIMDevice_Width - headToView - headWidth;
        _headImageViewF = CGRectMake(headX, cellMargin+topDateHeight, headWidth, headWidth);
        
        
        if (type == MIMMessageBodyTypeText) { // 文字
            NSString *content = @" ";
            
            if ([model.body isKindOfClass:[MIMTextMessageBody class]]) {
                content = [(MIMTextMessageBody*)model.body text];
            }
            
            if (style == 1) {
                //提醒号
                int topOffset = 50;
                
                //只处理接受
                //CGSize lastChatLabelSize=[content sizeWithRichTextMaxWidth:chatLabelMax andFont:MOBIMChatMessageMessageFont];
                self.textLayout = [MOBIMFaceManager textLayout:content maxWidth:chatLabelMax font:MOBIMChatMessageMessageFont insets:UIEdgeInsetsMake(10, 10, 10, 10) textColor:[UIColor whiteColor]];
                CGSize lastChatLabelSize = self.textLayout.textBoundingSize;
                
                CGSize chateLabelSize =CGSizeMake(lastChatLabelSize.width-KMOBIMLabelInset, lastChatLabelSize.height-KMOBIMLabelInset);
                
                
                //            CGSize chateLabelSize = [model.content sizeWithMaxWidth:chatLabelMax andFont:MOBIMChatMessageMessageFont];
                CGSize topViewSize    = CGSizeMake(cellMinW+bubblePadding*2, topViewH);
                CGSize bubbleSize = CGSizeMake(chateLabelSize.width + bubblePadding * 2 + arrowWidth, chateLabelSize.height + bubblePadding * 2+50);
                
                _bubbleViewF  = CGRectMake(CGRectGetMaxX(_headImageViewF) + headToBubble, cellMargin+topViewH + topDateHeight, bubbleSize.width, bubbleSize.height);
                CGFloat x     = CGRectGetMinX(_bubbleViewF) + bubblePadding + arrowWidth;
                _topViewF     = CGRectMake(CGRectGetMinX(_bubbleViewF)+arrowWidth, cellMargin+topOffset + topDateHeight, topViewSize.width, topViewSize.height);
                _chatLabelF   = CGRectMake(x - KMOBIMLabelInset/2.0, cellMargin + bubblePadding + topViewH - KMOBIMLabelInset/2.0+topOffset + topDateHeight, lastChatLabelSize.width, lastChatLabelSize.height);
                
                CGSize nameSize=[model.fromUserInfo.nickname sizeWithMaxWidth:chatLabelMax andFont:MOBIMChatMessageMessageFont];
                _nameViewF = CGRectMake(x - KMOBIMLabelInset/2.0+10, cellMargin+topViewH+10 + topDateHeight, nameSize.width, 21);
                
                _dateViewF = CGRectMake(x - KMOBIMLabelInset/2.0+10, cellMargin+topViewH+21+10 + topDateHeight, _chatLabelF.size.width, 21);
            }else{

                
                
                //CGSize lastChatLabelSize=[content sizeWithRichTextMaxWidth:chatLabelMax andFont:MOBIMChatMessageMessageFont];
                self.textLayout = [MOBIMFaceManager textLayout:content maxWidth:chatLabelMax font:MOBIMChatMessageMessageFont insets:UIEdgeInsetsMake(10, 10, 10, 10)  textColor:[UIColor whiteColor]];
                CGSize lastChatLabelSize = self.textLayout.textBoundingSize;
                
                CGSize chateLabelSize =CGSizeMake(lastChatLabelSize.width-KMOBIMLabelInset, lastChatLabelSize.height-KMOBIMLabelInset);
                
                CGSize bubbleSize     = CGSizeMake(chateLabelSize.width + bubblePadding * 2 + arrowWidth, chateLabelSize.height + bubblePadding * 2);
                CGSize topViewSize    = CGSizeMake(cellMinW+bubblePadding*2, topViewH);
                _bubbleViewF          = CGRectMake(CGRectGetMinX(_headImageViewF) - headToBubble - bubbleSize.width, cellMargin+topViewH +topDateHeight, bubbleSize.width, bubbleSize.height);
                CGFloat x             = CGRectGetMinX(_bubbleViewF)+bubblePadding;
                _topViewF             = CGRectMake(CGRectGetMinX(_headImageViewF) - headToBubble - topViewSize.width-headToBubble-5, cellMargin +topDateHeight,topViewSize.width,topViewSize.height);
                
                _chatLabelF           = CGRectMake(x-KMOBIMLabelInset/2.0, topViewH + cellMargin + bubblePadding-KMOBIMLabelInset/2.0+topDateHeight, lastChatLabelSize.width, lastChatLabelSize.height);
            }
         
        } else if (type == MIMMessageBodyTypeImage) { // 图片
            
            CGSize imageSize = [(MIMImageMessageBody*)model.body size];
            //UIImage *image   = [UIImage imageWithContentsOfFile:[[MOBIMImageManager sharedManager] imagePathWithName:model.body.local.lastPathComponent]];
            //if (image) {
            imageSize          = [self handleImage:imageSize];
            //}
            
            imageSize.width        = imageSize.width > timeSize.width ? imageSize.width : timeSize.width;
            CGSize topViewSize     = CGSizeMake(imageSize.width-arrowWidth, topViewH);
            CGSize bubbleSize      = CGSizeMake(imageSize.width, imageSize.height);
            CGFloat bubbleX        = CGRectGetMinX(_headImageViewF)-headToBubble-bubbleSize.width - ( 2*picOffset + arrowWidth);
            
            _bubbleViewF           = CGRectMake(bubbleX, cellMargin+topViewH +topDateHeight, bubbleSize.width + 2*picOffset + arrowWidth, bubbleSize.height + 2*picOffset);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF             = CGRectMake(x, cellMargin +topDateHeight,topViewSize.width,topViewSize.height);
            
            //缩小处理
            _picViewF              = CGRectMake(x + 5, cellMargin+topViewH+5 +topDateHeight, imageSize.width, imageSize.height);
        } else if (type == MIMMessageBodyTypeVoice) { // 语音消息
            CGFloat bubbleViewW     = 85;
            
            NSString *duraStr = [NSString stringWithFormat:@"%d",[(MIMVoiceMessageBody*)model.body duration]];
            
            if ([duraStr intValue] > KMOBIMMaxAudioSeconds) {
                bubbleViewW = chatAudioChangeMax + bubbleViewW;
            }else{
                NSLog(@"----%f",[duraStr intValue]/KMOBIMMaxAudioSeconds);
                bubbleViewW = bubbleViewW + chatAudioChangeMax*([duraStr intValue]/KMOBIMMaxAudioSeconds);
            }
            
            CGSize audioSize = [duraStr sizeWithMaxWidth:50 andFont:[UIFont systemFontOfSize:14]];
            
            _bubbleViewF = CGRectMake(CGRectGetMinX(_headImageViewF) - headToBubble - bubbleViewW, cellMargin+topViewH +topDateHeight, bubbleViewW, 40);
            _topViewF               = CGRectMake(CGRectGetMinX(_bubbleViewF), cellMargin +topDateHeight, bubbleViewW - arrowWidth, topViewH);
            
            _durationLabelF         = CGRectMake(CGRectGetMinX(_bubbleViewF) - bubblePadding -audioSize.width , cellMargin + 10+topViewH +topDateHeight, audioSize.width, 20);
            _voiceIconF = CGRectMake(CGRectGetMaxX(_bubbleViewF) - 22, cellMargin + 10 + topViewH +topDateHeight, 11, 16.5);// - 20
            
            
        }  else if (type == MIMMessageBodyTypeVideo) { // 视频信息
            CGSize imageSize = CGSizeMake(150, 150);
            
            //CGSize realImageSize = [(MIMVideoMessageBody*)model.body thumbnailSize];
            //float scale        = realImageSize.height/realImageSize.width;
            //imageSize = CGSizeMake(150, 140*scale);
            imageSize          = [self handleImage:[(MIMVideoMessageBody*)model.body thumbnailSize]];

            
            CGSize bubbleSize = CGSizeMake(imageSize.width, imageSize.height);
            _bubbleViewF = CGRectMake(CGRectGetMinX(_headImageViewF)-headToBubble-bubbleSize.width - 2*picOffset - arrowWidth, cellMargin+topViewH +topDateHeight, bubbleSize.width+2*picOffset+arrowWidth, bubbleSize.height+2*picOffset);
            CGSize topViewSize     = CGSizeMake(imageSize.width-arrowWidth, topViewH);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF              = CGRectMake(x, cellMargin +topDateHeight, topViewSize.width, topViewSize.height);
            _picViewF              = CGRectMake(x+picOffset, cellMargin+topViewH+picOffset +topDateHeight, imageSize.width, imageSize.height);
            
        } else if (type == MIMMessageBodyTypeFile) {
            
            CGSize bubbleSize = CGSizeMake(fileBubbleMax, 95.0);
            _bubbleViewF = CGRectMake(CGRectGetMinX(_headImageViewF)-headToBubble-bubbleSize.width, cellMargin+topViewH +topDateHeight, bubbleSize.width, bubbleSize.height);
            CGSize topViewSize     = CGSizeMake(bubbleSize.width-arrowWidth, topViewH);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF              = CGRectMake(x, cellMargin +topDateHeight, topViewSize.width, topViewSize.height);
            _picViewF              = CGRectMake(x, cellMargin+topViewH+topDateHeight, bubbleSize.width, bubbleSize.height);
        }
        
        
        CGFloat activityW = 20;
        CGFloat activityH = 20;
        CGFloat activityX = _bubbleViewF.origin.x-activityW-10;
        CGFloat activityY = (_bubbleViewF.origin.y + _bubbleViewF.size.height)/2 ;

        _activityF        = CGRectMake(activityX, activityY, activityW, activityH);
        
        if (type == MIMMessageBodyTypeVoice)  { // 语音消息
            _activityF        = CGRectMake(CGRectGetMinX(_durationLabelF) - activityW - 10, _bubbleViewF.origin.y - (activityH - _bubbleViewF.size.height)/2.0,  activityW, activityH);
            
        }
    } else {    // 接收者
        _headImageViewF   = CGRectMake(headToView, cellMargin+topDateHeight, headWidth, headWidth);
        CGSize nameSize       = CGSizeMake(0, 0);
        cellMinW = nameSize.width + 6 + timeSize.width; // 最小宽度
        if (type == MIMMessageBodyTypeText) { // 文字
            NSString *content = @" ";
            if (model.body && [model.body isKindOfClass:[MIMTextMessageBody class]])
            {
               content = [(MIMTextMessageBody*)model.body text];
            }
            else if (model.body && [model.body isKindOfClass:[MIMNoticeMessageBody class]])
            {
                content = [(MIMNoticeMessageBody*)model.body notice];

            }
            
            if (style == 1) {
                //提醒号
                int topOffset = 50;
                
                //只处理接受

                self.textLayout = [MOBIMFaceManager textLayout:content maxWidth:chatLabelMax font:MOBIMChatMessageMessageFont insets:UIEdgeInsetsMake(10, 10, 10, 10)  textColor:[UIColor blackColor]];
                CGSize lastChatLabelSize = self.textLayout.textBoundingSize;
                
                CGSize chateLabelSize =CGSizeMake(lastChatLabelSize.width-KMOBIMLabelInset, lastChatLabelSize.height-KMOBIMLabelInset);
                
                
                //            CGSize chateLabelSize = [model.content sizeWithMaxWidth:chatLabelMax andFont:MOBIMChatMessageMessageFont];
                CGSize topViewSize    = CGSizeMake(cellMinW+bubblePadding*2, topViewH);
                CGSize bubbleSize = CGSizeMake(MAX(chateLabelSize.width + bubblePadding * 2 + arrowWidth, fileBubbleMax), chateLabelSize.height + bubblePadding * 2+50);
                
                _bubbleViewF  = CGRectMake(CGRectGetMaxX(_headImageViewF) + headToBubble, cellMargin+topViewH + topDateHeight, bubbleSize.width, bubbleSize.height);
                CGFloat x     = CGRectGetMinX(_bubbleViewF) + bubblePadding + arrowWidth;
                _topViewF     = CGRectMake(CGRectGetMinX(_bubbleViewF)+arrowWidth, cellMargin+topOffset + topDateHeight, topViewSize.width, topViewSize.height);
                _chatLabelF   = CGRectMake(x - KMOBIMLabelInset/2.0, cellMargin + bubblePadding + topViewH - KMOBIMLabelInset/2.0+topOffset + topDateHeight, lastChatLabelSize.width, lastChatLabelSize.height);
                
                content = model.fromUserInfo.nickname ? model.fromUserInfo.nickname : @"系统消息";
                lastChatLabelSize=[content sizeWithMaxWidth:chatLabelMax andFont:[UIFont boldSystemFontOfSize:16.0f]];
                _nameViewF = CGRectMake(x - KMOBIMLabelInset/2.0+10, cellMargin+topViewH+10 + topDateHeight, lastChatLabelSize.width, 21);
                
                
                content = [NSString dateIntToDateString:_modelNew.timestamp isList:NO];
                lastChatLabelSize=[content sizeWithMaxWidth:chatLabelMax andFont:[UIFont boldSystemFontOfSize:16.0f]];
                _dateViewF = CGRectMake(x - KMOBIMLabelInset/2.0+10, cellMargin+topViewH+21+10 + topDateHeight, lastChatLabelSize.width, 21);
            }else{
                
                
                
                if ([model.body isKindOfClass:[MIMTextMessageBody class]])
                {
                    //CGSize lastChatLabelSize=[content sizeWithRichTextMaxWidth:chatLabelMax andFont:MOBIMChatMessageMessageFont];
                    self.textLayout = [MOBIMFaceManager textLayout:content maxWidth:chatLabelMax font:MOBIMChatMessageMessageFont insets:UIEdgeInsetsMake(10, 10, 10, 10)  textColor:[UIColor blackColor]];
                    CGSize lastChatLabelSize = self.textLayout.textBoundingSize;
                    
                    CGSize chateLabelSize =CGSizeMake(lastChatLabelSize.width-KMOBIMLabelInset, lastChatLabelSize.height-KMOBIMLabelInset);
                    
                    
                    CGSize topViewSize    = CGSizeMake(cellMinW+bubblePadding*2, topViewH);
                    CGSize bubbleSize = CGSizeMake(chateLabelSize.width + bubblePadding * 2 + arrowWidth, chateLabelSize.height + bubblePadding * 2);
                    
                    _bubbleViewF  = CGRectMake(CGRectGetMaxX(_headImageViewF) + headToBubble, cellMargin+topViewH+topDateHeight, bubbleSize.width, bubbleSize.height);
                    CGFloat x     = CGRectGetMinX(_bubbleViewF) + bubblePadding + arrowWidth;
                    _topViewF     = CGRectMake(CGRectGetMinX(_bubbleViewF)+arrowWidth, cellMargin+topDateHeight, topViewSize.width, topViewSize.height);
                    _chatLabelF   = CGRectMake(x - KMOBIMLabelInset/2.0, cellMargin + bubblePadding + topViewH - KMOBIMLabelInset/2.0+topDateHeight, lastChatLabelSize.width, lastChatLabelSize.height);
                    
                }
                else if ([model.body isKindOfClass:[MIMNoticeMessageBody class]])
                {
                    //考虑通知类消息
                    //CGSize size           = [content sizeWithMaxWidth:MOIMDevice_Width-40 andFont:[UIFont systemFontOfSize:10.0]];
                    self.textLayout = [MOBIMFaceManager textLayout:content maxWidth:chatLabelMax font:[UIFont systemFontOfSize:10.0f] insets:UIEdgeInsetsMake(10, 10, 10, 10) textColor:MOBIMRGB(0xA6A6B2)];
                    CGSize size = self.textLayout.textBoundingSize;
                    size.height = size.height - 16;
                    
                    _headImageViewF = CGRectZero;
                    cellMargin = 0;
                    _bubbleViewF = CGRectMake(0,  topDateHeight, 0, size.height);// 只需要高度就行
                    _chatLabelF = CGRectMake(20, 0, MOIMDevice_Width-40, size.height );
                }
                
            }
            

        } else if (type == MIMMessageBodyTypeImage) {
            
            CGSize imageSize = [(MIMImageMessageBody*)model.body size];
            //UIImage *image   = [UIImage imageWithContentsOfFile:[[MOBIMImageManager sharedManager] imagePathWithName:model.body.local.lastPathComponent]];
            //if (image) {
            imageSize          = [self handleImage:imageSize];
            //}
            
            imageSize.width        = imageSize.width > cellMinW ? imageSize.width : cellMinW;
            CGSize topViewSize     = CGSizeMake(imageSize.width-arrowWidth, topViewH);
            CGSize bubbleSize      = CGSizeMake(imageSize.width, imageSize.height);
            CGFloat bubbleX        = CGRectGetMaxX(_headImageViewF)+headToBubble;
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF              = CGRectMake(x+arrowWidth, cellMargin+topDateHeight, topViewSize.width, topViewSize.height);
            _bubbleViewF           = CGRectMake(bubbleX, cellMargin+topViewH+topDateHeight, bubbleSize.width + 2*picOffset + arrowWidth, bubbleSize.height + 2*picOffset);
            
            //缩小处理
            _picViewF              = CGRectMake(bubbleX + 5 + arrowWidth, cellMargin+topViewH+5+topDateHeight, imageSize.width , imageSize.height );
            
        }else if (type == MIMMessageBodyTypeVoice) {   // 语音
            
            
            CGFloat bubbleViewW     = 85;
            NSString *duraStr = [NSString stringWithFormat:@"%d",[(MIMVoiceMessageBody*)model.body duration]];
            
            if ([duraStr intValue] > KMOBIMMaxAudioSeconds) {
                bubbleViewW = chatAudioChangeMax + bubbleViewW;
            }else{
                bubbleViewW = bubbleViewW + chatAudioChangeMax*([duraStr intValue]/KMOBIMMaxAudioSeconds);
            }
            
            _bubbleViewF = CGRectMake(CGRectGetMaxX(_headImageViewF) + headToBubble, cellMargin+topViewH+topDateHeight, bubbleViewW, 40);
            _topViewF    = CGRectMake(CGRectGetMinX(_bubbleViewF)+arrowWidth, cellMargin+topDateHeight, bubbleViewW-arrowWidth, topViewH);
            _voiceIconF = CGRectMake(CGRectGetMinX(_bubbleViewF)+arrowWidth+bubblePadding, cellMargin + 10 + topViewH+topDateHeight, 11, 16.5);
            // 假设
            CGSize durSize = [duraStr sizeWithMaxWidth:chatLabelMax andFont:[UIFont systemFontOfSize:13]];
            _durationLabelF = CGRectMake(CGRectGetMaxX(_bubbleViewF) + bubblePadding , cellMargin + 10 + topViewH+topDateHeight, durSize.width, durSize.height);
            _redViewF = CGRectMake(CGRectGetMinX(_durationLabelF) + (CGRectGetWidth(_durationLabelF) -8)/2.0, CGRectGetMinY(_durationLabelF) - 8, 8, 8);
        } else if (type == MIMMessageBodyTypeVideo) {   // 视频
            CGSize imageSize       = CGSizeMake(150, 150);
            //CGSize realImageSize = [(MIMVideoMessageBody*)model.body thumbnailSize];
            //float scale        = realImageSize.height/realImageSize.width;
            //imageSize = CGSizeMake(150, 140*scale);
            //imageSize = [self adjustImageSize:[(MIMVideoMessageBody*)model.body thumbnailSize]];
            imageSize          = [self handleImage:[(MIMVideoMessageBody*)model.body thumbnailSize]];

            
            CGSize bubbleSize = CGSizeMake(imageSize.width, imageSize.height+topViewH);
            _bubbleViewF = CGRectMake(CGRectGetMaxX(_headImageViewF)+headToBubble, cellMargin+topViewH+topDateHeight, bubbleSize.width+ 2*picOffset+arrowWidth, bubbleSize.height+2*picOffset);
            CGSize topViewSize     = CGSizeMake(imageSize.width-arrowWidth, topViewH);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF              = CGRectMake(x+arrowWidth, cellMargin+topDateHeight, topViewSize.width, topViewSize.height);
            _picViewF              = CGRectMake(x+picOffset +arrowWidth, cellMargin+topViewH + picOffset+topDateHeight, imageSize.width, imageSize.height);
            
            
        } else if (type == MIMMessageBodyTypeFile) {
            CGSize bubbleSize = CGSizeMake(fileBubbleMax, 95.0);
            _bubbleViewF = CGRectMake(CGRectGetMaxX(_headImageViewF)+headToBubble, cellMargin+topViewH+topDateHeight, bubbleSize.width, bubbleSize.height);
            CGSize topViewSize     = CGSizeMake(bubbleSize.width-arrowWidth, topViewH);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF              = CGRectMake(x+arrowWidth, cellMargin+topDateHeight, topViewSize.width, topViewSize.height);
            _picViewF              = CGRectMake(x, cellMargin+topViewH+topDateHeight, bubbleSize.width, bubbleSize.height);
            
            
        }
        
    }
    
    _retryButtonF     = _activityF;

    _cellHeight = MAX(CGRectGetMaxY(_bubbleViewF), CGRectGetMaxY(_headImageViewF)) + cellMargin;
    
    //不计算在_cellHeight
    _topDateF = CGRectMake(20, 5, [UIScreen mainScreen].bounds.size.width-40, topDateHeight);
    
    _hasCacheHeight = YES;
}

- (CGSize)adjustImageSize:(CGSize)imageSize
{
    float resultHeight = imageSize.height;
    float resultWidth = imageSize.width;

    if (imageSize.width > imageSize.height)
    {
        //以最大宽度按比例来生成尺寸，是否超过最大宽度和高度
        resultHeight = maxImageWidth/(imageSize.width/imageSize.height);
        resultWidth = maxImageWidth;
        
        if (resultHeight <= maxImageHeight) {
        }
        
        //以最大高度按比例来生成尺寸，是否超过最大宽度和高度
    }
    else if (imageSize.width < imageSize.height)
    {
        resultHeight = maxImageHeight;
        resultWidth = maxImageHeight*(imageSize.width/imageSize.height);
    }
    else
    {
        resultWidth = minImageHeight;
        resultHeight = minImageHeight;
    }
    
    return CGSizeMake(resultWidth, resultHeight);
}

@end
