//
//  MDChannelView.h
//  MDSpeedNews
//
//  Created by Medalands on 16/4/8.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDChannelViewDelegate <NSObject>

@required
/**
 *  点击了显示更多频道的按钮,传出去按钮的状态
 *
 *  @param show 按钮的状态
 */
- (void) clickToMoreChannelViewShowOrHidden:(BOOL)show;
/**
 *  点击了删除按钮,开启或者关闭删除模式
 */
- (void) clickToMoreChannelViewDeleteButtonShowOrHidden;

@end

@interface MDChannelView : UIView
/**
 *  点击频道按钮时，把下标传给controller，再传给MDSNScollView
 */
@property (nonatomic , copy) void (^sendButtonIndexWhenClick)(NSInteger index);
/**
 *  代理人
 */
@property (nonatomic , weak) id<MDChannelViewDelegate>delegate;
/**
 *  显示更多频道的按钮(方便外部调用)
 */
@property (nonatomic , strong) UIButton *moreButton;
/**
 *  传进来一个频道名字，建一个按钮放在滚动视图上
 *
 *  @param title 频道名字
 */
- (void) loadButtonWithTitle:(NSString *)title;
/**
 *  删除频道按钮
 *
 *  @param index 按钮的下标
 */
- (void) deleteChannelWithIndex:(NSInteger)index;
/**
 *  默认第一个频道被选中
 */
- (void) setFirstButtonDefaultSeleted;
/**
 *  当MDScrollView滚动的时候，根据下标，使响应的按钮被选中
 *
 *  @param page ：NSInteget -》MDScrollView滚动到的页面
 */
- (void) setButtonSelectedAccordingPage:(NSInteger)page;

@end






