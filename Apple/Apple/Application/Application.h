//
//  Application.h
//  UFTMobile
//
//  Created by PENG.Q on 11-8-16.
//  Copyright 2011年 UFTobacco Inc. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Application : NSObject
{
    NSUserDefaults * mUserDefaults;
}

@property (nonatomic, readonly)    NSString * documentsDirectory;
@property (nonatomic, copy)        NSString * appVersion;

+ (Application *) theApp;

- (id) preferenceWithName:(NSString *)prefname;
- (void) setPreference:(id)ob withName:(NSString *)prefname;

- (NSString *) appVersion;
- (NSString *) deviceUniqueId;

- (UIImage *) getImageWithImageName:(NSString *)name;
    
#pragma mark - 设置/获取 自定义EQ
- (void)setCustomEQValueArray:(NSArray *)array;
- (NSArray *)getCustomEQValueArray;
#pragma mark - 设置/获取 EQ类型
- (void)setEQType:(NSInteger)type;
- (NSInteger)getEQType;

- (void)setHadGetLocalMusic:(BOOL)hadGetLocalMusic;
- (BOOL)isHadGetLocalMusic;

- (void)setPlayMusicOrConversationMode:(BOOL)isConversationMode;
- (BOOL)isAppConversationMode;
    
@end


