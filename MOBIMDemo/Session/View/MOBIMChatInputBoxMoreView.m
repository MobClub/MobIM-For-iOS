//
//  MOBIMChatInputBoxMoreView.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/25.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMChatInputBoxMoreView.h"
#import "Masonry.h"
#import "MOBIMChatInputBoxMoreViewItem.h"
#import "MOBIMGConst.h"


#define KItemTag 1000
#define KItemWidth 60
#define KItemHeight 82

@implementation MOBIMChatInputBoxMoreView


- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        
//        self.backgroundColor=[UIColor redColor];
        
        [self loadData];
        [self loadUI];
        
    }
    
    return self;
}


- (void)loadData
{
    
}

- (void)loadUI
{
    
}

- (void)setItems:(NSMutableArray *)items
{
    
    _items=items;
    float count = items.count;
    
    CGFloat  offset = (MOIMDevice_Width-3*KItemWidth)/(count+1);
    
    for (int i = 0 ; i<items.count; i++)
    {
        NSDictionary *itemDict=items[i];
        
        MOBIMChatInputBoxMoreViewItem *item =[[MOBIMChatInputBoxMoreViewItem alloc] init];
        
        CGRect rect = CGRectMake(offset*(i+1)+KItemWidth*i, (self.frame.size.height - MOIMDevice_Width/count)/2.0, KItemWidth, KItemHeight);
        
        item.frame = rect;
        [item setTitle:itemDict[@"name"] imageName:itemDict[@"imageName"] moreViewItemType:[itemDict[@"MOBIMChatInputBoxMoreViewItemType"] intValue]];
        
        item.button.tag = i+KItemTag;
        [item.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:item];
    }
    
}

- (void)buttonClick:(UIButton*)button
{
    long tag = button.tag- KItemTag;
    NSDictionary *itemDict = self.items[tag];
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxMoreView:didSelectItem:)]) {
        
        [_delegate chatBoxMoreView:self didSelectItem:[itemDict[@"MOBIMChatInputBoxMoreViewItemType"] intValue]];
    }
    
}

@end
