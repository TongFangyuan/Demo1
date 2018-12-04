//
//  TTMusicModelProtocol.h
//  PlayerDemo
//
//  Created by admin on 2018/11/27.
//  Copyright © 2018年 Tongfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTMusicModelProtocol <NSObject>

@required
@property (nonatomic, copy) NSString *url;

@optional
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *album;

@end
