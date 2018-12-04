//
//  ViewController.m
//  AudioPlayerDemo
//
//  Created by admin on 2018/12/4.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"c_tts" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSError *error;
    AVAudioPlayer *player =  [[AVAudioPlayer alloc] initWithData:data fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
    player.volume = 1;
    player.delegate = self;
    [player prepareToPlay];
    
    if (!error) {
        [player play];
        NSLog(@"play");
    } else {
        NSLog(@"error:%@",error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    NSLog(@"%@",error);
}


- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
    
}

/* audioPlayerEndInterruption: is called when the preferred method, audioPlayerEndInterruption:withFlags:, is not implemented. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    
}

@end
