//
//  MOBIMSessionCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMSessionCell.h"
#import "MOBIMBadgeView.h"
#import "NSString+MOBIMExtension.h"

#define KSessionCellPanWidth 60
#define KSessionCellTapWidth  0
#define kCriticalTranslationX   30
#define kShouldSlideX           -2

@interface MOBIMSessionCell ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, assign) BOOL isSlided;
@property (nonatomic, assign) BOOL shouldSlide;

@end

@implementation MOBIMSessionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self loadUI];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self loadUI];
    }
    
    return self;
}

- (void)loadUI
{
    
    [self.contentView addSubview:self.unreadLabel];
    self.unreadLabel.hidden = YES;
    [_unreadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.trailing.mas_offset(-15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    

    self.desLabel.textColor = KMOBIMDesColor;
    self.dateLabel.textColor = KMOBIMDateColor;
    [self.avatarView setRoundedCornersSize:46];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setDataModel:(MIMConversation*)sessionModel
{
    
    //事件处理,可以考虑动态计算
    NSString *dateStr = [NSString dateIntToDateString:sessionModel.updateAt isList:YES];
    self.dateLabel.text= dateStr;
    

    //处理消息体
    [self handleMessageBody:sessionModel];
    
    //未读消息处理
    [self handleUnreadMessage:sessionModel];
    
    //处理消息主体的信息，图片，昵称
    [self handleFromInfo:sessionModel];
    
    
    [self.contentView setNeedsLayout];
    

    
}

- (void)handleMessageBody:(MIMConversation*)sessionModel
{
    if (sessionModel.conversationType == MIMConversationTypeSystem)
    {
        self.nameLabel.text=sessionModel.fromUserInfo.nickname;
        //图片文字
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:sessionModel.fromUserInfo.avatar] placeholderImage:[UIImage imageNamed:@"tips_avatar"]];

    }
    else if (sessionModel.conversationType == MIMConversationTypeSingle)
    {
        self.nameLabel.text=sessionModel.fromUserInfo.nickname;
        //图片文字
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:sessionModel.fromUserInfo.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
    }
    else if (sessionModel.conversationType == MIMConversationTypeGroup || sessionModel.conversationType == MIMConversationTypeNotice)
    {
        //self.nameLabel.text= [NSString stringWithFormat:@"%@ (%d人)",sessionModel.fromGroupInfo.groupName,sessionModel.fromGroupInfo.membersCount];
        
        MIMGroup *groupInfo = sessionModel.fromGroupInfo;
        if ([groupInfo.membersList count] != groupInfo.membersCount && [groupInfo.membersList count] > 0)
        {
            self.nameLabel.text = [NSString stringWithFormat:@"%@ (%zd人)",groupInfo.groupName,[groupInfo.membersList count]];
            
        }
        else
        {
            self.nameLabel.text = [NSString stringWithFormat:@"%@ (%d人)",groupInfo.groupName,groupInfo.membersCount];
            
        }
        
        //图片文字
        [_avatarView setImage:[UIImage imageNamed:@"avatar_group"]];
    }
    
    NSString * content = @"";
    MIMMessageBodyType bodyType = sessionModel.lastMessage.body.type;
    switch (bodyType)
    {
        case MIMMessageBodyTypeText:
        {
            if (sessionModel.lastMessage.body)
            {
                if ([sessionModel.lastMessage.body isKindOfClass:[MIMTextMessageBody class]])
                {
                    content=[(MIMTextMessageBody*)sessionModel.lastMessage.body text];
                }
                else if ([sessionModel.lastMessage.body isKindOfClass:[MIMNoticeMessageBody class]])
                {
                    content = [[MOBIMMessageManager sharedManager] contentStringWithGroupExt:sessionModel.lastMessage];
                    
                }
            }
            else
            {
                content = @"";
            }

        }
            break;
        case MIMMessageBodyTypeImage:
        {
            content=@"[图片]";

        }
            break;
        case MIMMessageBodyTypeVoice:
        {
            content=@"[语音]";
        }
            break;
        case MIMMessageBodyTypeVideo:
        {
            content=@"[视频]";
        }
            break;
        case MIMMessageBodyTypeFile:
        {
            content = @"[文件]";

        }
            break;
        case MIMMessageBodyTypeAction:
        {
            content = @"[系统]";
        }
            break;
        default:
        {
            content = @"";
        }
            break;
    }
    
    self.desLabel.text = content;
}

//未读消息处理
- (void)handleUnreadMessage:(MIMConversation*)sessionModel
{
    _unreadLabel.badgeBackgroundColor = MOBIMRGB(0xFD7B6C);
    
    if (sessionModel.conversationType == MIMConversationTypeSingle)
    {
        if (sessionModel.fromUserInfo.appUserId)
        {
            MIMVCard *vcard = [[MobIM getUserManager] getVCardWithUserId:sessionModel.fromUserInfo.appUserId];
            if (vcard.isDisturb)
            {
                _unreadLabel.badgeBackgroundColor = MOBIMColor(178, 178, 178);
                
            }
        }
    }
    else if (sessionModel.conversationType == MIMConversationTypeGroup || sessionModel.conversationType == MIMConversationTypeNotice)
    {
        if (sessionModel.fromGroupInfo.groupId)
        {
            MIMVCard *vcard = [[MobIM getGroupManager] getVCardWithGroupId:sessionModel.fromGroupInfo.groupId];
            if (vcard.isDisturb)
            {
                _unreadLabel.badgeBackgroundColor = MOBIMColor(178, 178, 178);
                
            }
        }

    }
    self.unreadLabel.badgeTextColor = [UIColor whiteColor];
    self.unreadLabel.badgeAlignment = MOBIMBadgeAlignmentTop|MOBIMBadgeAlignmentRight;
    
    int64_t count = sessionModel.unreadCount;
    if (count > 99)
    {
        self.unreadLabel.badgeType = MOBIMBadgeTypeNumber;
        _unreadLabel.badgeText = @"99+";
        self.unreadLabel.hidden = NO;
        self.unreadLabel.specificText = @"99+";
    }
    else if (count < 99 && count > 0)
    {
        self.unreadLabel.badgeType = MOBIMBadgeTypeNumber;
        _unreadLabel.badgeText = [NSString stringWithFormat:@"%lld", count];
        self.unreadLabel.hidden = NO;

    }
    else
    {
        self.unreadLabel.hidden = YES;
    }
}

- (void)handleFromInfo:(MIMConversation*)sessionModel
{
    MOBIMWEAKSELF
    //如果没有传图片地址的话,下载用户，群组或者用户系统的信息

    if (sessionModel.lastMessage.conversationType == MIMConversationTypeSingle && sessionModel.fromUserInfo.appUserId)
    {
        [[MOBIMUserManager sharedManager] fetchUserInfo:sessionModel.fromUserInfo.appUserId needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
            
            if (user)
            {
                [weakSelf.avatarView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:KMOBIMDefaultAvatar]];
                weakSelf.nameLabel.text = user.nickname;
            }

        }];

    }
    else if (sessionModel.lastMessage.conversationType == MIMConversationTypeGroup && sessionModel.fromGroupInfo.groupId)
    {
        
    }
    
