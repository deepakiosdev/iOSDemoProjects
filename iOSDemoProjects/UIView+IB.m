//
//  UIView+IB.m
//  iOSDemoProjects
//
//  Created by Deepak on 09/07/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import "UIView+IB.h"

@implementation UIView (IB)

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

-(void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
   /* UIColor *color = [UIColor yellowColor];
    self.layer.borderColor = color.CGColor;*/
}

-(UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
@end
