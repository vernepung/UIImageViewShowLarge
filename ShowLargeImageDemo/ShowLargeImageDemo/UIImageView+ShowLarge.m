//
//  UIImageView+ShowLarge.m
//  StudentStudyNew
//
//  Created by vernepung on 15/10/30.
//  Copyright (c) 2015年 vernepung. All rights reserved.
//

#import "UIImageView+ShowLarge.h"
#import <objc/runtime.h>
static const void *oldFrameKey = &oldFrameKey;
static const void *oneTaBlockpKey = &oneTaBlockpKey;
static const void *longPressBlockKey = &longPressBlockKey;
@interface UIImageView (ShowLarge)<UIActionSheetDelegate>
{
}
@property (copy,nonatomic) NSValue *oldFrame;
@end
@implementation UIImageView (ShowLarge)

- (void)setOldFrame:(NSValue *)oldFrame
{
    objc_setAssociatedObject(self, oldFrameKey, oldFrame, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSValue *)oldFrame
{
    return objc_getAssociatedObject(self, oldFrameKey);
}

- (void)setOneTap:(VPTapBlock)block
{
    objc_setAssociatedObject(self, oneTaBlockpKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (VPTapBlock)oneTap
{
    return objc_getAssociatedObject(self, oneTaBlockpKey);
}

- (void)setLongPress:(VPLongPressBlock)longPressBlock
{
    objc_setAssociatedObject(self, longPressBlockKey, longPressBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (VPLongPressBlock)longPress
{
    return objc_getAssociatedObject(self, longPressBlockKey);
}

- (void)showLargeImageWithLargeUrl:(NSString *)url
{
    UIImage *oldImage = self.image;
    UIWindow *window = [self getCurrentWindow];
    self.oldFrame = [NSValue valueWithCGRect:[self convertRect:self.bounds toView:window]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideLargeImage:)];
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight)];
    backgroundView.tag = 5002;
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.alpha = 0;
    [backgroundView addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPressGesture.minimumPressDuration = 1.0f;
    UIImageView *newImageView = [[UIImageView alloc]initWithFrame:([self.oldFrame CGRectValue])];
    newImageView.userInteractionEnabled = YES;
    newImageView.tag = 5001;
    newImageView.image = oldImage;
    [newImageView addGestureRecognizer:longPressGesture];
    [backgroundView addSubview:newImageView];
    [window addSubview:backgroundView];
    CGFloat height = self.image.size.height * kMainBoundsWidth / self.image.size.width;
    
    [UIView animateWithDuration:.25 animations:^{
        newImageView.frame = CGRectMake(0, (kMainBoundsHeight - height) / 2, kMainBoundsWidth, height);
        backgroundView.alpha = 1;
        backgroundView.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        
    }];
    if (url && url.length > 0)
    {
        [newImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]];
        // DownLoad Image
        
//        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight)];
//        indicatorView.backgroundColor = [UIColor clearColor];
//        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//        indicatorView.center = window.center;
//        [indicatorView startAnimating];
//        [window addSubview:indicatorView];
//        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url] options:SDWebImageRefreshCached progress:^(NSUInteger receivedSize, long long expectedSize) {
//            
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//            [newImageView setImage:image];
//            [indicatorView stopAnimating];
//            [indicatorView removeFromSuperview];
//        }];
    }
    
}

- (void)longPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (self.longPress)
    {
        self.longPress(longPressGesture);
    }
    else
    {
        if (longPressGesture.state == UIGestureRecognizerStateBegan)
        {
            NSLog(@"单击大图，未设置Block");
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存图片" otherButtonTitles: nil];
            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImageView *newImageView = (UIImageView *)[[self getCurrentWindow] viewWithTag:5001];
        UIImageWriteToSavedPhotosAlbum(newImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = @"图片已经保存到相册";
    if (error)
    {
        msg = @"保存图片失败";
    }
    NSLog(msg);
}

- (void)hideLargeImage:(UIGestureRecognizer *)gesture
{
    if (self.oneTap)
    {
        self.oneTap(gesture);
    }
    else
    {
        UIWindow *window = [self getCurrentWindow];
        UIView *backgroundView = (UIView *)[window viewWithTag:5002];
        UIImageView *newImageView = (UIImageView *)[backgroundView viewWithTag:5001];
        [UIView animateWithDuration:.25 animations:^{
            newImageView.frame = [self.oldFrame CGRectValue];
            backgroundView.backgroundColor = [UIColor clearColor];
            backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
        }];
    }
}

- (UIWindow *)getCurrentWindow
{
    UIWindow *window = nil;
    for (UIWindow *tempWindow in [UIApplication sharedApplication].windows) {
        if (tempWindow.tag == 54321)
        {
            window = tempWindow;
            break;
        }
    }
    if (!window)
    {
        window = [UIApplication sharedApplication].keyWindow;
        window.tag = 54321;
    }
    return window;
}

@end
