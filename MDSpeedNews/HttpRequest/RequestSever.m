//
//  RequestSever.m
//  Demo_1网络练习
//
//  Created by Medalands on 15/10/22.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "RequestSever.h"

@implementation RequestSever

+ (void) showMsgWithError:(NSError *)error{
    
    if (error) {
        
        NSString *string = nil;
        
        if (error.code == -1009) {
            
           string = @"网络断开连接";
        }
        else if (error.code == -1003 || error.code == -1004){
            
            string = @"服务器异常";
        }
        else if (error.code == -1001){
            
            string = @"请求超时";
        }
        else if (error.code == 3848){
            
            string = @"转换JSON 格式错误";
        }
        else if (error.code == -1016){
            
            string = @"请求的内容格式和解析用方法不匹配";
        }
        else{
            
            string = @"网络不给力";
        }
        
        if (string) {
            
            [ViewHelps showHUDWithText:string];
        }
        else{
            
            [ViewHelps showHUDWithText:[NSString stringWithFormat:@"%@",error]];
        }
    }
}

@end
