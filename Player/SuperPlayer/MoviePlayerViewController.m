    //
//  MoviePlayerViewController.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MoviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry/Masonry.h>
#import "ZFPlayer.h"
#import "UINavigationController+ZFFullscreenPopGesture.h"
#import "ScanQRController.h"
#import "UIImage+Additions.h"
#import "ListVideoCell.h"
#import "TXPlayerAuthParams.h"
#import "TXVodPlayer.h"
#import "TCHttpUtil.h"
#import "MBProgressHUD.h"
#import "TXMoviePlayerNetApi.h"

#define LIST_VIDEO_CELL_ID @"LIST_VIDEO_CELL_ID"

__weak UITextField *appField;
__weak UITextField *fileidField;

@interface MoviePlayerViewController () <ZFPlayerDelegate, ScanQRDelegate, UITableViewDelegate, UITableViewDataSource,TXMoviePlayerNetDelegate>
/** 播放器View的父视图*/
@property (nonatomic) UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 是否播放默认宣传视频 */
@property (nonatomic, assign) BOOL isPlayDefaultVideo;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) UITextField *textView;

@property (nonatomic, strong) UITableView *videoListView;
@property NSMutableArray *authParamArray;
@property NSMutableArray *dataSourceArray;
@property TXMoviePlayerNetApi *getInfoNetApi;
@property MBProgressHUD *hud;

@end

@implementation MoviePlayerViewController

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image=[UIImage imageNamed:@"背景"];
    [self.view insertSubview:imageView atIndex:0];
    
    // 右侧
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //修改按钮向右移动10pt
    [button setFrame:CGRectMake(0, 0, 60, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"扫码"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickScan:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.hidden = !_isPlayDefaultVideo;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[rightItem];

    // 左侧
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    //修改按钮向右移动10pt
    [leftbutton setFrame:CGRectMake(0, 0, 60, 25)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    
    self.title = @"超级播放器";
//    // 中间
//    self.navigationItem.titleView = ({
//        UITextField *textView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-120, self.navigationController.navigationBar.bounds.size.height-8)];
//        textView.textColor = [UIColor whiteColor];
//        textView.backgroundColor = [UIColor clearColor];
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame: textView.frame];
//        imgView.image = [UIImage imageNamed: @"搜索框"];
//        [textView addSubview: imgView];
//        [textView sendSubviewToBack: imgView];
//        self.textView = textView;
//        textView;
//    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _authParamArray = [NSMutableArray new];
    _dataSourceArray = [NSMutableArray new];
    
    self.zf_prefersNavigationBarHidden = NO;
    if (!self.videoURL) {
        self.videoURL = [NSURL URLWithString:@"http://1252463788.vod2.myqcloud.com/95576ef5vodtransgzp1252463788/68e3febf4564972819220421305/master_playlist.m3u8"];
        _isPlayDefaultVideo = YES;
    }else{
        _isPlayDefaultVideo = NO;
    }
    
    self.playerFatherView = [[UIView alloc] init];
    self.playerFatherView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(20+self.navigationController.navigationBar.bounds.size.height);
        }
        make.leading.trailing.mas_equalTo(0);
        // 这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    [self.playerView autoPlayTheVideo];
    
    UILabel *label_v = [[UILabel alloc] initWithFrame:CGRectZero];
    label_v.text = @"视频列表";
    label_v.textColor = [UIColor whiteColor];
    label_v.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:label_v];
    [label_v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playerFatherView.mas_bottom).offset(20);
        make.left.mas_equalTo(15);
    }];
    [label_v sizeToFit];
    
    self.videoListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.videoListView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.videoListView];
    [self.videoListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label_v.mas_bottom).offset(5);
        make.left.mas_equalTo(0);
        make.leading.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.videoListView.delegate = self;
    self.videoListView.dataSource = self;
    [self.videoListView registerClass:[ListVideoCell class] forCellReuseIdentifier:LIST_VIDEO_CELL_ID];
    
    UIView *tableFooterView = [UIView new];
    tableFooterView.frame = CGRectMake(0, 0, ScreenWidth, 80);
    self.videoListView.tableFooterView = tableFooterView;
    [self.videoListView setSeparatorColor:[UIColor clearColor]];
    
    // 定义一个button
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"addp"] forState:UIControlStateNormal];
    addButton.hidden = !_isPlayDefaultVideo;
    [self.view addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label_v.mas_centerY);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
    }];
    [addButton addTarget:self action:@selector(onAddClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_isPlayDefaultVideo) {
        TXPlayerAuthParams *p = [TXPlayerAuthParams new];
        p.appId = 1252463788;
        p.fileId = @"4564972819220421305";
        [_authParamArray addObject:p];
        
        p = [TXPlayerAuthParams new];
        p.appId = 1252463788;
        p.fileId = @"4564972819219071568";
        [_authParamArray addObject:p];
        
        p = [TXPlayerAuthParams new];
        p.appId = 1252463788;
        p.fileId = @"4564972819219071668";
        [_authParamArray addObject:p];
        
        p = [TXPlayerAuthParams new];
        p.appId = 1252463788;
        p.fileId = @"4564972819219071679";
        [_authParamArray addObject:p];
        
        //    p = [TXPlayerAuthParams new];
        //    p.appId = 1252463788;
        //    p.fileId = @"4564972819219071693";
        //    [_authParamArray addObject:p];
        
        p = [TXPlayerAuthParams new];
        p.appId = 1252463788;
        p.fileId = @"4564972819219081699";
        [_authParamArray addObject:p];
        [self getNextInfo];
    }else{
        [TCHttpUtil asyncSendHttpRequest:@"api/v1/resource/videos" httpServerAddr:kHttpUGCServerAddr HTTPMethod:@"GET" param:nil handler:^(int result, NSDictionary *resultDict) {
            if (result == 0){
                NSDictionary *dataDict = resultDict[@"data"];
                if (dataDict) {
                    NSArray *list = dataDict[@"list"];
                    for(NSDictionary *dic in list){
                        TXPlayerAuthParams *p = [TXPlayerAuthParams new];
                        p.appId = [UGCAppid intValue];
                        p.fileId = dic[@"fileId"];
                        [_authParamArray addObject:p];
                    }
                    [self getNextInfo];
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取视频列表失败"
                                                                        message:[NSString stringWithFormat:@"错误码：%@ 错误信息：%@",resultDict[@"code"], resultDict[@"message"]]
                                                                       delegate:self
                                                              cancelButtonTitle:@"知道了"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
        }];
    }
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    // if (ZFPlayerShared.isLandscape) {
    //    return UIStatusBarStyleDefault;
    // }
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return ZFPlayerShared.isStatusBarHidden;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    [self backClick];
}

- (void)zf_playerDownload:(NSString *)url {

}

- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {

}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {

}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = @"小直播宣传视频";
        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
    }
    return _playerView;
}

