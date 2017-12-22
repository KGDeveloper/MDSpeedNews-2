//
//  MDSettingViewController.m
//  MDSpeedNews
//
//  Created by Medalands on 16/4/7.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDSettingViewController.h"


#define iOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

#define AppID 1234


@interface MDSettingViewController ()

@end

@implementation MDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setUpDefaultView];
}

- (void) setUpDefaultView{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton addTarget:self action:@selector(backButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [backButton setFrame:CGRectMake(13, 30, 40, 40)];
    
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    // 设置title
    UILabel *navTitleLbale = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, 44)];
    
    [navTitleLbale setBackgroundColor:MDRGBA(51, 153, 51, 1.0)];
    
    [navTitleLbale setText:@"设置"];
    
    [navTitleLbale setTextAlignment:NSTextAlignmentCenter];
    
    [navTitleLbale setFont:[UIFont boldSystemFontOfSize:17.0f]];
    
    [navTitleLbale setTextColor:[UIColor whiteColor]];
    
    
    
    
    // icon的蒙版view
    UIView *iconContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64 + MDXFrom6(230))];
    
    [iconContentView setBackgroundColor:MDRGBA(51, 153, 51, 1.0)];
    
    [self.view addSubview:iconContentView];
    
    [iconContentView addSubview:navTitleLbale];
    
    [iconContentView addSubview:backButton];
    
    // iconImageView
    CGFloat iconY = MDXFrom6(57);
    CGFloat iconHeight = MDXFrom6(230) - iconY - MDXFrom6(80);
    CGFloat iconX = KScreenWidth/2 - iconHeight/2;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 64 + iconY, iconHeight, iconHeight)];
    
    [iconImageView setImage:[UIImage imageNamed:@"icon"]];
    
    [iconImageView.layer setCornerRadius:20.0f];
    
    [iconImageView.layer setBorderColor:MDRGBA(255, 255, 255, 0.5).CGColor];
    
    [iconImageView.layer setBorderWidth:7.0f];
    
    [iconContentView addSubview:iconImageView];
    
    // 显示版本的label
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconHeight + 12, KScreenWidth, 15)];
    
    [tmpLabel setFont:[UIFont systemFontOfSize:15.0f]];
    
    [tmpLabel setTextColor:[UIColor whiteColor]];
    
    // 获取系统版本信息的字典
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *versionNumber = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    [tmpLabel setText:[NSString stringWithFormat:@"速闻 %@",versionNumber]];
    
    [tmpLabel setTextAlignment:NSTextAlignmentCenter];
    
    [iconContentView addSubview:tmpLabel];
    
    // 获得button的尺寸和位置
    CGFloat buttonY = iconContentView.frame.size.height + MDXFrom6(45);
    CGFloat buttonWidth = 190;
    CGFloat buttonX = (KScreenWidth - buttonWidth)/2;
    
    for (NSInteger i = 0; i < 2; i++) {
       
        UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [tmpButton setFrame:CGRectMake(buttonX, buttonY, buttonWidth, 50)];
        
        [tmpButton.layer setCornerRadius:25.0f];
        
        [tmpButton.layer setMasksToBounds:YES];
        
        [tmpButton setBackgroundImage:[UIImage imageWithColor:MDRGBA(51, 153, 51,1.0)] forState:UIControlStateNormal];
        
        [tmpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // -- 设置Tag值
        [tmpButton setTag:i + 1];
        
        [tmpButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            
            [tmpButton setTitle:@"     应用评分" forState:UIControlStateNormal];
            
            [tmpButton setImage:[UIImage imageNamed:@"score"] forState:UIControlStateNormal];
        }else{
            
            [tmpButton setTitle:@"     清除缓存" forState:UIControlStateNormal];
            
            [tmpButton setImage:[UIImage imageNamed:@"cache"] forState:UIControlStateNormal];
        }
        
        [self.view addSubview:tmpButton];
        
        buttonY = buttonY + 50 + MDXFrom6(40);
    }
}

// 返回按钮的点击事件
- (void)backButtonDidPress:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 应用评分 和 意见反馈 && 点击事件 -
// 应用评分和清除缓存的点击事件
- (void) buttonTouchUpInside:(UIButton *)sender{
    if (sender.tag == 1) {

        [self goToAppStore];
    }
    else{
        
        [self clearCache];
    }
}

#pragma mark - 清除缓存
- (void) clearCache{
    
    //创建文件管理器
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    //拿到本地的缓存文件夹目录
    NSString *cachePathString = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    //拿到缓存文件夹
    NSString *filePath = [cachePathString stringByAppendingPathComponent:@"com.medalands.listCache"];
    
    //拿到文件夹的所有属性
    NSDictionary *tmpDict = [mgr attributesOfItemAtPath:filePath error:nil];
    
    //拿到文件夹大小
    NSInteger tmpfileSize = [[tmpDict valueForKey:@"NSFileSize"] integerValue];
    
    [mgr removeItemAtPath:filePath error:nil];
    
    // 我们现在清除的SDWebImage下载的图片
    
    // 图片的缓存都在SDImageChahe类里
    SDImageCache *tmpCache = [SDImageCache sharedImageCache];
    
    // 拿到文件的数量
    NSUInteger numberOfImages = [tmpCache getDiskCount];
    
    // 拿到文件的总大小
    NSUInteger imageSize = [tmpCache getSize];
    
    //清空缓存
    [tmpCache clearDiskOnCompletion:^{
        
        [ViewHelps showHUDWithText:[NSString stringWithFormat:@"已经成功清理%.2fMB缓存", imageSize/1024.0/1024.0 + tmpfileSize/1024.0f/1024.0f]];
    }];
    
    NSFetchRequest *res = [[NSFetchRequest alloc]initWithEntityName:@"MDSpeedNews"];
    
    NSArray *tmp = [KAppdelegate.managedObjectContext executeFetchRequest:res error:nil];
    
    for (MDSpeedNews *obj in tmp) {
        
        obj.tid = @"";
        
        [KAppdelegate saveContext];
    }

    
}

#pragma mark - 应用评分 -
-(void) goToAppStore{
    
    NSString *str= @"";
    
    if (iOS7){
        
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",AppID];
    }
    else
        str = [NSString stringWithFormat:
               @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",AppID];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
