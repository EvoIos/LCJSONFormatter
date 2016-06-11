//
//  LCDialogController.m
//  XcodePlguinDemo
//
//  Created by z on 16/6/6.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCDialogController.h"

@interface LCDialogController ()<NSWindowDelegate,NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *inputTextField;

@end

@implementation LCDialogController

- (void)windowDidLoad {
    [super windowDidLoad];

    self.inputTextField.delegate = self;
    self.window.delegate = self;

    self.inputTextField.stringValue = self.className;
    self.tipsLabel.stringValue = self.msg;
    [self.inputTextField becomeFirstResponder];
}

-(void)setDataWithMsg:(NSString *)msg defaultClassName:(NSString *)className enter:(void(^)(NSString *className))enterBlock{
    self.msg = msg;
    self.className = className;
    self.enterBlock = enterBlock;
}

- (void)enterBtnClick:(NSButton *)sender {
    if (self.enterBlock) {
        self.enterBlock(self.inputTextField.stringValue);
    }
    [self close];
}

-(void)windowWillClose:(NSNotification *)notification{
    [NSApp stopModal];
    [NSApp endSheet:[self window]];
    [[self window] orderOut:nil];
}

#pragma mark - nstextfiled delegate
- (void)controlTextDidEndEditing:(NSNotification *)notification {
    if ( [[[notification userInfo] objectForKey:@"NSTextMovement"] intValue] == NSReturnTextMovement){
        [self enterBtnClick:nil];
    }
}


@end
