//
//  MOBIMGConst.h
//  MOBIMDemo
//
//  Created by hower on 2017/10/1.
//  Copyright © 2017年 MOB. All rights reserved.
//


#ifndef __MOBIMGConst__H__
#define __MOBIMGConst__H__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// 日志输出
#ifdef DEBUG
#define MOBIMLog(...) NSLog(__VA_ARGS__)
#else
#define MOBIMLog(...)
#endif

//测试
//#define MOBIMNetworkUrl(action) [NSString stringWithFormat:@"http://10.18.97.63:9700%@",action]
#define MOBIMNetworkUrl(action) [NSString stringWithFormat:@"http://demo.im.mob.com%@",action]


//弱引用
#define MOBIMWEAKSELF typeof(self) __weak weakSelf = self;

//强应用
#define MOBIMSTRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#define KMOBIMNavOffset -10
#define KMOBIMNavLeftTitleOffset -5
#define KMOBIMNavRightOffset -5

//颜色相关
#define MOBIMRGB(colorHex) [UIColor colorWithRed:((float)((colorHex & 0xFF0000) >> 16)) / 255.0 green:((float)((colorHex & 0xFF00) >> 8)) / 255.0 blue:((float)(colorHex & 0xFF)) / 255.0 alpha:1.0]

#define MOBIMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//通用文本灰色
#define KMOBIMDesColor MOBIMRGB(0x6E6F78)

//表格cell 分割线颜色
#define KMOBIMCommonLineColor MOBIMRGB(0xE6E6EC)

//日期灰色颜色
#define KMOBIMDateColor MOBIMRGB(0xA6A6B2)

//通用button 颜色
#define KMOBIMCommonButtonColor MOBIMRGB(0x00C59C)

//聊天界面，键盘 颜色
#define KMOBIMCommonKeyboardColor MOBIMRGB(0xF7F7F9)
//#define KMOBIMCommonKeyboardColor MOBIMRGB(0xFFFFFF)


//聊天界面最大 录音时长(秒)
#define KMOBIMMaxAudioSeconds  60.0f

//聊天界面，录音，倒计时(秒)
#define KMOBIMAudioCountdownSeconds  15

//聊天界面发送文件，最大 文件长度 20M
#define KMOBIMMaxFileLength  20*1024*1024.0
#define KMOBIMMaxImageLength  5*1024*1024.0

//#define KMOBIMMaxFileLength  0


#define KMOBIMDefaultAvatar @"default_avatar"


//defines
//黑名单列表cell
#define KMOBIMBlackCellTag  @"KMOBIMBlackCellTag"


#define MOIMAPP_RootViewController  [UIApplication sharedApplication].keyWindow.rootViewController

#define MOIMDevice_Width  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度
#define MOIMDevice_Height [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define MOBIMAppDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

//是否是 iPhoneX
#define  MOBIM_iPhoneX (MOIMDevice_Width == 375.f && MOIMDevice_Height == 812.f ? YES : NO)

//底部home高度
#define  MOBIM_TabbarSafeBottomMargin  (MOBIM_iPhoneX ? 34.f : 0.f)

//状态栏高度
#define  MOBIM_StatusBarHeight  ([UIApplication sharedApplication].statusBarFrame.size.height)



//群组删除
#define KMOBIMOwerDeleteTag 11111111
#define KMOBIMUnOwerDeleteTag 11111112

//群组-删除成员
#define KMOBIMOwerDeleteMemeberTag 11111113
#define KMOBIMGroupDisbandedTag 11111114
#define KMOBIMGroupMemberRemovedTag 11111115



//通用弹窗toast，时间间隔
FOUNDATION_EXTERN NSTimeInterval MOBIMToastTimeInterval;

//文件存储路径,文件夹
#define KMOBIMChatMessageVideoPath @"Chat/Video"  // video子路径
#define KMOBIMChatMessageAudioRecordPath @"Chat/Audio"  // Audio子路径

//音频，视频类型
#define KMOBIMChatMessageVideoType @".mp4"        // video类型
#define KMOBIMChatMessageAudioType @".wav"        // Audio类型
#define KMOBIMChatMessageAudioAMRType @"amr"      //录音原始文件类型

//聊天界面，通用字体大小
#define MOBIMChatMessageMessageFont [UIFont systemFontOfSize:13.0f]


//MOBIMBaseViewSelectCell  重用标示tag
#define KMOBIMBaseViewSelectCellTag  @"KMOBIMBaseViewSelectCellTag"

//MOBIMBaseButtonCell  重用标示tag
#define KMOBIMBaseButtonCellTag  @"KMOBIMBaseButtonCellTag"

