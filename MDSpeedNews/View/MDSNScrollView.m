//
//  MDSNScrollView.m
//  MDSpeedNews
//
//  Created by Medalands on 16/4/7.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDSNScrollView.h"

@interface MDSNScrollView ()
<
UIScrollViewDelegate
>

// 放置listView的滚动视图
@property (nonatomic , strong) UIScrollView *listScrollView;

// 声明一个数组的属性来保存listView
@property (nonatomic , strong) NSMutableArray *listViewArr;


@end

@implementation MDSNScrollView


- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.listViewArr = [NSMutableArray array];
        
        [self setClipsToBounds:YES];
        
        [self setUpListScrollView];
        
    }
    return self;
}

- (void) setUpListScrollView{
    
    self.listScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    [self.listScrollView setDelegate:self];
    
    // 整页滚动
    [self.listScrollView setPagingEnabled:YES];
    
    // 隐藏滚动条
    [self.listScrollView setShowsHorizontalScrollIndicator:NO];
    
    [self.listScrollView setShowsVerticalScrollIndicator:NO];
    
    // 背景颜色
    [self.listScrollView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.listScrollView];
    
}

#pragma mark - 添加MDSNNewsListView的对象 && 删除频道 -
//添加MDSNNewsListView的对象
- (void) loadNewsListView:(MDSNNewsListView *)listView{
    
    CGFloat selfWidth = self.listScrollView.frame.size.width;
    
    CGFloat selfHeight = self.listScrollView.frame.size.height;
    
    // 不知道外界给的listView是否符合需求，先改变frame
    [listView setFrame:CGRectMake(self.listViewArr.count * selfWidth, 0, selfWidth, selfHeight)];
    
    [self.listViewArr addObject:listView];

    [self.listScrollView setContentSize:CGSizeMake(self.listViewArr.count *selfWidth, selfHeight)];

    [self.listScrollView addSubview:listView];
}

//删除频道
- (void) deleteListViewWithPage:(NSInteger)page
{
    //获取到应该删除的MDSNNewsListView,从父视图移除,从数组中移除,重新计算frame
    if (self.listViewArr.count <= page) {
        
        return;
    }
    
    //获取到MDSNNewsListView
    MDSNNewsListView *deleteView = [self.listViewArr objectAtIndex:page];
    
    //从父视图移除,重新计算其余的频道的frame
    [deleteView removeFromSuperview];
    
    [self.listViewArr removeObject:deleteView];
    
    for (NSInteger i = page; i < self.listViewArr.count ; i++) {
        
        MDSNNewsListView *tmpListView = [self.listViewArr objectAtIndex:i];
        
        [tmpListView setFrame:CGRectOffset(tmpListView.frame, - self.listScrollView.frame.size.width, 0)];
    }
    
    //重新计算listscrollView的contentSize
    [self.listScrollView setContentSize:CGSizeMake(self.listViewArr.count * self.listScrollView.frame.size.width, self.listScrollView.frame.size.height)];
    
    //如果在显示最后的一个频道的时候,删除最后一个频道,因为不走协议里的方法,页面不会刷新,需要我们手动刷新
    [self sendCurrentListViewToRefreshWhenEndScroll];
}

#pragma mark - 得到当前滚动视图上的MDSNNewsListView 的对象
- (MDSNNewsListView *) getCurrentNewsListView{
    
    // 得到当前是第几个listView
    NSInteger currentPage =  self.listScrollView.contentOffset.x/self.listScrollView.frame.size.width;
    
    MDSNNewsListView *listView = nil;
    
    // 判断会不会数组越界
    if (self.listViewArr.count > currentPage) {
        
         listView = self.listViewArr[currentPage];
        
    }
    else{
        
        NSLog(@"数组越界 -》%@ -》%s", [self class], __FUNCTION__);
    }
    
    return listView;
}

#pragma mark - scrollViewDelegate -
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self sendCurrentListViewToRefreshWhenEndScroll];
    
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // 如果在拖动结束的时候，没有减速的过程
    if (!decelerate){

        [self sendCurrentListViewToRefreshWhenEndScroll];
    }
    
    
}

#pragma mark - 当滚动结束的时候把当前的listView传出去 以便刷新 -
- (void) sendCurrentListViewToRefreshWhenEndScroll{
    
    // 得到当前的listView
    MDSNNewsListView * listView = [self getCurrentNewsListView];
    
    // 判断block是否实现，如果实现，传到controller上，来启动刷新
    if (self.scrollViewEndToNewsListView) {
        
        self.scrollViewEndToNewsListView(listView);
        
    }
    
    // 声明一个回调，当我们滚的时候，告诉上边，滚过了，你给点反应。
    // 滚完之后，调用block，把当前页传给controller，让controller传给显示频道名的view，让响应的频道变色
    
    NSInteger page = self.listScrollView.contentOffset.x/self.listScrollView.frame.size.width;
    
    if (self.scrollViewScrollEndSendPage) {
        self.scrollViewScrollEndSendPage(page);
    }
    
    
}

// 点击频道按钮时，改变偏移量
- (void) scrollToNewListViewWithIndex:(NSInteger)index{
    
    // 先得到X轴偏移量
    CGFloat contentOffsetX = index * self.listScrollView.frame.size.width;
    
    // 设置偏移量
    [self.listScrollView setContentOffset:CGPointMake(contentOffsetX, 0)];
    
    // 因为手动设置不走协议的方法，我们手动刷新
    [self sendCurrentListViewToRefreshWhenEndScroll];
}




@end
