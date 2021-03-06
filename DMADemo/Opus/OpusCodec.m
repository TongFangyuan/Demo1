//
//  OpusCodec.m
//  HelloWord
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 008. All rights reserved.
//

#import "OpusCodec.h"
#import <opus/opus.h>

#define kDefaultSampleRate 16000

#define WB_FRAME_SIZE  320

@implementation OpusCodec

{
    
    OpusEncoder *enc;
    
    OpusDecoder *dec;
    
    unsigned char opus_data_encoder[40];
    
}

-(void)opusInit

{
    
    int error;
    
    enc = opus_encoder_create(kDefaultSampleRate, 1, OPUS_APPLICATION_VOIP, &error);//(采样率，声道数,,)
    dec = opus_decoder_create(kDefaultSampleRate, 1, &error);
    
    opus_encoder_ctl(enc, OPUS_SET_BITRATE(kDefaultSampleRate));//比特率
    opus_encoder_ctl(enc, OPUS_SET_BANDWIDTH(OPUS_AUTO));//OPUS_BANDWIDTH_NARROWBAND 宽带窄带
    opus_encoder_ctl(enc, OPUS_SET_VBR(0));
    opus_encoder_ctl(enc, OPUS_SET_VBR_CONSTRAINT(1));
    opus_encoder_ctl(enc, OPUS_SET_COMPLEXITY(8));//录制质量 1-10
    opus_encoder_ctl(enc, OPUS_SET_PACKET_LOSS_PERC(0));
    opus_encoder_ctl(enc, OPUS_SET_SIGNAL(OPUS_SIGNAL_VOICE));//信号
    
    opus_decoder_ctl(dec, OPUS_SET_VBR_REQUEST, 0);
    opus_decoder_ctl(dec, OPUS_SET_BITRATE_REQUEST, 16000);
    opus_decoder_ctl(dec, OPUS_SET_SIGNAL_REQUEST, OPUS_SIGNAL_VOICE);
    opus_decoder_ctl(dec, OPUS_SET_COMPLEXITY_REQUEST, 0);
    opus_decoder_ctl(dec, OPUS_SET_EXPERT_FRAME_DURATION(OPUS_FRAMESIZE_20_MS));
    
}

- (NSData *)encode:(short *)pcmBuffer length:(NSInteger)lengthOfShorts

{
    
    //    NSLog(@"--->>lengthOfShorts = %ld  size -= %lu",(long)lengthOfShorts,sizeof(short));
    
    int frame_size = (int)lengthOfShorts / sizeof(short);//WB_FRAME_SIZE;
    
    short input_frame[frame_size];
    
    opus_int32 max_data_bytes = 2 * WB_FRAME_SIZE ;//随便设大,此时为原始PCM大小
    
    memcpy(input_frame, pcmBuffer, lengthOfShorts );//frame_size * sizeof(short)
    
    int encodeBack = opus_encode(enc, input_frame, frame_size, opus_data_encoder, max_data_bytes);
    
    //    NSLog(@"encodeBack===%d",encodeBack);
    
    if (encodeBack > 0)
        
    {
        
        NSData *decodedData = [NSData dataWithBytes:opus_data_encoder length:encodeBack];
        
        return decodedData;
        
    }
    
    else
        
    {
        
        return nil;
        
    }
    
}

//int decode(unsigned char* in_data, int len, short* out_data, int* out_len) {

-(int)decode:(unsigned char *)encodedBytes length:(int)lengthOfBytes output:(short *)decoded

{
    
    int frame_size = WB_FRAME_SIZE;
    
    unsigned char cbits[frame_size];
    
    memcpy(cbits, encodedBytes, lengthOfBytes);
    
    int pcm_num = opus_decode(dec, cbits, lengthOfBytes, decoded, 320, 0);
    
//    NSLog(@"解压后长度=%d",pcm_num);
//    NSLog(@"%c", decoded);
    
//    for(int i=0; i<2; i++) {
//        short val = decoded[i];
////        NSLog(@"----ox:%i", val);
//    }
    
    return frame_size;
    
}

-(NSData *)encodePCMData:(NSData*)data

{
    
    //    NSLog(@"原始数据长度--->>%lu",(unsigned long)data.length);
    
    return  [self encode:(short *)[data bytes] length:[data length]];
    
}

-(NSData *)decodeOpusData:(NSData*)data

{
    
    int len = (int)[data length];
    
    Byte *byteData = (Byte*)malloc(len);
    
    memcpy(byteData, [data bytes], len);
    
    int frame_size = WB_FRAME_SIZE;
    
    short decodedBuffer[frame_size];
    
    int nDecodedByte = sizeof(short) * [self decode:byteData length:len output:decodedBuffer];
    
    NSData *PCMData = [NSData dataWithBytes:(Byte *)decodedBuffer length:nDecodedByte];
        
    return PCMData;
    
}

-(void)destroy

{
    opus_encoder_destroy(enc);
    opus_decoder_destroy(dec);
}





@end

