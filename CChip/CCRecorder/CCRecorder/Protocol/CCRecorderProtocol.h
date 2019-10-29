//
//  CCRecorderProtocol.h
//  CCRecorder
//
//  Created by Tong on 2019/10/29.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CCRecorderProtocol;

@protocol CCRecorderConfiguratorProtocol <NSObject>

@property (nonatomic, strong) NSDictionary *setting;
@property (nonatomic, copy)   NSString     *fileName;

@end

@protocol CCRecorderDelegate <NSObject>

- (void)recorder:(id<CCRecorderProtocol>)recorder
       audioData:(NSData *)data
         isFirst:(BOOL)isFirst
          isLast:(BOOL)isLast;

- (void)recorder:(id<CCRecorderProtocol>)recorder occourrError:(NSError *)recorder;
- (void)recorderPrepare:(id<CCRecorderProtocol>)recorder;
- (void)recorderStart:(id<CCRecorderProtocol>)recorder;
- (void)recorderFinish:(id<CCRecorderProtocol>)recorder;
- (void)recorderCancel:(id<CCRecorderProtocol>)recorder;

@end

typedef enum : NSUInteger {
    CCVADModeLocal,
    CCVADModeCloud,
    CCVADModeMix,
    CCVADModeNone
} CCVADMode;

@protocol CCRecorderProtocol <NSObject>

@property (nonatomic, strong, readonly) AVAudioRecorder *audioRecorder; //!< 录音器
@property (nonatomic, assign, readonly) BOOL isAudioRecording;
@property (nonatomic, assign) CCVADMode VADMode;
@property (nonatomic, weak, readonly) id<CCRecorderDelegate> delegate;
@property (nonatomic, weak, readonly) id<CCRecorderConfiguratorProtocol> configurator;
@property (nonatomic, assign) BOOL isRecognizeForExpectSpeech;  //!< 是否涉及到多轮对话

+ (instancetype)recorderWithConfiguarator:(id<CCRecorderConfiguratorProtocol>)configurator delegate:(id<CCRecorderDelegate>)delegate;

- (void)startRecordWithVAD:(CCVADMode)mode;
- (void)startRecord;

- (void)stopRecord;

@end

NS_ASSUME_NONNULL_END
