//
//  MDNormalTableViewCell.h
//  MDSpeedNews
//
//  Created by Medalands on 16/4/6.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDListModel.h"

@interface MDNormalTableViewCell : UITableViewCell

/**
 *显示新闻图片的imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

/**
 *显示标题的Label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 *显示内容的Label
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

/**
 * 绑定数据
 *
 * @parm model:MDListModel
 */
- (void) bindDataWithListModel:(MDListModel *)model;

@end
