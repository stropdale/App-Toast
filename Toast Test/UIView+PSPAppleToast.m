//
//  UIView+PSPAppleToast.m
//  Toast Test
//
//  Created by Richard Stockdale on 10/05/2016.
//  Copyright © 2016 Richard Stockdale. All rights reserved.
//

#import "UIView+PSPAppleToast.h"

@implementation UIView (PSPAppleToast)

- (UIView *)makeToastWithTitle:(NSString *)title message: (NSString *) message position: (PSPToastPresentationLocation) position {
    UIView *toast = [self toastViewForMessage:message title:title];
    
    if (toast == nil) {
        return nil;
    }
    
    [self showToast:toast duration:2.5 position:position];
    
    return toast;
}

- (UIView *)toastViewForMessage:(NSString *)message title:(NSString *)title {
    
    CGFloat viewCornerRadius = 10.0;
    CGFloat viewShadowOpacity = 0.6;
    
    // sanity
    if(message == nil && title == nil) return nil;
    
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    UIFont *titleFont = [UIFont boldSystemFontOfSize:17.0];
    UIFont *messageFont = [UIFont systemFontOfSize:15.0];
    
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = viewCornerRadius;
    
    wrapperView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    wrapperView.layer.shadowOpacity = viewShadowOpacity;
    wrapperView.layer.shadowRadius = 4.0;
    wrapperView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    
    wrapperView.backgroundColor = [UIColor whiteColor];
    
    
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 10;
        titleLabel.font = titleFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.textColor = [UIColor darkTextColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width + 40), self.bounds.size.height + 40);
        CGSize expectedSizeTitle = [titleLabel sizeThatFits:maxSizeTitle];
        expectedSizeTitle = CGSizeMake(MIN(maxSizeTitle.width, expectedSizeTitle.width), MIN(maxSizeTitle.height, expectedSizeTitle.height));
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 10;
        messageLabel.font = messageFont;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        messageLabel.textColor = [UIColor darkTextColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // Give it a max size
        CGSize maxSizeMessage = CGSizeMake((300), self.bounds.size.height);
        CGSize expectedSizeMessage = [messageLabel sizeThatFits:maxSizeMessage];
        expectedSizeMessage = CGSizeMake(MIN(maxSizeMessage.width, expectedSizeMessage.width), MIN(maxSizeMessage.height, expectedSizeMessage.height));
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    CGFloat padding = 24.0;
    
    CGRect titleRect = CGRectZero;
    
    if(titleLabel != nil) {
        titleRect.origin.x = padding;
        titleRect.origin.y = 20;
        titleRect.size.width = titleLabel.bounds.size.width + padding;
        titleRect.size.height = titleLabel.bounds.size.height;
    }
    
    CGRect messageRect = CGRectZero;
    
    if(messageLabel != nil) {
        messageRect.origin.x = padding;
        messageRect.origin.y = titleRect.origin.y + titleRect.size.height + 5;
        messageRect.size.width = messageLabel.bounds.size.width + padding;
        messageRect.size.height = messageLabel.bounds.size.height;
    }
    
    CGFloat longerWidth = MAX(titleRect.size.width, messageRect.size.width);
    
    CGFloat wrapperWidth = padding + (longerWidth + padding);
    CGFloat wrapperHeight = padding + (titleRect.size.height + messageRect.size.height) + 20;
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if (titleRect.size.width > messageRect.size.width) {
        messageRect.size.width = titleRect.size.width;
    }
    else {
        titleRect.size.width = messageRect.size.width;
    }
    
    if(titleLabel != nil) {
        titleLabel.frame = titleRect;
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = messageRect;
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
    
    return wrapperView;
}

- (void)showToast:(UIView *)toast duration: (NSTimeInterval)duration position: (PSPToastPresentationLocation) position {
    toast.center = [self centerPointForPosition:position withToast:toast];
    toast.alpha = 0.0;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleToastTapped:)];
    [toast addGestureRecognizer:recognizer];
    toast.userInteractionEnabled = YES;
    toast.exclusiveTouch = YES;
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(toastTimerDidFinish:) userInfo:toast repeats:NO];
                         [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                     }];
}

- (CGPoint)centerPointForPosition: (PSPToastPresentationLocation) point withToast: (UIView *)toast {
    
    switch (point) {
        case PSPToastPresentationLocationTop: {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + 60.0);
            break;
        }
            
        case PSPToastPresentationLocationCentre: {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            break;
        }
            
        case PSPToastPresentationLocationBottom: {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - (toast.frame.size.height + 20));
            break;
        }
            
        default:
            break;
    }
}

- (void)handleToastTapped:(UITapGestureRecognizer *)recognizer {
    UIView *toast = recognizer.view;
    
    [self hideToast:toast fromTap:YES];
}

- (void)toastTimerDidFinish:(NSTimer *)timer {
    [self hideToast:(UIView *)timer.userInfo];
}

- (void)hideToast:(UIView *)toast {
    [self hideToast:toast fromTap:NO];
}

- (void)hideToast:(UIView *)toast fromTap:(BOOL)fromTap {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                     }];
}

@end
