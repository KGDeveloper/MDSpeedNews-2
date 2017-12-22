//
//  MainViewController.m
//  MDSpeedNews
//
//  Created by Medalands on 16/4/6.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MainViewController.h"
#import "MDSNNewsListView.h"
#import "MDSNScrollView.h"
#import "MDChannelView.h"

#import "MDCategoryModel.h"
#import "MDSettingViewController.h"
#import "MDMoreChannelView.h"

@interface MainViewController ()<UIScrollViewDelegate,MDChannelViewDelegate>
/**
 *  保存listView的SNScrollView
 */
@property (nonatomic , strong) MDSNScrollView *tmpScrollView;

@property (nonatomic , strong) MDSNNewsListView *listView;
/**
 *  储存频道名按钮的view
 */
@property (nonatomic , strong) MDChannelView *channelView;
/**
 *  储存更多频道的View
 */
@property (nonatomic , strong) MDMoreChannelView *moreChannelView;
/**
 *  默认的展示区域频道个数
 */
@property (nonatomic , assign) NSInteger defaultNumberOfChannel;
/**
 *  储存频道分类的数组
 */
@property (nonatomic , strong) NSMutableArray *categoryArr;
/**
 *  保存显示的的频道按钮的数组
 */
@property (nonatomic , strong) NSMutableArray *showingArr;
/**
 *  保存未显示的频道按钮的数组
 */
@property (nonatomic , strong) NSMutableArray *notShowingArr;
/**
 *  判断频道是否发生了改变
 */
@property (nonatomic , assign) BOOL isChannel;

@end

@implementation MainViewController

// 让第一个listView上的tableView 刷新 写在这。 我们需要动画，所以写在这
- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    // 获取到当前页面的MDSNNewsListView
    MDSNNewsListView *listView = [self.tmpScrollView getCurrentNewsListView];
    
    [listView autoRefreshIfNeed];
    
    [listView.listTableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isChannel = NO;
    
    //初始化数组
    self.categoryArr = [NSMutableArray array];
    
    self.showingArr = [NSMutableArray array];
    
    self.notShowingArr = [NSMutableArray array];
    
    //初始化频道默认展示区域个数(方便以后更改)
    self.defaultNumberOfChannel = 10;
    
    [self.navigationItem setTitle:@"速闻"];
    
    [self setNavigationRightBarButtonWithImageNamed:@"set"];
    
    [self readChannelInCache];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    [self setUpCategoryArr];
    
    [self setUpChannelView];

    [self setUpSnScrollView];
    
    [self setUpMoreChannelView];
    
}

- (void) rightButtonTouchUpInside:(id)sender{
    
    MDSettingViewController *setViewController = [[MDSettingViewController alloc] init];
    
    [self.navigationController pushViewController:setViewController animated:YES];
    
    
}

#pragma Mark- categoryArr : 储存频道信息（tid和tname）的数组 -
- (void) setUpCategoryArr{
    
    if (self.showingArr.count > 0) {
        
        return;
    }
    
    // 本地json解析
    NSString *dalPath = [[NSBundle mainBundle] pathForResource:@"allCategory" ofType:@"txt"];
    
    NSData *dalData = [NSData dataWithContentsOfFile:dalPath];
    
    NSArray *dalArr = [NSJSONSerialization JSONObjectWithData:dalData options:kNilOptions error:nil];
    
    for (NSDictionary *dict in dalArr) {
        
        NSArray *tListArr = dict[@"tList"];
        
        for (NSDictionary *subDict in tListArr) {
            
            MDCategoryModel *model = [[MDCategoryModel alloc] initWithDict:subDict];
            
            //判断展示区域是否大于默认值
            if (self.showingArr.count < self.defaultNumberOfChannel) {
                
                [self.showingArr addObject:model];
            }
            else
            {
                [self.notShowingArr addObject:model];
            }
            
            [self.categoryArr addObject:model];
            
        }
    }
}