//    if (sessionModel.from) {
//        if (sessionModel.chatRoomType == MOBIMChatRoomTypeChat) {
//            [[MOBIMUserManager sharedManager] fetchUserInfo:sessionModel.from needNetworkFetch:YES completion:^(MOBIMUser *user) {
//
//                [weakSelf.avatarView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:user.avatar]];
//
//            }];
//        }else if (sessionModel.chatRoomType == MOBIMChatRoomTypeGroup){
//
//            [[MOBIMGroupManager sharedManager] fethGroupInfo:sessionModel.from needNetworkFetch:YES completion:^(MOBIMGroup *group) {
//                [weakSelf.avatarView sd_setImageWithURL:[NSURL URLWithString:group.avatar] placeholderImage:[UIImage imageNamed:group.avatar]];
//
//            }];
//
//        }else if (sessionModel.chatRoomType == MOBIMChatRoomTypeTips){
//
//        }
//    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}



- (MOBIMBadgeView *)unreadLabel
{
    if (_unreadLabel == nil) {
        
        _unreadLabel= [[MOBIMBadgeView alloc] init];
        _unreadLabel.backgroundColor = [UIColor whiteColor];
        _unreadLabel.badgeBackgroundColor = MOBIMRGB(0xFD7B6C);
        _unreadLabel.badgeTextFont = [UIFont boldSystemFontOfSize:11];
    }
    

    return _unreadLabel;
}


@end

