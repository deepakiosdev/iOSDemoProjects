//
//  Bitrate.h
//  MixMachDemo
//
//  Created by Dipak on 10/20/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bitrate : NSObject

@property (nonatomic, strong) NSString  *URL;
@property (nonatomic, strong) NSString  *birtateTitle;
@property (nonatomic, assign) double    bitrate;
@property (nonatomic, assign) BOOL      isSelection;

@end
