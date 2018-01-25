//
//  MOBIMChatSystemCell.m
//  XZ_WeChat
//
//  Created by Hower on 17-9-27.
//  Copyright (c) 2017年 gxz. All rights reserved.
//

#import "MOBIMChatSystemCell.h"
#import "MOBIMGConst.h"
#import "UIView+MOBIMExtention.h"
#import "NSString+MOBIMExtension.h"

@interface MOBIMChatSystemCell ()

@property (nonatomic, weak) UILabel *contentLabel;

@end



@implementation MOBIMChatSystemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *contentLabel = [[UILabel alloc] init];
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
        self.backgroundColor           = [UIColor clearColor];
        self.selectionStyle            = UITableViewCellSelectionStyleNone;
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.textColor       = MOBIMRGB(0xA6A6B2);
        self.contentLabel.textAlignment   = NSTextAlignmentCenter;
        self.contentLabel.font            = [UIFont systemFontOfSize:10.0];
        self.contentLabel.numberOfLines        = 0;
    }
    return self;
}

- (void)setMessageF:(MOBIMChatMessageFrame *)messageF
{

    self.contentLabel.frame = messageF.chatLabelF;
    _messageF            = messageF;
    
    if (messageF.messageExt.textContent)
    {
        self.contentLabel.text = messageF.messageExt.textContent;
    }
    else
    {
        if ([messageF.modelNew.body isKindOfClass:[MIMNoticeMessageBody class]])
        {
            self.contentLabel.text = [(MIMNoticeMessageBody*)messageF.modelNew.body notice];
            
        }
        else if ([messageF.modelNew.body isKindOfClass:[MIMTextMessageBody class]])
        {
            self.contentLabel.text = [(MIMTextMessageBody*)messageF.modelNew.body text];
            
        }
        
    }
    
//    self.contentLabel.backgroundColor = [UIColor blueColor];
 
}



- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
