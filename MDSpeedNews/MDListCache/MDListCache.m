//
//  MDListCache.m
//  MDSpeedNews
//
//  Created by Medalands_1 on 16/4/13.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDListCache.h"

@implementation MDListCache

+(void)setObjectWithDict:(NSDictionary *)dict withKey:(NSString *)key
{
    //拿到本地的缓存文件夹目录
    NSString *cachePathString = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *filePath = [cachePathString stringByAppendingPathComponent:@"com.medalands.listCache"];
    
    //判断是否存在
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //缓存文件的路径
    NSString *cacheListPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    
    //写入文件
    [dict writeToFile:cacheListPath atomically:YES];
    
}

+(NSDictionary *)readCacheForKey:(NSString *)key
{
    //拿到本地的缓存文件夹目录
    NSString *cachePathString = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *filePath = [cachePathString stringByAppendingPathComponent:@"com.medalands.listCache"];
    
    //缓存文件的路径
    NSString *cacheListPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:cacheListPath];
    
    return dict;
    
}

@end
