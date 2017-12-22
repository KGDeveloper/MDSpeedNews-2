//
//  MDSpeedNews+CoreDataProperties.h
//  MDSpeedNews
//
//  Created by Medalands_1 on 16/4/13.
//  Copyright © 2016年 Medalands. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MDSpeedNews.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDSpeedNews (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *docid;
@property (nullable, nonatomic, retain) NSString *tid;

@end

NS_ASSUME_NONNULL_END
