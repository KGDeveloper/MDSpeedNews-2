//
//  MDMoreChannelView.m
//  MDSpeedNews
//
//  Created by Medalands_1 on 16/4/11.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDMoreChannelView.h"
#import "MDDeleteButton.h"

@interface MDMoreChannelView ()<MDDeleteButtonDelegate>
{
    /**
     *  按钮的宽
     */
    CGFloat buttonWidth;
    /**
     *  按钮的高
     */
    CGFloat buttonHeight;
    /**
     *  按钮间横向间隙
     */
    CGFloat buttonSpaceX;
    /**
     *  按钮间纵向间隙
     */
    CGFloat buttonSpaceY;
    //按钮距离左边和右边的距离
    CGFloat XSpace;

    //按钮的Y值和X值
    /**
     *  按钮居左的距离
     */
    CGFloat buttonX;
    /**
     *  按钮居上的距离
     */
    CGFloat buttonY;
}
/**
 *  保存View的起始位置,因为当View显示的时候frame改变了,那么隐藏的时候frame得变回原来的,我们拿一个属性保存下
 */
@property (nonatomic , assign) CGRect originFrame;
/**
 *  保存正在展示的频道的按钮的数组
 */
@property (nonatomic , strong) NSMutableArray *showingButtonArr;
/**
 *  中间的label
 */
@property (nonatomic , strong) UILabel *middleLabel;
/**
 *  放置未选中按钮的滚动视图
 */
@property (nonatomic , strong) UIScrollView *buttonScrollView;
/**
 *  保存没有展示频道按钮的数组
 */
@property (nonatomic , strong) NSMutableArray *notShowingButtonArr;
/**
 *  判断当前是否是删除模式
 */
@property (nonatomic , assign) BOOL isDelete;
/**
 *  默认最多频道数
 */
@property (nonatomic , assign) NSInteger defaultMaxOfChannel;

@end

@implementation MDMoreChannelView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.defaultMaxOfChannel = 20;
        
        //保存初始位置
        [self setOriginFrame:frame];
        
        [self setUpView];
        
    }
    
    return self;
}

/**
 *  对View进行一部分设置
 */
- (void) setUpView
{
    //设置背景色
    [self setBackgroundColor:MDRGBA(236, 236, 236, 0.96)];
    
    //切割
    [self setClipsToBounds:YES];
    
    //初始化删除状态为No
    self.isDelete = NO;

    //初始化数组
    self.showingButtonArr = [NSMutableArray array];
    
    self.notShowingButtonArr = [NSMutableArray array];
    
    //对按钮的位置进行设置
    XSpace = MDXFrom6(15);
    
    buttonHeight = MDXFrom6(33);
    
    buttonWidth = MDXFrom6(75);
    
    buttonSpaceX = (self.frame.size.width - 4 * buttonWidth - 2 * XSpace)/3;
    
    buttonSpaceY = MDXFrom6(15);
    
}