- (void)onNetSuccess:(TXMoviePlayerNetApi *)obj
{
    ListVideoModel *model = [ListVideoModel new];
    model.cover = obj.playInfo.coverUrl;
    model.duration = obj.playInfo.source.duration;
    model.url = obj.playInfo.playUrl;
    model.title = obj.playInfo.videoDescription;
    if (model.title.length == 0) {
        model.title = obj.playInfo.name;
    }
    [_dataSourceArray addObject:model];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_videoListView reloadData];
        [self getNextInfo];
    });
}

- (void)onNetFailed:(TXMoviePlayerNetApi *)obj reason:(NSString *)reason code:(int)code {
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    [self.view addSubview:_hud];
    _hud.label.text = @"fileid请求失败";
    _hud.mode = MBProgressHUDModeText;
    
    [_hud showAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_hud removeFromSuperview];
        _hud = nil;
    });
}

- (void)getNextInfo {
    if (_authParamArray.count == 0)
        return;
    TXPlayerAuthParams *p = [_authParamArray objectAtIndex:0];
    [_authParamArray removeObject:p];
    
    if (self.getInfoNetApi == nil) {
        self.getInfoNetApi = [[TXMoviePlayerNetApi alloc] init];
        self.getInfoNetApi.delegate = self;
        self.getInfoNetApi.https = TRUE;
    }
    [self.getInfoNetApi getplayinfo:p.appId
                             fileId:p.fileId
                             timeout:p.timeout
                                  us:p.us
                               exper:p.exper
                                sign:p.sign];
}

#pragma mark - Action

- (IBAction)backClick {
    [self.playerView resetPlayer];  //非常重要
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) clickScan:(UIButton*) btn
{
    ScanQRController* vc = [[ScanQRController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)onScanResult:(NSString *)result
{
    self.textView.text = result;
    self.playerModel.title            = @"这是新播放的视频";
    self.playerModel.videoURL         = [NSURL URLWithString:result];
    [self.playerView resetToPlayNewVideo:self.playerModel];
}

- (void)onAddClick:(UIButton *)btn
{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"添加视频" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入appid";
        appField = textField;
    }];
    
    [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入fileid";
        fileidField = textField;
    }];
    
    [control addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        TXPlayerAuthParams *p = [TXPlayerAuthParams new];
        p.appId = [appField.text intValue];
        p.fileId = fileidField.text;
        [_authParamArray addObject:p];
        
        [self getNextInfo];
        
    }]];
     
    [control addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self.navigationController presentViewController:control animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    return 78;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger row = indexPath.row;
    ListVideoModel *param = [_dataSourceArray objectAtIndex:row];
    if (param) {
        ListVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:LIST_VIDEO_CELL_ID];
        [cell setDataSource:param];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListVideoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        _playerModel.title = [cell getSource].title;
        _playerModel.videoURL = [NSURL URLWithString:[cell getSource].url];
        _playerModel.placeholderImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[cell getSource].cover]]];
        
        [_playerView resetToPlayNewVideo:self.playerModel];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_dataSourceArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    }
}
@end
