//
//  MOBIMBaseEditDesCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/28.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseEditDesCell.h"

@implementation MOBIMBaseEditDesCell

- (instancetype)init
{
    MOBIMBaseEditDesCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MOBIMBaseEditDesCell" owner:self options:nil] lastObject];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.contentView addSubview:self.placeholderLabel];
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self loadUI];
}

//- (void)loadUI
//{
//    
//    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(5);
//        make.left.equalTo(self.desTextView.mas_left).offset(8);
//        make.height.mas_equalTo(21);
//    }];
//    
//}

//- (UILabel *)placeholderLabel{
//    if (!_placeholderLabel) {
//        _placeholderLabel = [[UILabel alloc]init];
//        _placeholderLabel.text = @"请输入消息...";
//        _placeholderLabel.textColor = MOBIMColor(183, 183, 183);
//        _placeholderLabel.font = [UIFont systemFontOfSize:14];
//    }
//    return _placeholderLabel;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
