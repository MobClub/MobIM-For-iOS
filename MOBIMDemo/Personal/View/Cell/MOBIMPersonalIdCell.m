//
//  MOBIMPersonalIdCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMPersonalIdCell.h"

@implementation MOBIMPersonalIdCell


- (instancetype)init
{
    MOBIMPersonalIdCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MOBIMPersonalIdCell" owner:self options:nil] lastObject];
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        [self loadUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self loadUI];
}


- (void)loadUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
    longRecognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longRecognizer];
    
    self.lineLabel.backgroundColor = MOBIMColor(242, 242, 245);
    self.lineLabel.hidden = YES;
    self.desLabel.textColor = MOBIMRGB(0x6E6F78);
    
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:@"用户ID" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:@"（不可修改，长按可复制）" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:MOBIMRGB(0x6E6F78)}];
    [nameString appendAttributedString:countString];
    
    self.nameLabel.attributedText = nameString;
    
}




#pragma mark - longPress delegate

- (void)longPressRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if (self.longPressCompletionBlock)
    {
        self.longPressCompletionBlock(recognizer);
    }
}


@end

