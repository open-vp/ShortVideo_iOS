//
//  BottomTabBar.m
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/11.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "BottomTabBar.h"
#import "ColorMacro.h"
#import "UIView+Additions.h"

#define kButtonCount 7
#define kButtonNormalColor UIColorFromRGB(0x181818);

@implementation BottomTabBar
{
    UIButton*       _btnCut;        //裁剪
    UIButton*       _btnTime;       //时间特效
    UIButton*       _btnFilter;     //滤镜
    UIButton*       _btnMusic;      //混音
    UIButton*       _btnEffect;     //特效
    UIButton*       _btnText;       //字幕
    UIButton*       _btnPaster;     //贴纸
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        _btnCut = [[UIButton alloc] init];
//        _btnCut.backgroundColor = kButtonNormalColor;
        [_btnCut setImage:[UIImage imageNamed:@"ic_cut"] forState:UIControlStateNormal];
        [_btnCut setImage:[UIImage imageNamed:@"ic_cut_press"] forState:UIControlStateHighlighted];
        [_btnCut addTarget:self action:@selector(onCutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCut];
        
        _btnTime = [[UIButton alloc] init];
        //        _btnCut.backgroundColor = kButtonNormalColor;
        [_btnTime setImage:[UIImage imageNamed:@"time"] forState:UIControlStateNormal];
        [_btnTime setImage:[UIImage imageNamed:@"time_press"] forState:UIControlStateHighlighted];
        [_btnTime addTarget:self action:@selector(onTimeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnTime];
        
        _btnEffect = [[UIButton alloc] init];
        //        _btnMusic.backgroundColor = kButtonNormalColor;
        [_btnEffect setImage:[UIImage imageNamed:@"ic_music"] forState:UIControlStateNormal];
        [_btnEffect setImage:[UIImage imageNamed:@"ic_music_press"] forState:UIControlStateHighlighted];
        [_btnEffect addTarget:self action:@selector(onEffectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnEffect];
        
        _btnFilter = [[UIButton alloc] init];
//        _btnFilter.backgroundColor = kButtonNormalColor;
        [_btnFilter setImage:[UIImage imageNamed:@"ic_beautiful"] forState:UIControlStateNormal];
        [_btnFilter setImage:[UIImage imageNamed:@"ic_beautiful_press"] forState:UIControlStateHighlighted];
        [_btnFilter addTarget:self action:@selector(onFilterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnFilter];
        
        _btnMusic = [[UIButton alloc] init];
//        _btnMusic.backgroundColor = kButtonNormalColor;
        [_btnMusic setImage:[UIImage imageNamed:@"ic_music"] forState:UIControlStateNormal];
        [_btnMusic setImage:[UIImage imageNamed:@"ic_music_press"] forState:UIControlStateHighlighted];
        [_btnMusic addTarget:self action:@selector(onMusicBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnMusic];
        
        _btnPaster = [[UIButton alloc] init];
//        _btnPaster.backgroundColor = kButtonNormalColor;
        [_btnPaster setImage:[UIImage imageNamed:@"decorate_nor"] forState:UIControlStateNormal];
        [_btnPaster setImage:[UIImage imageNamed:@"decorate_pressed"] forState:UIControlStateHighlighted];
        [_btnPaster addTarget:self action:@selector(onPasterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnPaster];
        
        _btnText = [[UIButton alloc] init];
//        _btnText.backgroundColor = kButtonNormalColor;
        [_btnText setImage:[UIImage imageNamed:@"ic_word"] forState:UIControlStateNormal];
        [_btnText setImage:[UIImage imageNamed:@"ic_word_press"] forState:UIControlStateHighlighted];
        [_btnText addTarget:self action:@selector(onTextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnText];
        
        
        [self onCutBtnClicked];
        
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonWidth= self.width / kButtonCount;
    int i = 0;
    _btnCut.frame = CGRectMake(buttonWidth * i++, 0, buttonWidth, self.height);
    _btnTime.frame = CGRectMake(buttonWidth * i++, 0, buttonWidth, self.height);
    _btnEffect.frame = CGRectMake(buttonWidth * i++, 0, buttonWidth, self.height);
    _btnFilter.frame = CGRectMake(buttonWidth * i++, 0, buttonWidth, self.height);
    _btnMusic.frame = CGRectMake(buttonWidth * i++, 0, buttonWidth, self.height);
    _btnPaster.frame = CGRectMake(buttonWidth * i++, 0, buttonWidth, self.height);
    _btnText.frame = CGRectMake(buttonWidth * i++, 0, buttonWidth, self.height);
}

- (void)resetButtonNormal
{
    [_btnCut setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
    [_btnTime setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
    [_btnFilter setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
    [_btnMusic setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
    [_btnEffect setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
    [_btnPaster setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
    [_btnText setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
}


#pragma mark - click handle
- (void)onCutBtnClicked
{
    [self resetButtonNormal];
    [_btnCut setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [self.delegate onCutBtnClicked];
}

- (void)onTimeBtnClicked
{
    [self resetButtonNormal];
    [_btnTime setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [self.delegate onTimeBtnClicked];
}

- (void)onEffectBtnClicked
{
    [self resetButtonNormal];
    [_btnEffect setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [self.delegate onEffectBtnClicked];
}

- (void)onFilterBtnClicked
{
    [self resetButtonNormal];
    [_btnFilter setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [self.delegate onFilterBtnClicked];
}

- (void)onMusicBtnClicked
{
    [self resetButtonNormal];
    [_btnMusic setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [self.delegate onMusicBtnClicked];
}

- (void)onTextBtnClicked
{
    [self resetButtonNormal];
    [_btnText setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [self.delegate onTextBtnClicked];
}

- (void)onPasterBtnClicked
{
    [self resetButtonNormal];
    [_btnPaster setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [self.delegate onPasterBtnClicked];
}

@end
