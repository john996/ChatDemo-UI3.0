/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import <AVFoundation/AVFoundation.h>
#import <CoreTelephony/CTCallCenter.h>
#import <UIKit/UIKit.h>
#import "GPUImage.h"

static CTCallCenter *g_callCenter;

@interface CallViewController : UIViewController<UIAlertViewDelegate, EMCallManagerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, GPUImageVideoCameraDelegate>
{
    NSTimer *_timeTimer;
    AVAudioPlayer *_ringPlayer;
    
    UIView *_topView;
    UILabel *_statusLabel;
    UILabel *_timeLabel;
    UILabel *_nameLabel;
    UIImageView *_headerImageView;
    
    UIView *_smallView;
    OpenGLView20 *_openGLView;
    AVCaptureVideoPreviewLayer *_smallCaptureLayer;
    AVCaptureSession *_session;
    AVCaptureVideoDataOutput *_captureOutput;
    AVCaptureDeviceInput *_captureInput;
    
    UIView *_actionView;
    UIButton *_silenceButton;
    UILabel *_silenceLabel;
    UIButton *_speakerOutButton;
    UILabel *_speakerOutLabel;
    
    UIButton *_rejectButton;
    UIButton *_answerButton;
    
    UIButton *_hangupButton;
    
    BOOL _isIncoming;
    int _timeLength;
    EMCallSession *_callSession;
    UITapGestureRecognizer *_tapRecognizer;
    
    UInt8 *_imageDataBuffer;
    UInt8 *_imageAfterDataBuffer;
    
    GPUImageVideoCamera* _videoCamera;
    GPUImageView* _gpuView;
    GPUImageRawDataOutput* _gpuImageDataOutput;
    GPUImageOutput<GPUImageInput>* _filter;
    UIImageView* _maImage;
    BOOL _isModify;
    NSTimer* _runTime;
    double _fractionOfAPixel;
    double _fractionCount;
    int _timeSum;
    
    UIButton* _pixelateBtn;
    UIButton* _polkDotBtn;
    UILabel* _timeShowLabel;
}
@property(strong, nonatomic) GPUImageRawDataOutput* gpuImageDataOutput;
@property (strong, nonatomic) NSString *chatter;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

- (instancetype)initWithSession:(EMCallSession *)session
                     isIncoming:(BOOL)isIncoming;

+ (BOOL)canVideo;

+ (void)saveBitrate:(NSString*)value;

@end
