//
//  LCStructInfo.h
//  XcodePlguinDemo
//
//  Created by z on 16/6/7.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCStructInfo : NSObject

/**
 *  object name after JSON parsing
 */
@property (nonatomic, copy) NSString *structName;

/**
 *  key in JSON node
 */
@property (nonatomic, copy) NSString *structNameKey;

/**
 *  dic of JSON
 */
@property (nonatomic, strong) NSDictionary *structDic;

//mutableDic
/**
 *  information of JSON and object
 *  key: JSON node, value: object name
 */
@property (nonatomic, strong) NSMutableDictionary *infoDic;


- (instancetype)initWithStructNameKey:(NSString *)structNameKey StructName:(NSString *)structName StructDic:(NSDictionary *)structDic;


@end
