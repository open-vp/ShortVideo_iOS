# ShortVideo_iOS                                

OpenVP开源技术社区

ios短视频录制功能

短视频录制：采集摄像头画面和麦克风声音，经过图像和声音处理后，进行（H264、AAC）编码压缩生成指定分辨率的MP4文件。 


1、基本录制

//设置正方形、全屏录制

 [[VPRecord shareInstance] setOrientation:VIDOE_ORIENTATION_FULL]; 
 
  
//设置视频录制比例：        3:4          9:16          1:1

 [VPRecord shareInstance] setAspectRatio:VIDEO_RATIO_9_16]; 
 
 
 
//设置视频录制速率

 [[VPRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_NOMAL]; 
 

  
//开始录制

 [[VPRecord shareInstance] startRecord];
 
 
//开始录制, 可以指定输出视频文件地址和时长   30s    2m

 [[VPRecord shareInstance] startRecord:videoPath time:time]; 
  
//暂停录制

 [[VPRecord shareInstance] pauseRecord]; 
 
//继续录制

 [[VPRecord shareInstance] resumeRecord]; 
 
//结束录制

 [[VPRecord shareInstance] stopRecord]; 



2、滤镜功能

//设置风格滤镜,选择滤镜背景

 [[VPRecord shareInstance] setFilter:filterImage]; 

//设置风格滤镜效果程度

 [[VPRecord shareInstance] setSpecialRatio:0.5];



3、美颜功能

//设置美颜和美白

 [[VPRecord shareInstance] setBeautyStyle:beautyStyle beautyLevel:beautyLevel ]; 
 
//设置大眼级别

 [[VPRecord shareInstance] setEyeScaleLevel:3]; 
 
//设置V 字脸级别

 [[VPRecord shareInstance] setFaceVLevel:3]; 
  
//设置短脸

 [[VPRecord shareInstance] setFaceShortLevel:3]; 

//设置瘦脸级别

 [[VPRecord shareInstance] setFaceScaleLevel:3]; 

//设置瘦鼻

 [[VPRecord shareInstance] setNoseSlimLevel:3]; 
 
4、设置无绿幕特效，替换自然背景

//替换自然背景

 [[VPRecord shareInstance] setNatureScreen: background]; 




