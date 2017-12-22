//
//  BaseNaviViewController.m
//  AISpeedNew
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "BaseNaviViewController.h"




@interface BaseNaviViewController ()

@end

@implementation BaseNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
   
    
    // -- 新建一个图片来当背景
    UIImage *tmpImage = [UIImage imageWithColor:MDRGBA(43.0, 139.0, 39.0, 0.80)];
    
    // --  导航栏背景颜色
    [self.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
    
    // -- 导航栏文字颜色和大小
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f]}];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
