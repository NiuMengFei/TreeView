//
//  CustemCell.m
//  TreeView
//
//  Created by leo on 16/7/12.
//  Copyright © 2016年 huashen. All rights reserved.
//

#import "CustemCell.h"

@implementation CustemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.model.level == 0) {
        self.contentView.backgroundColor = [UIColor yellowColor];
    }else{
        self.contentView.backgroundColor = [UIColor orangeColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(CellModel *)model{
     _model = model ;
    self.separatorInset = UIEdgeInsetsMake(5, 30 * _model.level + 5, 5, 5);
    self.textLabel.text = model.name ;
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    if (self.model.level == 0) {
        self.contentView.backgroundColor = [UIColor yellowColor];

    }else if (self.model.level == 1){
        self.contentView.backgroundColor = [UIColor greenColor];
    }else{
        self.contentView.backgroundColor = [UIColor purpleColor];
        
    }
}

@end
