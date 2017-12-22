//
//  MDLaunchADView.m
//  MDYNews
//
//  Created by Medalands on 15/4/11.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDLaunchADView.h"

#define IPhone4_5_6_6P_MDLaunchADView(a,b,c,d) (CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size) ?(a) :(CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size) ? (b) : (CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size) ?(c) : (CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size) ?(d) : (a)))))

//广告图 和 屏幕 高度的 比例
#define MDADViewHeightScale 0.78

// 广告图 存在的时间
#define MDADViewShowDuration 4.0



@implementation MDLaunchADView



+(instancetype)createADViewWithImagePhone4_5_6_6PNameS:(NSArray *)array ADImageName:(NSString *)imageName
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];

    MDLaunchADView * view = [[MDLaunchADView alloc] initWithFrame:window.bounds imagePhone4_5_6_6PNameS:array ADImageName:imageName];
    
    [window addSubview:view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MDADViewShowDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [view removeFromSuperview];
        
        if (view.endShowBlock)
        {
            view.endShowBlock();
        }
        
    });
    
    return view;
}


-(instancetype)initWithFrame:(CGRect)frame imagePhone4_5_6_6PNameS:(NSArray *)array ADImageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.userInteractionEnabled = YES;
        
        // 创建和启动图 一样的背景图
        self.backgroundColor = [UIColor clearColor];
        
        NSInteger index = IPhone4_5_6_6P_MDLaunchADView(0, 1, 2, 3);
        
        NSString * backImageName = @"";
        
        if (array.count > index)
        {
            backImageName = [array objectAtIndex:index];
        }
        else if(array.count > 0)
        {
              backImageName = [array objectAtIndex:0];
        }
        
        [self setImage:[UIImage imageNamed:backImageName]];
        
        _adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * MDADViewHeightScale)];
        
        [_adImageView setImage:[UIImage imageNamed:imageName]];
        
        _adImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _adImageView.backgroundColor = [UIColor clearColor];
        
        [_adImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAdViewAction:)]];
        
        _adImageView.userInteractionEnabled = YES;
        
        [self addSubview:_adImageView];
  
    }
    return self;
}

-(void)tapAdViewAction:(UITapGestureRecognizer *)ges
{
    if (self.tapAdViewBlock)
    {
        self.tapAdViewBlock();
    }
}


@end
