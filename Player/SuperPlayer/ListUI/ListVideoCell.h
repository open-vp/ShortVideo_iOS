//
//  ListVideoCell.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/1/25.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListVideoModel : NSObject

@property NSString *cover;
@property NSString *url;
@property NSString *title;
@property int duration;

@end

@interface ListVideoCell : UITableViewCell



- (void)setDataSource:(ListVideoModel *)source;
- (ListVideoModel *)getSource;

@end
