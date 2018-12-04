//
//  ViewController.m
//  PlayerDemo
//
//  Created by admin on 2018/11/27.
//  Copyright © 2018年 Tongfy. All rights reserved.
//

#import "ViewController.h"
#import "AudioPlayBar.h"
#import "TTAudioPlayer.h"
#import "Masonry.h"

@interface ViewController ()<TTAudioPlayerStatusDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AudioPlayBar *playBar = [AudioPlayBar sharePlayBar];
    [self.view addSubview:playBar];
    [playBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(playBar.bounds.size);
    }];
    
    
//    NSString *config = @"[{\"audioUrl\":\"http://tmjl128.alicdn.com/194/7194/2102408807/1792653269_1476762863432.mp3?auth_key=1543978800-0-0-d41777b7e924ab71959ae54af6adc6e3\",\"audioName\":\"数鸭子\",\"audioAnchor\":\"李志\"},{\"audioUrl\":\"http://tmjl128.alicdn.com/428/62428/422853/1770001654_1512634063795.mp3?auth_key=1543978800-0-0-70a986c9328714721c0f5381e2b7b514\",\"audioName\":\"幸福的孩子爱唱歌\",\"audioAnchor\":\"谢欣芷\"},{\"audioUrl\":\"http://tmjl128.alicdn.com/147/7147/298010/3302004_1532947360257.mp3?auth_key=1543978800-0-0-03c7c35a7d746545ba33c085158d48b7\",\"audioName\":\"嘟嘟歌\",\"audioAnchor\":\"黄建为\"},{\"audioUrl\":\"http://tmjl128.alicdn.com/841/395312841/695312853/1772798197_15662156_l.mp3?auth_key=1543978800-0-0-bac3b7dd08f7fb9642e7820940448f41\",\"audioName\":\"我有一只小毛驴\",\"audioAnchor\":\"碧瑶\"},]";
    
    TTMusicModel *item1 = [TTMusicModel new];
    item1.name = @"数鸭子";
    item1.url  = @"http://tmjl128.alicdn.com/194/7194/2102408807/1792653269_1476762863432.mp3?auth_key=1543978800-0-0-d41777b7e924ab71959ae54af6adc6e3";
    item1.author = @"李志";
    
    TTMusicModel *item2 = [TTMusicModel new];
    item2.name = @"幸福的孩子爱唱歌";
    item2.url  = @"http://tmjl128.alicdn.com/428/62428/422853/1770001654_1512634063795.mp3?auth_key=1543978800-0-0-70a986c9328714721c0f5381e2b7b514";
    item2.author = @"谢欣芷";
    
    TTMusicModel *item3 = [TTMusicModel new];
    item3.name = @"我有一只小毛驴";
    item3.url  = @"http://tmjl128.alicdn.com/841/395312841/695312853/1772798197_15662156_l.mp3?auth_key=1543978800-0-0-bac3b7dd08f7fb9642e7820940448f41";
    item3.author = @"碧瑶";
    
    NSArray *items = @[item1,item2,item3,item4,item5];
    /// 配置播放数据
    [TTAudioPlayer shareInstance].delegate = self;
    [[TTAudioPlayer shareInstance] replaceAllQueueWithArray:items];
    [[TTAudioPlayer shareInstance] playMusicWithInfo:item1];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ttAudioPlayerPlayStart{
    [[AudioPlayBar sharePlayBar] updatePlayStatus:YES];
}
- (void)ttAudioPlayerPlayFinished{
    [[AudioPlayBar sharePlayBar] updatePlayStatus:NO];
}
- (void)ttAudioPlayerPause{
    [[AudioPlayBar sharePlayBar] updatePlayStatus:NO];
}
- (void)ttAudioPlayerStoped{
    [[AudioPlayBar sharePlayBar] updatePlayStatus:NO];
}
- (void)ttAudioPlayerPlayError:(NSError *)error{
    [[AudioPlayBar sharePlayBar] updatePlayStatus:NO];
    NSLog(@"音乐播放错误%@",error.description);
}
- (void)ttAudioPlayerSeekPosition:(double)progress{
    NSLog(@"");
}
- (void)ttAudioPlayerUpdateProgress:(double)progress
{
    [[AudioPlayBar sharePlayBar] updateProgress:progress];
}

- (void)ttAduioPlayerMusicInfoUpdate:(id<TTMusicModelProtocol>)musicInfo
{
    [[AudioPlayBar sharePlayBar] updateMusicInfo:musicInfo];
}

@end
