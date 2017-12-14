//
//  RKBIPlatform.h
//  RKSDKBITest
//
//  Created by rekoo on 2017/3/24.
//  Copyright © 2017年 rekoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKBIEvent.h"

@interface RKBIPlatform : NSObject

/**
 *  单例
 *
 *  @return 实例
 */
+(nonnull instancetype)getInstance;

/**
 *  初始化
 */
- (void)rkInit;

/**
 发送BI数据到服务器

 @param event BI数据
 */
+ (void)rkTrackEvent:(nonnull RKBIEvent *)event;







@end
