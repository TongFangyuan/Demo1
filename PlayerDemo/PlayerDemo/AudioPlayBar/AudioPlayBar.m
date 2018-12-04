//
//  AudioPlayBar.m
//  PlayerDemo
//
//  Created by admin on 2018/11/28.
//  Copyright © 2018年 Tongfy. All rights reserved.
//

#import "AudioPlayBar.h"
#import "Masonry.h"

@interface AudioPlayBar()

@property (nonatomic, strong) UIImageView    *thumImageView;
@property (nonatomic, strong) UILabel        *textLabel;
@property (nonatomic, strong) UIButton       *preButton;
@property (nonatomic, strong) UIButton       *playPauseButton;
@property (nonatomic, strong) UIButton       *nextButton;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation AudioPlayBar

+ (instancetype)sharePlayBar {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}


#pragma mark - public

- (void)updateProgress:(double)value {
    [self.progressView setProgress:value animated:NO];
}

- (void)updatePlayStatus:(BOOL)isPlay {
    self.playPauseButton.selected = isPlay;
}

- (void)updateMusicInfo:(id<TTMusicModelProtocol>) model {
    self.textLabel.text = model.name;
}

#pragma mark - priavte

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)]) {
        [self setupUI];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.progressView];
    self.progressView.progressTintColor = [UIColor colorWithRed:33/255.0 green:220/255.0 blue:249/255.0 alpha:1.0];
    self.progressView.trackTintColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1.0];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(5.0f);
    }];
    
    UIView *containerView = [UIView new];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.progressView.mas_top);
    }];
    
    self.thumImageView = [UIImageView new];
    [containerView addSubview:self.thumImageView];
    [self.thumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.centerY.equalTo(containerView);
        make.left.mas_equalTo(15);
    }];
    self.thumImageView.image = [UIImage imageNamed:@"音乐图标"];
    
    self.textLabel = [UILabel new];
    [containerView addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thumImageView.mas_right).offset(10);
        make.centerY.equalTo(self.thumImageView);
    }];
    self.textLabel.textColor = [UIColor blackColor];
    
    self.nextButton = [UIButton new];
    [containerView addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.thumImageView);
        make.right.equalTo(containerView).offset(-15);
    }];
    [self.nextButton setImage:[UIImage imageNamed:@"下一首"] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    self.playPauseButton = [UIButton new];
    [containerView addSubview:self.playPauseButton];
    [self.playPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.centerY.equalTo(self.thumImageView);
        make.right.equalTo(self.nextButton.mas_left).offset(-10);
    }];
    [self.playPauseButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [self.playPauseButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
    [self.playPauseButton addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    
    self.preButton = [UIButton new];
    [containerView addSubview:self.preButton];
    [self.preButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.thumImageView);
        make.right.equalTo(self.playPauseButton.mas_left).offset(-10);
    }];
    [self.preButton setImage:[UIImage imageNamed:@"上一首"] forState:UIControlStateNormal];
    [self.preButton addTarget:self action:@selector(pre) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pre {
    [[TTAudioPlayer shareInstance] pre];
}

- (void)next {
    [[TTAudioPlayer shareInstance] next];
}

- (void)playOrPause {
    BOOL isPlay = !self.playPauseButton.selected;
    if (isPlay) {
        [[TTAudioPlayer shareInstance] play];
    } else {
        [[TTAudioPlayer shareInstance] pause];
    }
}

@end
