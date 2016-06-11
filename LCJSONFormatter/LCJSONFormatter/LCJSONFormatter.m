//
//  LCJSONFormatter.m
//  LCJSONFormatter
//
//  Created by zhenglanchun on 16/6/11.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCJSONFormatter.h"
#import "LCInputController.h"
#import "LCPbxprojectInfo.h"
#import "LCStructInfo.h"

static LCJSONFormatter *sharedPlugin;

@interface LCJSONFormatter()
@property (nonatomic, strong) NSTextView *currentTextView;
@property (nonatomic, copy) NSString *currentFilePath;
@property (nonatomic) BOOL swift;
@property (nonatomic, strong) NSString *propertyContentStr;
@property (nonatomic, strong) NSString *detailContentStr;
@property (nonatomic, strong) NSString *totalFuncStr;
@property (nonatomic) BOOL firstParseDetailContent;
@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, strong) LCInputController *inputController;

@property (nonatomic) BOOL optional;
@property (nonatomic) BOOL optionalArray;
@end

@implementation LCJSONFormatter

#pragma mark - Initialization

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    NSArray *allowedLoaders = [plugin objectForInfoDictionaryKey:@"me.delisa.XcodePluginBase.AllowedLoaders"];
    if ([allowedLoaders containsObject:[[NSBundle mainBundle] bundleIdentifier]]) {
        sharedPlugin = [[self alloc] initWithBundle:plugin];
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)bundle
{
    if (self = [super init]) {
        _bundle = bundle;
        
        if (NSApp && !NSApp.mainMenu) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(applicationDidFinishLaunching:)
                                                         name:NSApplicationDidFinishLaunchingNotification
                                                       object:nil];
        } else {
            [self initializeAndLog];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputResult:) name:LCFormatResultNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLog:) name:NSTextViewDidChangeSelectionNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLog:) name:@"IDEEditorDocumentDidChangeNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLog:) name:@"PBXProjectDidOpenNotification" object:nil];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    [self initializeAndLog];
}