#pragma mark -添加选中频道的按钮 && 按钮的点击事件-
- (void) addShowingChannelViewWithTitle:(NSString *)title
{
    buttonY = buttonSpaceY + (self.showingButtonArr.count)/4 * (buttonHeight + buttonSpaceY);
    
    buttonX = XSpace + (self.showingButtonArr.count)%4 * (buttonWidth + buttonSpaceX);
    
    MDDeleteButton *showingButton = [self getDefaultButtonWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    
    [showingButton setTitle:title forState:UIControlStateNormal];
    
    [showingButton.layer setCornerRadius:10.0f];
    
    [showingButton setDelegate:self];
    
    [showingButton addTarget:self action:@selector(showingButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:showingButton];
    
    //添加到数组
    [self.showingButtonArr addObject:showingButton];
    
}

- (void) showingButtonDidPress:(MDDeleteButton *)sender
{
    if (self.isDelete) {
        
        return;
    }
    //点击了选择频道,获取到按钮在showingArr里面的下标,传给controller,显示该频道,并且取消显示morechannelview
    
    //取得下标
    NSInteger index = [self.showingButtonArr indexOfObject:sender];
    
    if (self.jumpToChannelWithIndex) {
        
        self.jumpToChannelWithIndex(index);
    }
}

#pragma mark -红色删除按钮的点击回调-
-(void) deleteButtonClick:(MDDeleteButton *)deleteButton
{
    /**
     *从showingbuttonarr里面移除对应的按钮,添加到nonshowingarr里面,移除点击事件,添加新的点击事件,再改变frame
     */
    //获取到父视图,获取父视图的下标,通过回调传给controller,删除频道
    MDDeleteButton *tmpButton = (MDDeleteButton *)[deleteButton superview];
    
    //改变删除状态
    [tmpButton setDeleteButtonStates:MDDeleteButtonStateNormal];
    
    //拿到下标
    NSInteger index = [self.showingButtonArr indexOfObject:tmpButton];

    //把下标传出去
    if (self.sendButtonIndexToDeleteChannel) {
        
        self.sendButtonIndexToDeleteChannel(index);
    }
    
    //从原来数组移除
    [self.showingButtonArr removeObject:tmpButton];
    
    //移除原来的点击事件
    [tmpButton removeTarget:self action:@selector(showingButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加到新的数组
    [self.notShowingButtonArr addObject:tmpButton];
    
    //添加新的点击事件
    [tmpButton addTarget:self action:@selector(notShowingButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    //更改父视图
    [self.buttonScrollView addSubview:tmpButton];
    
    //重新计算frame
    buttonY = buttonSpaceY + (self.notShowingButtonArr.count - 1)/4 * (buttonHeight + buttonSpaceY);
    
    buttonX = XSpace + (self.notShowingButtonArr.count - 1)%4 * (buttonWidth + buttonSpaceX);
    
    [tmpButton setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    
    //改变label的frame和scrollerView的frame
    buttonY = buttonSpaceY + (self.showingButtonArr.count - 1)/4 * (buttonHeight + buttonSpaceY) + buttonHeight + buttonSpaceY;
    
    [self.middleLabel setFrame:CGRectMake(0, buttonY, self.frame.size.width, 43)];
    
    buttonY += 43;
    
    [self.buttonScrollView setFrame:CGRectMake(0, buttonY, self.frame.size.width, self.frame.size.height - buttonY)];
    
    //改变滚动视图的contentSize
    [self.buttonScrollView setContentSize:CGSizeMake(self.buttonScrollView.frame.size.width, tmpButton.frame.origin.y + buttonHeight + buttonSpaceY)];
    
    __weak typeof(self) weakSelf = self;
    
    //重新布局展示区域剩下的Button
    [UIView animateWithDuration:0.4 animations:^{
        
        for (NSInteger i = index; i < weakSelf.showingButtonArr.count; i++) {
            
            MDDeleteButton *beleftButton = [weakSelf.showingButtonArr objectAtIndex:i];
            
            buttonY = buttonSpaceY + i/4 * (buttonHeight + buttonSpaceY);
            
            buttonX = XSpace + i%4 * (buttonWidth + buttonSpaceX);
            
            [beleftButton setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
        }
        
    }];
}

#pragma mark -创建中间的label和下面的滚动视图 :滚动视图用来承载未选中的频道按钮-
-(void)setUpMiddleLabelAndScrollerView
{
    //重新计算ButtonY当做label的Y
    buttonY += buttonHeight + buttonSpaceY;
    
    //实现放在中间的label
    self.middleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, buttonY, self.frame.size.width, 43)];
    
    [self.middleLabel setBackgroundColor:[UIColor whiteColor]];
    
    [self.middleLabel setText:@"  点击标签添加栏目"];
    
    [self.middleLabel setTextColor:MDRGBA(153, 153, 153, 1.0)];
    
    [self.middleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    
    [self addSubview:self.middleLabel];
    
    //实现保存未选中频道按钮的滚动视图
    self.buttonScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.middleLabel.frame.size.height + buttonY, self.frame.size.width, self.frame.size.height - (self.middleLabel.frame.size.height + buttonY))];
    
    [self.buttonScrollView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.buttonScrollView];
}

#pragma mark -添加未选中频道按钮 && 按钮的点击事件-
-(void)addNotShowingChannelViewWithTitle:(NSString *)title
{
    buttonY = buttonSpaceY + (self.notShowingButtonArr.count)/4 * (buttonHeight + buttonSpaceY);
    
    buttonX = XSpace + (self.notShowingButtonArr.count)%4 * (buttonWidth + buttonSpaceX);
    
    MDDeleteButton *notShowingButton = [self getDefaultButtonWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    
    [notShowingButton setTitle:title forState:UIControlStateNormal];
    
    [notShowingButton.layer setCornerRadius:10.0f];
    
    [notShowingButton addTarget:self action:@selector(notShowingButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonScrollView setContentSize:CGSizeMake(self.frame.size.width, buttonY + buttonHeight + buttonSpaceY)];
    
    [self.buttonScrollView addSubview:notShowingButton];
    
    //添加到数组
    [self.notShowingButtonArr addObject:notShowingButton];
}

//未选中按钮的点击事件
- (void) notShowingButtonDidPress:(MDDeleteButton *)sender
{
    if (self.showingButtonArr.count >= self.defaultMaxOfChannel) {
        
        [ViewHelps showHUDWithText:[NSString stringWithFormat:@"最\n多\n只\n能\n添\n加\n%lu\n个\n频\n道",self.defaultMaxOfChannel]];
        
        return;
    }
    
    //点击按钮获取按钮的下标,传出去,让MDChannelView添加频道,从notShowingArr里面移除,添加到showingArr里面,改变点击事件,重新设置frame
    //获得下标
    NSInteger index = [self.notShowingButtonArr indexOfObject:sender];
    
    if (self.sendButtonIndexToAddChannel) {
        
        self.sendButtonIndexToAddChannel(index);
    }
    
    //从原来数组中移除
    [self.notShowingButtonArr removeObject:sender];
    
    //移除点击事件
    [sender removeTarget:self action:@selector(notShowingButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加到新的数组
    [self.showingButtonArr addObject:sender];
    
    //添加新的点击事件
    [sender addTarget:self action:@selector(showingButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [sender setDelegate:self];
    
    //改变父视图
    [self addSubview:sender];
    
    //改变frame,重新设置frame,新的frame和旧的frame,在视觉上一致
    [sender setFrame:CGRectMake(sender.frame.origin.x, sender.frame.origin.y + self.buttonScrollView.frame.origin.y - self.buttonScrollView.contentOffset.y, buttonWidth, buttonHeight)];
    
    //重新计算ButtonX和ButtonY(因为Button已经添加到数组了,所以count要减一)
    buttonY = buttonSpaceY + (self.showingButtonArr.count - 1)/4 * (buttonHeight + buttonSpaceY);
    
    buttonX = XSpace + (self.showingButtonArr.count - 1)%4 * (buttonWidth + buttonSpaceX);
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        [sender setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
        
        //设置label和滚动视图的frame
        buttonY += buttonHeight + buttonSpaceY;
        
        [weakSelf.middleLabel setFrame:CGRectMake(0, buttonY, self.middleLabel.frame.size.width, buttonHeight)];
        
        buttonY += 43;
        
        [weakSelf.buttonScrollView setFrame:CGRectMake(0, buttonY, self.frame.size.width, self.frame.size.height - buttonY)];
        
        //重新布局非展示区域剩下的按钮
        for (NSInteger i = index; i < self.notShowingButtonArr.count ; i++) {
            
            //重新计算ButtonX和ButtonY(因为Button已经添加到数组了,所以count要减一)
            buttonY = buttonSpaceY + i/4 * (buttonHeight + buttonSpaceY);
            
            buttonX = XSpace + i%4 * (buttonWidth + buttonSpaceX);
            
            MDDeleteButton *tmpButton = self.notShowingButtonArr[i];
            
            [tmpButton setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
        }
        
    }];
    
    //拿到最后一个按钮,重新计算滚动视图的contentSize
    MDDeleteButton *lastButton = [self.notShowingButtonArr lastObject];
    
    [self.buttonScrollView setContentSize:CGSizeMake(self.buttonScrollView.frame.size.width, lastButton.frame.origin.y + buttonHeight + buttonSpaceY)];
}


#pragma mark -返回一个标准的按钮:传一个frame-
- (MDDeleteButton *) getDefaultButtonWithFrame:(CGRect)frame
{
    MDDeleteButton *tmpButton = [[MDDeleteButton alloc]initWithFrame:frame];
    
    [tmpButton setBackgroundImage:[UIImage imageNamed:@"column"] forState:UIControlStateNormal];
    
    [tmpButton setTitleColor:MDRGBA(51, 51, 51, 1.0) forState:UIControlStateNormal];
    
    [tmpButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    
    //隐藏红色按钮
    [tmpButton setDeleteButtonStates:MDDeleteButtonStateNormal];
    
    return tmpButton;
}

#pragma mark -开启或者关闭删除模式-
- (void) startOrCancelDeleteModel
{
    if (self.isDelete) {
        
        //如果是删除状态,则取消删除状态,显示label和滚动视图
        
        self.isDelete = NO;
        
        [self.middleLabel setHidden:NO];
        
        [self.buttonScrollView setHidden:NO];
        
        //遍历,每一个都变成正常状态
        for (MDDeleteButton *obj in self.showingButtonArr) {
            
            [obj setDeleteButtonStates:MDDeleteButtonStateNormal];
        }
        
    }
    else
    {
        //如果不是删除状态变成删除状态,隐藏label和滚动视图
        self.isDelete = YES;
        
        [self.middleLabel setHidden:YES];
        
        [self.buttonScrollView setHidden:YES];
        
        //进入删除状态,如果是头条不能删除
        for (NSInteger i = 0; i < self.showingButtonArr.count ; i++) {
            
            //先取出来按钮
            MDDeleteButton *tmpButton = [self.showingButtonArr objectAtIndex:i];
            
            if (i == 0) {
                
                [tmpButton setDeleteButtonStates:MDDeleteButtonStateCanNotDelete];
                
            }
            else
            {
                [tmpButton setDeleteButtonStates:MDDeleteButtonStateCanDelete];
            }
        }
    }
}

#pragma mark -morechannelview的显示和隐藏-
/**
 *  显示
 */
-(void) showMoreChannelView
{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [weakSelf setFrame:weakSelf.showFrame];
        
    }];
    
}
/**
 *  隐藏
 */
- (void) hiddenMoreChannelView
{
    //隐藏的时候,判断是否处于编辑状态,如果处于,侧取消
    if (self.isDelete) {
        
        [self startOrCancelDeleteModel];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [weakSelf setFrame:weakSelf.originFrame];
        
    }];
}

@end
