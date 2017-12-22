//
//  MDSNNewsListView.m
//  MDSpeedNews
//
//  Created by Medalands on 16/4/6.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDSNNewsListView.h"
#import "MDTopTableViewCell.h"
#import "MDLongTableViewCell.h"
#import "MDNormalTableViewCell.h"
#import "MDMoreTableViewCell.h"
#import "MDListModel.h"
#import "MDDetalViewController.h"
#import "MDImagesViewController.h"
#import "MDListCache.h"
#import "MDSpeedNews.h"
#import "AppDelegate.h"



@interface MDSNNewsListView ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    // 声明一个page来记录当前请求更多数据的页数
    NSInteger page;
}

// 数据源
@property (nonatomic , strong) NSMutableArray *dataArr;

// 记录最后一次刷新的时间
@property (nonatomic , assign) CFAbsoluteTime lastRefreshTime;

@end

@implementation MDSNNewsListView

// 重写初始化方法
- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {

        page = 1;
        
        [self setUpDataArr];
        
        [self setUptableView];
        
        [self setUpRefreshAndLoadMore];
        
    }
    
    return self;
}

//tid的set方法
- (void) setTid:(NSString *)tid
{
    _tid = tid;
    
    NSDictionary *dict = [MDListCache readCacheForKey:tid];
    
    NSArray *tmpArr = [dict objectForKey:tid];
    
    for (NSDictionary *obj in tmpArr) {
        
        MDListModel *model = [[MDListModel alloc]initWithDict:obj];
        
        [self.dataArr addObject:model];
    }
}

// 数组初始化
- (void) setUpDataArr{
    
    self.dataArr = [NSMutableArray array];
}

#pragma mark - 下拉刷新和上拉加载更多
- (void) setUpRefreshAndLoadMore{
    // 声明一个弱引用的self
    __weak typeof(self)weakSelf = self;

    // 创建一个动画的刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadRefreshData];
    
    }];
    
    // 正常状态
    [header setImages:@[[UIImage imageNamed:@"RefreshOne"]] forState:MJRefreshStateIdle];
    
    // 即将开始刷新状态
    [header setImages:@[[UIImage imageNamed:@"RefreshTwo"]] forState:MJRefreshStatePulling];
    
    // 进入刷新状态
    [header setImages:@[[UIImage imageNamed:@"RefreshThree"],[UIImage imageNamed:@"RefreshFour"],[UIImage imageNamed:@"RefreshFive"]] forState:MJRefreshStateRefreshing];
    
    // 把创建好的下拉刷新控件给tableView
    self.listTableView.header = header;
    
    
    // 创建一个动画的刷新
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    // 正常状态
    [footer setImages:@[[UIImage imageNamed:@"RefreshOne"]] forState:MJRefreshStateIdle];
    
    // 即将开始刷新状态
    [footer setImages:@[[UIImage imageNamed:@"RefreshTwo"]] forState:MJRefreshStatePulling];
    
    // 进入刷新状态
    [footer setImages:@[[UIImage imageNamed:@"RefreshThree"],[UIImage imageNamed:@"RefreshFour"],[UIImage imageNamed:@"RefreshFive"]] forState:MJRefreshStateRefreshing];
    
      self.listTableView.footer = footer;
    
}

// 刷新数据
- (void) loadRefreshData{
    
    // 声明一个弱引用的self
    __weak typeof(self)weakSelf = self;
    
    NSString *urlString = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/headline/%@/0-20.html",self.tid];
    
    [HttpRequest GET:urlString parameters:nil success:^(id responseObject) {
        
        //每次刷新成功的时候保存起来
        [MDListCache setObjectWithDict:responseObject withKey:weakSelf.tid];
        
        // 当请求成功了之后page =1，清空数据源
        page = 1;
        
        [weakSelf.dataArr removeAllObjects];

        // 记录最后一次刷新的时间
        weakSelf.lastRefreshTime = CFAbsoluteTimeGetCurrent();
        
        NSArray *tmpArr = [responseObject  valueForKey:self.tid];
        
        for (NSDictionary *dict in tmpArr) {
            
            MDListModel *model = [[MDListModel alloc] initWithDict:dict];
            
            [weakSelf.dataArr addObject:model];
        }
        
        [weakSelf.listTableView.header endRefreshing];
        
        [weakSelf.listTableView reloadData];
        
    } failure:^(NSError *error) {
        
        // 当请求失败的时候，调这个方法：把错误信息转换成字符串，然后通过HUD显示出来
        [RequestSever showMsgWithError:error];
        
        [weakSelf.listTableView.header endRefreshing];
        
    }];    
}

