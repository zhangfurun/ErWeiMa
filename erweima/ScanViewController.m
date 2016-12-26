//
//  ScanViewController.m
//  erweima
//
//  Created by 张福润 on 2016/12/26.
//  Copyright © 2016年 张福润. All rights reserved.
//

#import "ScanViewController.h"

#import <AVFoundation/AVFoundation.h>

#define SCREEN_WIDTH [UIApplication sharedApplication].delegate.window.frame.size.width
#define SCREEN_HEIGHT [UIApplication sharedApplication].delegate.window.frame.size.height

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.output.rectOfInterest = CGRectMake((100)/(SCREEN_HEIGHT),(SCREEN_WIDTH - 100 - 200)/SCREEN_WIDTH,100/SCREEN_HEIGHT,200/SCREEN_WIDTH);
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    redView.layer.borderWidth = 2;
    redView.layer.borderColor = [UIColor cyanColor].CGColor;
    [self.view addSubview:redView];
    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    
    
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    _preview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    [_session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0){
        //停止扫描
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:stringValue delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [self.view addSubview:alert];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [_session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