//MOBIMContactsCell  重用标示tag
#define KMOBIMContactsCellId  @"MOBIMContactsCellId"

//MOBIMContactsCell 加，减操作  重用标示tag
#define KMOBIMContactsOperationCellId  @"KMOBIMContactsOperationCellId"

//MOBIMContactsAddCell  重用标示tag
#define KMOBIMContactsAddCellTag  @"KMOBIMContactsAddCellTag"

//MOBIMBlackCell  重用标示tag
#define KMOBIMBlackCellTag  @"KMOBIMBlackCellTag"

//MOBIMBaseButtonAvatarCell  重用标示tag
#define KMOBIMBaseButtonAvatarCellTag  @"KMOBIMBaseButtonAvatarCellTag"

//MOBIMBaseButtonAvatarCell 加，减操作   重用标示tag
#define KMOBIMGroupsAddOperationCellTag  @"KMOBIMGroupsAddOperationCellTag"
#define KMOBIMGroupsAddCellTag  @"KMOBIMGroupsAddCellTag"

//MOBIMBaseAvatarAddCell  重用标示tag
#define KMOBIMBaseAvatarAddCellTag  @"KMOBIMBaseAvatarAddCellTag"


//--群组--//
//群组-名称修改成功
#define KMOBIMGroupNameModifiedSucessNtf  @"KMOBIMGroupNameModifiedSucessNtf"

//群组-转让成功
#define KMOBIMUserGroupTransferSucessNtf  @"KMOBIMUserGroupTransferSucessNtf"

//群组-修改群组简介成功
#define KMOBIMGroupIntroductionModifiedSucessNtf  @"KMOBIMGroupIntroductionModifiedSucessNtf"

//群组-修改群组通告成功
#define KMOBIMGroupNoticeModifiedSucessNtf  @"KMOBIMGroupNoticeModifiedSucessNtf"

//群组-添加成员成功
#define KMOBIMGroupAddMemebersSucessNtf  @"KMOBIMGroupAddMemebersSucessNtf"

//群组-删除成员成功
#define KMOBIMGroupDeleteMemebersSucessNtf  @"KMOBIMGroupDeleteMemebersSucessNtf"

//群组-修改用户在群组中的昵称成功
#define KMOBIMGroupUserNicknameModifiedSucessNtf  @"KMOBIMGroupUserNicknameModifiedSucessNtf"

//群组-加入群组成功
#define KMOBIMGroupUserJoinSucessNtf  @"KMOBIMGroupUserJoinSucessNtf"

//群组-群组创建成功
#define KMOBIMGroupCreateSucessNtf  @"KMOBIMGroupCreateSucessNtf"

//群组-解散群组
#define KMOBIMDisbandGroupSucessNtf  @"KMOBIMDisbandGroupSucessNtf"

//群组-退出群组
#define KMOBIMQuitGroupSucessNtf  @"KMOBIMGroupDisbandSucessNtf"


//个人-添加联系人成功
#define KMOBIMUserAddContactSucessNtf  @"KMOBIMUserAddContactSucessNtf"

//个人-删除联系人成功
#define KMOBIMUserDeleteContactSucessNtf  @"KMOBIMUserDeleteContactSucessNtf"

//聊天界面，最少的录音时间
#define KMOBIMChatMessagMinRecordDuration 1.0
#define KMOBIMToshortRecord @"MOBIMToshortRecord"


//聊天界面-底部moreview高度
#define KChatInputBoxMoreViewHeight 128

//聊天界面-底部表情视图高度
#define KChatInputBoxFaceViewHeight 215


//群组详情头像宽度
#define KGroupInfoAvatarHeight 46

//键盘通知
FOUNDATION_EXTERN NSString *const KMOBIMEmotionDidSelectNotification;
FOUNDATION_EXTERN NSString *const KMOBIMEmotionDidDeleteNotification;
FOUNDATION_EXTERN NSString *const KMOBIMEmotionDidSendNotification;
FOUNDATION_EXTERN NSString *const KMOBIMSelectEmotionKey;

// NS_ENUM
#pragma mark - 聊天相关
// 消息发送状态
typedef NS_ENUM(NSUInteger,MOBIMChatMessageDeliveryState){
    MOBIMChatMessageDeliveryState_Pending = 0,  // 待发送
    MOBIMChatMessageDeliveryState_Delivering,   // 正在发送
    MOBIMChatMessageDeliveryState_Delivered,    // 已发送，成功
    MOBIMChatMessageDeliveryState_Failure,      // 发送失败
    MOBIMChatMessageDeliveryState_ServMOBIMeFaid   // 发送服务器失败(可能其它错,待扩展)
};


