//
//  MOBIMChatRoomViewController.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/24.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatRoomViewController.h"
#import "MOBIMChatInputBoxViewController.h"
#import "MOBIMChatInputBox.h"
#import "MOBIMChatMessageTools.h"
#import "MOBIMChatMessageFrame+MOBIMExtension.h"
#import "MOBIMChatMessageFrame.h"
#import "MOBIMVideoManager.h"
#import "MOBIMChatMessageTextCell.h"
#import "MOBIMAudioManager.h"
#import "MOBIMFileManager.h"
#import "MOBIMChatMessageAudioCell.h"
#import "MOBIMVoiceConverter.h"
#import "UIImage+MOBIMExtension.h"
#import "MOBIMImageManager.h"
#import "MOBIMChatMessagePhotoCell.h"
#import "MOBIMPhotoBrowserController.h"
#import "MOBIMChatMessageVideoCell.h"
#import "MOBIMChatMessageFileCell.h"
#import "NSString+MOBIMExtension.h"
#import "NSDictionary+MOBIMExtention.h"
#import "MOBIMIDocumentReaderController.h"
#import "UIView+MOBIMExtention.h"
#import "UIColor+MOBIMExtentions.h"
#import "MOBIMChatSystemCell.h"
#import "MOBIMGConfigManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "MOBIMRecordHUD.h"
#import "MOBIMVideoPlayerView.h"
#import "MOBIMDownloadManager.h"
#import "MOBIMChatMessageTipsCell.h"

#define KMOBIMInputTabbarHeight 49



//文件类型
typedef NS_ENUM(NSUInteger,MOBIMCellLongPressType){
    MOBIMCellLongPressTypeDefault = 0,                // 默认
    MOBIMCellLongPressTypeCyDel = 1,  //拷贝，删除
    MOBIMCellLongPressTypeDel = 2   //删除
};



@interface MOBIMChatRoomViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MOBIMAudioManagerDelegate,UIViewControllerAnimatedTransitioning,MOBIMChatInputBoxViewControllerDelegate,UIViewControllerTransitioningDelegate>

/**
 *输入控制器，主要用来管理底部的自定义输入控件
 *进行分层控制，不要全部放在聊天界面，聊天界面尽量做两天的事情
 **/
@property (nonatomic, strong) MOBIMChatInputBoxViewController *chatInputBoxVC;

//消息列表
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headRefreshView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic, strong) UIView *bottomView;



//输入对话框中文本对话框
@property (nonatomic, strong) UITextView *textView;


//录音时，各种状态显示
@property (nonatomic, strong) MOBIMRecordHUD *recordHUD;

//当前播放的音频
@property (nonatomic, copy) NSString *audioPath;

//正在播放音频的动画图片层
@property (nonatomic, strong) UIImageView *currentVoiceIcon;

//图片放大动画时的大图片
@property (nonatomic, strong) UIImageView *presentImageView;

//消息列表中图片需要做放大动画的列表图片
@property (nonatomic, strong) UIButton *cellPresentView;

@property (nonatomic, assign)  BOOL presentFlag;  // 是否model出控制器
@property (nonatomic, assign) CGRect smallRect;
@property (nonatomic, assign) CGRect bigRect;
@property (nonatomic, assign) BOOL   isKeyBoardAppear;     // 键盘是否弹出来了

//长按cell 的indexPath
@property (nonatomic, strong) NSIndexPath* longIndexPath;

//分页加载相关
@property (nonatomic, assign) MIMMessage *lastMessage;
@property (nonatomic, assign) NSInteger pageSize;


/**
 指令运作队列
 */
@property (nonatomic) dispatch_queue_t commandQueue;

/**
 获取应用配置信号量
 */
@property (nonatomic) dispatch_semaphore_t configSemaphore;


@property (nonatomic, strong) MASConstraint *bottomConstraint;

//table 布局
@property (nonatomic, strong) NSLayoutConstraint *tableTopContraint;
@property (nonatomic, strong) NSLayoutConstraint *tableBottomContraint;
@property (nonatomic, strong) NSLayoutConstraint *tableHeadContraint;
@property (nonatomic, strong) NSLayoutConstraint *tableTailContraint;

//正在加载历史数据
@property (nonatomic, assign) BOOL   isLoadingHistoryData;

@property (nonatomic, strong) NSString *messageReceivedTag;

@property (nonatomic, assign) MOBIMCellLongPressType cellLongPressType;

@end

@implementation MOBIMChatRoomViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.commandQueue = dispatch_queue_create("MOBIMChatRoomVCCommandQueue", DISPATCH_QUEUE_SERIAL);

    

    self.title=@"聊天";

    [self loadData];

    [self loadUI];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MobIM getChatManager] removeMessageHandlerForIdentifier:self.messageReceivedTag];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}


- (NSString *)topShowDateString:(MOBIMChatMessageFrame*)messageF
{
    if (self.messageStyle != MOBIMMessageStyleTips) {
        
        MOBIMChatMessageFrame *messageFrame = self.dataArray.firstObject;
        if (messageFrame)
        {
            
            messageF.messageExt.day = [NSString dayFromDateInt:messageF.modelNew.timestamp];
            
            
            if (messageFrame.messageExt.day != messageF.messageExt.day) {
                
                messageF.messageExt.showDate = YES;
                
                if (messageF.modelNew) {
                    
                    messageF.messageExt.showDateString = [NSString dateIntToDateString:messageFrame.modelNew.timestamp isList:NO];
                }else{
                    
                    
                    messageF.messageExt.showDateString = [NSString dateIntToDateString:messageFrame.modelNew.timestamp isList:NO];
                    
                }
            }else{
                messageF.messageExt.showDateString = messageFrame.messageExt.showDateString;
                
            }
        }
        else
        {
            messageF.messageExt.showDateString = [NSString dateIntToDateString:messageF.modelNew.timestamp isList:NO];

        }
    }
    return messageF.messageExt.showDateString;
}

- (NSString *)conversationId
{
    if (self.dataArray)
    {
        MOBIMChatMessageFrame *messageFrame = self.dataArray.lastObject;
        return messageFrame.modelNew.conversationId;
    }
    return nil;
}

