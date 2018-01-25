//
//  MOBIMDocumentCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMDocumentCell.h"
#import "MOBIMFileManager.h"
#import "UIColor+MOBIMExtentions.h"
#import "UIView+MOBIMExtention.h"
#import "NSString+MOBIMExtension.h"
#import "MOBIMChatMessageTools.h"
#import "MOBIMGConst.h"
#import "UIImage+MOBIMExtension.h"
#import "MOBIMFileModel.h"

@interface MOBIMDocumentCell ()

@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *sizeLabel;


@end

@implementation MOBIMDocumentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftFreeSpace = 115;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"docCell";
    MOBIMDocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MOBIMDocumentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setModel:(MOBIMFileModel *)model
{
    _model = model;
    
    NSString *type = [model.name pathExtension];
    self.nameLabel.text = [model.name originName];
    
    
    self.sizeLabel.text = [NSString stringWithFormat:@"%@ %@",self.model.date,[MOBIMFileManager filesize:model.filePath]];
    NSNumber *num = [MOBIMChatMessageTools fileType:type];
    if (num == nil) {
        self.imageV.image = [UIImage imageNamed:@"iconfont-wenjian"];
    } else {
        self.imageV.image = [UIImage allocationImage:[num intValue]];
    }
}





- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageV.frame    = CGRectMake(22, 16, 22, 24);
    self.nameLabel.frame = CGRectMake(_imageV.right+17, 14, MOIMDevice_Width-_imageV.right-17-40, 16);
//    [_nameLabel sizeToFit];
    
    self.sizeLabel.frame = CGRectMake(_imageV.right+17,_imageV.bottom-5 , 100, 15);
    
    self.selectBtn.frame = CGRectMake(MOIMDevice_Width-15-20-5, 18, 20, 20);

    [_sizeLabel sizeToFit];
}


- (void)selectBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectBtnClicked:)]) {
        [self.delegate selectBtnClicked:sender];
    }
}

#pragma mark - Getter

- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        
//        btn.backgroundColor=[UIColor redColor];
        _selectBtn = btn;
        [_selectBtn setImage:[UIImage imageNamed:@"single_unselected"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"single_selected"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIImageView *)imageV
{
    if (!_imageV) {
        UIImageView *imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:imageV];
        _imageV = imageV;
    }
    return _imageV;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        _nameLabel = label;
        _nameLabel.font = [UIFont systemFontOfSize:13.0];
        _nameLabel.numberOfLines = 1;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _nameLabel.textColor = MOBIMRGB(0x000000);
    }
    return _nameLabel;
}

- (UILabel *)sizeLabel
{
    if (!_sizeLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        _sizeLabel = label;
        _sizeLabel.font = [UIFont systemFontOfSize:11.0];
        _sizeLabel.textColor = KMOBIMDateColor;
    }
    return _sizeLabel;
}

@end
