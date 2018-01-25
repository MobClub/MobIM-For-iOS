//
//  MIMMessageBody+CoreDataClass.h
//  MobIM
//
//  Created by youzu on 2017/9/12.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MIMDefine.h"

NS_ASSUME_NONNULL_BEGIN
/**
 消息体基类
 */
@interface MIMMessageBody : NSManagedObject

# pragma mark - Type Transient

/**
 消息体类型
 */
@property (nonatomic, assign) MIMMessageBodyType type;

@end

NS_ASSUME_NONNULL_END
