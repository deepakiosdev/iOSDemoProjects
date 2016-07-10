//
//  MyCustomView.m
//  iOSDemoProjects
//
//  Created by Deepak on 09/07/16.
//  Copyright © 2016 Deepak. All rights reserved.
//



#import "MyCustomView.h"
#import "UIView+IB.h"

@interface MyCustomView ()
{
    IBInspectable NSInteger lineWidth;
}

@property (nonatomic) IBInspectable UIColor *fillColor;

//For testing
@property (nonatomic) IBInspectable BOOL testBool;
@property (nonatomic, strong) IBInspectable NSString *title;
//
@end

@implementation MyCustomView

- (void)drawRect:(CGRect)rect {
    lineWidth   = 15;
    _fillColor  = [UIColor blueColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect    myFrame = self.bounds;
    CGContextSetLineWidth(context, lineWidth);
    CGRectInset(myFrame, 5, 5);
    [_fillColor set];
    UIRectFrame(myFrame);
}

- (void)prepareForInterfaceBuilder
{
    UIColor *color = [UIColor purpleColor];
    self.borderColor = color;
    self.backgroundColor = [UIColor lightGrayColor];
}

@end
