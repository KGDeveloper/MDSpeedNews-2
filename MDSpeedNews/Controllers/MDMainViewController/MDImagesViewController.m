//
//  MDImagesViewController.m
//  MDSpeedNews
//
//  Created by Medalands_1 on 16/4/12.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDImagesViewController.h"

@interface MDImagesViewController ()
<
UIScrollViewDelegate
>
/**
 *  承载图片的滚动视图
 */
@property (nonatomic , strong) UIScrollView *tmpScrollView;

@property (nonatomic , strong) UIPageControl *pageControl;
/**
 *  存放图片地址的数组
 */
@property (nonatomic , strong) NSMutableArray *imageURLArr;
/**
 *  存放下载下来的图片的数组
 */
@property (nonatomic , strong) NSMutableArray *imageArr;

@end

@implementation MDImagesViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *tmpImage = [UIImage imageWithColor:MDRGBA(0, 0, 0, 0.9)];
    
    [self.navigationController.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIImage *tmpImage = [UIImage imageWithColor:MDRGBA(43.0, 139.0, 39.0, 0.80)];
    
    [self.navigationController.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.navigationItem setTitle:@"详情"];
    
    [self baseForDefaultLeftNavButton];
    
    [self setUpArr];
    
    [self setUpScrollViewAndPageControl];
}

//实现数组
- (void) setUpArr
{
    //把图片的网址取出来放在数组中
    self.imageURLArr = [NSMutableArray array];
    
    //第一张
    [self.imageURLArr addObject:self.getListModel.imgsrc];
    
    //第二张和第三张
    if (self.getListModel.imgextra.count >= 2) {
        
        [self.imageURLArr addObject:[self.getListModel.imgextra[0] valueForKey:@"imgsrc"]];
        
        [self.imageURLArr addObject:[self.getListModel.imgextra[1] valueForKey:@"imgsrc"]];
    }
    
    //实现保存图片的数组
    self.imageArr = [NSMutableArray array];
    
    
    
}

//封装一个方法实现滚动视图和pagecontroller
- (void) setUpScrollViewAndPageControl
{
    self.tmpScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    
    [self.tmpScrollView setDelegate:self];
    
    [self.tmpScrollView setPagingEnabled:YES];
    
    [self.tmpScrollView setBounces:NO];
    
    [self.tmpScrollView setShowsHorizontalScrollIndicator:NO];
    
    [self.tmpScrollView setShowsVerticalScrollIndicator:NO];
    
    [self.tmpScrollView setContentSize:CGSizeMake(self.tmpScrollView.frame.size.width * 3, self.tmpScrollView.frame.size.height)];
    
    for (NSInteger i = 0; i < self.imageURLArr.count; i++) {
        
        UIImageView *tmpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.tmpScrollView.frame.size.width * i, - 32, self.tmpScrollView.frame.size.width, self.tmpScrollView.frame.size.height)];
        
        __weak typeof(self) weakSelf = self;
        
        //让imageView一直在中心
        [tmpImageView setContentMode:UIViewContentModeCenter];
        
        //让imageView不失真
        [tmpImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        //开交互
        [tmpImageView setUserInteractionEnabled:YES];
        
        //添加一个长按手势
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage)];
        
        [tmpImageView addGestureRecognizer:longGesture];
        
        [tmpImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageURLArr[i]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                
                //把下载下来的图片添加到数组中记录
                [weakSelf.imageArr addObject:image];
            }
            
        }];
        
        [self.tmpScrollView addSubview:tmpImageView];
    }
    
    [self.view addSubview:self.tmpScrollView];
    
    //pageControl
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, KScreenHeight - 40, KScreenWidth, 20)];
    
    [self.pageControl setNumberOfPages:self.imageURLArr.count];
    
    [self.pageControl setCurrentPage:0];
    
    [self.pageControl setUserInteractionEnabled:NO];
    
    [self.view addSubview:self.pageControl];
    
    //label
    UILabel *tmpLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, KScreenHeight - 100, KScreenWidth - 20, 40)];
    
    [tmpLabel setFont:[UIFont systemFontOfSize:18.0f]];
    
    [tmpLabel setTextColor:[UIColor whiteColor]];
    
    [tmpLabel setText:self.getListModel.title];
    
    [self.view addSubview:tmpLabel];
    
}

- (void) saveImage
{
    [self alertCOntrollerMessage:@"是否要保存图片"];
}

//警告框
- (void) alertCOntrollerMessage:(NSString *)message
{
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *leftButton = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSInteger index = weakSelf.tmpScrollView.contentOffset.x/self.tmpScrollView.frame.size.width;
        
        UIImage *saveImage = nil;
        
        //取得图片
        if (self.imageArr.count > index) {
            
            saveImage = self.imageArr[index];
        }
        
        //保存图片到图库
        UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        
    }];
    
    UIAlertAction *rightButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:leftButton];
    
    [alert addAction:rightButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

//保存图片结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        
        [ViewHelps showHUDWithText:@"保存失败"];
    }
    else
    {
        [ViewHelps showHUDWithText:@"保存成功"];
    }
}

#pragma mark -UIScrollViewDelegate-
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x/self.tmpScrollView.frame.size.width;
    
    [self.pageControl setCurrentPage:page];
    
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