#pragma mark -保存频道到本地 && 从本地取频道-
//保存频道
- (void) saveChannelInCache
{
    NSMutableArray *saveShowingArr = [NSMutableArray array];
    
    for (MDCategoryModel *model in self.showingArr) {
        
        [saveShowingArr addObject:model.channelDict];
    }
    
    NSMutableArray *saveNotShowingArr = [NSMutableArray array];
    
    for (MDCategoryModel *model in self.notShowingArr) {
        
        [saveNotShowingArr addObject:model.channelDict];
    }
    
    NSDictionary *tmpDict = @{
                              @"showing":saveShowingArr,
                              @"notShowing":saveNotShowingArr
                              };
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:tmpDict forKey:@"MedalandsChannel"];
    
    //同步到本地
    [userDefaults synchronize];
    
}

//取频道
- (void) readChannelInCache
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *cacheDict = [userDefaults objectForKey:@"MedalandsChannel"];
    
    if (cacheDict == nil) {
        
        return;
    }
    
    NSArray *saveShowingArr = cacheDict[@"showing"];
    
    NSArray *saveNotShowingArr = cacheDict[@"notShowing"];
    
    for (NSDictionary *dict in saveShowingArr) {
        
        MDCategoryModel *model = [[MDCategoryModel alloc]initWithDict:dict];
        
        [self.showingArr addObject:model];
    }
    
    for (NSDictionary *dict in saveNotShowingArr) {
        
        MDCategoryModel *model = [[MDCategoryModel alloc]initWithDict:dict];
        
        [self.notShowingArr addObject:model];
    }
    
}

#pragma mark - MDChannelView: 承载频道名按钮的View -
// 封装一个方法：创建一个ChannelView的对象去加载频道名对应的按钮
- (void) setUpChannelView{
    
    __weak typeof(self)weakSelf = self;
    
    self.channelView = [[MDChannelView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, 43)];
    
    //设置代理人
    [self.channelView setDelegate:self];
    
     // 实现点击频道名的回调，把下标传给MDSNScollView
    [self.channelView setSendButtonIndexWhenClick:^(NSInteger index) {
        
        [weakSelf.tmpScrollView scrollToNewListViewWithIndex:index];
        
    }];
    
    // 循环在数组中取值，取出来频道名加载到channelView上
    for (NSInteger i  = 0; i < self.showingArr.count; i++) {
        
        MDCategoryModel *model = self.showingArr[i];

        [self.channelView loadButtonWithTitle:model.tname];
    }
    
    // 设置默认第一个频道被选中（先添加按钮，在调用这个方法去取按钮）
    [self.channelView setFirstButtonDefaultSeleted];
    
    [self.view addSubview:self.channelView];
}

#pragma mark -实现协议里的方法,显示更多频道按钮的回调 && 删除按钮的回调-
//更多频道显示按钮的回调
- (void) clickToMoreChannelViewShowOrHidden:(BOOL)show
{
    if (show) {
        
        [self.moreChannelView showMoreChannelView];
    }
    else
    {
        [self.moreChannelView hiddenMoreChannelView];
        
        if (self.isChannel) {
            
            self.isChannel = NO;
            
            [self saveChannelInCache];
        }
    }
}
//删除按钮的回调
- (void) clickToMoreChannelViewDeleteButtonShowOrHidden
{
    [self.moreChannelView startOrCancelDeleteModel];
}

#pragma mark -MDMoreChannelView 承载更多频道的view-

