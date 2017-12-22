//
//  MDHTMLService.m
//  MDYNews
//
//  Created by Medalands on 15/8/25.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDHTMLService.h"
#import <UIKit/UIKit.h>
#import "MDWebviewPicModel.h"

@implementation MDHTMLService

+(NSString *)htmlStringFromDic:(NSDictionary *)dic
{
    //取出标题
    NSString *title = [dic objectForKey:@"title"];
    //取出 body(body 自带格式,不需要重新拼接)
    NSString *body = [dic objectForKey:@"body"];
    //利用单例把这个文章的主要内容传过去
    //取出所有的图片,用 DetailWebPicture 对象存到 imgUrls 数组中
    NSArray *imgs = [dic objectForKey:@"img"];
    
    //取出时间
    NSString *time =[dic objectForKey:@"ptime"];
    
    NSMutableArray *imgUrls = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSDictionary *d in imgs) {
        MDWebviewPicModel *pic = [[MDWebviewPicModel alloc] init];
        [pic setValuesForKeysWithDictionary:d];//KVC
        NSArray * arr = [pic.pixel componentsSeparatedByString:@"*"];
        NSInteger m = [[arr objectAtIndex:0] intValue];
        NSInteger n = [[arr objectAtIndex:1] intValue];
        pic.src = [NSString stringWithFormat:@"<img src='%@' height='%f' width='960'/>",pic.src,700.0 * n /m];
        [imgUrls addObject:pic];
    }
    for (int i = 0; i < imgUrls.count; i++) {
        MDWebviewPicModel *pic = imgUrls[i];
        body = [body stringByReplacingOccurrencesOfString:pic.ref withString:pic.src];
    }
    
    //UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    UIFont *fontSize = [UIFont systemFontOfSize:28];
    NSString  *fontColor = @"#000000";
    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {font-size: %@;color:%@;}\n"
                          "</style> \n"
                          "</head> \n"
                          "<body><h2>%@</h2></body><body><h4>%@</body><body>&nbsp;&nbsp;&nbsp;%@</h4></body><body>%@</body> \n"
                          
                          "</html>",fontSize,fontColor,title,
                          
                          @"来源:速闻",time,body];
    return jsString;
}

@end
