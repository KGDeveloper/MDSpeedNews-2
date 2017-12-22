//
//  MDListCache.h
//  MDSpeedNews
//
//  Created by Medalands_1 on 16/4/13.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDListCache : NSObject

//插
+ (void) setObjectWithDict:(NSDictionary *)dict withKey:(NSString *)key;

//查
+ (NSDictionary *) readCacheForKey:(NSString *)key;

@end