- (void)handleReceivedMessage:(MIMMessage *)message
{
    //更新数组已读状态
    if (message)
    {
        [[MobIM getChatManager] updateMessageToReaded:message];
    }
    
    MOBIMWEAKSELF
    if (message.conversationType == MIMConversationTypeGroup)
    {
        
        if ([message.to isEqualToString:weakSelf.to]) {
            
            //                    MOBIMweakSelf
            dispatch_async(weakSelf.commandQueue, ^{
                MOBIMChatMessageFrame *modelF = [[MOBIMChatMessageFrame alloc] init];
                modelF.modelNew = message;
                {
                    MOBIMChatMessageExt *ext = [[MOBIMChatMessageExt alloc] init];
                    ext.day = [NSString dayFromDateInt:message.timestamp];
                    modelF.messageExt = ext;
                }
                [weakSelf topShowDateString:modelF];
                
                
                [weakSelf addObject:modelF isSender:NO];
            });
            
        }
    }
    else if (message.conversationType == MIMConversationTypeSingle)
    {
        if (message.to &&  weakSelf.from && [message.to isEqualToString:weakSelf.from] && [message.from isEqualToString:weakSelf.to]) {
            //                MOBIMweakSelf
            dispatch_async(weakSelf.commandQueue, ^{
                
                //转换MOBIMChatMessageFrame 后再使用
                MOBIMChatMessageFrame *modelF = [[MOBIMChatMessageFrame alloc] init];
                modelF.modelNew = message;
                {
                    MOBIMChatMessageExt *ext = [[MOBIMChatMessageExt alloc] init];
                    ext.day = [NSString dayFromDateInt:message.timestamp];
                    modelF.messageExt = ext;
                }
                [weakSelf topShowDateString:modelF];
                
                [weakSelf addObject:modelF isSender:NO];
                
            });
            
        }
    }
    else if (message.conversationType == MIMConversationTypeSystem)
    {
        if (message.to &&  weakSelf.from && [message.to isEqualToString:weakSelf.from] && [message.from isEqualToString:self.to]) {
            //                MOBIMweakSelf
            dispatch_async(weakSelf.commandQueue, ^{
                
                //转换MOBIMChatMessageFrame 后再使用
                MOBIMChatMessageFrame *modelF = [[MOBIMChatMessageFrame alloc] init];
                modelF.modelNew = message;
                {
                    MOBIMChatMessageExt *ext = [[MOBIMChatMessageExt alloc] init];
                    ext.day = [NSString dayFromDateInt:message.timestamp];
                    modelF.messageExt = ext;
                }
                
                [weakSelf addObject:modelF isSender:NO];
                
            });
            
        }
    }
    else if (message.conversationType == MIMConversationTypeNotice && [message.body isKindOfClass:[MIMNoticeMessageBody class]])
    {
        
        //            MOBIMweakSelf
        dispatch_async(weakSelf.commandQueue, ^{
            
            MIMNoticeMessageBody *messageBody = (MIMNoticeMessageBody*)message.body;
            
            if ((messageBody.noticeType <= MIMNoticeTypeMemberRemoved) && (messageBody.noticeType >= MIMNoticeTypeCreateGroup)) {
                MOBIMChatMessageFrame *modelF = [[MOBIMChatMessageFrame alloc] init];
                modelF.modelNew = message;
                {
                    MOBIMChatMessageExt *ext = [[MOBIMChatMessageExt alloc] init];
                    ext.day = [NSString dayFromDateInt:message.timestamp];
                    modelF.messageExt = ext;
                }
                
                if (self.chatRoomType == MOBIMChatRoomTypeGroup) {
                    
                    [weakSelf topShowDateString:modelF];
                    
                    modelF.messageExt.textContent = messageBody.notice;
                    
                    switch (messageBody.noticeType) {
                        case MIMNoticeTypeCreateGroup:
                        {
                            if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:self.to]) {
                                
                                if ([weakSelf.dataArray count]  > 0) {
                                    return ;
                                }
                                
                                [weakSelf addObject:modelF isSender:NO];
                            }
                        }
                            break;
                        case MIMNoticeTypeUpdateGroupName:
                        {
                            if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:self.to]) {
                                
                                modelF.messageExt.textContent = [NSString stringWithFormat:@"%@ 修改群名称为: %@",[weakSelf nickNameWithUser:messageBody.ownerInfo],message.ext[@"name"]];
                                
                                [weakSelf addObject:modelF isSender:NO];
                                self.title = message.ext[@"name"];
                            }
                        }
                            break;
                        case MIMNoticeTypeUpdateGroupNoti:
                        {
                            if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:self.to]) {
                                modelF.messageExt.textContent = [NSString stringWithFormat:@"%@更新公告: %@",[weakSelf nickNameWithUser:messageBody.ownerInfo],message.ext[@"notice"]];
                                
                                [weakSelf addObject:modelF isSender:NO];
                            }
                        }
                            break;
                        case MIMNoticeTypeGroupTransfer:
                        {
                            if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:self.to]) {
                                modelF.messageExt.textContent = [NSString stringWithFormat:@"%@ 转让群组给 %@",[weakSelf nickNameWithUser:messageBody.ownerInfo],[weakSelf nickNameWithUser:messageBody.userInfo]];
                                
                                [weakSelf addObject:modelF isSender:NO];
                            }
                        }
                            break;
                        case MIMNoticeTypeGroupDisbanded:
                        {
                            if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:self.to]) {
                                modelF.messageExt.textContent = [NSString stringWithFormat:@"你所在的群组\"%@\"已被解散",message.ext[@"name"]];
                                
                                [weakSelf addObject:modelF isSender:NO];
                            }
                        }
                            break;
                        case MIMNoticeTypeJoinGroup:
                        {
                            if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:self.to]) {
                                modelF.messageExt.textContent = [NSString stringWithFormat:@"%@ 加入该群聊",[weakSelf nickNameWithUser:messageBody.userInfo]];
                                
                                [weakSelf addObject:modelF isSender:NO];
                            }
                            
                        }
                            break;
                        case MIMNoticeTypeInvitedToGroup:
                        {
                            if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:self.to]) {
                                
                                NSArray *users =message.ext[@"users"];
                                if (users) {
                                    
                                    NSMutableString *userStr = [NSMutableString new];
                                    for (NSDictionary *userItem in users) {
                                        NSString *nickname = [weakSelf nickNameWithDict:userItem];
                                        [userStr appendFormat:@"%@,",nickname];
                                    }
                                    if ([userStr hasSuffix:@","]) {
                                        [userStr deleteCharactersInRange:NSMakeRange(userStr.length-1, 1)];
                                    }
                                    modelF.messageExt.textContent = [NSString stringWithFormat:@"%@ 加入群聊",userStr];
                                    
                                }
                                
                                [weakSelf addObject:modelF isSender:NO];
                            }
                        }
                            break;
                        case MIMNoticeTypeExitGroup:
                        {
                            if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:self.to]) {
                                modelF.messageExt.textContent = [NSString stringWithFormat:@"%@ 退出该群聊",[weakSelf nickNameWithUser:messageBody.userInfo]];
                                
                                [weakSelf addObject:modelF isSender:NO];
                            }
                        }
                            break;
                        case MIMNoticeTypeRemoveMembers:
                        {
                            if (message.ext && message.ext[@"id"] && [message.ext[@"id"] isEqualToString:self.to]) {
                                
                                NSArray *users =message.ext[@"users"];
                                if (users) {
                                    
                                    NSMutableString *userStr = [NSMutableString new];
                                    for (NSDictionary *userItem in users) {
                                        NSString *nickname = [weakSelf nickNameWithDict:userItem];
                                        [userStr appendFormat:@"%@,",nickname];
                                    }
                                    if ([userStr hasSuffix:@","]) {
                                        [userStr deleteCharactersInRange:NSMakeRange(userStr.length-1, 1)];
                                    }
                                    modelF.messageExt.textContent = [NSString stringWithFormat:@"%@ 被移除",userStr];
                                    
                                }
                                
                                
                                [weakSelf addObject:modelF isSender:NO];
                            }
                        }
                            break;
                        case MIMNoticeTypeMemberRemoved:
                        {
                            modelF.messageExt.textContent = [NSString stringWithFormat:@"你已被移除出群组: %@",message.ext[@"name"]];
                            [weakSelf addObject:modelF isSender:NO];
                            
                        }
                            break;
                        default:
                            break;
                    }
                    
                    [weakSelf handleNoticeMessageSucess:message];
                }
                
                
                
                
            }
        });
        
        
        
        
    }
}


- (void)loadData
{
    if (self.messageReceivedTag.length < 1) {
        self.messageReceivedTag = [NSString stringWithFormat:@"%.0f",[NSDate date].timeIntervalSince1970*1000];
    }
    //监听消息
    MOBIMWEAKSELF
    
    [[MobIM getChatManager] onMessageReceivedWithIdentifier:self.messageReceivedTag messageHandler:^(MIMMessage *message) {
        if (weakSelf) {
            [weakSelf handleReceivedMessage:message];
        }
    }];
    
    
    
    self.cellLongPressType = MOBIMCellLongPressTypeDefault;
    self.lastMessage = nil;

    [self loadHistoryCacheData];

}


