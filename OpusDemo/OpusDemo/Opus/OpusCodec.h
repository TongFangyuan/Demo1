//
//  OpusCodec.h
//  HelloWord
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 008. All rights reserved.
//

//#import <Foundation/Foundation.h>
//
//@interface OpusCodec : NSObject
//
//-(void)opusInit;
//
//-(NSData*)encodePCMData:(NSData*)data;
//
//-(NSData*)decodeOpusData:(NSData*)data;
//
//-(void)destroy;
//
//
//@end











#import <Foundation/Foundation.h>

#define WB_FRAME_SIZE 320
#define kDefaultSampleRate 48000

@interface OpusCodec : NSObject
-(void)opusInit;
-(NSData*)encodePCMData:(NSData*)data;
-(NSData*)decodeOpusData:(NSData*)data;

-(NSData*)test_decodeOpusData:(NSData*)data;
-(NSData*)test_encodePCMData:(NSData*)data;

@end
