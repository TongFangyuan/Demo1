//#import "OpusCodec.h"
//
//#import "opus.h"
////#import <opus/opus.h>
//
//#define kDefaultSampleRate 8000
//
//#define WB_FRAME_SIZE  320
//
//@implementation OpusCodec
//
//{
//
//    OpusEncoder *enc;
//
//    OpusDecoder *dec;
//
//    unsigned char opus_data_encoder[40];
//
//}
//
//-(void)opusInit
//
//{
//
//    int error;
//
//    enc = opus_encoder_create(kDefaultSampleRate, 1, OPUS_APPLICATION_VOIP, &error);//(采样率，声道数,,)
//
//    dec = opus_decoder_create(kDefaultSampleRate, 1, &error);
//
//    opus_encoder_ctl(enc, OPUS_SET_BITRATE(kDefaultSampleRate));//比特率
//
//    opus_encoder_ctl(enc, OPUS_SET_BANDWIDTH(OPUS_AUTO));//OPUS_BANDWIDTH_NARROWBAND 宽带窄带
//
//    opus_encoder_ctl(enc, OPUS_SET_VBR(0));
//
//    opus_encoder_ctl(enc, OPUS_SET_VBR_CONSTRAINT(1));
//
//    opus_encoder_ctl(enc, OPUS_SET_COMPLEXITY(8));//录制质量 1-10
//
//    opus_encoder_ctl(enc, OPUS_SET_PACKET_LOSS_PERC(0));
//
//    opus_encoder_ctl(enc, OPUS_SET_SIGNAL(OPUS_SIGNAL_VOICE));//信号
//
//}
//
//- (NSData *)encode:(short *)pcmBuffer length:(NSInteger)lengthOfShorts
//
//{
//
//    //    NSLog(@"--->>lengthOfShorts = %ld  size -= %lu",(long)lengthOfShorts,sizeof(short));
//
//    int frame_size = (int)lengthOfShorts / sizeof(short);//WB_FRAME_SIZE;
//
//    short input_frame[frame_size];
//
//    opus_int32 max_data_bytes = 2 * WB_FRAME_SIZE ;//随便设大,此时为原始PCM大小
//
//    memcpy(input_frame, pcmBuffer, lengthOfShorts );//frame_size * sizeof(short)
//
//    int encodeBack = opus_encode(enc, input_frame, frame_size, opus_data_encoder, max_data_bytes);
//
//    //    NSLog(@"encodeBack===%d",encodeBack);
//
//    if (encodeBack > 0)
//
//    {
//
//        NSData *decodedData = [NSData dataWithBytes:opus_data_encoder length:encodeBack];
//
//        return decodedData;
//
//    }
//
//    else
//
//    {
//
//        return nil;
//
//    }
//
//}
//
////int decode(unsigned char* in_data, int len, short* out_data, int* out_len) {
//
//-(int)decode:(unsigned char *)encodedBytes length:(int)lengthOfBytes output:(short *)decoded
//
//{
//
//    int frame_size = WB_FRAME_SIZE;
//
//    unsigned char cbits[frame_size*2];
//
//    memcpy(cbits, encodedBytes, lengthOfBytes);
//
//    int pcm_num = opus_decode(dec, cbits, lengthOfBytes, decoded, frame_size, 0);
//
//    NSLog(@"解压后长度=%d",pcm_num);
//
//    return frame_size;
//
//}
//
//-(NSData *)encodePCMData:(NSData*)data
//
//{
//
//    //    NSLog(@"原始数据长度--->>%lu",(unsigned long)data.length);
//
//    return  [self encode:(short *)[data bytes] length:[data length]];
//
//}
//
//-(NSData *)decodeOpusData:(NSData*)data
//
//{
//
//    int len = (int)[data length];
//
//    Byte *byteData = (Byte*)malloc(len);
//
//    memcpy(byteData, [data bytes], len);
//
//    int frame_size = WB_FRAME_SIZE;
//
//    short decodedBuffer[frame_size ];
//
//    int nDecodedByte = sizeof(short) * [self decode:byteData length:len output:decodedBuffer];
//
//    NSData *PCMData = [NSData dataWithBytes:(Byte *)decodedBuffer length:nDecodedByte];
//
//    return PCMData;
//
//}
//
//-(void)destroy
//
//{
//
//    opus_encoder_destroy(enc);
//
//    opus_decoder_destroy(dec);
//
//}
//
//@end



#import "OpusCodec.h"
#import "opus.h"



@implementation OpusCodec
{
    OpusEncoder *enc;
    OpusDecoder *dec;
    int opus_num;
    int pcm_num;
    unsigned char opus_data_encoder[40];
}