- (NSString *)nickNameWithUser:(MIMUser*)user
{
    if (user.nickname)
    {
        return user.nickname;
    }
    
    MOBIMUser *appUser = [[MOBIMUserManager sharedManager] usserInfoWithId:user.appUserId];
    if (appUser && appUser.nickname) {
        
        return appUser.nickname;
    }
    
    //取消在
    [[MOBIMUserManager sharedManager] fetchUserInfo:user.appUserId needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
        
    }];
    
    return user.appUserId;
}

- (NSString *)nickNameWithDict:(NSDictionary*)userDict
{
    if (userDict[@"nickname"])
    {
        return userDict[@"nickname"];
    }
    
    MOBIMUser *appUser = [[MOBIMUserManager sharedManager] usserInfoWithId:userDict[@"appUserId"]];
    if (appUser && appUser.nickname) {
        
        return appUser.nickname;
    }
    
    //取消在
    [[MOBIMUserManager sharedManager] fetchUserInfo:userDict[@"appUserId"] needNetworkFetch:YES completion:^(MOBIMUser *user, NSError *error) {
        
    }];
    
    return userDict[@"appUserId"];
}

- (void)handleNoticeMessageSucess:(MIMMessage*)message
{
    
}

- (MOBIMMessageStyle)messageStyle
{
    return MOBIMMessageStyleDefault;
}

- (BOOL)showInputBox
{
    
    return YES;
}

- (void)loadHistoryCacheData
{
    if (self.isRefresh == YES) {
        return;
    }
    self.isRefresh = YES;
    BOOL isFirstLoad = YES;

    if (self.lastMessage) {
        self.tableView.tableHeaderView = self.headRefreshView;
        [self.activityIndicator startAnimating];
        self.isRefresh = YES;

        isFirstLoad = NO;
    }


    NSMutableArray *firstCacheMessages = [NSMutableArray new];
    NSArray *cacheArray = [self cacheData:self.lastMessage pageSize:10];
    if (cacheArray && [cacheArray count] > 0) {

        for (MIMMessage *message in cacheArray) {
            //转换MOBIMChatMessageFrame 后再使用
            MOBIMChatMessageFrame *modelF = [[MOBIMChatMessageFrame alloc] init];
            modelF.modelNew = message;
            {
                MOBIMChatMessageExt *ext = [[MOBIMChatMessageExt alloc] init];
                ext.day = [NSString dayFromDateInt:message.timestamp];
                modelF.messageExt = ext;
            }
            [self topShowDateString:modelF];


            [firstCacheMessages insertObject:modelF atIndex:0];
        }

        //再进行时间(按天)归类
        if (firstCacheMessages && firstCacheMessages.count && self.messageStyle == MOBIMMessageStyleDefault) {

            //按时间进行分段
            NSMutableDictionary *dateSectionsDict = [NSMutableDictionary new];
            [firstCacheMessages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MOBIMChatMessageFrame *modelF = (MOBIMChatMessageFrame*)obj;
                if (modelF.messageExt) {
                    NSString *key = [NSString stringWithFormat:@"%d",modelF.messageExt.day];

                    if (dateSectionsDict[key]) {
                        modelF.messageExt.showDate = NO;
                    }else{
                        //每种分段的第一条显示时间
                        modelF.messageExt.showDate = YES;
                    }
                    modelF.messageExt.textContent = [[MOBIMMessageManager sharedManager] contentStringWithGroupExt:modelF.modelNew];

                    [dateSectionsDict setObject:key forKey:key];

//                    if (![sectionsIndexArray containsObject:key]) {
//                        [sectionsIndexArray addObject:key];
//                    }
                }
            }];
        }

        
        MOBIMWEAKSELF
        dispatch_async(self.commandQueue, ^{
            BOOL needShowScrollRow = NO;

//            MOBIMChatMessageFrame *oldFirstMessageFrame = nil;
            
            //考虑线程安全问题
            if (firstCacheMessages.count > 0) {
                needShowScrollRow = [weakSelf.dataArray count] > 0;
                
                MOBIMChatMessageFrame *messageFrame = self.dataArray.firstObject;
                if (messageFrame && (messageFrame.messageExt.day == [firstCacheMessages.lastObject messageExt].day)) {
                    messageFrame.messageExt.showDate = NO;
                    messageFrame = weakSelf.dataArray.firstObject;
                    
                    
                }
                
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0,firstCacheMessages.count)];
                
                //插入数据源中
                [self.dataArray insertObjects:firstCacheMessages atIndexes:indexSet];
                
                self.lastMessage = [self.dataArray.firstObject modelNew] ;

            }
            
            
            if (isFirstLoad) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    [weakSelf.tableView reloadData];
                    [weakSelf scrollToBottom];
                    
                    [weakSelf.activityIndicator stopAnimating];
                    weakSelf.tableView.tableHeaderView = nil;
                    weakSelf.isRefresh = NO;
                    
                });
                
            }else{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    
                    if (needShowScrollRow ==YES && firstCacheMessages && [firstCacheMessages count] > 0 && [self.dataArray count] > 0) {
                        [weakSelf.tableView reloadData];
                        
                        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([firstCacheMessages count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    }
                    
                    
                    [weakSelf.activityIndicator stopAnimating];
                    weakSelf.tableView.tableHeaderView = nil;
                    weakSelf.isRefresh = NO;
                    
                });
            }
            
        });

  


    }
    else
    {
        [self delayDisplayData];
    }
    
}

- (void)delayDisplayData
{
    MOBIMWEAKSELF

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf.activityIndicator stopAnimating];
        weakSelf.tableView.tableHeaderView = nil;
        weakSelf.isRefresh = NO;
        
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];

    //停止播放音频文件
    if (self.audioPath)
    {
        [[MOBIMAudioManager sharedManager] stopPlayAudio:self.audioPath];
    }
}




//分页获取缓存数据
- (NSArray*)cacheData:(MIMMessage*)lastMessage pageSize:(NSUInteger)pageSize
{
    
    return  [[MobIM getChatManager] fetchSingleChatMessagesByOtherId:self.to lastMessage:lastMessage pageSize:pageSize];
}

//会话，发送人
- (NSString *)from
{
    return [MOBIMUserManager sharedManager].currentUser.appUserId;
}

//会话，接收人
- (NSString *)to
{
    return nil;
}

- (MIMConversationType)currentMIMChatType
{
    return MIMConversationTypeSingle;
}


- (MOBIMChatRoomType)chatRoomType
{
    return MOBIMChatRoomTypeChat;
}

//底部输入控件控制器
- (MOBIMChatInputBoxViewController *) chatInputBoxVC
{
    if (_chatInputBoxVC == nil) {
        _chatInputBoxVC = [[MOBIMChatInputBoxViewController alloc] init];
        _chatInputBoxVC.delegate = self;
//        _chatInputBoxVC.view.backgroundColor = MOBIMRGB(0xEFEFF3);
        _chatInputBoxVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        _chatInputBoxVC.view.backgroundColor = KMOBIMCommonKeyboardColor;

    }
    return _chatInputBoxVC;
}


