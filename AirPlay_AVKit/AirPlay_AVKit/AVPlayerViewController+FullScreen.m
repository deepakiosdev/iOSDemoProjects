//
//  AVPlayerViewController+FullScreen.m
//  AirPlay_AVKit
//
//  Created by Dipak on 10/18/16.
//  Copyright © 2016 Dipak. All rights reserved.
//

#import "AVPlayerViewController+FullScreen.h"

@implementation AVPlayerViewController (FullScreen)

-(void)goFullscreen {
    SEL fsSelector = NSSelectorFromString(@"_transitionToFullScreenViewControllerAnimated:completionHandler:");
    if ([self respondsToSelector:fsSelector]) {
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:fsSelector]];
        [inv setSelector:fsSelector];
        [inv setTarget:self];
        BOOL animated = YES;
        id completionBlock = nil;
        [inv setArgument:&(animated) atIndex:2];
        [inv setArgument:&(completionBlock) atIndex:3];
        [inv invoke];
    }
}

@end