-(void)opusInit
{
    int error;
    int Fs = 16000;//采样率
    int channels = 1;
    int application = OPUS_APPLICATION_VOIP;
    
    opus_int32 bitrate_bps = kDefaultSampleRate;
    int bandwidth = OPUS_AUTO;//OPUS_BANDWIDTH_NARROWBAND 宽带窄带
    int use_vbr = 0;
    int cvbr = 1;
    int complexity = 4; //录制质量 1-10
    int packet_loss_perc = 0;
    
    enc = opus_encoder_create(Fs, channels, application, &error);
    dec = opus_decoder_create(Fs, channels, &error);
    
    opus_encoder_ctl(enc, OPUS_SET_BITRATE(bitrate_bps));
    opus_encoder_ctl(enc, OPUS_SET_BANDWIDTH(bandwidth));
    opus_encoder_ctl(enc, OPUS_SET_VBR(use_vbr));
    opus_encoder_ctl(enc, OPUS_SET_VBR_CONSTRAINT(cvbr));
    opus_encoder_ctl(enc, OPUS_SET_COMPLEXITY(complexity));
    opus_encoder_ctl(enc, OPUS_SET_PACKET_LOSS_PERC(packet_loss_perc));
    opus_encoder_ctl(enc, OPUS_SET_SIGNAL(OPUS_SIGNAL_VOICE));//信号
    
    opus_decoder_ctl(dec, OPUS_SET_SIGNAL(OPUS_SIGNAL_VOICE));
    opus_decoder_ctl(dec, OPUS_SET_GAIN(10));
}

- (NSData *)encode:(short *)pcmBuffer length:(int)lengthOfShorts
{
    NSMutableData *decodedData = [NSMutableData data];
    int frame_size = WB_FRAME_SIZE;
    short input_frame[WB_FRAME_SIZE];
    opus_int32 max_data_bytes = 2500;
    
    memcpy(input_frame, pcmBuffer, frame_size * sizeof(short));
    int encodeBack = opus_encode(enc, input_frame, frame_size, opus_data_encoder, max_data_bytes);
    NSLog(@"encodeBack===%d",encodeBack);
    if (encodeBack > 0)
    {
        [decodedData appendBytes:opus_data_encoder length:encodeBack];
    } else {
        NSLog(@"音频解码错误 ： %d",encodeBack);
    }
    
    return decodedData;
}

//int decode(unsigned char* in_data, int len, short* out_data, int* out_len) {
-(int)decode:(unsigned char *)encodedBytes length:(int)lengthOfBytes output:(short*)decoded {
    int frame_size = WB_FRAME_SIZE;
    char cbits[frame_size + 1];
    memcpy(cbits, encodedBytes, lengthOfBytes);
    pcm_num = opus_decode(dec,
                          cbits,
                          lengthOfBytes,
                          decoded,
                          frame_size,
                          0);
    if (pcm_num<0) {
        NSLog(@"音频解码错误 ： %d",pcm_num);
    } else {
        NSLog(@"音频解码成功 ： 解压后长度=%d",pcm_num);
    }
    return frame_size;
    
    
}
-(NSData*) encodePCMData:(NSData*)data
{
    return  [self encode:(short *)[data bytes] length:[data length]/sizeof(short)];
}

-(NSData*)decodeOpusData:(NSData*)data
{
    NSInteger len = [data length];
    NSLog(@"数据长度===%d",len);
    
    Byte *byteData = (Byte*)malloc(len);
    
    memcpy(byteData, [data bytes], len);
    
    short decodedBuffer[1024];
    
    int nDecodedByte = sizeof(short) * [self decode:byteData length:len output:decodedBuffer];
    NSLog(@"返回的长度＝＝%d",nDecodedByte);
    NSData* PCMData = [NSData dataWithBytes:(Byte *)decodedBuffer length:nDecodedByte];
    return PCMData;
}


-(NSData*)test_encodePCMData:(NSData*)data
{
    NSInteger len = [data length];
    
    int esample = 20 * kDefaultSampleRate / 1000;
    unsigned char encoderOutputBuffer[1000*sizeof(unsigned char)];

    int returnValue = opus_encode_float(enc, [data bytes], esample, encoderOutputBuffer, 1000);
    
    if (returnValue <= 0) {
        NSLog(@"encode error : %d",returnValue);
        return nil;
    }else {
        NSMutableData *outputData = [NSMutableData new];
        [outputData appendBytes:encoderOutputBuffer length:returnValue * sizeof(unsigned char)];
        NSLog(@"encode success : %d",returnValue);
        return outputData;
    }

}

-(NSData*) test_decodeOpusData:(NSData*)data
{
    NSInteger len = [data length];
    unsigned char * inputData = (unsigned char *)[data bytes];
    
    int bw = opus_packet_get_bandwidth(inputData); //TEST: return OPUS_BANDWIDTH_SUPERWIDEBAND here
    
    short outputBuffer[1000*sizeof(unsigned char)];
    int32_t decodedSamples = 0;
    
    int esample = 60 * kDefaultSampleRate / 1000;

    int returnValue = opus_decode_float(dec, inputData, (opus_int32)len, outputBuffer, esample, 0);
    if (returnValue < 0) {
        NSLog(@"decode error %d", returnValue);
        return nil;
    } else {
        NSLog(@"decode success %d", returnValue);
        decodedSamples = returnValue;
        NSUInteger length = decodedSamples * 1;
        NSData *audioData = [NSData dataWithBytes:outputBuffer length:length * sizeof(opus_int16)];
        return audioData;

    }
}

@end

