//
//  LCPbxprojectInfo.h
//  LCJSONFormatter
//
//  Created by zhenglanchun on 16/6/11.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCPbxprojectInfo : NSObject
@property (nonatomic, copy, readonly) NSString *classPrefix;
@property (nonatomic, copy, readonly) NSString *organizationName;
@property (nonatomic, copy, readonly) NSString *productName;

+(instancetype)shareInstance;
-(void)setParamsWithPath:(NSString *)path;
@end
