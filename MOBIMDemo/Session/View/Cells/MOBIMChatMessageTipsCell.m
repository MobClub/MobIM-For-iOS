//
//  MOBIMChatMessageTipsCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/30.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatMessageTipsCell.h"
#import "NSString+MOBIMExtension.h"

@interface MOBIMChatMessageTipsCell ()
{
    
}
@property (nonatomic, strong) UILabel    *dateLabel;
@property (nonatomic, strong) UILabel    *nameLabel;


@end

@implementation MOBIMChatMessageTipsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadUI];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self loadUI];
}

- (void)loadUI
{
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.nameLabel];

}

- (void)setModelFrame:(MOBIMChatMessageFrame *)modelFrame
{
    [super setModelFrame:modelFrame];
    self.dateLabel.frame=modelFrame.dateViewF;
    self.nameLabel.frame=modelFrame.nameViewF;
    
    self.dateLabel.text = [NSString dateIntToDateString:modelFrame.modelNew.timestamp isList:NO];
    self.nameLabel.text = modelFrame.modelNew.fromUserInfo.nickname;
    
    self.chatLabel.frame = modelFrame.chatLabelF;
    
    if ([modelFrame.modelNew.body isKindOfClass:[MIMTextMessageBody class]])
    {
        [self.chatLabel setText:[(MIMTextMessageBody*)modelFrame.modelNew.body text]];
    }
    else
    {
        [self.chatLabel setText:[(MIMNoticeMessageBody*)modelFrame.modelNew.body notice]];

    }
}


- (UILabel *)dateLabel
{
    if (nil == _dateLabel ) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:12.0];
        _dateLabel.textColor = KMOBIMDateColor;
    }
    return _dateLabel;
}

- (UILabel *)nameLabel
{
    if (nil == _nameLabel ) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    }
    return _nameLabel;
}



@end
