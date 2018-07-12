//
//  MainTableViewCell.m
//  RTMPiOSDemo
//
//  Created by rushanting on 2017/5/3.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "MainTableViewCell.h"
#import "ColorMacro.h"

@implementation CellInfo

@end


@interface MainTableViewCell () {
    UIImageView*         _backgroundView;
    UIImageView*    _iconImageView;
    UILabel*        _titleLabel;
    UIImageView*    _detailImageView;
}

@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.contentMode = UIViewContentModeScaleToFill;
        _backgroundView.image = [UIImage imageNamed:@"block_normal"];
        [self addSubview:_backgroundView];
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_backgroundView addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = UIColor.whiteColor;
        [_backgroundView addSubview:_titleLabel];

        _detailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        [_backgroundView addSubview:_detailImageView];

    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, 55);
    _iconImageView.frame = CGRectMake(25, (_backgroundView.frame.size.height - 32) / 2, 32, 32);
    _titleLabel.frame = CGRectMake(90, 0, 150, _backgroundView.frame.size.height);
    _detailImageView.center = CGPointMake(_backgroundView.frame.size.width - _detailImageView.image.size.width - 25, _backgroundView.center.y);
}

- (void)setCellData:(CellInfo*)cellInfo
{
    UIImage* image = [UIImage imageNamed:cellInfo.iconName];
    _iconImageView.image = image;
    _titleLabel.text = cellInfo.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        _backgroundView.image = [UIImage imageNamed:@"block_pressed"];
    } else {
        _backgroundView.image = [UIImage imageNamed:@"block_normal"];
    }
}


@end
