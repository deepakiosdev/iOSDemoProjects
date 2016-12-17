//
//  Utility.h
//  MixMachDemo
//
//  Created by Dipak on 10/20/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(NSString *)getLanguageNameFromLanguageCode:(NSString *)languageCode;
+(NSString*)checkForNull:(NSString*)value;
+(NSArray*)getBitratesFromM3u8:(NSString*)m3u8String withURL:(NSString*)urlString;
+(NSString *)getBitrateName:(double)bitrate;
@end
