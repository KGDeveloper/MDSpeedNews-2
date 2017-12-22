//
//  BaseViewController.m
//  AISpeedNew
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "BaseViewController.h"




@interface BaseViewController ()
{
    MBProgressHUD *progressHUD;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    // Do any additional setup after loading the view.
}

/*设置导航栏左侧的按钮 和点击事件*/
- (void) setNavigationLeftBarButtonWithImageNamed:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 25, 44)];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
}

- (void) baseForDefaultLeftNavButton
{
    UIImage *image = [UIImage imageNamed:@"back"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 25, 44)];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
}

- (void) leftButtonTouchUpInside:(id)sender
{
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*设置导航栏右侧的按钮 和点击事件*/
- (void) setNavigationRightBarButtonWithImageNamed:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 25, 44)];
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
}

- (void) rightButtonTouchUpInside:(id)sender{
    
}


/*设置的菊花*/
- (void) showHUD
{
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [progressHUD setDimBackground:YES];
    [self.view addSubview:progressHUD];
    [progressHUD show:YES];
}

- (void) hidenHUD
{
    [progressHUD hide:YES];
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
