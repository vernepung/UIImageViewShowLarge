//
//  UIImageView+ShowLarge.h
//  StudentStudyNew
//
//  Created by vernepung on 15/10/30.
//  Copyright (c) 2015年 vernepung. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define kMainBoundsHeight [UIScreen mainScreen].bounds.size.height
typedef void (^VPTapBlock)(UIGestureRecognizer *);
typedef void (^VPLongPressBlock)(UILongPressGestureRecognizer *);

@interface UIImageView (ShowLarge)
/**
 *  不设置则自动隐藏
 */
@property (copy,nonatomic) VPTapBlock oneTap;
@property (copy,nonatomic) VPLongPressBlock longPress;
- (void)showLargeImageWithLargeUrl:(NSString *)url;
@end
