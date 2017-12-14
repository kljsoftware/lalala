//
//  RKBIEvent.h
//  RKSDKBITest
//
//  Created by rekoo on 2017/3/27.
//  Copyright © 2017年 rekoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKBIEvent : NSObject


/**
 添加action事件
 
 @param action 统计事件
 */
+ (nonnull RKBIEvent *)rkBIAddAction:(nonnull NSString *)action;

/**
 添加action事件对应的参数值
 
 @param key key
 @param value value
 */
- (void)rkBIAddEvent:(nonnull NSString *)key value:(nullable NSString *)value;






@end
