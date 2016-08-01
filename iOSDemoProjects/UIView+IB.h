//
//  UIView+IB.h
//  iOSDemoProjects
//
//  Created by Deepak on 09/07/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IB)

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (assign,nonatomic ) IBInspectable CGFloat borderWidth;
@property (assign,nonatomic ) IBInspectable UIColor  *borderColor;

@end
