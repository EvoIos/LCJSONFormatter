//
//  LCJSONFormatter.h
//  LCJSONFormatter
//
//  Created by zhenglanchun on 16/6/11.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface LCJSONFormatter : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end