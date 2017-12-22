//
//  MDChannelView.m
//  MDSpeedNews
//
//  Created by Medalands on 16/4/8.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDChannelView.h"

@interface MDChannelView ()
<
UIScrollViewDelegate
>
{
    // 水平按钮X坐标
    CGFloat horizontalX;
}
// 承载频道按钮的滚动视图
@property (nonatomic , strong) UIScrollView *channelScrollView;
/**
 *  保存显示按钮的数组
 */
@property (nonatomic , strong) NSMutableArray *buttonArr;
/**
 *  当moreChannelView出现的时候战士的view
 */
@property (nonatomic , strong) UIView *subChannelView;

@property (nonatomic , strong) UIImageView *tmpImageView;

@end

@implementation MDChannelView

- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.buttonArr = [NSMutableArray array];
        
        horizontalX = 15;
        
        [self setUpChannelScrollViewAndMoreButton];
        
        [self setUpSubChannelView];
        
        [self setUpImageView];
    }
    return self;
    
}

// 封装一个方法去实现滚动视图和更多频道按钮
- (void) setUpChannelScrollViewAndMoreButton{
    
    self.channelScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 50, self.frame.size.height)];
    
    [self.channelScrollView setDelegate:self];
    
    // 隐藏滚动条
    [self.channelScrollView setShowsHorizontalScrollIndicator:NO];
    
    [self addSubview:self.channelScrollView];
    
    // more button
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.moreButton setFrame:CGRectMake(self.frame.size.width - 50, 0, 50, self.frame.size.height)];
    
    [self.moreButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    
    [self.moreButton setImage:[UIImage imageNamed:@"pull"] forState:UIControlStateSelected];
    
    [self.moreButton addTarget:self action:@selector(moreButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.moreButton];
    
    // 更多按钮左边的线
    UIImageView *lineImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(self.moreButton.frame.origin.x, 0, 2, self.frame.size.height)];
    
    [lineImageView setImage:[UIImage imageNamed:@"divl"]];
    
    [self addSubview:lineImageView];
}

#pragma mark - 显示更多频道按钮的点击事件 -
- (void) moreButtonDidPress:(UIButton *)sender{

    if (sender.selected) {
        
        [sender setSelected:NO];
        
        [self.subChannelView setAlpha:0.0f];
    }
    else
    {
        [sender setSelected:YES];
        
        [self.subChannelView setAlpha:1.0f];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickToMoreChannelViewShowOrHidden:)]) {
        
        [self.delegate clickToMoreChannelViewShowOrHidden:sender.selected];
    }
}

#pragma mark -当morechannelview出现的时候战士的view && subchannelview上删除按钮的点击事件-

- (void) setUpSubChannelView
{
    self.subChannelView = [[UIView alloc]initWithFrame:self.channelScrollView.bounds];
    
    [self.subChannelView setBackgroundColor:[UIColor whiteColor]];
    
    //开始的时候是隐藏的
    [self.subChannelView setAlpha:0.0f];
    
    //加label
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 43)];
    
    [titleLabel setText:@"切换栏目"];
    
    [titleLabel setTextColor:MDRGBA(153, 153, 153, 1.0)];
    
    [titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    
    [self.subChannelView addSubview:titleLabel];
    
    //删除
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [deleteButton setFrame:CGRectMake(self.subChannelView.frame.size.width - 15 - 25, (self.subChannelView.frame.size.height - 28)/2, 25, 28)];
    
    [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    
    [deleteButton addTarget:self action:@selector(deleteButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.subChannelView addSubview:deleteButton];
    
    [self addSubview:self.subChannelView];
    
}

#pragma mark -删除频道按钮的点击事件-
- (void) deleteButtonDidPress:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickToMoreChannelViewDeleteButtonShowOrHidden)]) {
        
        [self.delegate clickToMoreChannelViewDeleteButtonShowOrHidden];
    }
}

