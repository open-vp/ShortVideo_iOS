//
//  VideoComposeCell.m
//  TCLVBIMDemo
//
//  Created by annidyfeng on 2017/4/19.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "VideoJoinerCell.h"
#import "TXVideoEditer.h"

@implementation VideoJoinerCellModel


@end

@implementation VideoJoinerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(VideoJoinerCellModel *)model {
    _model = model;
    self.backgroundColor = UIColor.blackColor;
    self.name.text = [model.videoPath lastPathComponent];
    self.cover.image = model.cover;
    self.duration.text = [self time2str:model.duration];
    self.resolution.text = [NSString stringWithFormat:@"%d*%d",model.width,model.height];
}

- (NSString *)time2str:(int)time {
    int m = time / 60;
    int s = time % 60;
    
    return [NSString stringWithFormat:@"%d:%.2d", m, s];
}
@end