//加载ui
- (void)loadUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   self.tableView.backgroundColor = MOBIMRGB(0xEFEFF3);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillHide) name:UIMenuControllerWillHideMenuNotification object:nil];

    
    //注册cell
    [self.tableView registerClass:[MOBIMChatMessageTipsCell class] forCellReuseIdentifier:MOBIMChatMessageTypeTextTips];
    [self.tableView registerClass:[MOBIMChatMessageTextCell class] forCellReuseIdentifier:MOBIMChatMessageTypeText];
    [self.tableView registerClass:[MOBIMChatMessageAudioCell class] forCellReuseIdentifier:MOBIMChatMessageTypeAudio];
    [self.tableView registerClass:[MOBIMChatMessagePhotoCell class] forCellReuseIdentifier:MOBIMChatMessageTypePic];
    [self.tableView registerClass:[MOBIMChatMessageVideoCell class] forCellReuseIdentifier:MOBIMChatMessageTypeVideo];
    [self.tableView registerClass:[MOBIMChatMessageFileCell class] forCellReuseIdentifier:MOBIMChatMessageTypeFile];
    [self.tableView registerClass:[MOBIMChatSystemCell class] forCellReuseIdentifier:MOBIMChatMessageTypeSystem];
    
    [self.view addSubview:self.tableView];

    //加载自控制器与消息列表
    if ([self showInputBox]) {
        self.chatInputBoxVC.delegate=self;
        [self addChildViewController:self.chatInputBoxVC];
        [self.view addSubview:self.chatInputBoxVC.view];
    }


    self.tableView.tableHeaderView = self.headRefreshView;



    
    {
        UIView *subView = self.tableView;
        //子view的上边缘离父view的上边缘40个像素
        NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        //子view的左边缘离父view的左边缘40个像素
        NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        //子view的下边缘离父view的下边缘40个像素
        NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:(-KMOBIMHEIGHT_TABBAR-[self safeBottomHeight])];
        //子view的右边缘离父view的右边缘40个像素
        NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        
        self.tableBottomContraint = contraint3;
        
        //把约束添加到父视图上
        NSArray *array = [NSArray arrayWithObjects:contraint1, contraint2, contraint3, contraint4, nil];
        [self.view addConstraints:array];
    }

    if (_chatInputBoxVC && [_chatInputBoxVC.view superview])
    {
        UIView *subView = self.chatInputBoxVC.view;
        //子view的上边缘离父view的上边缘40个像素
        NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        //子view的左边缘离父view的左边缘40个像素
        NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        
        NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:MOIMDevice_Height];

        //子view的右边缘离父view的右边缘40个像素
        NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];



        //把约束添加到父视图上
        NSArray *array = [NSArray arrayWithObjects:contraint1, contraint2, contraint3, contraint4, nil];
        [self.view addConstraints:array];
    }

    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];

    //录音超过最长时间后的结束处理
    MOBIMWEAKSELF
    [self.recordHUD setMaxTimeBlock:^(MOBIMRecordHUD *recordHUD) {
        
        [[MOBIMAudioManager sharedManager] stopRecordingWithCompletion:^(NSString *recordPath) {
            
            int16_t duration = [[MOBIMAudioManager sharedManager] durationWithAudioPath:[NSURL fileURLWithPath:recordPath]];

            if ([recordPath isEqualToString:KMOBIMToshortRecord] || duration <= 0) {
                
                if ([recordPath isEqualToString:KMOBIMToshortRecord])
                {
                    [weakSelf voiceRecordSoShort];
                }
                [[MOBIMAudioManager sharedManager] removeCurrentRecordFile:weakSelf.chatInputBoxVC.recordName];
            } else {    // send voice message
                [weakSelf chatBoxViewController:nil sendAudioMessage:recordPath];
            }
        }];
        
      

    }];

    if ([self safeBottomHeight] > 0) {
        
        [self.view addSubview:self.bottomView];
        
        MOBIMWEAKSELF
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([weakSelf safeBottomHeight]);
            make.bottom.mas_equalTo(0);
            make.leading.trailing.mas_equalTo(0);
        }];
    }

}

- (UIView *)headRefreshView
{
    if (!_headRefreshView) {
        _headRefreshView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//        _headRefreshView.backgroundColor = [UIColor redColor];

        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.frame = CGRectMake(_headRefreshView.frame.size.width/2, 10, 20, 20);
        [_headRefreshView addSubview:_activityIndicator];
//        _headRefreshView.hidden = YES;
    }



    return _headRefreshView;
}


- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = KMOBIMCommonKeyboardColor;
    }
    
    return _bottomView;
}



- (MOBIMRecordHUD *)recordHUD {
    if (!_recordHUD) {
        _recordHUD = [[MOBIMRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 155, 155)];

        _recordHUD.hidden = YES;
        [self.view addSubview:_recordHUD];
        _recordHUD.center = CGPointMake(MOIMDevice_Width/2, MOIMDevice_Height/2);

    }
    [self.view bringSubviewToFront:_recordHUD];

    return _recordHUD;
}

- (UIImageView *)presentImageView
{
    if (!_presentImageView) {
        _presentImageView = [[UIImageView alloc] init];
    }
    return _presentImageView;
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        //        _tableView.contentInset = UIEdgeInsetsMake(-(HEIGHT_STATUSBAR+HEIGHT_NAVBAR), 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _tableView;
}



- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - Tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id tempMessageFrame = self.dataArray[indexPath.row];
    
    MOBIMChatMessageFrame *modelFrame     = (MOBIMChatMessageFrame *)tempMessageFrame;
    
    //系统或者时间消息消息cell
    if ([modelFrame.modelNew.body isKindOfClass:[MIMNoticeMessageBody class]])
    {
        MOBIMChatSystemCell *cell = [tableView dequeueReusableCellWithIdentifier:MOBIMChatMessageTypeSystem];
        cell.messageF              = modelFrame;
        
//        cell.contentView.backgroundColor = [UIColor redColor];
        return cell;

    }

    //其他消息cell
    NSString *messageType = [self cellReuseForMessage:modelFrame.modelNew];
    MOBIMBaseChatMessageCell *cell    = [tableView dequeueReusableCellWithIdentifier:messageType];
    if (cell)
    {
        cell.delegate         = self;
        cell.modelFrame                = modelFrame;
        
        //处理各种类型的消息
        [self handleMessageWithCell:cell];
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MOBIMChatMessageTypeUnkown];
        cell.textLabel.text = @"未知消息";
        
        return cell;
    }

    return cell;
}


- (void)handleMessageWithCell:(MOBIMBaseChatMessageCell*)cell
{
    MOBIMWEAKSELF
    //文本消息
    if ([cell isKindOfClass:[MOBIMChatMessageTextCell class]]) {
        
        [[(MOBIMChatMessageTextCell*)cell chatLabel] setHighlightTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
        }];
    }
    else   if ([cell isKindOfClass:[MOBIMChatMessageAudioCell class]]) {
        //音频消息

        [(MOBIMChatMessageAudioCell*)cell setAudioClickCompletion:^(MOBIMChatMessageFrame *modelFrame, UIImageView *audioIcon, UIView *redView) {
            [weakSelf handleAudioClickWithModelFrame:modelFrame audioIcon:audioIcon redView:redView];
        }];

    }
    else   if ([cell isKindOfClass:[MOBIMChatMessagePhotoCell class]]) {
        //图片消息

        [(MOBIMChatMessagePhotoCell*)cell setPhotoClickCompletion:^(MOBIMChatMessageFrame *modelFrame, UIButton *presentImageView, CGRect smallImageRect, CGRect bigImageRect) {
            [weakSelf handlePhotoClickWithModelFrame:modelFrame presentImageView:presentImageView smallImageRect:smallImageRect bigImageRect:bigImageRect];

        }];

    }
    else   if ([cell isKindOfClass:[MOBIMChatMessageFileCell class]]) {
        //文件消息

        [(MOBIMChatMessageFileCell*)cell setFileClickCompletion:^(MOBIMChatMessageFrame *modelFrame, NSString *filePath, UIButton *fileBtn) {
            [weakSelf handleFileClickWithModelFrame:modelFrame filePath:filePath fileBtn:fileBtn];
        }];

    }
    else   if ([cell isKindOfClass:[MOBIMChatMessageVideoCell class]]) {
        //视频消息

        [(MOBIMChatMessageVideoCell*)cell setVideoClickCompletion:^(MOBIMChatMessageFrame *modelFrame, NSString *path, UIImage *thumbnailImage,BOOL localUrl) {

            [weakSelf handleVideoClickWithModelFrame:modelFrame filePath:path thumbnail:thumbnailImage localUrl:localUrl];
        }];

    }
}


