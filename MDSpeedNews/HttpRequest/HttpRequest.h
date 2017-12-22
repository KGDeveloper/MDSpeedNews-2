//
//  HttpRequest.h
//  TableView
//
//  Created by Micheal on 15/7/13.
//  Copyright (c) 2015年 Micheal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpRequest : NSObject

+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

@end
