//
//  PlayerWithCustomControlVC.m
//  AirPlay_AVKit
//
//  Created by Dipak on 10/18/16.
//  Copyright © 2016 Dipak. All rights reserved.
//

#import "PlayerWithCustomControlVC.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerViewController+FullScreen.h"
#import  <MediaPlayer/MediaPlayer.h>

@interface PlayerWithCustomControlVC ()

@property (weak, nonatomic) IBOutlet UIButton *playPauseBtn;
@property (nonatomic, strong) AVPlayerViewController *playerVC;
@property (weak, nonatomic) IBOutlet UIView *airPlayIconView;

@end

@implementation PlayerWithCustomControlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self configureAirPlayView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playPauseAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_playerVC.player play];
    } else {
        [_playerVC.player pause];

    }
}

- (IBAction)goToFullScreen:(id)sender {
    [_playerVC goFullscreen];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _playerVC           = [[AVPlayerViewController alloc] init];
    _playerVC           = (AVPlayerViewController *)segue.destinationViewController;
    NSURL *videoUrl     = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
   // NSURL *videoUrl     = [NSURL URLWithString:@"http://playertest.longtailvideo.com/adaptive/oceans_aes/oceans_aes.m3u8"];
    _playerVC.player    = [AVPlayer playerWithURL:videoUrl];
    
    _playerVC.showsPlaybackControls                                     = NO;
    _playerVC.player.allowsExternalPlayback                             = YES;
    _playerVC.player.usesExternalPlaybackWhileExternalScreenIsActive    = YES;
    
    [self performSelector:@selector(showWatermark) withObject:nil afterDelay:3.0];
}

- (void)showWatermark {
    if (_playerVC.contentOverlayView.subviews.count == 0) {
        
        UILabel *waterMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 150, 200, 70)];
        waterMarkLabel.text = @"Player Watermark";
        [waterMarkLabel sizeToFit];
        waterMarkLabel.textColor = [UIColor whiteColor];
        [_playerVC.contentOverlayView addSubview:waterMarkLabel];
    }
}

- (void)configureAirPlayView {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init] ;
    [volumeView setShowsVolumeSlider:NO];
    [volumeView sizeToFit];
    [_airPlayIconView addSubview:volumeView];
}

@end
