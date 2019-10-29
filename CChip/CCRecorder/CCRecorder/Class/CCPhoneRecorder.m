//
//  CCPhoneRecorder.m
//  CCRecorder
//
//  Created by Tong on 2019/10/29.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import "CCPhoneRecorder.h"

@interface CCPhoneRecorder()
{
    CCVADMode mVADMode;
}

@property (nonatomic, strong, readwrite) AVAudioRecorder *audioRecorder;
@property (nonatomic, assign, readwrite) BOOL isAudioRecording;
@property (nonatomic, weak,   readwrite) id<CCRecorderConfiguratorProtocol> configurator;

@end


@implementation CCPhoneRecorder

+ (instancetype)recorderWithConfiguarator:(id<CCRecorderConfiguratorProtocol>)configurator
                                 delegate:(id<CCRecorderDelegate>)delegate
{
    CCPhoneRecorder *obj = [CCPhoneRecorder new];
    obj.configurator = configurator;
    obj.delegate = delegate;
    return obj;
}

- (instancetype)init {
    if (self=[super init]) {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSArray *dirs = [fileMgr URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        
        NSString *directory = [dirs[0] absoluteString];
        NSString *tmpfile = self.configurator.fileName;
        NSDictionary *settings = self.configurator.setting;
        NSString *fileURL = [directory stringByAppendingPathComponent:tmpfile];
        
        NSError *error = nil;
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:fileURL] settings:settings error:&error];
        if (!error) {
            NSAssert(error, @"录音器初始化错误");
        }
        
        self.VADMode = CCVADModeLocal;
    }
    return self;
}

- (void)startRecord {
    [self prepareRecord];
    [self.audioRecorder record];
}

- (void)startRecordWithVAD:(CCVADMode)mode {
    self.VADMode = mode;
    [self startRecord];
}

- (void)stopRecord {
    [self.audioRecorder stop];
}

- (void)prepareRecord {
    
    if ([self.delegate respondsToSelector:@selector(recorderPrepare:)]) {
        [self.delegate recorderPrepare:self];
    }

    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *e_rr = nil;
    [session setActive:YES error:&e_rr];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:&e_rr];
    
    [self.audioRecorder prepareToRecord];
    
}


#pragma mark - ------------- setter ------------------
- (void)setVADMode:(CCVADMode)VADMode {
    mVADMode = VADMode;
}

- (CCVADMode)VADMode {
    return mVADMode;
}

@end
