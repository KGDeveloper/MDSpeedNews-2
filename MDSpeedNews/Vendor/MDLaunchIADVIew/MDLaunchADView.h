//
//  MDLaunchADView.h
//  MDYNews
//
//  Created by Medalands on 15/4/11.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDLaunchADView : UIImageView

/**
 *
 */
@property(nonatomic,copy)void(^endShowBlock)();

@property(nonatomic,copy)void(^tapAdViewBlock)();

@property(nonatomic,strong)UIImageView * adImageView;


/**
 * 创建广告图
 */
+(instancetype)createADViewWithImagePhone4_5_6_6PNameS:(NSArray *)array ADImageName:(NSString *)imageName;




@end
