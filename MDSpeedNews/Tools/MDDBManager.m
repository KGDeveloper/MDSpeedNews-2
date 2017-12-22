//
//  MDDBManager.m
//  MDSpeedNews
//
//  Created by Medalands_1 on 16/4/13.
//  Copyright © 2016年 Medalands. All rights reserved.
//


#import "MDDBManager.h"
#import "AppDelegate.h"
#import "MDSpeedNews.h"

#define KAppdelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@implementation MDDBManager

+ (void) insertNewDocid:(NSString *)docid
{
    if ([[self class] isHaveDocid:docid]) {
        
        return;
    }
    
    MDSpeedNews *model = [NSEntityDescription insertNewObjectForEntityForName:@"MDSpeedNews" inManagedObjectContext:KAppdelegate.managedObjectContext];
    
    model.docid = docid;
    
    [KAppdelegate saveContext];
    
}

//查询CoreData是否有传入参数这条数据的记录(如果有返回YES)
+ (BOOL) isHaveDocid:(NSString *)docid
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"MDSpeedNews"];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"docid like %@",docid];
    
    [request setPredicate:pred];
    
    NSArray *resultArr = [KAppdelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    if (resultArr.count > 0) {
        
        return YES;
    }
    
    return NO;
}

@end
