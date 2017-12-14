//
//  RKBINetworkManager.h
//  RKSDKBITest
//
//  Created by rekoo on 2017/3/27.
//  Copyright © 2017年 rekoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKBINetworkManager : NSObject

/**
 *  发送Init的BI数据
 */
+ (void)sendInitBIRequest;

/**
 *  发送网络请求
 */
+ (void)sendBIRequest;



@end
