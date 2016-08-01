//
//  IBInspectable&IBDesignable.m
//  iOSDemoProjects
//
//  Created by Deepak on 09/07/16.
//  Copyright © 2016 Deepak. All rights reserved.
//




#import "IBInspectable&IBDesignable.h"

#import "MyCustomView.h"
#import "UIView+IB.h"

@interface IBInspectable_IBDesignable()
 IB_DESIGNABLE @property (weak, nonatomic) IBOutlet UIView *myView;
@end

@implementation IBInspectable_IBDesignable


- (void)prepareForInterfaceBuilder
{
    UIColor *color = [UIColor yellowColor];
    _myView.backgroundColor = [UIColor purpleColor];
    _myView.borderColor = color;
    _myView.borderWidth = 60;
    _myView.cornerRadius = 20;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
