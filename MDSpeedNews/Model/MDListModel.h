//
//  MDListModel.h
//  MDSpeedNews
//
//  Created by Medalands on 16/4/7.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDBaseModel.h"

@interface MDListModel : MDBaseModel

// 有四种cell，第一种topCell 就是indexPath.row == 0
// 第二种longCell   imgtype == @(1)
// 第三种moreCell  imgextra.count>1
// 其余的是第四种cell

/**
 *标题
 */
@property (nonatomic , copy) NSString *title;

/**
 *图片
 */
@property (nonatomic , copy) NSString *imgsrc;

/**
 *描述
 */
@property (nonatomic , copy) NSString *digest;

/**
 *图片数组，三张图的cell需要用到这个字段
 */
@property (nonatomic , strong) NSArray *imgextra;

/**
 *详情的URL
 */
@property (nonatomic , copy) NSString *url;

/**
 *唯一性：新闻的标识
 */
@property (nonatomic , copy) NSString *docid;

/**
 *判断是不是longTableViewCell 如果是imgType = 1
 */
@property (nonatomic , assign) NSNumber *imgType;

#pragma mark - 这些！暂时！用不着  -
@property (nonatomic , copy) NSString *postid;
@property (nonatomic , copy) NSString *hasCover;
@property (nonatomic , copy) NSString *hasHead;
@property (nonatomic , copy) NSString *skipID;
@property (nonatomic , copy) NSString *replyCount;
@property (nonatomic , copy) NSString *alias;
@property (nonatomic , copy) NSString *hasImg;
@property (nonatomic , copy) NSString *hasIcon;
@property (nonatomic , copy) NSString *skipType;
@property (nonatomic , copy) NSString *cid;
@property (nonatomic , copy) NSString *hasAD;
@property (nonatomic , copy) NSString *order;
@property (nonatomic , copy) NSString *priority;
@property (nonatomic , copy) NSString *lmodify;
@property (nonatomic , copy) NSString *boardid;

@property (nonatomic , copy) NSString *tname;
@property (nonatomic , copy) NSString *ename;
@property (nonatomic , copy) NSString *ads;
@property (nonatomic , copy) NSString *photosetID;
@property (nonatomic , copy) NSString *ptime;
@property (nonatomic , copy) NSString *tmpplate;
@property (nonatomic , copy) NSString *votecount;
@property (nonatomic , copy) NSString *source;





@end
