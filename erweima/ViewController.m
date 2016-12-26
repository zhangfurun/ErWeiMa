//
//  ViewController.m
//  erweima
//
//  Created by 张福润 on 2016/12/26.
//  Copyright © 2016年 张福润. All rights reserved.
//

// QQ:122674287
// github:

#import "ViewController.h"

#import <CoreImage/CoreImage.h>

#import "ScanViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSString *dataString = @"锋绘动漫";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    
    //因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    self.imageView.image = [self getErWeiMaImageFormCIImage:outputImage withSize:200];
}

#pragma mark - Methods

- (UIImage *)getErWeiMaImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - Action
- (IBAction)onBtnTap:(UIButton *)sender {
    ScanViewController *scanVC = [ScanViewController new];
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
