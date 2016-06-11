//
//  LCPbxprojectInfo.m
//  LCJSONFormatter
//
//  Created by zhenglanchun on 16/6/11.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCPbxprojectInfo.h"

static LCPbxprojectInfo *instance;

@implementation LCPbxprojectInfo
+(instancetype)shareInstance{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[LCPbxprojectInfo alloc] init];
    });
    return instance;
}

/**
 *  get classprefix/organizationname/productname from project.pbxproj 
 *
 *  @param path xproject path
 */
-(void)setParamsWithPath:(NSString *)path{
    if ([[path stringByDeletingLastPathComponent] hasSuffix:@"Pods.xcodeproj"]) {
        return;
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    for (NSString *key in dic[@"objects"]) {
        id obj = dic[@"objects"][key];
        if  ([obj objectForKey:@"attributes"]) {
            _classPrefix = obj[@"attributes"][@"CLASSPREFIX"];
            _organizationName = obj[@"attributes"][@"ORGANIZATIONNAME"];
            
        } else if ([obj objectForKey:@"productName"]) {
            _productName = obj[@"productName"];
            
        }
    }
}

@end
