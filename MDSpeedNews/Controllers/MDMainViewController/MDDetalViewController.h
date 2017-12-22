//
//  MDDetalViewController.h
//  MDSpeedNews
//
//  Created by Medalands_1 on 16/4/11.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "BaseViewController.h"
#import "MDListModel.h"

@interface MDDetalViewController : BaseViewController
/**
 *  声明一个model去接受传出的model
 */
@property (nonatomic , strong) MDListModel *getModel;

@end
