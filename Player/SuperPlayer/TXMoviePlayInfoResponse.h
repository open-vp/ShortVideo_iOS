//
//  TXMoviePlayInfoResponse.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/4/13.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXPlayerAuthParams.h"

@interface TXMoviePlayInfoStream : NSObject
@property NSString *url;
@property int height;
@property int width;
@property int size;
@property int bitrate;
@property int duration;
@end


@interface TXMoviePlayInfoResponse : NSObject

@property (copy) NSDictionary *responseDict;
@property (nonatomic) NSString *playUrl;  // 获取服务器下发的播放地址
@property (readonly) TXMoviePlayInfoStream *playStream;
@property (nonatomic) NSArray<TXMoviePlayInfoStream *> *streamList;
@property (nonatomic) TXMoviePlayInfoStream *source;
@property (nonatomic) TXMoviePlayInfoStream *master;
@property (readonly) NSString *coverUrl;
@property (readonly) NSString *name;
@property (readonly) NSString *videoDescription;

- (instancetype)initWithResponse:(NSDictionary *)dict;

@end
