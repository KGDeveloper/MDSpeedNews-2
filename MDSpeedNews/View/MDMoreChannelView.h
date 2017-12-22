//
//  MDMoreChannelView.h
//  MDSpeedNews
//
//  Created by Medalands_1 on 16/4/11.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDMoreChannelView : UIView
/**
 *  View显示的时候的frame,写在.h里面是因为View本身不能很好的设置好自己在父视图的位置
 */
@property (nonatomic , assign) CGRect showFrame;
/**
 *  点击了选中按钮的频道,跳转到响应的频道,并且使moreChannelView
 */
@property (nonatomic , copy) void(^jumpToChannelWithIndex)(NSInteger index);
/**
 *  点击了未选中频道的按钮,将在数组中的下标传出去,让MDScrollView和MDChannel添加频道
 */
@property (nonatomic , copy) void(^sendButtonIndexToAddChannel)(NSInteger index);
/**
 *  点击了选中频道的删除按钮,将在数组中得下标传出去,让MDScrollView删除频道
 */
@property (nonatomic , copy) void(^sendButtonIndexToDeleteChannel)(NSInteger index);
/**
 *  显示moreChannelView
 */
- (void) showMoreChannelView;
/**
 *  隐藏moreChannelView
 */
- (void) hiddenMoreChannelView;
/**
 *  添加正在展示的频道的按钮
 *
 *  @param title 频道的name
 */
- (void) addShowingChannelViewWithTitle:(NSString *)title;
/**
 *  创建中间的label和下面的滚动视图,方法写在.h里面是因为要在选中频道按钮后回调
 */
- (void) setUpMiddleLabelAndScrollerView;
/**
 *  添加没有展示的频道按钮
 *
 *  @param title 没有展示的频道
 */
- (void) addNotShowingChannelViewWithTitle:(NSString *)title;
/**
 *  开启或者关闭删除模式
 */
- (void) startOrCancelDeleteModel;

@end
