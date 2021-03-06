//
//  Application.m
//  UFTMobile
//
//  Created by PENG.Q on 11-8-16.
//  Copyright 2011年 UFTobacco Inc. Ltd. All rights reserved.
//

#import "Application.h"

static Application * theApp_;

@implementation Application

@synthesize documentsDirectory;
@synthesize appVersion;

- (id) init {
    self = [super init];
    if (self) {
         
        mUserDefaults = [NSUserDefaults standardUserDefaults];
        documentsDirectory = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] copy];
    }
    return self;
}

#pragma mark 单例最简单的写法

+ (Application *) theApp {
    if (!theApp_) {
        theApp_ = [[Application alloc] init];
    }
    return theApp_;
}
 
#pragma mark UserDefaults存取
- (id) preferenceWithName:(NSString *)prefname
{
    return [mUserDefaults objectForKey:prefname];
}

- (void) setPreference:(id)ob withName:(NSString *)prefname
{
    [mUserDefaults setValue:ob forKey:prefname];
    [mUserDefaults synchronize];
}

#pragma mark 版本号
- (NSString *) appVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleShortVersionString"];
}
#pragma mark 构建版本号
- (NSString *)appBuildVersion{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleVersion"];
}
#pragma mark App名称
- (NSString *)appName{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleDisplayName"];
}
#pragma mark bundleId
- (NSString *)appBundleId
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

#pragma mark 设备唯一标识符
- (NSString *) deviceUniqueId {
    
    NSString *service = [self appBundleId];
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:service account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""] || currentDeviceUUIDStr.length<=0)
    {
        NSUUID * currentDeviceUUID = [[UIDevice currentDevice] identifierForVendor];
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSKeychain setPassword: currentDeviceUUIDStr forService:service account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}

#pragma mark 通过图片名获取UIImage
- (UIImage *) getImageWithImageName:(NSString *)name
{
    //imageNamed 缓存图片，下次使用不再重新加载，适用小图片／少图片，会自动适应@2x；
    //imageWithContentsOfFile 不缓存图片，不自动适应@2x。
    return [UIImage imageNamed:name];
}

#pragma mark - 设置/获取 自定义EQ
- (void)setCustomEQValueArray:(NSArray *)array {
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"customEQArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)getCustomEQValueArray {
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"customEQArray"];
    return array;
}

#pragma mark - 设置/获取 EQ类型
- (void)setEQType:(NSInteger)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:@"EQType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)getEQType {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"EQType"] integerValue];
}

    
#pragma mark - 设置播放、对话模式
- (void)setPlayMusicOrConversationMode:(BOOL)isConversationMode {
    [[NSUserDefaults standardUserDefaults] setBool:isConversationMode forKey:@"isAppConversationMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isAppConversationMode {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAppConversationMode"] boolValue];
}

#pragma mark - 判断是否已经载入本地音乐
- (void)setHadGetLocalMusic:(BOOL)hadGetLocalMusic {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HadGetLocalMusic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isHadGetLocalMusic {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"HadGetLocalMusic"] boolValue];
}
    
@end
