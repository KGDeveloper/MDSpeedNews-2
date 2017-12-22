//
//  MDDetalViewController.m
//  MDSpeedNews
//
//  Created by Medalands_1 on 16/4/11.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDDetalViewController.h"
#import "MDHTMLService.h"

@interface MDDetalViewController ()<UIWebViewDelegate>

@property (nonatomic , strong) UIWebView *tmpWebView;

@end

@implementation MDDetalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor yellowColor]];
    
    [self baseForDefaultLeftNavButton];
 
    [self.navigationItem setTitle:@"详情"];
    
    [self setUpWebView];
    
    [self requestData];
}

//请求数据
- (void) requestData
{
    NSString *baseUrl = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/%@/full.html",self.getModel.docid];
    
    __weak typeof(self) weakSelf = self;
    
    [self showHUD];
    
    [HttpRequest GET:baseUrl parameters:nil success:^(id responseObject) {
        
        [weakSelf hidenHUD];
        
        NSDictionary *dict = responseObject[self.getModel.docid];
        
        NSString *htmlString = [MDHTMLService htmlStringFromDic:dict];
        
        [weakSelf.tmpWebView loadHTMLString:htmlString baseURL:nil];
        
    } failure:^(NSError *error) {
        
        [weakSelf hidenHUD];
        
        [RequestSever showMsgWithError:error];
        
    }];
    
}

//实现webView
- (void) setUpWebView
{
    self.tmpWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    
    [self.tmpWebView setDelegate:self];
    
    [self.tmpWebView setScalesPageToFit:YES];
    
//    [self.tmpWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.getModel.url]]];
    
    [self.view addSubview:self.tmpWebView];
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
