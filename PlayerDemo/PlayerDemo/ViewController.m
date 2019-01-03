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
    
    TTMusicModel *item1 = [TTMusicModel new];
    item1.name = @"数鸭子";
    item1.url  = @"http://tmjl128.alicdn.com/158/7158/1136455538/1774490672_1478671781016.mp3?auth_key=1547089200-0-0-716d40c725d7be545e657ee1a16e7c5a";
    item1.author = @"李志";
    
    TTMusicModel *item2 = [TTMusicModel new];
    item2.name = @"幸福的孩子爱唱歌";
    item2.url  = @"http://tmjl128.alicdn.com/158/7158/1136455538/1774490672_1478671781016.mp3?auth_key=1547089200-0-0-716d40c725d7be545e657ee1a16e7c5a";
    item2.author = @"谢欣芷";
    
    TTMusicModel *item3 = [TTMusicModel new];
    item3.name = @"我有一只小毛驴";
    item3.url  = @"http://tmjl128.alicdn.com/158/7158/1136455538/1774490672_1478671781016.mp3?auth_key=1547089200-0-0-716d40c725d7be545e657ee1a16e7c5a";
    item3.author = @"碧瑶";
    
    TTMusicModel *item4 = [TTMusicModel new];
    item4.name = @"我有一只小毛驴";
    item4.url  = @"http://tmjl128.alicdn.com/158/7158/1136455538/1774490672_1478671781016.mp3?auth_key=1547089200-0-0-716d40c725d7be545e657ee1a16e7c5a";
    item4.author = @"碧瑶";
    
    TTMusicModel *item5 = [TTMusicModel new];
    item5.name = @"我有一只小毛驴";
    item5.url  = @"http://tmjl128.alicdn.com/158/7158/1136455538/1774490672_1478671781016.mp3?auth_key=1547089200-0-0-716d40c725d7be545e657ee1a16e7c5a";
    item5.author = @"碧瑶";
    
    NSArray *items = @[item1,item2,item3,item4,item5];
    /// 配置播放数据
    [[TTAudioPlayer shareInstance] replaceAllQueueWithArray:items];
    [[TTAudioPlayer shareInstance] playMusicWithInfo:item1];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
}

@end
