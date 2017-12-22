//
//  MDMoreTableViewCell.m
//  MDSpeedNews
//
//  Created by Medalands on 16/4/6.
//  Copyright © 2016年 Medalands. All rights reserved.
//

#import "MDMoreTableViewCell.h"

@implementation MDMoreTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"MDMoreTableViewCell" owner:self options:nil] lastObject];
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

    
    // 左边的imageview
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"threeDefault"]];
    
    // 中间的ImageView
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:[model.imgextra[0] valueForKey:@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"threeDefault"]];
    
    // 右侧的imageView
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:[model.imgextra[1] valueForKey:@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"threeDefault"]];
    
    [self.titleLabel setText:model.title];
    
    
    
}

- (void)awakeFromNib {

    [self.titleLabel setTextColor:MDRGBA(51, 51, 51, 1.0)];
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
