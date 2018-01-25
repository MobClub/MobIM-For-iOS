//
//  MOBIMBaseChatMessageCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseChatMessageCell.h"
#import "MOBIMChatMessageModel.h"

@implementation MOBIMBaseChatMessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
        longRecognizer.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longRecognizer];

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - UI

- (void)setupUI {
    [self.contentView addSubview:self.bubbleView];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.activityView];
    [self.contentView addSubview:self.retryButton];
    [self.contentView addSubview:self.topDateLabel];
    self.topDateLabel.hidden =YES;
    
}

#pragma mark - Getter and Setter

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
        //[_headImageView setColor:IColor(219, 220, 220) bording:0.0];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked)];
        [_headImageView addGestureRecognizer:tapGes];
    }
    return _headImageView;
}

- (UIImageView *)bubbleView
{
    if (_bubbleView == nil)
    {
        _bubbleView = [[UIImageView alloc] init];
    }
    return _bubbleView;
}

- (UIActivityIndicatorView *)activityView
{
    if (_activityView == nil)
    {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityView;
}

- (UIButton *)retryButton
{
    if (_retryButton == nil) {
        _retryButton = [[UIButton alloc] init];
        [_retryButton setImage:[UIImage imageNamed:@"button_retry_comment"] forState:UIControlStateNormal];
        [_retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

#pragma mark - Respond Method

- (void)retryButtonClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(retrySendMessage:)]) {
        [self.delegate retrySendMessage:self];
    }
}


- (void)setModelFrame:(MOBIMChatMessageFrame *)modelFrame
{
    _modelFrame = modelFrame;
    MIMMessage *message = modelFrame.modelNew;
    self.headImageView.frame     = modelFrame.headImageViewF;
    self.bubbleView.frame        = modelFrame.bubbleViewF;
    
    
    if (message.direction == MIMMessageDirectionSend)
    {    // 发送者
        self.activityView.frame  = modelFrame.activityF;
        self.retryButton.frame   = modelFrame.retryButtonF;
        switch (modelFrame.modelNew.status)
        { // 发送状态
            case MIMMessageStatusSucceed:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:YES];
                
            }
                break;
            case MIMMessageStatusFailed:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:NO];
            }
                break;
            default:
            {
                [self.activityView setHidden:NO];
                [self.retryButton setHidden:YES];
                [self.activityView startAnimating];
            }
                break;
        }
        
        //[self.headImageView setImage:[UIImage imageNamed:@"mayun.jpg"]];
        
        MOBIMUser *currentUser = [MOBIMUserManager sharedManager].currentUser;
        if (currentUser)
        {
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:currentUser.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
        }
        self.bubbleView.image = [[UIImage imageNamed:@"chatbubblesend"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
        
    } else {    // 接收者
        
        MOBIMWEAKSELF
        if (message.conversationType == MIMConversationTypeSingle || message.conversationType == MIMConversationTypeGroup)
        {
            [[MOBIMUserManager sharedManager] fetchUserInfo:message.from needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
                
                if (user)
                {
                    //群其他成员信息
                    [weakSelf.headImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
                }

            }];
        }
        else if (message.conversationType == MIMConversationTypeSystem)
        {
            [weakSelf.headImageView sd_setImageWithURL:[NSURL URLWithString:message.fromUserInfo.avatar] placeholderImage:[UIImage imageNamed:@"tips_avatar"]];
            
        }
                
        self.bubbleView.image = [[UIImage imageNamed:@"chatbubblereceive"]  stretchableImageWithLeftCapWidth:40 topCapHeight:30];
        [self.retryButton setHidden:YES];
        
    }
    
   
    if (modelFrame.messageExt.showDate)
    {
        self.topDateLabel.frame = modelFrame.topDateF;
        self.topDateLabel.text = modelFrame.messageExt.showDateString;
        self.topDateLabel.hidden = NO;
    }else{
        self.topDateLabel.hidden = YES;

    }

    
    [_headImageView setRoundedCornersSize:46.0f];

}

- (UILabel*)topDateLabel
{
    if (!_topDateLabel)
    {
        _topDateLabel= [UILabel new];
        _topDateLabel.backgroundColor = [UIColor clearColor];
        _topDateLabel.textColor       = MOBIMRGB(0xA6A6B2);
        _topDateLabel.textAlignment   = NSTextAlignmentCenter;
        _topDateLabel.font            = [UIFont systemFontOfSize:10.0];
        _topDateLabel.width = [UIScreen mainScreen].bounds.size.width - 40;
        _topDateLabel.numberOfLines        = 0;
//        _topDateLabel.backgroundColor = [UIColor redColor];
    }
    
    return _topDateLabel;
}

- (void)headClicked
{
    BOOL isSender = (_modelFrame.modelNew.direction == MIMMessageDirectionSend);

    
    if (!isSender && [self.delegate respondsToSelector:@selector(headImageClicked:)])
    {
        //获取用户id
        [self.delegate headImageClicked:_modelFrame.modelNew.from];
    }
}

#pragma mark - longPress delegate

- (void)longPressRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if ([self.delegate respondsToSelector:@selector(longPress:)])
    {
        [self.delegate longPress:recognizer];
    }
}



@end
