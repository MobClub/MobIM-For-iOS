//
//  MOBIMChatMessageTextCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatMessageTextCell.h"

@interface MOBIMChatMessageTextCell ()

@end


@implementation MOBIMChatMessageTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.chatLabel];
        
    }
    return self;
}

- (void)awakeFromNib {
        [super awakeFromNib];
        // Initialization code
        
        [self.contentView addSubview:self.chatLabel];

 }

#pragma mark - Private Method

- (void)setModelFrame:(MOBIMChatMessageFrame *)modelFrame
{
    //    self.chatLabel.frame = modelFrame.chatLabelF;
    //    [self.chatLabel setAttributedText:[ICFaceManager transferMessageString:modelFrame.model.message.content font:self.chatLabel.font lineHeight:self.chatLabel.font.lineHeight]];
    
    if (modelFrame.modelNew.direction == MIMMessageDirectionSend)
    {
        _chatLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        _chatLabel.textColor = [UIColor blackColor];
        
    }
    
    [super setModelFrame:modelFrame];
    
    
    self.chatLabel.frame = modelFrame.chatLabelF;
    
    if ([modelFrame.modelNew.body isKindOfClass:[MIMTextMessageBody class]]) {
//        MIMTextMessageBody *messageBody = (MIMTextMessageBody*)modelFrame.modelNew.body;
        
        //设置值
//        [self.chatLabel setText:messageBody.text];
    }
    else if ([modelFrame.modelNew.body isKindOfClass:[MIMNoticeMessageBody class]])
    {
//        [self.chatLabel setText: [(MIMNoticeMessageBody*)modelFrame.modelNew.body notice]];
        
    }else{
//        [self.chatLabel setText:modelFrame.model.content];
    }
    
    self.chatLabel.textLayout = modelFrame.textLayout;
    
}


- (YYLabel *)chatLabel
{
    if (!_chatLabel)
    {
        _chatLabel = [[YYLabel alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
        _chatLabel.userInteractionEnabled = YES;
        _chatLabel.numberOfLines = 0;
        UIFont *font = [UIFont systemFontOfSize:13.0f];
        _chatLabel.font = font;
        _chatLabel.displaysAsynchronously = YES; /// enable async display
        _chatLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _chatLabel.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
//        [_chatLabel setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.2]];
        

    }
    return _chatLabel;
}



@end
