//
//  MOBIMIFileReaderController.m
//  XZ_WeChat
//
//  Created by Hower on 17-9-27.
//  Copyright (c) 2017年 gxz. All rights reserved.
//

#import "MOBIMIDocumentReaderController.h"
#import <QuickLook/QuickLook.h>
#import "MOBIMAudioView.h"
#import "UIView+MOBIMExtention.h"
#import "MOBIMGConst.h"
#import "UIColor+MOBIMExtentions.h"

@interface MOBIMIDocumentReaderController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIWebViewDelegate,UIDocumentInteractionControllerDelegate>

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, strong) QLPreviewController *previewController;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) UIDocumentInteractionController *documentInCtr;
@property (nonatomic, weak) MOBIMAudioView *audioView;

@end

@implementation MOBIMIDocumentReaderController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadUI];
    
    self.fileURL = [NSURL fileURLWithPath:self.filePath];
    NSString *type = [self.filePath pathExtension];
    [self setupVew:type];
    
}

- (void)loadData
{
    
}

- (void)loadUI
{
    self.title = _orgName;
    
    
    self.fileURL = [NSURL fileURLWithPath:self.filePath];
    NSString *type = [self.filePath pathExtension];
    [self setupVew:type];
    [self setupNavBack];

}


- (void)setupNavBack
{
    // 左上角的返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    backButton.backgroundColor = [UIColor redColor];
    backButton.size = CGSizeMake(50, 50);
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    // 让按钮内部的所有内容左对齐
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton addTarget:self action:@selector(backCLick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, KMOBIMNavOffset, 0, 0); // 这里微调返回键的位置可以让它看上去和左边紧贴
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backCLick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupVew:(NSString *)type
{
    type = [type lowercaseString];
    
    if ([type isEqualToString:@"html"] || [type isEqualToString:@"htm"]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,MOIMDevice_Height)];
        _webView           = webView;
        webView.delegate = self;
        //        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
        webView.scrollView.backgroundColor = [UIColor whiteColor];
        [self webViewLoadData:type];
    }else if ([type isEqualToString:@"pdf"]||[type isEqualToString:@"doc"]||[type isEqualToString:@"docx"]||[type isEqualToString:@"xls"]||[type isEqualToString:@"xlsx"]||[type isEqualToString:@"ppt"]||[type isEqualToString:@"pptx"]||[type isEqualToString:@"txt"]){
        
        _previewController = [[QLPreviewController alloc] init];
        [self addChildViewController:_previewController];

        [self.view addSubview:_previewController.view];

        _previewController.currentPreviewItemIndex = 0;
        _previewController.dataSource = self;
        _previewController.delegate   = self;
        _previewController.view.frame = CGRectMake(10,10, self.view.width-20, MOIMDevice_Height-20);
        [_previewController reloadData];
    }  else if ([type isEqualToString:@"png"]||[type isEqualToString:@"jpg"]||[type isEqualToString:@"jpeg"]||[type isEqualToString:@"gif"]||[type isEqualToString:@"bmp"]||[type isEqualToString:@"tiff"]||[type isEqualToString:@"svg"]) {
        UIImageView *imageV = [[UIImageView alloc] init];
        [self.view addSubview:imageV];
        
        imageV.frame = CGRectMake(100, 100, 300, 300);
        imageV.center = CGPointMake(self.view.width*0.5, self.view.height*0.5);
        UIImage *image = [UIImage imageWithContentsOfFile:self.filePath];
        imageV.image   = image;
    } else if ([type isEqualToString:@"mp3"]||[type isEqualToString:@"amr"]||[type isEqualToString:@"wav"]||[type isEqualToString:@"aac"]||[type isEqualToString:@"wma"]||[type isEqualToString:@"ogg"]||[type isEqualToString:@"ape"]) {
        MOBIMAudioView *audioView = [[MOBIMAudioView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:audioView];

        audioView.audioPath = _filePath;
        audioView.audioName = _orgName;
        _audioView = audioView;
    } else {
        [self makeOtherView];
    }
}

- (void)makeOtherView
{
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.frame        = CGRectMake(MOIMDevice_Width*0.5-40, 45, 80, 80);
    imageV.image        = [UIImage imageNamed:@"iconfont-wenjian"];
    [self.view addSubview:imageV];
    UILabel *nameL      = [[UILabel alloc] initWithFrame:CGRectMake(MOIMDevice_Width*0.5-150, imageV.bottom+32, 300, 40)];
    nameL.text          = [self.filePath lastPathComponent];
    nameL.font          = [UIFont systemFontOfSize:15.0];
    nameL.textColor     = MOBIMRGB(0x505f62);
    nameL.numberOfLines = 0;
    nameL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameL];
    [nameL sizeToFit];
    nameL.centerX = MOIMDevice_Width*0.5;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MOIMDevice_Width*0.5-100, nameL.bottom+85, 200, 40)];
    [self.view addSubview:label];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = MOBIMRGB(0xbebebe);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"该文件暂不支持本地浏览，请使用其他应用打开";
    [label sizeToFit];
    label.centerX = MOIMDevice_Width * 0.5;
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.frame     = CGRectMake(13, label.bottom + 40, MOIMDevice_Width-26, 48);
    [self.view addSubview:openBtn];
    openBtn.layer.cornerRadius = 5;
    openBtn.layer.masksToBounds = YES;
    [openBtn setBackgroundImage:[UIImage imageNamed:@"beijign"] forState:UIControlStateNormal];
    [openBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openBtn setTitle:@"使用其他应用打开" forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(otherApplicationOpen) forControlEvents:UIControlEventTouchUpInside];
}


- (void)webViewLoadData:(NSString *)type
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSURL *baseUrl = [NSURL fileURLWithPath:[paths objectAtIndex:0]];
    NSData *data = [[NSData alloc] initWithContentsOfFile:self.filePath];
    NSString *MIMEType = [NSString stringWithFormat:@"text/%@",type];
    [_webView loadData:data MIMEType:MIMEType textEncodingName:@"UTF-8" baseURL:baseUrl];
}

- (void)otherApplicationOpen
{
    UIDocumentInteractionController *documentController =[UIDocumentInteractionController interactionControllerWithURL:self.fileURL];
    self.documentInCtr = documentController;  // 必须强引用起来
    [documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    documentController.delegate = self;
}

#pragma mark -

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}


#pragma mark - QLDelegate
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return self.fileURL;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

#pragma mark - webViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=350;"
     "for =(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if (myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = maxwidth * (myimg.height/oldwidth);"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_audioView releaseTimer];
}

- (void)dealloc
{
    [_audioView releaseTimer];
}


@end