- (void)initializeAndLog
{
    NSString *name = [self.bundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *version = [self.bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *status = [self initialize] ? @"loaded successfully" : @"failed to load";
    NSLog(@"🔌 Plugin %@ %@ %@", name, version, status);
}

#pragma mark - notification

- (void)notificationLog:(NSNotification *)notify
{
    
    if ([notify.name isEqualToString:NSTextViewDidChangeSelectionNotification]) {
        if ([notify.object isKindOfClass:[NSTextView class]]) {
            NSTextView *text = (NSTextView *)notify.object;
            self.currentTextView = text;
        }
    }else if ([notify.name isEqualToString:@"IDEEditorDocumentDidChangeNotification"]){
        //Track the current open paths
        NSObject *array = notify.userInfo[@"IDEEditorDocumentChangeLocationsKey"];
        NSURL *url = [[array valueForKey:@"documentURL"] firstObject];
        if (![url isKindOfClass:[NSNull class]]) {
            NSString *path = [url absoluteString];
            self.currentFilePath = path;
            if ([self.currentFilePath hasSuffix:@"swift"]) {
                self.swift = YES;
            }else{
                self.swift = NO;
            }
        }
    }else if ([notify.name isEqualToString:@"PBXProjectDidOpenNotification"]){
        //track current open proj
        NSString *currentProjectPath = [notify.object valueForKey:@"path"];
        [[LCPbxprojectInfo shareInstance] setParamsWithPath:[currentProjectPath stringByAppendingPathComponent:@"project.pbxproj"]];
    }
}

-(void)outputResult:(NSNotification*)noti{
    LCStructInfo *structInfo = noti.object;
    if (!self.currentTextView) return;
    self.totalFuncStr = @"";
    self.fileName = [[self.currentFilePath lastPathComponent] stringByDeletingPathExtension];
    
    [self parsePropertyAndContent:structInfo];
    
    NSString *headerStr = [self dealHeaderStrWithFileName:self.fileName];
    NSString *funcContentStr = [NSString stringWithFormat:@"%@%@", headerStr , self.totalFuncStr] ;
    [funcContentStr writeToURL:[NSURL URLWithString:self.currentFilePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

#pragma mark - help private func
- (void)parsePropertyAndContent:(LCStructInfo *)structInfo {
    
    self.detailContentStr = @"";
    self.propertyContentStr = @"";
    self.firstParseDetailContent = YES;
    
    for (NSString *key in structInfo.structDic) {
        self.optional = NO;
        self.optionalArray = NO;
        
        id obj = structInfo.structDic[key];
        if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
            LCStructInfo *tmpStructInfo = (LCStructInfo *)structInfo.infoDic[key];
            NSString *childClassName = tmpStructInfo.structName;

            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *formatStr = [self formatDicWithKey:key value:childClassName];
                self.propertyContentStr = [NSString stringWithFormat:@"%@\n%@",self.propertyContentStr ,formatStr];
                
                NSString *detailStr = [self formatDetailWithKey:key next:1];
                self.detailContentStr = [NSString stringWithFormat:@"%@%@",self.detailContentStr ,detailStr];
            } else {
                NSString *formatStr = [self formatArrayWithKey:key value:childClassName];
                self.propertyContentStr = [NSString stringWithFormat:@"%@\n%@",self.propertyContentStr ,formatStr];
                
                
                NSString *detailStr = [self formatDetailWithKey:key next:2];
                self.detailContentStr = [NSString stringWithFormat:@"%@%@",self.detailContentStr ,detailStr];
            }
            
        } else {
            NSString *formatStr = [self formatPropertyWithKey:key value:obj];
            self.propertyContentStr = [NSString stringWithFormat:@"%@\n%@",self.propertyContentStr ,formatStr];
            
            NSString *detailStr = [self formatDetailWithKey:key next:0];
            self.detailContentStr = [NSString stringWithFormat:@"%@%@",self.detailContentStr ,detailStr];
        }
    }
    
    
    NSString *structName = nil;
    if  ([structInfo.structNameKey isEqualToString:LCClassNameKey]) {
        structName = self.fileName;
    }  else {
        structName = structInfo.structName;
    }
    
    NSString *totalFuncStr = [NSString stringWithFormat:headerFuncStr, structName, self.propertyContentStr,structName, self.detailContentStr];
    self.totalFuncStr = [NSString stringWithFormat:@"%@\n%@",self.totalFuncStr,totalFuncStr];
    
    if ([structInfo.infoDic allKeys].count != 0) {
        for (NSString *key in structInfo.infoDic) {
            LCStructInfo *tmpInfo = structInfo.infoDic[key];
            [self parsePropertyAndContent:tmpInfo];
        }
    }
    
}



#pragma mark -
#pragma mark convert to Argo
//nextFlag ==0 property;== 1 dic; == 2 array
- (NSString *)formatDetailWithKey:(NSString *)key next:(NSInteger)nextFlag{
    NSString *indexStr = @"<*>";
    if (self.firstParseDetailContent == YES) {
        indexStr = @"<^>";
        self.firstParseDetailContent = NO;
    }
    NSString *tmpStr = [NSString stringWithFormat:@"\n        %@ json <| \"%@\"",indexStr ,key];
    if (nextFlag == 0) {
        if (self.optional == YES) {
            tmpStr = [NSString stringWithFormat:@"\n        %@ json <|? \"%@\"",indexStr ,key];
        }
    } else if (nextFlag == 1) {
        tmpStr = [NSString stringWithFormat:@"\n        %@ json <| \"%@\"",indexStr ,key];
    } else if(nextFlag == 2) {
        if (self.optionalArray == YES) {
            tmpStr = [NSString stringWithFormat:@"\n        %@ json <||? [\"%@\"]",indexStr ,key];
        } else {
            tmpStr = [NSString stringWithFormat:@"\n        %@ json <|| [\"%@\"]",indexStr ,key];
        }
        
        
    }
    return tmpStr;
}

#pragma mark parse property
- (NSString *)formatArrayWithKey:(NSString *)key value:(NSObject *)value {
    NSString *typeStr = @"";
    typeStr = (NSString *)value;
    if (value == nil) {
        typeStr = @"String";
        self.optionalArray = YES;
        return [NSString stringWithFormat:@"    let %@: [%@]?",key,typeStr];
    }
    return [NSString stringWithFormat:@"    let %@: [%@]",key,typeStr];
}

- (NSString *)formatDicWithKey:(NSString *)key value:(NSObject *)value {
    NSString *typeStr = @"";
    typeStr = (NSString *)value;
    return [NSString stringWithFormat:@"    let %@: %@",key,typeStr];
}

- (NSString *)formatPropertyWithKey:(NSString *)key value:(NSObject *)value {
    NSString *typeStr = @"";
    if ([value isKindOfClass:[NSString class]]) {
        typeStr = @"String";
    }else if([value isKindOfClass:[@(YES) class]]){
        typeStr = @"Bool";
    }else if([value isKindOfClass:[NSNumber class]]){
        NSString *valueStr = [NSString stringWithFormat:@"%@",value];
        if ([valueStr rangeOfString:@"."].location!=NSNotFound){
            typeStr = @"Double";
        }else{
            typeStr = @"Int";
        }
    }else if([value isKindOfClass:[NSNull class]]) {
        typeStr = @"String?";
        self.optional = YES;
    }
    return [NSString stringWithFormat:@"    let %@: %@",key,typeStr];
}



/**
 *  make up header description
 *
 *  @param fileName filename
 *
 *  @return header description str
 */
- (NSString *)dealHeaderStrWithFileName:(NSString *)fileName {
    //template file name
    NSString *templateFile = [ESJsonFormatPluginPath stringByAppendingPathComponent:@"Contents/Resources/DataModelsTemplate.txt"];
    NSString *templateString = [NSString stringWithContentsOfFile:templateFile encoding:NSUTF8StringEncoding error:nil];

    templateString = [templateString stringByReplacingOccurrencesOfString:@"__MODELNAME__" withString:[NSString stringWithFormat:@"%@.swift",fileName]];

    templateString = [templateString stringByReplacingOccurrencesOfString:@"__NAME__" withString:NSFullUserName()];

    NSString *productName = [LCPbxprojectInfo shareInstance].productName;
    if (productName.length) {
        templateString = [templateString stringByReplacingOccurrencesOfString:@"__PRODUCTNAME__" withString:productName];
    }
    
    NSString *organizationName = [LCPbxprojectInfo shareInstance].organizationName;
    if (organizationName.length) {
        templateString = [templateString stringByReplacingOccurrencesOfString:@"__ORGANIZATIONNAME__" withString:organizationName];
    }
    
    templateString = [templateString stringByReplacingOccurrencesOfString:@"__DATE__" withString:[self dateStr]];
    if (templateString.length == 0) {
        templateString = @"";
    }
    NSString *string = @"import UIKit\n\nimport Argo\nimport Curry\n\n";
    templateString = [NSString stringWithFormat:@"%@%@", templateString, string];
    
    return [templateString copy];
}

- (NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yy/MM/dd";
    return [formatter stringFromDate:[NSDate date]];
}

#pragma mark - add menu to window

- (BOOL)initialize
{
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Window"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"LCJSONFromatter" action:@selector(LCJSONFromatter) keyEquivalent:@""];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
        return YES;
    } else {
        return NO;
    }

}

- (void)LCJSONFromatter
{
    self.inputController = [[LCInputController alloc] initWithWindowNibName:@"LCInputController"];
    [self.inputController showWindow:self.inputController];
    
}

- (NSString *)propertyContentStr {
	if(_propertyContentStr == nil) {
		_propertyContentStr = [[NSString alloc] init];
	}
	return _propertyContentStr;
}

- (NSString *)detailContentStr {
	if(_detailContentStr == nil) {
		_detailContentStr = [[NSString alloc] init];
	}
	return _detailContentStr;
}

- (NSString *)totalFuncStr {
	if(_totalFuncStr == nil) {
		_totalFuncStr = [[NSString alloc] init];
	}
	return _totalFuncStr;
}

@end
