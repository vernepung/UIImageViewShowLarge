//
//  ViewController.m
//  ShowLargeImageDemo
//
//  Created by vernepung on 15/11/2.
//  Copyright (c) 2015年 vernepung. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+ShowLarge.h"
const CGFloat imageSize = 80;
@interface ViewController ()
{
    NSArray *_largeImageArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _largeImageArr = @[@"http://img.woyaogexing.com/2014/08/15/0e0875831a1790e3!200x200.jpg",@"http://img5.duitang.com/uploads/item/201407/03/20140703082412_NKFCs.jpeg"];
    UIImageView *imageView = nil;
    UITapGestureRecognizer *tapGesture;
    for (NSInteger i = 0; i < 5; i ++) {
//        + (kMainBoundsWidth - imageSize) / 2
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * 45 , i * (imageSize + 20) + 40, imageSize, imageSize)];
        
        tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
        [imageView addGestureRecognizer:tapGesture];
        
        imageView.tag = 2000 + i;
        imageView.userInteractionEnabled = YES;
        [imageView setImage:[UIImage imageNamed:@"1.jpg"]];
        [self.view addSubview:imageView];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)imageTap:(UITapGestureRecognizer *)tapGesture
{
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    NSInteger temp = imageView.tag - 2000;
    [imageView showLargeImageWithLargeUrl:temp == 0 ? nil : _largeImageArr[temp % 2]];
    imageView.longPress = ^(UILongPressGestureRecognizer *longPressGesture)
    {
        NSLog(@"长按大图");
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
