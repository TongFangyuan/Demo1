//
//  ViewController.m
//  OpusDemo
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 tongfy. All rights reserved.
//
//  opus加密解密

#import "ViewController.h"
#import "OpusCodec.h"

/// 文件夹
#define kOutputDirectoryPath @"/Users/admin/Desktop"

@interface ViewController ()
{
    OpusCodec *opusCodes;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    opusCodes = [[OpusCodec alloc] init];
    [opusCodes opusInit];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)encodePCM:(id)sender {

    NSString *filePath =  [[NSBundle mainBundle] pathForResource:@"speech_orig" ofType:@"wav"];
    NSData *ori_data = [[NSData alloc] initWithContentsOfFile:filePath];
    
    NSMutableData *encode_data = [NSMutableData data];
    NSMutableData *decode_data = [NSMutableData data];
    [self addWavHeader:decode_data];

    
    NSUInteger limitLength = 320;
    if (ori_data.length>limitLength) {

        NSUInteger i = 0;
        while ((i + 1) * limitLength <= ori_data.length) {
            NSData *data_per = [ori_data subdataWithRange:NSMakeRange(i * limitLength, limitLength)];
            NSData *encodeData = [opusCodes encodePCMData:data_per];
            NSData *decodeData = [opusCodes decodeOpusData:encodeData];

            [encode_data appendData:encodeData];
            [decode_data appendData:decodeData];

            i++;
        }
        i = ori_data.length % limitLength;
        if(i > 0)
        {
            NSData *data_per = [ori_data subdataWithRange:NSMakeRange(ori_data.length - i, i)];
            NSData *encodeData = [opusCodes encodePCMData:data_per];
            NSData *decodeData = [opusCodes decodeOpusData:encodeData];
            [encode_data appendData:encodeData];
            [decode_data appendData:decodeData];
        }

    }
    
//    encode_data = [opusCodes test_encodePCMData:ori_data];
//    decode_data = [opusCodes test_decodeOpusData:encode_data];
    
    
    NSString *file_path = [NSString stringWithFormat:@"%@/speech_ecode.opus",kOutputDirectoryPath];
    [encode_data writeToFile:file_path atomically:YES];
    NSLog(@"保存加密文件完毕");
    
    
    NSString *file_path2 = [NSString stringWithFormat:@"%@/speech_decode.wav",kOutputDirectoryPath];
    [decode_data writeToFile:file_path2 atomically:YES];
    NSLog(@"保存解密文件完毕");
    
}

- (IBAction)decodePCM:(id)sender {
   
    NSString *filePath =  [[NSBundle mainBundle] pathForResource:@"speech" ofType:@"opus"];
    NSData *ori_data = [[NSData alloc] initWithContentsOfFile:filePath];
    
    if (ori_data) {
        NSString *file_path = [NSString stringWithFormat:@"%@/11.opus",kOutputDirectoryPath];
        [ori_data writeToFile:file_path atomically:YES];
        NSLog(@"保存加密文件完毕");
    }
//    NSMutableData *resultData = [NSMutableData data];
//    ori_data = [ori_data subdataWithRange:NSMakeRange(0, 20)];
    
//    NSData *decode_data = [opusCodes decodeOpusData:ori_data];
    NSData *decode_data = [opusCodes test_decodeOpusData:ori_data];
    if (decode_data && decode_data.length) {
        [self addWavHeader:decode_data];
        NSString *file_path2 = [NSString stringWithFormat:@"%@/speech_decode.wav",kOutputDirectoryPath];
        [decode_data writeToFile:file_path2 atomically:YES];
        NSLog(@"保存解密文件完毕");        
    }

}


- (NSMutableData *)addWavHeader:(NSData *)wavNoheader {
    
    int headerSize = 44;
    long totalAudioLen = [wavNoheader length];
    long totalDataLen = [wavNoheader length] + headerSize-8;
    long longSampleRate = 48000;
    int channels = 1;
    long byteRate = 16 * 11025 * channels/8;
    
    Byte *header = (Byte*)malloc(44);
    header[0] = 'R';  // RIFF/WAVE header
    header[1] = 'I';
    header[2] = 'F';
    header[3] = 'F';
    header[4] = (Byte) (totalDataLen & 0xff);
    header[5] = (Byte) ((totalDataLen >> 8) & 0xff);
    header[6] = (Byte) ((totalDataLen >> 16) & 0xff);
    header[7] = (Byte) ((totalDataLen >> 24) & 0xff);
    header[8] = 'W';
    header[9] = 'A';
    header[10] = 'V';
    header[11] = 'E';
    header[12] = 'f';  // 'fmt ' chunk
    header[13] = 'm';
    header[14] = 't';
    header[15] = ' ';
    header[16] = 16;  // 4 bytes: size of 'fmt ' chunk
    header[17] = 0;
    header[18] = 0;
    header[19] = 0;
    header[20] = 1;  // format = 1
    header[21] = 0;
    header[22] = (Byte) channels;
    header[23] = 0;
    header[24] = (Byte) (longSampleRate & 0xff);
    header[25] = (Byte) ((longSampleRate >> 8) & 0xff);
    header[26] = (Byte) ((longSampleRate >> 16) & 0xff);
    header[27] = (Byte) ((longSampleRate >> 24) & 0xff);
    header[28] = (Byte) (byteRate & 0xff);
    header[29] = (Byte) ((byteRate >> 8) & 0xff);
    header[30] = (Byte) ((byteRate >> 16) & 0xff);
    header[31] = (Byte) ((byteRate >> 24) & 0xff);
    header[32] = (Byte) (2 * 8 / 8);  // block align
    header[33] = 0;
    header[34] = 16;  // bits per sample
    header[35] = 0;
    header[36] = 'd';
    header[37] = 'a';
    header[38] = 't';
    header[39] = 'a';
    header[40] = (Byte) (totalAudioLen & 0xff);
    header[41] = (Byte) ((totalAudioLen >> 8) & 0xff);
    header[42] = (Byte) ((totalAudioLen >> 16) & 0xff);
    header[43] = (Byte) ((totalAudioLen >> 24) & 0xff);
    
    NSMutableData *newWavData = [NSMutableData dataWithBytes:header length:44];
    [newWavData appendBytes:[wavNoheader bytes] length:[wavNoheader length]];
    free(header);
    return newWavData;
}


@end
