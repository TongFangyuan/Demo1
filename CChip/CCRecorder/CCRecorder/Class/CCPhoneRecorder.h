//
//  CCPhoneRecorder.h
//  CCRecorder
//
//  Created by Tong on 2019/10/29.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCRecorderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCPhoneRecorder : NSObject <CCRecorderProtocol>

@property (nonatomic, strong, readonly) AVAudioRecorder *audioRecorder;
@property (nonatomic, assign, readonly) BOOL isAudioRecording;
@property (nonatomic, assign) CCVADMode VADMode;
@property (nonatomic, weak)   id<CCRecorderDelegate> delegate;
@property (nonatomic, weak, readonly) id<CCRecorderConfiguratorProtocol> configurator;
@property (nonatomic, assign) BOOL isRecognizeForExpectSpeech;

+ (instancetype)recorderWithConfiguarator:(id<CCRecorderConfiguratorProtocol>)configurator delegate:(id<CCRecorderDelegate>)delegate;

- (void)startRecordWithVAD:(CCVADMode)mode;
- (void)startRecord;
- (void)stopRecord;

@end

NS_ASSUME_NONNULL_END
