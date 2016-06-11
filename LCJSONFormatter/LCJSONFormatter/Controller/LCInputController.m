//
//  LCInputController.m
//  XcodePlguinDemo
//
//  Created by z on 16/6/6.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCInputController.h"
#import "LCDialogController.h"
#import "LCStructInfo.h"

@interface LCInputController ()<NSTextViewDelegate,NSWindowDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *inputTextView;


@end

@implementation LCInputController

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (IBAction)cancel:(NSButton *)sender {
    [self close];
}

- (IBAction)enter:(NSButton *)sender {
    id result = [self dictionaryWithJsonStr:self.inputTextView.string];
    
    if ([result isKindOfClass:[NSError class]]) {
        NSError *error = result;
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
    } else {
        LCStructInfo *structInfo = [self handleJsonResult:result];
        [[NSNotificationCenter defaultCenter] postNotificationName:LCFormatResultNotification object:structInfo];
        [self close];

    }
}

#pragma mark - help private func
- (LCStructInfo *)handleJsonResult:(id)json {
    __block LCStructInfo *structInfo = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        structInfo = [[LCStructInfo alloc] initWithStructNameKey:LCClassNameKey StructName:LCClassName StructDic:json];
        [self handleWithDic:structInfo];
    } else {
        if ([json isKindOfClass:[NSArray class]]) {
            
            LCDialogController *dialog = [[LCDialogController alloc] initWithWindowNibName:@"LCDialogController"];
            NSString *msg = [NSString stringWithFormat:@"The data is in JSON Array, and name is:"];
            [dialog setDataWithMsg:msg defaultClassName:LCArrayKeyName enter:^(NSString *className) {
                NSDictionary *dic = [NSDictionary dictionaryWithObject:json forKey:className];
                structInfo = [[LCStructInfo alloc] initWithStructNameKey:LCClassNameKey StructName:LCClassName StructDic:(NSDictionary *)dic];
            }];
            [self.window beginCriticalSheet:[dialog window] completionHandler:nil];
            [NSApp runModalForWindow:[dialog window]];
            [self handleWithDic:structInfo];
        }
    }
    return structInfo;
}

- (LCStructInfo *)handleWithDic:(LCStructInfo * )result {
    LCStructInfo *structInfo = nil;
    if ([result.structDic isKindOfClass:[NSDictionary class]] || [result.structDic isKindOfClass:[NSArray class]]) {
        for (NSString *key in result.structDic) {
            id obj = result.structDic[key];
            if ([obj isKindOfClass:[NSDictionary class]]||[obj isKindOfClass:[NSArray class]]) {
                LCDialogController *dialog = [[LCDialogController alloc] initWithWindowNibName:@"LCDialogController"];
                
                NSString *msg = [NSString stringWithFormat:@"The '%@' struct name is:",key];
                __block NSString *childClassName;
                [dialog setDataWithMsg:msg defaultClassName:[key capitalizedString] enter:^(NSString *className) {
                    childClassName = className;
                }];
                [self.window beginCriticalSheet:[dialog window] completionHandler:nil];
                [NSApp runModalForWindow:[dialog window]];
                
                //dic or array in json[key]
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    structInfo = [[LCStructInfo alloc] initWithStructNameKey:key StructName:childClassName StructDic:obj];
                    [result.infoDic setObject:structInfo forKey:key];
                    [self handleWithDic:structInfo];
                }else if([obj isKindOfClass:[NSArray class]]) {
                    NSArray *array = obj;
                    if (array.firstObject) {
                        NSObject *objInArray = [array firstObject];
                        if ([objInArray isKindOfClass:[NSDictionary class]]) {
                            structInfo = [[LCStructInfo alloc] initWithStructNameKey:key StructName:childClassName StructDic:(NSDictionary *)objInArray];
                            [result.infoDic setObject:structInfo forKey:key];
                            [self handleWithDic:structInfo];
                        }
                    }
                
                }
            }
        }
    }
    return structInfo;
}

-(void)close{
    [super close];
}

/**
 *  check input str is correct JSON
 *
 *  @param jsonString JSON str
 *
 *  @return JSON dic or errror
 */
-(id)dictionaryWithJsonStr:(NSString *)jsonString{
    jsonString = [[jsonString stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dicOrArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&err];
    if (err) {
        return err;
    }else{
        return dicOrArray;
    }
}

@end
