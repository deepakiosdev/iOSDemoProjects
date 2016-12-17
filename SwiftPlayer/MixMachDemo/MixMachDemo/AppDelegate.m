//
//  AppDelegate.m
//  MixMachDemo
//
//  Created by Deepak on 24/09/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVKit/AVKit.h>
@interface AppDelegate () <AVAssetDownloadDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   /* let audioSession = AVAudioSession.sharedInstance()
    
    do {
        
        try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        
    } catch {
        
        print("Setting category to AVAudioSessionCategoryPlayback failed.")
        
    }
    */
    // Set AudioSession
    //NSError *sessionError = nil;
   // [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
//    /* Pick any one of them */
//    // 1. Overriding the output audio route
//    //UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    //AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
//    
//    // 2. Changing the default output audio route
//    UInt32 doChangeDefaultRoute = 1;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    
    //[self backGroundDownlaod];
    
    return YES;
}

- (void)backGroundDownlaod {
    
    //1. Create asset, URL, configuration and delegate
    AVURLAsset *hlsAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:@"https://devimages.apple.com.edgekey.net/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8"]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"myIdentifier"];
    //  MyDownloadDelegate *delegate = [[MyDownloadDelegate alloc] init];
    AVAssetDownloadURLSession *downloadURLSession =    [AVAssetDownloadURLSession sessionWithConfiguration:configuration assetDownloadDelegate:self delegateQueue:nil];
    
   // 2. Create a download session and task
    AVAssetDownloadTask *downloadTask = [downloadURLSession assetDownloadTaskWithURLAsset:hlsAsset assetTitle:@"Movie Download" assetArtworkData:nil options:nil];
   // 3. Resume task to start download
    [downloadTask resume];
    
    //4. Get the asset from the download task and create a playerItem with it
    //AVAsset *restoredAsset      = downloadTask.URLAsset;
   // AVPlayerItem *playerItem    = [AVPlayerItem playerItemWithAsset:restoredAsset];
}


- (void)URLSession:(NSURLSession *)session assetDownloadTask:(AVAssetDownloadTask *)assetDownloadTask didFinishDownloadingToURL:(NSURL *)location  {
    NSLog(@"didFinishDownloadingToURL:%@",location);
    
}
- (void)URLSession:(NSURLSession *)session assetDownloadTask:(AVAssetDownloadTask *)assetDownloadTask didLoadTimeRange:(CMTimeRange)timeRange totalTimeRangesLoaded:(NSArray<NSValue *> *)loadedTimeRanges timeRangeExpectedToLoad:(CMTimeRange)timeRangeExpectedToLoad {
    NSLog(@"totalTimeRangesLoaded");
    
    float percentComplete = 0.0;
    
    for (NSValue *value in loadedTimeRanges) {
        CMTimeRange loadedTimeRange = value.CMTimeRangeValue;
        percentComplete += CMTimeGetSeconds(loadedTimeRange.duration);
        NSLog(@"percentComplete:%f",percentComplete);
    }
}

- (void)URLSession:(NSURLSession *)session assetDownloadTask:(AVAssetDownloadTask *)assetDownloadTask didResolveMediaSelection:(AVMediaSelection *)resolvedMediaSelection  {
    NSLog(@"didResolveMediaSelection");

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