- (void) setUpMoreChannelView
{
    __weak typeof(self) weakSelf = self;
    
    self.moreChannelView = [[MDMoreChannelView alloc]initWithFrame:CGRectMake(0, - self.tmpScrollView.frame.size.height, self.tmpScrollView.frame.size.width, self.tmpScrollView.frame.size.height)];
    
    [self.moreChannelView setShowFrame:self.tmpScrollView.bounds];
    
    //实现点击了选中按钮回调:跳转到相应的页面,隐藏moreChannelView
    [self.moreChannelView setJumpToChannelWithIndex:^(NSInteger index) {
        
        //滚动到莫个页面
        [weakSelf.tmpScrollView scrollToNewListViewWithIndex:index];
        
        //手动触发按钮的点击事件
        [weakSelf.channelView.moreButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        
    }];
    
    //实现点击未选中频道的按钮的回调:让MDSNScrollView和MDChannelView添加新的频道
    [self.moreChannelView setSendButtonIndexToAddChannel:^(NSInteger index) {
        
        [weakSelf addChannelWithIndex:index];
        
    }];
    
    //实现点击选中频道的删除按钮的回调:让MDSNScrollView和MDChannelView删除频道
    [self.moreChannelView setSendButtonIndexToDeleteChannel:^(NSInteger index) {
        
        [weakSelf deleteChannel:index];
        
    }];
    
    for (NSInteger i = 0 ; i < self.showingArr.count; i++) {
        
        MDCategoryModel *model = [self.showingArr objectAtIndex:i];
        
        [self.moreChannelView addShowingChannelViewWithTitle:model.tname];
    }
    //添加label还有保存未选中频道按钮的滚动视图
    [self.moreChannelView setUpMiddleLabelAndScrollerView];
    
    //添加未展示的按钮
    for (MDCategoryModel *model in self.notShowingArr) {
        
        [self.moreChannelView addNotShowingChannelViewWithTitle:model.tname];
    }
    
    [self.tmpScrollView addSubview:self.moreChannelView];
}

#pragma mark -增加频道 && 删除频道-
//增加频道
- (void) addChannelWithIndex:(NSInteger)index
{
    //index对应频道在notShowingArr里面的下标,取出来Model,从原来的数组中移除,加到新的数组里面,把频道加上去
    if (self.notShowingArr.count > index) {
        
        self.isChannel = YES;
        
        MDCategoryModel *model = self.notShowingArr[index];
        
        //添加频道
        MDSNNewsListView *tmpListView = [[MDSNNewsListView alloc]initWithFrame:CGRectMake(0, 0, self.tmpScrollView.frame.size.width, self.tmpScrollView.frame.size.height)];
        
        __weak typeof(self) weakSelf = self;
        
        [tmpListView setPushViewControllerBlack:^(UIViewController *controller) {
            
            [weakSelf.navigationController pushViewController:controller animated:YES];
            
        }];
        
        [tmpListView setTid:model.tid];
        
        [self.tmpScrollView loadNewsListView:tmpListView];
        
        [self.channelView loadButtonWithTitle:model.tname];
        
        //从原来的数组移除,加到新的数组中
        [self.notShowingArr removeObject:model];
        
        [self.showingArr addObject:model];
        
    }
    
}

//删除频道
- (void) deleteChannel:(NSInteger)index
{
    if (self.showingArr.count > index) {
        
        self.isChannel = YES;
        
        //删除频道
        [self.channelView deleteChannelWithIndex:index];
        
        [self.tmpScrollView deleteListViewWithPage:index];
        
        //先取出model
        MDCategoryModel *model = self.showingArr[index];
        
        //从本身数组移除,添加到新的数组中
        [self.showingArr removeObject:model];
        
        [self.notShowingArr addObject:model];
    }
}

#pragma mark - MDSNScrollView ：承载listView的view -
// 封装一个方法：创建一个SNScrollView的对象去放置listView
- (void) setUpSnScrollView{
    
    __weak typeof(self)weakSelf = self;
    
    self.tmpScrollView = [[MDSNScrollView alloc] initWithFrame:CGRectMake(0, 64 + 43, KScreenWidth, KScreenHeight - 64 - 43)];
    
    // 实现滚到下一页的回调:让下一个页面开始刷新
    [self.tmpScrollView setScrollViewEndToNewsListView:^(MDSNNewsListView *listView) {
        
        [listView autoRefreshIfNeed];
        
    }];
    
    //实现滚动到下一个页面，按钮联动的回调
    [self.tmpScrollView setScrollViewScrollEndSendPage:^(NSInteger page) {
        
        [weakSelf.channelView setButtonSelectedAccordingPage:page];
        
    }];
    
    // 循环创建listView的对象，添加到ScrollView上
    for (NSInteger i = 0; i < self.showingArr.count; i++) {
        
        self.listView = [[MDSNNewsListView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, self.tmpScrollView.frame.size.height)];
        
        //实现跳转的回调
        [self.listView setPushViewControllerBlack:^(UIViewController *controller) {
            
            [weakSelf.navigationController pushViewController:controller animated:YES];
            
        }];
        
        MDCategoryModel *model = self.showingArr[i];
        
        self.listView.tid = model.tid;
        
        
       // 不希望外界直接访问到ScrollView，我们给外界一个接口
        [self.tmpScrollView loadNewsListView:self.listView];
       
        }
    [self.view addSubview:self.tmpScrollView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
