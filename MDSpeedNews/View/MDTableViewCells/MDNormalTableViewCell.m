//
//  MDNormalTableViewCell.m
//  MDSpeedNews
//
//  Created by Medalands on 16/4/6.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDNormalTableViewCell.h"

@implementation MDNormalTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"MDNormalTableViewCell" owner:self options:nil] lastObject];
    }
    
    return self;
}

- (void) bindDataWithListModel:(MDListModel *)model{
    
    if (!model) {
        
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

    // 图片
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"newsDefault"]];
    
    // 标题
    [self.titleLabel setText:model.title];
    
    // 描述
    [self.contentLabel setText:model.digest];
}

- (void)awakeFromNib {
  
    [self.titleLabel setTextColor:MDRGBA(51, 51, 51, 1.0)];
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    
    [self.contentLabel setTextColor:MDRGBA(153, 153, 153, 1.0)];
    
    [self.contentLabel setFont:[UIFont systemFontOfSize:12.0f]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
