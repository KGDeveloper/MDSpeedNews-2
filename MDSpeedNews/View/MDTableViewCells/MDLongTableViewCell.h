//
//  MDLongTableViewCell.h
//  MDSpeedNews
//
//  Created by Medalands on 16/4/6.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDListModel.h"

@interface MDLongTableViewCell : UITableViewCell

/**
 * 显示长图的imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *longImageView;

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
