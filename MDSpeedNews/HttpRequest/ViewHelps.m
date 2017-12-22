//
//  ViewHelps.m
//  Demo_1网络练习
//
//  Created by Medalands on 15/10/22.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "ViewHelps.h"

@implementation ViewHelps

+ (void) showHUDWithText:(NSString *)message{
    
    [[self class] showHUDWithText:message completionBlock:nil];
}

+ (void)showHUDWithText:(NSString *)message completionBlock:(void(^)(void))completionBlock{
    
    UIWindow *tmpWindow = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *tmpHUD = [[MBProgressHUD alloc] initWithView:tmpWindow];
    
    [tmpWindow addSubview:tmpHUD];
    
    [tmpHUD setMode:MBProgressHUDModeCustomView];
    
    // -- 设置文字
    [tmpHUD setDetailsLabelText:message];
    
    [tmpHUD show:YES];
    
    [tmpHUD hide:YES afterDelay:1];
    
    tmpHUD.completionBlock = completionBlock;
}
@end