// 加载更多数据
- (void) loadMoreData{
    
    // 页数加1
    page ++;  //2
    
    // 声明一个弱引用的self
    __weak typeof(self)weakSelf = self;
    
    NSString *urlString = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/headline/%@/%lu-20.html",self.tid,(page - 1) * 20];
    
    [HttpRequest GET:urlString parameters:nil success:^(id responseObject) {
    
        NSArray *tmpArr = [responseObject  valueForKey:self.tid];
        
        for (NSDictionary *dict in tmpArr) {
            
            MDListModel *model = [[MDListModel alloc] initWithDict:dict];
            
            [weakSelf.dataArr addObject:model];
        }
        
        [weakSelf.listTableView.footer endRefreshing];
        
        [weakSelf.listTableView reloadData];
        
    } failure:^(NSError *error) {
        
        [weakSelf.listTableView.footer endRefreshing];
        
        page --;
        
        [RequestSever showMsgWithError:error];
        
    }];
}

#pragma mark - 判断最后一次刷新的时间，判断时候需要刷新 - 
- (void) autoRefreshIfNeed{
    
    [self.listTableView reloadData];
    
    // 如果当前的时间 - 最后一次刷新的时间 大于 十分钟（600秒） 就需要刷新
    if (CFAbsoluteTimeGetCurrent() - self.lastRefreshTime > 10 * 60) {
        
        // 刷新
        [self.listTableView.header beginRefreshing];
        
    }
    
    
}


#pragma mark - tableView && tableViewDelegate && tableViewDataSource
// 初始化tableView
- (void) setUptableView{

    self.listTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    
    [self.listTableView setDelegate:self];
    
    [self.listTableView setDataSource:self];
    
    [self.listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.listTableView setTableFooterView:[[UIView alloc] init]];
    
    [self addSubview:self.listTableView];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArr count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MDListModel *model = nil;
    
    if (self.dataArr.count > indexPath.row) {

      model = self.dataArr[indexPath.row];
        
    }
    
    if (indexPath.row == 0) {
        
        static NSString *const ID1 = @"ID1";
        
        MDTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        
        if (!cell) {
            cell = [[MDTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
        }
        [cell bindDataWithListModel:model];
        
        return cell;
    }
    else if (model && model.imgType && [model.imgType isEqualToNumber:@(1)]){
        
        static NSString *const ID2 = @"ID2";
        
        MDLongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        
        if (!cell) {
            cell = [[MDLongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID2];
        }
        
        [cell bindDataWithListModel:model];
        
        return cell;

        
    }
    else if (model && model.imgextra && model.imgextra.count > 1){
        
        
        static NSString *const ID4 = @"ID4";
        
        MDMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID4];
        
        if (!cell) {
            cell = [[MDMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID4];
        }
        
        [cell bindDataWithListModel:model];
        
        return cell;
        
    }
    else{
    
        static NSString *const ID3 = @"ID3";
        
        MDNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID3];
        
        if (!cell) {
            cell = [[MDNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID3];
        }
        
        [cell bindDataWithListModel:model];
        
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MDListModel *model = nil;
    
    if (self.dataArr.count > indexPath.row) {
        
        model = self.dataArr[indexPath.row];
        
    }
    
    if (indexPath.row == 0) {
        return MDXFrom6(230);
    }
    else if(model && model.imgType && [model.imgType isEqualToNumber:@(1)]){

//        (320/375) * 100 // 这是iphone5下的图片的高度
        
        return 55 + MDXFrom6(100);
    }
    else if(model && model.imgextra && model.imgextra.count > 1){
        
        return 35 + MDXFrom6(88);
        
    }
    else{
        
            return 83.0f;
        
    }

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataArr.count <= indexPath.row)
    {
        
        return;
    }
    //取出model
    MDListModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    MDSpeedNews *obj = [NSEntityDescription insertNewObjectForEntityForName:@"MDSpeedNews" inManagedObjectContext:KAppdelegate.managedObjectContext];
    
    obj.tid = model.title;
    
    [KAppdelegate saveContext];
    
    if (model && model.imgextra && model.imgextra.count > 1 && model.imgType == nil)
    {
        
        MDImagesViewController *controller = [[MDImagesViewController alloc]init];
        
        [controller setGetListModel:self.dataArr[indexPath.row]];
        
        //传出去controller方便跳转
        if (self.pushViewControllerBlack)
        {
            
            self.pushViewControllerBlack(controller);
        }

    }
    else
    {
        MDDetalViewController *detaViewController = [[MDDetalViewController alloc]init];
        
        [detaViewController setGetModel:self.dataArr[indexPath.row]];
        
        //传出去controller方便跳转
        if (self.pushViewControllerBlack)
        {
            
            self.pushViewControllerBlack(detaViewController);
        }

    }
    
}


@end
