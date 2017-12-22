//
//  MDTopTableViewCell.m
//  MDSpeedNews
//
//  Created by Medalands on 16/4/6.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDTopTableViewCell.h"


@implementation MDTopTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {

        self = [[[NSBundle mainBundle] loadNibNamed:@"MDTopTableViewCell" owner:self options:nil] lastObject];
    }
    
    return self;
}

- (void) bindDataWithListModel:(MDListModel *)model{
    
    if (!model) {
        return;
    }
    
    NSFetchRequest *res = [[NSFetchRequest alloc]initWithEntityName:@"MDSpeedNews"];
    
    //谓词
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"tid like %@",model.title];
    
    //设置查询条件
    res.predicate = pred;
    
    NSArray *resArr = [KAppdelegate.managedObjectContext executeFetchRequest:res error:nil];
    
    if (resArr.count > 0) {
        
        [self setBackgroundColor:[UIColor grayColor]];
    }
    
    // 标题
    [self.titleLabel setText:model.title];
    
    // 图片
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"default"]];
  
}

// 当用XIB构建界面的时候会走的方法
- (void)awakeFromNib {

    // 设置文字颜色
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    
    // 设置文字字号
    [self.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