//处理视频点击
- (void)handleVideoClickWithModelFrame:(MOBIMChatMessageFrame*)modelFrame filePath:(NSString*)filePath thumbnail:(UIImage*)thumbnailImage localUrl:(BOOL)isLocalUrl
{

    /*
    //网页视频
    AVPlayer *player1 = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
    //2、创建视频播放视图的控制器
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
    //3、将创建的AVPlayer赋值给控制器自带的player
    playerVC.player = player1;
    //4、跳转到控制器播放
    [self presentViewController:playerVC animated:YES completion:nil];
    [playerVC.player play];
    */
    
    //更新状态
//    [[MobIM getChatManager] updateMessageToReaded:modelFrame.modelNew];
    

    [self.chatInputBoxVC resetToBottomWithNoAnimation:NO];

    MOBIMVideoPlayerView *playerView = nil;
    if (isLocalUrl) {
       playerView = [[MOBIMVideoPlayerView alloc] initWithUrl:[NSURL fileURLWithPath:filePath] thumbnail:thumbnailImage isLocalUrl:isLocalUrl];

    }else{
       playerView = [[MOBIMVideoPlayerView alloc] initWithUrl:[NSURL URLWithString:filePath] thumbnail:thumbnailImage isLocalUrl:isLocalUrl];

    }

    playerView.frame = [UIApplication sharedApplication].keyWindow.bounds;


    //添加播放器到视图
    [[UIApplication sharedApplication].keyWindow addSubview:playerView];


}

//处理文件点击
- (void)handleFileClickWithModelFrame:(MOBIMChatMessageFrame*)modelFrame filePath:(NSString*)filePath fileBtn:(UIButton*)fileBtn
{

    //更新状态
    //[[MobIM getChatManager] updateMessageToReaded:modelFrame.modelNew];
    
    MOBIMIDocumentReaderController *readController = [[MOBIMIDocumentReaderController alloc] init];
    readController.filePath              = filePath;
    readController.orgName               = filePath.lastPathComponent;
    [self.navigationController pushViewController:readController animated:YES];
}


//处理音频点击
- (void)handleAudioClickWithModelFrame:(MOBIMChatMessageFrame*)modelFrame audioIcon:(UIImageView*)audioIcon redView:(UIView*)redView
{

    MOBIMAudioManager *recordManager = [MOBIMAudioManager sharedManager];
    recordManager.audioPlayDelegate = self;

    if (modelFrame.modelNew) {
        MIMMessage *message = modelFrame.modelNew;
        MIMVoiceMessageBody *body = (MIMVoiceMessageBody*)message.body;
        MOBIMAudioManager *manager = [MOBIMAudioManager sharedManager];


        BOOL hasFile = NO;
        NSString *audioPath = nil;
        if (message.direction == MIMMessageDirectionSend) {
            //优先考虑本地发送的本地图片
            if ([MOBIMFileManager fileExistsAtPath:modelFrame.messageExt.localFilePath1])
            {
                audioPath = modelFrame.messageExt.localFilePath1;
                //播放
                if (body.isListened == NO) {
                    //message.isRead = YES;
                    [[MobIM getChatManager] updateVoiceMessageToListened:modelFrame.modelNew];

                    redView.hidden = YES;
                }
                
                hasFile = YES;
            }
            
        }
        
        if (!audioPath) {
            //发送
            if (message.direction == MIMMessageDirectionSend) {
                //优先考虑本地发送的本地图片-SDK保存的图片地址
                if ([MOBIMFileManager fileExistsAtPath:body.localPath])
                {
                    audioPath = body.localPath;
                    //播放
                    if (body.isListened == NO) {
                        //message.isRead = YES;
                        [[MobIM getChatManager] updateVoiceMessageToListened:modelFrame.modelNew];

                        redView.hidden = YES;
                    }
                    
                    hasFile = YES;
                    
                }
                
            }
            
        }
        
        

        //网络地址缓存到本地的音频
        NSString *destination = [manager audioLocalPathWithAudioURLString:body.remotePath];
        
        if (!audioPath) {

            if ([MOBIMFileManager fileExistsAtPath:destination])
            {
                audioPath = destination;
                //播放
                if (body.isListened == NO) {
                    //message.isRead = YES;
                    [[MobIM getChatManager] updateVoiceMessageToListened:modelFrame.modelNew];

                    
                    redView.hidden = YES;
                }

                hasFile = YES;
            }
            else
            {
                audioPath = [[MOBIMAudioManager sharedManager] audioLocalPathWithExtention:body.remotePath.pathExtension URLString:body.remotePath];
                if ([MOBIMFileManager fileExistsAtPath:audioPath])
                {
                    hasFile = YES;
                }

            }
        }

        
        if (audioPath && hasFile)
        {
            //暂时只支持amr 转wav
            if ([audioPath hasSuffix:KMOBIMChatMessageAudioAMRType])
            {
                NSString *amrPath   = [[audioPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"amr"];
                int sucess = [MOBIMVoiceConverter ConvertAmrToWav:amrPath wavSavePath:destination];
                
                //播放
                if (sucess == 1) {
                    //message.isRead = YES;
                    [[MobIM getChatManager] updateVoiceMessageToListened:modelFrame.modelNew];
                    
                    redView.hidden = YES;
                    
                    audioPath = destination;
                }

            }


            if ([self.audioPath isEqualToString:audioPath]) { // the same recoder
                self.audioPath = nil;
                [[MOBIMAudioManager sharedManager] stopPlayAudio:audioPath];
                [audioIcon stopAnimating];
                self.currentVoiceIcon = nil;
                return;
            } else {
                [self.currentVoiceIcon stopAnimating];
                self.currentVoiceIcon = nil;
            }

            [[MOBIMAudioManager sharedManager] startPlayAudio:audioPath];
            [audioIcon startAnimating];
            self.audioPath = audioPath;
            self.currentVoiceIcon = audioIcon;
        }else{
            //开始下载音频
            if (body.remotePath)
            {
                NSString *destination = [[MOBIMAudioManager sharedManager] audioLocalPathWithExtention:body.remotePath.pathExtension URLString:body.remotePath];
                
                [[MOBIMDownloadManager instance] downloadFileWithURLString:body.remotePath destination:destination progress:^(NSProgress * _Nonnull progress, MOBIMDownloadResponse * _Nonnull response) {
                    
                } success:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull url) {
                    
                    
                } faillure:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                    
                }];
            }

        }




    }

}