#pragma mark 加载更多频道 && 频道按钮的点击事件 && 默认第一个被选中 -
- (void) loadButtonWithTitle:(NSString *)title{
    
    // button 的字号
    UIFont *buttonFont = [UIFont systemFontOfSize:17.0f];
    
    // 根据一个尺寸限制、文字、字号 去得到一个矩形
    
    /*
     size: 宽高限制，用于计算文本绘制时的矩形块
     
     options：
     
     context：上下文，也就是信息：包括如何调整字间距以及缩放。
     */
    CGRect tmpRect = [title boundingRectWithSize:CGSizeMake(1000, self.frame.size.height) options:0 attributes:@{NSFontAttributeName : buttonFont} context:nil];
    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [tmpButton.titleLabel setFont:buttonFont];
    
    [tmpButton setFrame:CGRectMake(horizontalX, 0, tmpRect.size.width, self.frame.size.height)];
    
    [tmpButton setTitle:title forState:UIControlStateNormal];
    
    [tmpButton setTitleColor:MDRGBA(153, 153, 153, 1.0) forState:UIControlStateNormal];
    
    // 设置被选中时的颜色
    [tmpButton setTitleColor:MDRGBA(51, 153, 51, 1.0) forState:UIControlStateSelected];
    
    [tmpButton addTarget:self action:@selector(selectChannelButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    // 改变按钮
    horizontalX = horizontalX + tmpButton.frame.size.width + 20;
    
    // 改变channelView的ContentSize
    [self.channelScrollView setContentSize:CGSizeMake(horizontalX, self.channelScrollView.frame.size.height)];
    
    // 往数组中添加按钮
    [self.buttonArr addObject:tmpButton];
    
    [self.channelScrollView addSubview:tmpButton];
    
}

- (void) deleteChannelWithIndex:(NSInteger)index
{
    //根据下标去获取到按钮,从父视图移除,从数组中移除,排列剩下的按钮
    
    if (self.buttonArr.count > index) {
        
        //获取按钮
        UIButton *deleteButton = [self.buttonArr objectAtIndex:index];
        
        //得到空出来的区域
        CGFloat whiteSpace = deleteButton.frame.size.width + 20;
        
        //因为还有可能加频道,就算下一个加载的按钮的X
        horizontalX -= whiteSpace;
        
        //重新排列剩下的按钮
        for (NSInteger i = index; i < self.buttonArr.count ; i++) {
            
            UIButton *tmpButton = self.buttonArr[i];
            
            [tmpButton setFrame:CGRectOffset(tmpButton.frame, - whiteSpace, 0)];
        }
        //重新设置contentsize
        [self.channelScrollView setContentSize:CGSizeMake(self.channelScrollView.contentSize.width - whiteSpace, self.channelScrollView.contentSize.height)];
        
        //从数组和父视图移除
        [self.buttonArr removeObject:deleteButton];
        
        [deleteButton removeFromSuperview];
        
    }
    
}

// 频道按钮的点击事件
- (void) selectChannelButtonDidPress:(UIButton *) sender{
    
    /*
     *  先把所有按钮的选中取消，再设置点击的按钮被选中
     */
    [self.buttonArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if(obj && [obj isKindOfClass:[UIButton class]]){
            
            [obj setSelected:NO];
        }
        
    }];
    
    [sender setSelected:YES];
    
    [self.tmpImageView setFrame:CGRectMake(sender.frame.origin.x + (sender.frame.size.width)/2, self.frame.size.height - 10, 8, 8)];
    
    /*
     点击按钮，获得下标，传给controller，让controller传给下面的那个view，实现点击按钮，下面跟着动
    */
    
    // 需要知道按钮在buttonArr里面的位置(下标是从0开始计算)
    NSInteger index = [self.buttonArr indexOfObject:sender];
    
    
    if (self.sendButtonIndexWhenClick) {
        
        self.sendButtonIndexWhenClick(index);
        
    }
}

#pragma mark -实现小球的滚动-
- (void) setUpImageView
{
    self.tmpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(horizontalX + 15, self.frame.size.height - 10, 8, 8)];
    
    [self.tmpImageView setBackgroundColor:MDRGBA(51, 153, 51, 1.0)];
    
    [self.tmpImageView.layer setCornerRadius:4.0f];
    
    [self.channelScrollView addSubview:self.tmpImageView];
}

// 设置默认第一个按钮被选中
- (void) setFirstButtonDefaultSeleted{
    
    if (self.buttonArr.count > 0) {
        
        UIButton *firstButton = [self.buttonArr firstObject];
        
        [firstButton setSelected:YES];
    }
}

#pragma mark - 当MDSNScrollView滚动的时候，使相应的按钮被选中 -
- (void) setButtonSelectedAccordingPage:(NSInteger)page{
    
    for (UIButton *tmpButton in self.buttonArr) {
        
        if (tmpButton && [tmpButton isKindOfClass:[UIButton class]]) {
            
            [tmpButton setSelected:NO];
        }
    }
    
    if (self.buttonArr.count > page) {
        // 获取按钮，调按钮的点击事件
        UIButton *selectedButton = self.buttonArr[page];
        
        if (selectedButton && [selectedButton isKindOfClass:[UIButton class]]) {
            [selectedButton setSelected:YES];
            
            // 获取到滚动视图的宽和高
            CGFloat channelScrollViewWidth = self.channelScrollView.frame.size.width;
            
            CGFloat channelScrollViewHeight = self.channelScrollView.frame.size.height;
            
            // 定义某个区域是滚动视图可见的，如果可见就不操作
            [self.channelScrollView scrollRectToVisible:CGRectMake(selectedButton.center.x - channelScrollViewWidth/2, 0, channelScrollViewWidth, channelScrollViewHeight) animated:YES];
            
            [self.tmpImageView setFrame:CGRectMake(selectedButton.frame.origin.x + (selectedButton.frame.size.width)/2, self.frame.size.height - 10, 8, 8)];
        }
    }
}


// 比较low的方法去让当前频道居中
- (void) lowFunForScrollViewContentOffsetSet{
    UIButton *selectedButton = nil;
    // 获取按钮的中心x的坐标
    CGFloat buttonCenterX = selectedButton.center.x;
    
    // 改变后的偏移量
    CGFloat scrollViewContenOffsetX = buttonCenterX - self.channelScrollView.frame.size.width/2;
    
    // 偏移量不能小于0，不能大于contentSize.width - 滚动视图的宽
    if (scrollViewContenOffsetX < 0) {
        scrollViewContenOffsetX = 0;
    }
    else if(scrollViewContenOffsetX > (self.channelScrollView.contentSize.width - self.channelScrollView.frame.size.width)){
        
        scrollViewContenOffsetX = (self.channelScrollView.contentSize.width - self.channelScrollView.frame.size.width);
    }
    
    
    // 把偏移量给滚动视图
    [self.channelScrollView setContentOffset:CGPointMake(scrollViewContenOffsetX, 0) animated:YES];
}

@end
