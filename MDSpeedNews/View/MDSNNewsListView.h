//
//  MDSNNewsListView.h
//  MDSpeedNews
//
//  Created by Medalands on 16/4/6.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCategoryModel.h"

@interface MDSNNewsListView : UIView
 /**
 *  接收传过来的model，取出来tid去请求数据
 */
@property (nonatomic , copy) NSString *tid;
/**
 *  传controller出去,方便跳转
 */
@property (nonatomic , copy) void(^pushViewControllerBlack)(UIViewController *controller);

// tableView
@property (nonatomic , strong) UITableView *listTableView;
/**
 *判断是否需要自动刷新
 */
- (void) autoRefreshIfNeed;
/**
 *  传送下标出去
 *
 *  @param indPath 当前下标
 */
- (void) sendIndPathToController:(NSInteger)indPath;


@end
