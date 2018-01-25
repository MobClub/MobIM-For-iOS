//
//  MOBIMBaseTitleStyleCell.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/27.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMBaseTitleStyleCell.h"
#import "Masonry.h"
#import "MOBIMGConst.h"

@interface MOBIMBaseTitleStyleCell()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *desTailConstraint;


@end

@implementation MOBIMBaseTitleStyleCell

- (instancetype)init
{
    MOBIMBaseTitleStyleCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MOBIMBaseTitleStyleCell" owner:self options:nil] lastObject];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
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
    self.lineLabel.backgroundColor = KMOBIMCommonLineColor;

    UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
    longRecognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longRecognizer];
    
    self.desLabel.textColor = KMOBIMDesColor;
    self.lineLabel.backgroundColor = KMOBIMCommonLineColor;
    
}


#pragma mark - longPress delegate

- (void)longPressRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if (self.longPressCompletionBlock) {
        self.longPressCompletionBlock(recognizer);
    }
}


- (void)setShowArrow:(BOOL)showArrow
{
    _showArrow =  showArrow;
    if (showArrow ==  NO) {
        
        self.arrowImageView.hidden = YES;
        self.desTailConstraint.constant = 10;
        
    }else{
        self.arrowImageView.hidden = NO;
        
        self.desTailConstraint.constant = 46;

    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

