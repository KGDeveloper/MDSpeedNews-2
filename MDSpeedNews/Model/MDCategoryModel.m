//
//  MDCategoryModel.m
//  MDSpeedNews
//
//  Created by Medalands on 16/4/7.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDCategoryModel.h"

@implementation MDCategoryModel

- (id) initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        
        self.tid = dict[@"tid"];
        
        self.tname = dict[@"tname"];
        
        //我们用chanelDict保存频道的所有信息,我们只需要在NSUserDefaults保存self.channelDict就可以了
        self.channelDict = dict;
        
    }
    
    return self;
}

@end
