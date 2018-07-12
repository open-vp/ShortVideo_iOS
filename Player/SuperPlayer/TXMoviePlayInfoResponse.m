//
//  TXMoviePlayInfoResponse.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/4/13.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "TXMoviePlayInfoResponse.h"

@implementation TXMoviePlayInfoStream
@end

@implementation TXMoviePlayInfoResponse

- (instancetype)initWithResponse:(NSDictionary *)dict {
    self = [super init];
    
    _responseDict = [NSDictionary dictionaryWithDictionary:dict];
    
    return self;
}

- (NSString *)playUrl {
    if (self.master) {
        return self.master.url;
    }
    if (self.streamList.count > 0) {
        return self.streamList[0].url;
    }
    if (self.source) {
        return self.source.url;
    }
    return nil;
}

- (TXMoviePlayInfoStream *)playStream {
    if (self.master) {
        return self.master;
    }
    if (self.streamList.count > 0) {
        return self.streamList[0];
    }
    if (self.source) {
        return self.source;
    }
    return nil;
}

- (NSArray<TXMoviePlayInfoStream *> *)streamList
{
    NSMutableArray<TXMoviePlayInfoStream *> *result = [NSMutableArray new];
    NSDictionary *videoInfo = self.responseDict[@"videoInfo"];
    if ([videoInfo isKindOfClass:[NSDictionary class]]) {
        NSArray *transcodeList = videoInfo[@"transcodeList"];
        if ([transcodeList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *transcode in transcodeList) {
                if (![transcode isKindOfClass:[NSDictionary class]])
                    break;
                NSString *url = transcode[@"url"];
                NSNumber *width = transcode[@"width"];
                NSNumber *height = transcode[@"height"];
                NSNumber *size = transcode[@"size"];
                NSNumber *bitrate = transcode[@"bitrate"];
                NSNumber *duration = transcode[@"duration"];
                TXMoviePlayInfoStream *stream = [[TXMoviePlayInfoStream alloc] init];
                if ([url isKindOfClass:[NSString class]]) {
                    stream.url = url;
                }
                if ([width isKindOfClass:[NSNumber class]]) {
                    stream.width = [width intValue];
                }
                if ([height isKindOfClass:[NSNumber class]]) {
                    stream.height = [height intValue];
                }
                if ([size isKindOfClass:[NSNumber class]]) {
                    stream.size = [size intValue];
                }
                if ([bitrate isKindOfClass:[NSNumber class]]) {
                    stream.width = [bitrate intValue];
                }
                if ([duration isKindOfClass:[NSNumber class]]) {
                    stream.duration = [duration intValue];
                }
                [result addObject:stream];
            }
        }
    }
    
    return result;
}

- (NSArray<TXMoviePlayInfoStream *> *)sortedStreamList {
    return @[];
}

- (TXMoviePlayInfoStream *)source
{
    NSDictionary *videoInfo = self.responseDict[@"videoInfo"];
    if ([videoInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *sourceVideo = videoInfo[@"sourceVideo"];
        if ([sourceVideo isKindOfClass:[NSDictionary class]]) {
            NSString *url = sourceVideo[@"url"];
            NSNumber *width = sourceVideo[@"width"];
            NSNumber *height = sourceVideo[@"height"];
            NSNumber *size = sourceVideo[@"size"];
            NSNumber *bitrate = sourceVideo[@"bitrate"];
            NSNumber *duration = sourceVideo[@"duration"];
            TXMoviePlayInfoStream *stream = [[TXMoviePlayInfoStream alloc] init];
            if ([url isKindOfClass:[NSString class]]) {
                stream.url = url;
            }
            if ([width isKindOfClass:[NSNumber class]]) {
                stream.width = [width intValue];
            }
            if ([height isKindOfClass:[NSNumber class]]) {
                stream.height = [height intValue];
            }
            if ([size isKindOfClass:[NSNumber class]]) {
                stream.size = [size intValue];
            }
            if ([bitrate isKindOfClass:[NSNumber class]]) {
                stream.width = [bitrate intValue];
            }
            if ([duration isKindOfClass:[NSNumber class]]) {
                stream.duration = [duration intValue];
            }
            return stream;
        }
    }
    
    return nil;
}

- (TXMoviePlayInfoStream *)master
{
    NSDictionary *videoInfo = self.responseDict[@"videoInfo"];
    if ([videoInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *sourceVideo = videoInfo[@"masterPlayList"];
        if ([sourceVideo isKindOfClass:[NSDictionary class]]) {
            NSString *url = sourceVideo[@"url"];
            TXMoviePlayInfoStream *stream = [[TXMoviePlayInfoStream alloc] init];
            if ([url isKindOfClass:[NSString class]]) {
                stream.url = url;
            }
            return stream;
        }
    }
    
    return nil;
}

- (NSString *)coverUrl {
    NSDictionary *coverInfo = self.responseDict[@"coverInfo"];;
    if ([coverInfo isKindOfClass:[NSDictionary class]]) {
        NSString *coverUrl = coverInfo[@"coverUrl"];
        if ([coverUrl isKindOfClass:[NSString class]]) {
            return coverUrl;
        }
    }
    return nil;
}

- (NSString *)name {
    NSDictionary *videoInfo = self.responseDict[@"videoInfo"];
    if ([videoInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *basicInfo = videoInfo[@"basicInfo"];
        if ([basicInfo isKindOfClass:[NSDictionary class]]) {
            NSString *name = basicInfo[@"name"];
            if ([name isKindOfClass:[NSString class]]) {
                return name;
            }
        }
    }
    return nil;
}

- (NSString *)videoDescription {
    NSDictionary *videoInfo = self.responseDict[@"videoInfo"];
    if ([videoInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *basicInfo = videoInfo[@"basicInfo"];
        if ([basicInfo isKindOfClass:[NSDictionary class]]) {
            NSString *description = basicInfo[@"description"];
            if ([description isKindOfClass:[NSString class]]) {
                return description;
            }
        }
    }
    return nil;
}
@end
