//
//  UIView+PSPAppleToast.h
//  Toast Test
//
//  Created by Richard Stockdale on 10/05/2016.
//  Copyright © 2016 Richard Stockdale. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PSPToastPresentationLocation) {
    PSPToastPresentationLocationTop,
    PSPToastPresentationLocationCentre,
    PSPToastPresentationLocationBottom,
};


@interface UIView (PSPAppleToast)

- (UIView *)makeToastWithTitle:(NSString *)title message: (NSString *) message position: (PSPToastPresentationLocation) position;

@end
