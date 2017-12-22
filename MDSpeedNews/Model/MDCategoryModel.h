//
//  MDCategoryModel.h
//  MDSpeedNews
//
//  Created by Medalands on 16/4/7.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDBaseModel.h"

@interface MDCategoryModel : MDBaseModel

@property (nonatomic , copy) NSString *tname;

@property (nonatomic , copy) NSString *tid;
/**
 *  声明字典的属性,保存频道的信息
 */
@property (nonatomic , strong) NSDictionary *channelDict;

@end
