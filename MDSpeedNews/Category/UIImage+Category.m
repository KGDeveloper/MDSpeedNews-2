//
//  UIImage+Category.m
//  zhuna2.0
//
//  Created by zhuna on 13-8-15.
//  Copyright (c) 2013年 zhuna. All rights reserved.
//

#import "UIImage+Category.h"

typedef void (*FilterCallback)(UInt8 *pixelBuf, UInt32 offset, void *context);
#define SAFECOLOR(color) MIN(255,MAX(0,color))

@implementation UIImage (CategoryNN)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageNaviWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, .5, .5);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
