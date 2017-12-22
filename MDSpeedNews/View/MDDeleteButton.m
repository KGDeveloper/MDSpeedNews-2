//
//  MDDeleteButton.m
//  MDSpeedNews
//
//  Created by Medalands_1 on 16/4/12.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDDeleteButton.h"

@interface MDDeleteButton ()
/**
 *  声明一个按钮,红色的删除按钮
 */
@property (nonatomic , strong) UIButton *deleteButton;

@end

@implementation MDDeleteButton

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUpDeleteButton];
        
    }
    
    return self;
}

#pragma mark -添加删除按钮 && 按钮的点击事件-
//添加删除按钮
- (void) setUpDeleteButton
{
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.deleteButton setFrame:CGRectMake(self.frame.size.width - 13, - 6.5, 19, 19)];
    
    [self.deleteButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    [self.deleteButton addTarget:self action:@selector(deleteButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.deleteButton];
}

//删除按钮的点击事件
- (void) deleteButtonDidPress:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteButtonClick:)]) {
        
        [self.delegate deleteButtonClick:sender];
    }
}

#pragma mark -设置删除按钮的状态-
- (void) setDeleteButtonStates:(MDDeleteButtonState)states
{
    switch (states) {
            //正常状态
        case MDDeleteButtonStateNormal:
            
            [self.deleteButton setHidden:YES];
            
            break;
            //可以删除状态
        case MDDeleteButtonStateCanDelete:
            
            [self.deleteButton setHidden:NO];
            
            break;
            //不能删除状态
        case MDDeleteButtonStateCanNotDelete:
            
            [self.deleteButton setHidden:YES];
            
            break;
            
        default:
            break;
    }
}

@end
