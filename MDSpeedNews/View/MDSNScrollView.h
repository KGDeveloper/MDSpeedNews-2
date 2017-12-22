//
//  MDSNScrollView.h
//  MDSpeedNews
//
//  Created by Medalands on 16/4/7.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSNNewsListView.h"

@interface MDSNScrollView : UIView
/**
 *当滚到其他页的时候，把当前的listView传给controller，让controller来控制刷新
 */
@property (nonatomic , copy) void (^scrollViewEndToNewsListView)(MDSNNewsListView *listView);
/**
 *  当滚到其他页的时候，把当前页面的下标传给controller，让controller传给显示频道名的MDChannelView
 */
@property (nonatomic , copy) void (^scrollViewScrollEndSendPage)(NSInteger page);
/**
 *添加listView
 *
 *@parm listView : MDSNNewsListView
 */
- (void) loadNewsListView:(MDSNNewsListView *)listView;
/**
 *  删除频道
 *
 *  @param page 要删除的页数
 */
- (void) deleteListViewWithPage:(NSInteger)page;
/**
 *得到当前滚动视图上的MDSNNewsListView
 *
 * @return MDSNNewsListView
 */
- (MDSNNewsListView *) getCurrentNewsListView;
/**
 *  根据点击频道按钮的index设置滚动视图的偏移量
 *
 *  @param index ：NSInteger -》 点击的频道的下标
 */
- (void) scrollToNewListViewWithIndex:(NSInteger)index;

@end
