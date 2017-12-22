//
//  MDDBManager.h
//  MDSpeedNews
//
//  Created by Medalands_1 on 16/4/13.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDDBManager : NSObject
//插
+ (void) insertNewDocid:(NSString *)docid;
/**
 *  查
 *
 *  @param docid 参数
 *
 *  @return 是否存在(存在返回(YES))
 */
+ (BOOL) isHaveDocid:(NSString *)docid;

@end