// 消息状态
typedef NS_ENUM(NSUInteger,MOBIMChatMessageStatus){
    MOBIMChatMessageStatus_unRead = 0,          // 消息未读
    MOBIMChatMessageStatus_read,                // 消息已读
    MOBIMChatMessageStatus_back                 // 消息撤回
};


//文件类型
typedef NS_ENUM(NSUInteger,MOBIMFileType){
    MOBIMFileType_Other = 0,                // 其它类型
    MOBIMFileType_Audio,                    //
    MOBIMFileType_Video,                    //
    MOBIMFileType_Html,
    MOBIMFileType_Pdf,
    MOBIMFileType_Doc,
    MOBIMFileType_Xls,
    MOBIMFileType_Ppt,
    MOBIMFileType_Img,
    MOBIMFileType_Txt
};


//聊天室类型
typedef NS_ENUM(NSUInteger, MOBIMChatRoomType)
{
    MOBIMChatRoomTypeChat = 0,  //单聊
    MOBIMChatRoomTypeGroup = 1,  //群组
    MOBIMChatRoomTypeTips = 2   //系统通知
    
};

////文件类型
//typedef NS_ENUM(NSUInteger,MOBIMUserType){
//    MOBIMUserTypeCommon = 1,                // 普通用户
//    MOBIMUserTypeTips,                    //提醒号用户
//
//};


//更多按钮类型
typedef NS_ENUM(NSUInteger, MOBIMChatInputBoxMoreViewItemType)
{
    MOBIMChatInputBoxMoreViewItemTypePhoto,  //图片
    MOBIMChatInputBoxMoreViewItemTypeCamera, //视频
    MOBIMChatInputBoxMoreViewItemTypeFile    //文件
};

typedef NS_ENUM(NSUInteger, MOBIMChatInputBoxStatus)
{
    MOBIMChatInputBoxStatusTextViewDefault, //默认
    MOBIMChatInputBoxStatusTextViewShow,    //textview编辑状态
    MOBIMChatInputBoxStatusMoreView,        //moreview编辑状态
    MOBIMChatInputBoxStatusFace,            //表情编辑状态
    MOBIMChatInputBoxStatusAudio            //录音状态
};

//消息样式类型
typedef NS_ENUM(NSUInteger, MOBIMMessageStyle)
{
    MOBIMMessageStyleDefault, //默认聊天
    MOBIMMessageStyleTips //提醒号
};

//消息样式类型
typedef NS_ENUM(NSUInteger, MOBIMTopButtonStatus)
{
    MOBIMTopButtonStatusRightEditor, //右侧编辑
    MOBIMTopButtonStatusRightDone, //右侧完成
    MOBIMTopButtonStatusLeftCancel //取消
};


//consts

// 聊天界面cell
FOUNDATION_EXTERN NSString *const MOBIMChatMessageTipsDetailKey;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageMessageKey;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageVoMOBIMeMOBIMon;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageRedView;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageTypeSystem;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageTypeDate;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageTypeText;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageTypeTextTips;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageTypeUnkown;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageTypePicText;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageTypePic;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageTypeAudio;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageTypePMOBIM;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageTypeVideo;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageTypeFile;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageTypePMOBIMText;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageMessageTypeKey;
FOUNDATION_EXTERN NSString *const MOBIMChatMessageVideoPathKey;
FOUNDATION_EXTERN NSString *const KMOBIMChatMessageSelectEmotionKey;


//聊天界面-底部键盘高度
FOUNDATION_EXTERN CGFloat const KMOBIMHEIGHT_CHATBOXVIEW ;
FOUNDATION_EXTERN CGFloat const KMOBIMHEIGHT_CHATBOXVIEWMore ;


//聊天界面-底部tabbar 高度
FOUNDATION_EXTERN CGFloat const KMOBIMHEIGHT_TABBAR;

FOUNDATION_EXTERN NSString *const KMOBIMBaseAvatarCellTag;          //通用头像cell
FOUNDATION_EXTERN NSString *const KMOBIMBaseTitleStyleCellTag;      //通用标题cell
FOUNDATION_EXTERN NSString *const KMOBIMBaseSwitchCellTag;          //通用switch cell
FOUNDATION_EXTERN NSString *const KMOBIMBaseDesCellTag;             //通用文件编辑 cell


//长按 block
typedef void(^MOBIMLongPressCompletionBlock)(UILongPressGestureRecognizer *recognizer);

#endif

