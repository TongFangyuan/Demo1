//
//  OpusCodec.h
//  HelloWord
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 008. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpusCodec : NSObject

-(void)opusInit;

-(NSData*)encodePCMData:(NSData*)data;
//// 将设备发送的Opus数据转换为PCMdata
-(NSData*)decodeOpusData:(NSData*)data;

-(void)destroy;


@end