//处理图片点击
- (void)handlePhotoClickWithModelFrame:(MOBIMChatMessageFrame*)modelFrame presentImageView:(UIButton*)cellPresentView smallImageRect:(CGRect)smallImageRect bigImageRect:(CGRect)bigImageRect
{
    //更新状态
//    [[MobIM getChatManager] updateMessageToReaded:modelFrame.modelNew];

    //[self.chatInputBoxVC resignFirstResponder];
    
    BOOL isFirtResponder = [self.chatInputBoxVC.chatInputBox.textView isFirstResponder];
    [self.chatInputBoxVC resetToBottomWithNoAnimation:NO];


    self.cellPresentView = cellPresentView;

    //记录动画在 keyWindow 中的大小rect
    _smallRect = smallImageRect;
    _bigRect = bigImageRect;

    if (modelFrame.modelNew) {
        //大图
        UIImage *image = nil;

        //缩略图
        UIImage *thumnailImage = nil;

        MIMMessage *message = modelFrame.modelNew;
        MIMImageMessageBody *body = (MIMImageMessageBody*)message.body;
        MOBIMImageManager *manager = [MOBIMImageManager sharedManager];
        //发送
        if (message.direction == MIMMessageDirectionSend) {

            //优先考虑本地发送的本地图片
            image = [manager imageWithLocalPath:body.localPath];

        }

        //获取网络大图在本地的缓存
        if (!image) {
            NSString *destination = [[MOBIMImageManager sharedManager] originImgPathWithImageURLString:body.thumbnailRemotePath];
            image = [manager imageWithLocalPath:destination];

            //没有大图缓存，只能使用缩略图
            if (!image) {
                thumnailImage = cellPresentView.currentBackgroundImage;
            }
        }

        //显示大图
        [self showLargeImageWithImage:image thumnailImage:thumnailImage withURLString:body.thumbnailRemotePath animation:!isFirtResponder];


    }

}

//显示大图
- (void)showLargeImageWithImage:(UIImage *)image
                           thumnailImage:(UIImage *)thumnailImage
                  withURLString:(NSString *)urlString
                      animation:(BOOL)animation
{

    
    MOBIMPhotoBrowserController *photoVC = [[MOBIMPhotoBrowserController alloc] initWithThumnailImage:thumnailImage image:image imageUrl:urlString];

    self.presentImageView.image       = image ? image :thumnailImage;
    
    if (animation)
    {
        photoVC.transitioningDelegate     = self;
        photoVC.modalPresentationStyle    = UIModalPresentationCustom;
    }

    [self presentViewController:photoVC animated:YES completion:nil];
}

//显示大图
- (void)showLargeImageWithPath:(NSString *)imgPath
                  withMessageF:(MOBIMChatMessageFrame *)modelFrame
{
    UIImage *image = [[MOBIMImageManager sharedManager] imageWithLocalPath:imgPath];
    if (image == nil) {
        return;
    }
    MOBIMPhotoBrowserController *photoVC = [[MOBIMPhotoBrowserController alloc] initWithImage:image];
    self.presentImageView.image       = image;
    photoVC.transitioningDelegate     = self;
    photoVC.modalPresentationStyle    = UIModalPresentationCustom;
    [self presentViewController:photoVC animated:YES completion:nil];
}


- (NSString *)mediaPath:(NSString *)originPath
{
    // 这里文件路径重新给，根据文件名字来拼接
    NSString *name = [[originPath lastPathComponent] stringByDeletingPathExtension];
    return [[MOBIMAudioManager sharedManager] receiveVoicePathWithFileKey:name];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOBIMChatMessageFrame *messageF = [self.dataArray objectAtIndex:indexPath.row];
    //考虑特时间显示的殊性
//    CGFloat resultHeight = messageF.cellHeight + (messageF.messageExt.showDate ? 25 :0);

    return [messageF calCellHeight:self.messageStyle];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.chatInputBoxVC resignFirstResponder];
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {

    if ([cell isKindOfClass:[MOBIMChatMessageVideoCell class]] && self) {
        MOBIMChatMessageVideoCell *videoCell = (MOBIMChatMessageVideoCell *)cell;
        [videoCell stopVideo];
    }
}



#pragma mark 发送消息


//系统消息
- (void)sendDateTextMessageWithText:(NSString*)text isSender:(BOOL)isSender
{

    if (text && text.length > 0) {

        MOBIMChatMessageFrame *chatMessageFrame = [MOBIMChatMessageFrame createMessageNewFrame:self.currentMIMChatType bodyType:MIMMessageBodyTypeText content:text path:nil from:self.from to:self.to fileKey:nil isSender:isSender receivedSenderByYourself:NO];
        [self addObject:chatMessageFrame isSender:isSender];
        


        if (isSender == YES) {
            [self messageSendSucced:chatMessageFrame];
        }
    }
}

//系统消息
- (void)sendSystemTextMessageWithText:(NSString*)text isSender:(BOOL)isSender
{

    if (text && text.length > 0) {

        MOBIMChatMessageFrame *chatMessageFrame = [MOBIMChatMessageFrame createMessageNewFrame:self.currentMIMChatType bodyType:MIMMessageBodyTypeText content:text path:nil from:self.from to:self.to fileKey:nil isSender:isSender receivedSenderByYourself:NO];
        [self addObject:chatMessageFrame isSender:isSender];


        if (isSender == YES) {
            [self messageSendSucced:chatMessageFrame];
        }
    }
}


//发送文本消息
- (void)sendTextMessageWithText:(NSString*)text isSender:(BOOL)isSender
{

    if (text && text.length > 0) {

        MOBIMChatMessageFrame *chatMessageFrame = [MOBIMChatMessageFrame createMessageNewFrame:self.currentMIMChatType bodyType:MIMMessageBodyTypeText content:text path:nil from:self.from to:self.to fileKey:nil isSender:isSender receivedSenderByYourself:NO];
        [self addObject:chatMessageFrame isSender:isSender];

        [self sendMessage:chatMessageFrame];

    }
}


- (void)sendMessage:(MOBIMChatMessageFrame*)chatMessageFrame
{
    if (self.currentMIMChatType == MIMConversationTypeGroup)
    {
        MOBIMWEAKSELF
        [[MobIM getChatManager] sendMessage:chatMessageFrame.modelNew completion:^(MIMMessage *message, MIMError *error) {
            
            chatMessageFrame.modelNew = message;
            [weakSelf messageSendSucced:chatMessageFrame];

        }];
        
        
    }
    else if (self.currentMIMChatType == MIMConversationTypeSingle)
    {
        MOBIMWEAKSELF
        [[MobIM getChatManager] sendMessage:chatMessageFrame.modelNew completion:^(MIMMessage *message, MIMError *error) {
            
            chatMessageFrame.modelNew = message;
            [weakSelf messageSendSucced:chatMessageFrame];
            

        }];
    }
}




- (NSString *)cellReuseForMessage:(MIMMessage*)message
{
    if (message.conversationType == MIMConversationTypeSystem)
    {
        if (message.body.type == MIMMessageBodyTypeText) {
            return MOBIMChatMessageTypeTextTips;
        }
    }
    
    return [self cellReuseForBodyType:message.body.type];
}

- (NSString *)cellReuseForBodyType:(MIMMessageBodyType)bodyType
{
    if (bodyType == MIMMessageBodyTypeText) {
        return MOBIMChatMessageTypeText;
    }else if (bodyType == MIMMessageBodyTypeImage) {
        return MOBIMChatMessageTypePic;
    }else if (bodyType == MIMMessageBodyTypeVoice) {
        return MOBIMChatMessageTypeAudio;
    }else if (bodyType == MIMMessageBodyTypeVideo) {
        return MOBIMChatMessageTypeVideo;
    }else if (bodyType == MIMMessageBodyTypeFile) {
        return MOBIMChatMessageTypeFile;
    }

    return MOBIMChatMessageTypeText;
}

