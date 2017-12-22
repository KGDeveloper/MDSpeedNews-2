//
//  MDDeleteButton.h
//  MDSpeedNews
//
//  Created by Medalands_1 on 16/4/12.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  表明按钮状态的枚举(判断红色按钮是否该隐藏)
 */
typedef NS_ENUM(NSInteger,MDDeleteButtonState) {
    /**
     *  正常状态
     */
    MDDeleteButtonStateNormal = 0,
    /**
     *  可以删除状态
     */
    MDDeleteButtonStateCanDelete,
    /**
     *  不能删除状态
     */
    MDDeleteButtonStateCanNotDelete
};

@protocol MDDeleteButtonDelegate <NSObject>
/**
 *  点击红色按钮的回调(因为我们需要知道在moreChannelview上点击的哪一个按钮,所以我们的参数是deleteButton)
 *
 *  @param deleteButton 按钮
 */
- (void) deleteButtonClick:(UIButton *)deleteButton;

@end

@interface MDDeleteButton : UIButton
/**
 *  代理人属性
 */
@property (nonatomic , weak) id<MDDeleteButtonDelegate>delegate;
/**
 *  设置删除按钮的状态
 *
 *  @param states MDDeleteButtonState枚举
 */
- (void) setDeleteButtonStates:(MDDeleteButtonState)states;

@end
