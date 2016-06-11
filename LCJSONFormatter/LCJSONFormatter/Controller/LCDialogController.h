//
//  LCDialogController.h
//  XcodePlguinDemo
//
//  Created by z on 16/6/6.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LCDialogController : NSWindowController
@property (weak) IBOutlet NSTextField *tipsLabel;

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, assign) BOOL objIsKindOfArray;
@property (nonatomic, copy) void (^enterBlock)(NSString *className);

-(void)setDataWithMsg:(NSString *)msg defaultClassName:(NSString *)className enter:(void(^)(NSString *className))enterBlock;

@end