//发送音频消息
- (void)sendAudioMessageWithAudioPath:(NSString*)audioPath isSender:(BOOL)isSender
{

    if (audioPath && audioPath.length > 0) {
        
        MOBIMChatMessageFrame *chatMessageFrame = [MOBIMChatMessageFrame createMessageNewFrame:self.currentMIMChatType bodyType:MIMMessageBodyTypeVoice content:@"[语音]" path:audioPath from:self.from to:self.to fileKey:nil isSender:isSender receivedSenderByYourself:NO];
        
        [self addObject:chatMessageFrame isSender:isSender];
        [self sendMessage:chatMessageFrame];
        


    }
}


//发送照片消息
- (void)sendPhotoMessageWithImagePath:(NSString*)imagePath isSender:(BOOL)isSender
{

    if (imagePath && imagePath.length > 0) {


        MOBIMChatMessageFrame *chatMessageFrame = [MOBIMChatMessageFrame createMessageNewFrame:self.currentMIMChatType bodyType:MIMMessageBodyTypeImage content:@"[图片]" path:imagePath from:self.from to:self.to fileKey:nil isSender:isSender receivedSenderByYourself:NO];


        [self addObject:chatMessageFrame isSender:YES];
        [self sendMessage:chatMessageFrame];

    }
}

//发送视频消息b
- (void)sendVideoMessageWithVideoPath:(NSString*)videoPath isSender:(BOOL)isSender
{

    if (videoPath && videoPath.length > 0) {

        MOBIMChatMessageFrame *chatMessageFrame = [MOBIMChatMessageFrame createMessageNewFrame:self.currentMIMChatType bodyType:MIMMessageBodyTypeVideo content:@"[视频]" path:videoPath from:self.from to:self.to fileKey:nil isSender:isSender receivedSenderByYourself:NO];
        
        [self addObject:chatMessageFrame isSender:isSender];
        [self sendMessage:chatMessageFrame];
    }
}


//将消息添加到数组中
- (void)addObject:(MOBIMChatMessageFrame *)messageF
         isSender:(BOOL)isSender
{

    
    MOBIMWEAKSELF
    dispatch_async(self.commandQueue, ^{
        

        if (!weakSelf.lastMessage) {
            
            weakSelf.lastMessage = messageF.modelNew;
        }

        if (weakSelf.messageStyle != MOBIMMessageStyleTips) {
            
            MOBIMChatMessageFrame *messageFrame = weakSelf.dataArray.lastObject;
            if (messageFrame) {
                
                messageF.messageExt.day = [NSString dayFromDateInt:messageF.modelNew.timestamp];
                
                
                if (messageFrame.messageExt.day != messageF.messageExt.day) {
                    
                    messageF.messageExt.showDate = YES;
                    
                    if (messageF.modelNew) {
                        
                        messageF.messageExt.showDateString = [NSString dateIntToDateString:messageFrame.modelNew.timestamp isList:NO];
                    }else{
                        
                        
                        messageF.messageExt.showDateString = [NSString dateIntToDateString:messageFrame.modelNew.timestamp isList:NO];
                        
                    }
                }else{
                    messageF.messageExt.showDateString = messageFrame.messageExt.showDateString;
                    
                }
            }else{
                
                messageF.messageExt.day = [NSString dayFromDateInt:messageF.modelNew.timestamp];
                
                
                if (messageFrame.messageExt.day != messageF.messageExt.day) {
                    
                    messageF.messageExt.showDate = YES;
                    
                    
                    messageF.messageExt.showDateString = [NSString dateIntToDateString:messageF.modelNew.timestamp isList:NO];
                }else{
                    messageF.messageExt.showDateString = messageF.messageExt.showDateString;
                    
                }
                
                
            }
        }

        
        [weakSelf.dataArray addObject:messageF];
        
        
        [weakSelf performMainBlock:^{

            [weakSelf.tableView reloadData];
            //    if (isSender || self.isKeyBoardAppear) {
            [weakSelf scrollToBottom];
            //    }
        }];
        
    });
    

}

//消息发送成功状态更新
- (void)messageSendSucced:(MOBIMChatMessageFrame *)messageF
{
    [self performMainBlock:^{
        [self.tableView reloadData];
        
        if (messageF.modelNew.direction == MIMMessageDirectionSend || self.isKeyBoardAppear) {
            [self scrollToBottom];
        }

    }];

}

//滑动到底部
- (void) scrollToBottom
{
    if (self.dataArray.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.chatInputBoxVC resignFirstResponder];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < 0  && _isRefresh==NO)
    {
        [self loadHistoryCacheData];
    }
}


- (NSString *)audioRecordPath
{

    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *randName = [NSString stringWithFormat:@"%ld",(long)timeInterval];

    NSString *path = [MOBIMFileManager createPathWithChildPath:KMOBIMChatMessageAudioRecordPath];
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",randName,KMOBIMChatMessageAudioType]];
}



- (void)selectedFileName:(NSString *)fileName
{

    [self sendFileMessageWithFileName:fileName isSender:YES data:nil];

}


- (void)sendFileMessageWithFileName:(NSString*)fileName isSender:(BOOL)isSender data:(NSData *)data
{

    if (fileName && fileName.length > 0) {

        NSString *lastName = [fileName originName];
        NSString *fileKey   = [fileName firstStringSeparatedByString:@"_"];
        NSString *content = [NSString stringWithFormat:@"[文件]%@",lastName];


        MOBIMChatMessageFrame *chatMessageFrame = [MOBIMChatMessageFrame createMessageNewFrame:self.currentMIMChatType bodyType:MIMMessageBodyTypeFile content:content path:fileName from:self.from to:self.to fileKey:fileKey isSender:isSender receivedSenderByYourself:NO filedata:data];

        [self addObject:chatMessageFrame isSender:isSender];
        [self sendMessage:chatMessageFrame];
       
    }
}


- (void)sendPhotoMessage:(UIImage*)image imagePath:(NSString *)imgPath
{
    if (image && imgPath) {

        [self sendPhotoMessageWithImagePath:imgPath isSender:YES];

    }
}


#pragma mark - MOBIMChatInputBoxViewController
- (void) chatBoxViewController:(MOBIMChatInputBoxViewController *)chatboxViewController
               sendTextMessage:(NSString *)message
{
    [self sendTextMessageWithText:message isSender:YES];
}


- (void) chatBoxViewController:(MOBIMChatInputBoxViewController *)chatboxViewController
              sendImageMessage:(UIImage *)image
                     imagePath:(NSString *)imgPath
{

    if (image && imgPath) {

        [self sendPhotoMessageWithImagePath:imgPath isSender:YES];

    }

     //test
    //[self handleVideoClickWithModelFrame:nil filePath:nil thumbnail:image];
}

- (void) chatBoxViewController:(MOBIMChatInputBoxViewController *)chatboxViewController sendAudioMessage:(NSString *)audioPath
{
    [self.recordHUD voiceDidSend];
    
    int16_t duration = [[MOBIMAudioManager sharedManager] durationWithAudioPath:[NSURL fileURLWithPath:audioPath]];
    if (duration > 0) {
        
        [self sendAudioMessageWithAudioPath:audioPath isSender:YES];

    }

}


- (void) chatBoxViewController:(MOBIMChatInputBoxViewController *)chatboxViewController sendVideoMessage:(NSString *)videoPath
{
    if (videoPath) {

        [self sendVideoMessageWithVideoPath:videoPath isSender:YES];

    }
}
//
- (void) chatBoxViewController:(MOBIMChatInputBoxViewController *)chatboxViewController sendFileMessage:(NSString *)fileName data:(NSData *)data
{
    [self sendFileMessageWithFileName:fileName isSender:YES data:data];
}




- (void) voiceDidStartRecording
{
    [self.recordHUD voiceDidStartRecording];

}

- (void) voiceRecordSoShort
{
    [self.recordHUD voiceRecordSoShort];
}

