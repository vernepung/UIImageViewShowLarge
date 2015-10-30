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
@interface UIImageView (ShowLarge)
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
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.oldFrame = [NSValue valueWithCGRect:[self convertRect:self.bounds toView:window]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideLargeImage:)];
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight)];
    backgroundView.tag = 5002;
    backgroundView.backgroundColor = [UIColor blackColor];
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
    }];
    
}

- (void)longPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (self.longPress)
    {
        self.longPress(longPressGesture);
    }
}

- (void)hideLargeImage:(UIGestureRecognizer *)gesture
{
    if (self.oneTap)
    {
        self.oneTap(gesture);
    }
    else
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIImageView *newImageView = (UIImageView *)[window viewWithTag:5001];
        UIView *backgroundView = (UIView *)[window viewWithTag:5002];
        [UIView animateWithDuration:.25 animations:^{
            newImageView.frame = [self.oldFrame CGRectValue];
            backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [newImageView removeFromSuperview];
            [backgroundView removeFromSuperview];
        }];
    }
}
@end
