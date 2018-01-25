//
//  MOBIMFaceManager.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMFaceManager.h"
#import "MOBIMEmotion.h"
#import "MOBIMEmotion.h"

#define ICBundle [NSBundle mainBundle]


@implementation MOBIMFaceManager


static NSArray * _emojiEmotions,*_custumEmotions,*gifEmotions;



+ (NSArray *)emojiGroups
{
    NSMutableArray *groups = [NSMutableArray new];
    
    //自定义图片
    {
        NSMutableDictionary *emojiDict = [NSMutableDictionary new];
        [emojiDict setObject:@"自定义" forKey:@"groupname"];
        [emojiDict setObject:self.customEmotion forKey:@"groupemotions"];

        [groups addObject:emojiDict];
    }
    
    
    return groups;
}



+ (NSArray *)customEmotion
{
    if (_custumEmotions) {
        return _custumEmotions;
    }
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"faces" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path  = [bundle pathForResource:@"normal_face.plist" ofType:nil];
    
    NSMutableArray *lastDara = [[NSMutableArray alloc] init];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *item in array) {
        MOBIMEmotion *emotion = [[MOBIMEmotion alloc] init];
        emotion.face_name = item[@"face_name"];
        emotion.face_id = item[@"face_id"];
        emotion.code = item[@"code"];
        [lastDara addObject:emotion];

    }
    
    _custumEmotions = lastDara;
    
    return _custumEmotions;
}



+ (NSArray *)gifEmotion
{
    return nil;
}

+ (YYTextLayout*)textLayout:(NSString*)content maxWidth:(float)maxWidth font:(UIFont *)font insets:(UIEdgeInsets)insets textColor:(UIColor *)textColor
{
//    NSLog(@"---%@---content-",content);
    if (!content || content.length <= 0) {
        content = @"";
    }
    
    if (!textColor)
    {
        textColor = [UIColor blackColor];
    }
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attributeStr.length)];

    
    //处理表情
    //2、通过正则表达式来匹配字符串
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情
    regex_emoji = @"\\[(.*?)\\]"; //匹配表情
 
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    
    NSArray *resultArray = [re matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    //3、获取所有的表情以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSArray *faceArr = [MOBIMFaceManager customEmotion];
    
    float imageSize = 20;
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    for (NSTextCheckingResult *match in resultArray) {
        NSRange range    = match.range;
        NSString *subStr = [content substringWithRange:range];
        
        BOOL hasFind = NO;
        for (MOBIMEmotion *face in faceArr) {
            if ([face.face_name isEqualToString:subStr]) {
                
                NSMutableDictionary *imagDic   = [NSMutableDictionary dictionaryWithCapacity:2];
                
                //图片attachText
                NSString *imagePath = [@"faces.bundle" stringByAppendingPathComponent:face.face_id];
                
                NSString *name = [NSString stringWithFormat:@"%@.png",imagePath];
                YYImage *image = [YYImage imageNamed:name];//修改表情大小
                if (image) {
                    image.preloadAllAnimatedImageFrames = YES;
                    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                    imageView.frame = CGRectMake(0, 0, imageSize, imageSize);
                    
                    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(imageSize, imageSize) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                    
                    //设置相关属性，方便外面遍历，修改
                    [imagDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                    [imagDic setObject:attachText forKey:@"image"];
                    [imageArray addObject:imagDic];
                    hasFind = YES;

                }
                
                break;
                
            }
        }
        
        if (hasFind) {
            continue;
        }
    }
    
    for (int i =(int) imageArray.count - 1; i >= 0; i --) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        [attributeStr replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    
    //处理超链接
//    NSString *regex_hylink = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
//    re = [NSRegularExpression regularExpressionWithPattern:regex_hylink options:NSRegularExpressionCaseInsensitive error:&error];
//    if (!re) {
//        NSLog(@"%@", [error localizedDescription]);
//        return nil;
//    }
//
//    resultArray = [re matchesInString:content options:0 range:NSMakeRange(0, content.length)];
//    for (NSTextCheckingResult *match in resultArray) {
//        NSString *substrinsgForMatch2 = [attributeStr.string substringWithRange:match.range];
//        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:substrinsgForMatch2];
//        // 利用YYText设置一些文本属性
//        one.yy_font = font;
//        one.yy_underlineStyle = NSUnderlineStyleSingle;
//        one.yy_color = [UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000];
//
//        YYTextBorder *border = [YYTextBorder new];
//        border.cornerRadius = 3;
//        border.insets = UIEdgeInsetsMake(-2, -1, -2, -1);
//        border.fillColor = [UIColor colorWithWhite:0.000 alpha:0.220];
//
//        YYTextHighlight *highlight = [YYTextHighlight new];
//        [highlight setBorder:border];
//        [one yy_setTextHighlight:highlight range:one.yy_rangeOfAll];
//        // 根据range替换字符串
//        [attributeStr replaceCharactersInRange:match.range withAttributedString:one];
//    }
    

    
    //处理邮件
    
    //处理电话
    

    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(maxWidth, MAXFLOAT)];
    container.insets = insets;
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attributeStr];
    return textLayout;
}


+ (NSRange)endCustomEmotionRange:(NSString*)content
{
    //2、通过正则表达式来匹配字符串
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情
    regex_emoji = @"\\[(.*?)\\]"; //匹配表情

    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        //NSLog(@"%@", [error localizedDescription]);
    }
    NSArray *resultArray = [re matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    if (resultArray.count > 0) {
        NSRange range = [(NSTextCheckingResult*)resultArray.lastObject range];
        if ([content hasSuffix:[content substringWithRange:range]]) {
            return range;
        }
    }

    return NSMakeRange(NSNotFound, 0);
}

@end