- (void) voiceWillDragout:(BOOL)inside
{

    [self.recordHUD voiceWillDragout:inside];

}

- (void) voiceDidCancelRecording
{
    [self.recordHUD voiceDidCancelRecording];
}


#pragma mark -MOBIMBaseChatMessageCellDelegate
- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer
{
    
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        

        
        CGPoint location       = [longRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        _longIndexPath         = indexPath;
        id object              = [self.dataArray objectAtIndex:indexPath.row];
        if (![object isKindOfClass:[MOBIMChatMessageFrame class]]) return;
        
        MIMMessageBody *body = [(MOBIMChatMessageFrame*)object modelNew].body;
        if (body.type == MIMMessageBodyTypeText) {
            
            self.cellLongPressType = MOBIMCellLongPressTypeCyDel;
        }else
        {
            self.cellLongPressType = MOBIMCellLongPressTypeDel;

        }
        self.chatInputBoxVC.chatInputBox.textView.isCellLongPress = YES;
        
        MOBIMBaseChatMessageCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath message:cell.modelFrame.modelNew];
    }

}

- (void)headImageClicked:(NSString *)userId
{

}


- (void)retrySendMessage:(MOBIMBaseChatMessageCell *)messageCell
{
    //[self sendMessage:messageCell.modelFrame];
    
    MOBIMChatMessageFrame *chatMessageFrame = messageCell.modelFrame;
    
    if (self.currentMIMChatType == MIMConversationTypeGroup)
    {
        MOBIMWEAKSELF
        [[MobIM getChatManager] sendMessage:chatMessageFrame.modelNew completion:^(MIMMessage *message, MIMError *error) {
            
            chatMessageFrame.modelNew = message;
            
            [weakSelf performMainBlock:^{
                
                [messageCell setModelFrame:messageCell.modelFrame];
                
            }];
            
        }];
        
        
    }
    else if (self.currentMIMChatType == MIMConversationTypeSingle)
    {
        MOBIMWEAKSELF
        [[MobIM getChatManager] sendMessage:chatMessageFrame.modelNew completion:^(MIMMessage *message, MIMError *error) {
            
            chatMessageFrame.modelNew = message;
            
            [weakSelf performMainBlock:^{

                [messageCell setModelFrame:messageCell.modelFrame];
            }];
            
            
        }];
    }
    
    //更新对应消息显示状态
    [messageCell setModelFrame:messageCell.modelFrame];
    
}

#pragma mark MOBIMAudioManagerDelegate
- (void)audioDidPlayFinished
{
    MOBIMAudioManager *manager = [MOBIMAudioManager sharedManager];
    manager.audioPlayDelegate = nil;
    [self.currentVoiceIcon stopAnimating];
    self.currentVoiceIcon = nil;
    self.audioPath = nil;

}




#pragma mark - UIViewControllerTransitioningDelegate  图片消息动画

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{

    self.presentFlag = YES;
    return self;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presentFlag = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.presentFlag) {
        UIView *toView              = [transitionContext viewForKey:UITransitionContextToViewKey];
        self.presentImageView.frame = _smallRect;
        self.cellPresentView.hidden = YES;

        [[transitionContext containerView] addSubview:self.presentImageView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            self.presentImageView.frame = _bigRect;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.presentImageView removeFromSuperview];
                [[transitionContext containerView] addSubview:toView];
                [transitionContext completeTransition:YES];


            }
        }];
    } else {
        MOBIMPhotoBrowserController *photoVC = (MOBIMPhotoBrowserController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIImageView *iv     = photoVC.imageView;
        UIView *fromView    = [transitionContext viewForKey:UITransitionContextFromViewKey];
        iv.center = fromView.center;
        [fromView removeFromSuperview];
        [[transitionContext containerView] addSubview:iv];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            iv.frame = _smallRect;
        } completion:^(BOOL finished) {
            if (finished) {
                [iv removeFromSuperview];
                [transitionContext completeTransition:YES];
                self.cellPresentView.hidden = NO;

            }
        }];
    }
}


#pragma mark -长按操作

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath message:(MIMMessage *)messageModel
{
    UIMenuItem *chatCopyMenuItem   = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage:)];
    UIMenuItem *deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    
    
    if (messageModel.body.type == MIMMessageBodyTypeText)
    {
        [[UIMenuController sharedMenuController] setMenuItems:@[chatCopyMenuItem,deleteMenuItem]];
    }
    else
    {
        [[UIMenuController sharedMenuController] setMenuItems:@[deleteMenuItem]];

    }

    [[UIMenuController sharedMenuController] setTargetRect:showInView.frame inView:showInView.superview ];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if (self.cellLongPressType == MOBIMCellLongPressTypeCyDel) {
     
        if (action == @selector(copyMessage:) || action == @selector(deleteMessage:) ) {
            return YES;
        }
    }else if (self.cellLongPressType == MOBIMCellLongPressTypeDefault)
    {
        return NO;
    }
    else{
        if (action == @selector(deleteMessage:) ) {
            return YES;
        }
    }

    return NO;
}

//考虑消息
- (void)copyMessage:(UIMenuItem *)copyMenuItem
{
    UIPasteboard *pasteboard  = [UIPasteboard generalPasteboard];
    MOBIMChatMessageFrame * messageF = [self.dataArray objectAtIndex:_longIndexPath.row];
    if (messageF.modelNew) {
        if (messageF.modelNew.body.type == MIMMessageBodyTypeText) {
            
            pasteboard.string         = [(MIMTextMessageBody*)messageF.modelNew.body text];

        }
    }
}

//删除消息
- (void)deleteMessage:(UIMenuItem *)deleteMenuItem
{
    
    MOBIMWEAKSELF
    dispatch_async(self.commandQueue, ^{
        
        // 这里还应该把本地的消息附件删除
        MOBIMChatMessageFrame * messageF = [weakSelf.dataArray objectAtIndex:_longIndexPath.row];
        [self statusChanged:messageF];
        
    });

}



- (void)statusChanged:(MOBIMChatMessageFrame *)messageF
{
    [self.dataArray removeObject:messageF];
    
    [self performMainBlock:^{
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[_longIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
    }];
    
    //数据库更新
    if (messageF.modelNew)
    {
        [[MobIM getChatManager] deleteMessages:[NSArray arrayWithObjects:messageF.modelNew, nil]];
    }
    

}


#pragma mark - ICChatBoxViewControllerDelegate
- (void) chatBoxViewController:(MOBIMChatInputBoxViewController *)chatboxViewController
        didChangeChatBoxHeight:(CGFloat)height
{

    
    //NSLog(@"---begin-%f----",self.tableBottomContraint.constant );
    float bottom =  - height ;
    //NSLog(@"---end-%f----",bottom );

    //更新
//    [self.view removeConstraint:self.tableBottomContraint];
    
    [self.tableBottomContraint setConstant:bottom];
//    self.tableBottomContraint = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bottom];
//    [self.view addConstraint:self.tableBottomContraint];


    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    
    
    if (height == KMOBIMHEIGHT_TABBAR) {
        [self.tableView reloadData];
        _isKeyBoardAppear  = NO;
    } else {
        [self scrollToBottom];
        _isKeyBoardAppear  = YES;
    }
    if (self.textView == nil) {
        self.textView = chatboxViewController.chatInputBox.textView;
    }
}


- (BOOL)willBackToRootWithAlertTag:(NSInteger)tag
{
    return YES;
}


- (void)menuControllerWillHide
{
    self.cellLongPressType = MOBIMCellLongPressTypeDefault;
    self.chatInputBoxVC.chatInputBox.textView.isCellLongPress = NO;
}
@end
