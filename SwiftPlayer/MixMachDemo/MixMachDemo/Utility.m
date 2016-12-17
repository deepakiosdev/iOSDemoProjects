//
//  Utility.m
//  MixMachDemo
//
//  Created by Dipak on 10/20/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import "Utility.h"
#import "Bitrate.h"


/* Audio track constants */
#define AUDIO_TRACK_NAME_UNKNOWN_LANGUAGE                       @"Unknown Language"
#define AUDIO_TRACK_NAME_TRACK                                  @"Track"

@implementation Utility


/**
 * Get Audio track's full language name from language code
 */
+(NSString *)getLanguageNameFromLanguageCode:(NSString *)languageCode
{
    languageCode            = [Utility checkForNull:languageCode];
    NSLocale *englishLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSString *displayName   = [[englishLocale displayNameForKey:NSLocaleLanguageCode value:languageCode] capitalizedString];
    displayName             = [Utility checkForNull:displayName];
    
    if (!displayName || !displayName.length || [displayName isEqualToString:AUDIO_TRACK_NAME_UNKNOWN_LANGUAGE]) {
        displayName         = AUDIO_TRACK_NAME_TRACK;
    }
    return displayName;
}


+(NSString*)checkForNull:(NSString*)value
{
    if([value isKindOfClass:[NSNull class]]) {
        return @"";
    }
    else if (!value) {
        return @"";
    }
    else if (([value isKindOfClass:[NSString class]] && ([value isEqualToString:@""]))) {
        return @"";
    }
    else {
        return value;
    }
}


+(NSArray*)getBitratesFromM3u8:(NSString*)m3u8String withURL:(NSString*)urlString
{
    urlString = @"https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/";
    NSLog(@"Master m3u8 url:%@", urlString);
    if ([m3u8String isEqualToString:@""] || !m3u8String) {
        return nil;
    }
    
    NSMutableArray *bandwidths = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *m3u8Playlist = [m3u8String componentsSeparatedByString:@"\n"];
    
    if([m3u8String rangeOfString:@"BANDWIDTH="].location != NSNotFound)
    {
        NSMutableArray *bandwidthStrings = [[NSMutableArray alloc] init];
        
        int index = 1;
        for (NSString *streamString in m3u8Playlist)
        {
            if([streamString rangeOfString:@"BANDWIDTH="].location != NSNotFound && [streamString rangeOfString:@"EXT-X-I-FRAME-STREAM-INF"].location == NSNotFound)
            {
                [bandwidthStrings addObject:streamString];
                
                NSRange bandwidthRange = [streamString rangeOfString:@"BANDWIDTH="];
                NSString *bandwidthString = [streamString substringFromIndex:bandwidthRange.location + bandwidthRange.length];
                NSString *value;
                NSRange commaRange = [bandwidthString rangeOfString:@","];
                if (NSNotFound == commaRange.location) {
                    value = bandwidthString;
                } else {
                    value = [bandwidthString substringToIndex:commaRange.location];
                }
                NSString *playlistURL   = m3u8Playlist[index];
                if (playlistURL)
                {
                    Bitrate *bitrate        = [[Bitrate alloc] init];
                    bitrate.bitrate         = value.doubleValue;
                    bitrate.birtateTitle    = [Utility getBitrateName:[value doubleValue]];
                    NSLog(@"bit rate %f", bitrate.bitrate);

                    bitrate.URL          = [playlistURL stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    NSLog(@"Bitrate url:%@",bitrate.URL);
                    if (![bitrate.URL hasSuffix:@".m3u8"])
                        continue;
                    if(![bitrate.URL hasPrefix:@"http"]) {
                        bitrate.URL = [[[[NSURL URLWithString:urlString] URLByAppendingPathComponent:bitrate.URL]  absoluteString]stringByRemovingPercentEncoding];
                    }

                        
                    NSLog(@"Bitrate:%f, and corresponding m3u8 url:%@",value.doubleValue,bitrate.URL);
                    [bandwidths addObject:bitrate];
                }
            }
            ++index;
        }
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"bitrate"  ascending:YES];
        NSArray *sortedArray = [bandwidths sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
        
        bandwidths = [NSMutableArray arrayWithArray:sortedArray];
    }
    
    return bandwidths;
}

+ (NSString *)getBitrateName:(double)bitrate
{
    if (bitrate  >= 1048576)
    {
        bitrate = bitrate/(1024*1024);
        bitrate = round(10 * bitrate)/ 10;
        return [NSString stringWithFormat:@"%.1f Mbps",bitrate];
    }
    else if (bitrate >= 1024)
    {
        bitrate = bitrate/1024;
        bitrate = round(10 * bitrate)/10;
        return [NSString stringWithFormat:@"%4d Kbps",(int)bitrate];
    }
    else if (bitrate < 1024) {
        return [NSString stringWithFormat:@"%4d bps",(int)bitrate];
    }
    
    return [NSString stringWithFormat:@"%f",bitrate];
}
@end
