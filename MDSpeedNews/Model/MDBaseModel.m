//
//  BaseModel.m
//  MDSpeedNews
//
//  Created by Medalands on 16/4/7.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDBaseModel.h"

@implementation MDBaseModel

- (id) initWithDict:(NSDictionary *)dict{
    
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

- (void) setValue:(id)value forKey:(NSString *)key{
    
    [super setValue:value forKey:key];

}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    
}










@end
