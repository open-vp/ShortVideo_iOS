//
//  ListVideoCell.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/1/25.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "ListVideoCell.h"
#import "TXVodPlayer.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation ListVideoModel
@end

@interface ListVideoCell()
@property UIImageView *thumb;
@property UILabel *durationLabel;
@property UILabel *title;
@end

@implementation ListVideoCell {
    ListVideoModel *_source;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.thumb = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.thumb.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.thumb];
        [self.thumb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(120, 68));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(15);
        }];
        
        self.durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.durationLabel.font = [UIFont systemFontOfSize:12];
        self.durationLabel.textColor = [UIColor whiteColor];
        [self.thumb addSubview:self.durationLabel];
        [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.thumb.mas_right).offset(-7);
            make.bottom.equalTo(self.thumb.mas_bottom).offset(-7);
        }];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.font = [UIFont systemFontOfSize:14];
        self.title.textColor = [UIColor whiteColor];
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.thumb.mas_right).offset(20);
            make.right.equalTo(self.mas_right).offset(20);
            make.height.mas_equalTo(68);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDataSource:(ListVideoModel *)source;
{
    _source = source;
    
    int duration = source.duration;
    [self.thumb sd_setImageWithURL:[NSURL URLWithString:_source.cover]
                  placeholderImage:nil];
    self.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d", duration / 60, duration % 60];
    self.title.text = source.title;
}

- (ListVideoModel *)getSource;
{
    return _source;
}


@end
