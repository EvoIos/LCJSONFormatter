//
//  LCStructInfo.m
//  XcodePlguinDemo
//
//  Created by z on 16/6/7.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCStructInfo.h"

@implementation LCStructInfo
- (instancetype)initWithStructNameKey:(NSString *)structNameKey StructName:(NSString *)structName StructDic:(NSDictionary *)structDic
{
    self = [super init];
    if (self) {
        self.structNameKey = structNameKey;
        self.structName = structName;
        self.structDic = structDic;
    }
    
    return self;
}

- (NSMutableDictionary *)infoDic {
    if (_infoDic == nil) {
        _infoDic = [[NSMutableDictionary alloc] init];
    }
    return  _infoDic;
}

@end
