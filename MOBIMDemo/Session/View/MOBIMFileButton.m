//
//  MOBIMFileButton.m
//  MOBIMDemo
//
//  Created by hower on 2017/9/26.
//  Copyright © 2017年 MOB. All rights reserved.
//

#import "MOBIMFileButton.h"
#import "MOBIMChatMessageModel.h"
#import "NSDictionary+MOBIMExtention.h"
#import "UIView+MOBIMExtention.h"
#import "UIImage+MOBIMExtension.h"
#import "MOBIMChatMessageTools.h"

@interface MOBIMFileButton ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sizeLabel;



@end

@implementation MOBIMFileButton


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.imageV];
        [self addSubview:self.nameLabel];
        [self addSubview:self.sizeLabel];
        [self addSubview:self.progressView];
        [self addSubview:self.identLabel];
    }
    return self;
}

- (void)setModelFrame:(MOBIMChatMessageFrame *)modelFrame
{
//    NSString *lnk = messageModel.lnk;
//    NSDictionary *dicLnk = [NSDictionary dictionaryWithJsonString:lnk];
//    NSInteger size  = [[dicLnk objectForKey:@"s"] integerValue];
    
    
    MIMMessage *message = modelFrame.modelNew;
    MIMFileMessageBody *body = (MIMFileMessageBody*)message.body;
    
    
    NSInteger size = body.fileLength;
    NSString *sizeStr;
    if (size/1000.0 > 1000)
    {
        sizeStr = [NSString stringWithFormat:@"%.1fMB",size/1024.0/1000.0];
    } else {
        sizeStr = [NSString stringWithFormat:@"%.1fKB",size/1000.0];
    }
    
    NSNumber *x = [MOBIMChatMessageTools fileType:[body.fileName pathExtension]];
    if (!x) {
        x = @0;
    }
    MOBIMFileType type = [x intValue];
    NSString *name  = body.fileName;
    self.imageV.image = [UIImage allocationImage:type];
    //    self.nameLabel.text = [name lastStringSeparatedByString:@"_"];
    self.nameLabel.text   = name;
    self.sizeLabel.text = sizeStr;
    
    
    if (message.direction == MIMMessageDirectionSend)
    {
        self.nameLabel.textColor = [UIColor whiteColor];
        self.imageV.frame = CGRectMake(15, 13, 68, 68);
        self.nameLabel.frame = CGRectMake(_imageV.right+10, _imageV.top+3, (self.width-(_imageV.right+2*10)), 18.0);
        [_nameLabel sizeToFit];
        self.sizeLabel.frame = CGRectMake(_imageV.right+10, _imageV.bottom-3-12, 50, 12);
        [_sizeLabel sizeToFit];
        
        self.identLabel.frame = CGRectMake(self.width-12-50, _imageV.bottom-3-12, 40, 12);
        
        self.progressView.frame = CGRectMake(15,_imageV.bottom+10, self.width-30, 8);
        self.progressView.centerY = _imageV.bottom + (self.height-_imageV.bottom)*0.5;
        
    }
    else
    {

        self.nameLabel.textColor = [UIColor blackColor];

        self.imageV.frame = CGRectMake(self.width-12-50-15, 13, 68, 68);
        
        
        self.nameLabel.frame = CGRectMake(15, _imageV.top+3, (_imageV.left - 2*10), 18.0);
        [_nameLabel sizeToFit];
        
        self.sizeLabel.frame = CGRectMake(self.nameLabel.x, _imageV.bottom-3-12, 50, 12);
        [_sizeLabel sizeToFit];
        
        self.identLabel.frame = CGRectMake(self.width-12-50- self.imageV.width, _imageV.bottom-3-12, 40, 12);
        
        self.progressView.frame = CGRectMake(self.nameLabel.left,_imageV.bottom+10, self.width-30, 8);
        self.progressView.centerY = _imageV.bottom + (self.height-_imageV.bottom)*0.5;
        
    }
    
    
}


#pragma mark - Getter

- (UIImageView *)imageV
{
    if (!_imageV)
    {
        _imageV = [[UIImageView alloc] init];
    }
    return _imageV;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [UIFont systemFontOfSize:16.0];
        _nameLabel.textColor = MOBIMRGB(0x262626);
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _nameLabel;
}

- (UILabel *)sizeLabel
{
    if (!_sizeLabel)
    {
        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.font = [UIFont systemFontOfSize:11.0];
        _sizeLabel.textColor = MOBIMRGB(0x707070);
    }
    return _sizeLabel;
}

- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [[UIProgressView alloc] init];
        _progressView.hidden = YES;
        _progressView.progressTintColor = [UIColor greenColor];
    }
    return _progressView;
}

- (UILabel *) identLabel
{
    if (!_identLabel)
    {
        _identLabel = [[UILabel alloc] init];
        _identLabel.font = [UIFont systemFontOfSize:11.0];
        _identLabel.textColor = MOBIMRGB(0x707070);
        _identLabel.textAlignment = NSTextAlignmentRight;
    }
    return _identLabel;
}

@end
