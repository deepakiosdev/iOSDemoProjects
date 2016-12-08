//
//  PlayerWithDefatultControlVC.m
//  AirPlay_AVKit
//
//  Created by Dipak on 10/18/16.
//  Copyright © 2016 Dipak. All rights reserved.
//

#import "PlayerWithDefatultControlVC.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface PlayerWithDefatultControlVC ()

@property (nonatomic, strong) IBOutlet UIView *playerContainerView;
@property (nonatomic, strong) AVPlayerViewController *playerVC;
@property (weak, nonatomic) IBOutlet UILabel *waterMarkLbl;

@end

@implementation PlayerWithDefatultControlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _playerVC           = [[AVPlayerViewController alloc] init];
    _playerVC           = (AVPlayerViewController *)segue.destinationViewController;
    NSURL *videoUrl     = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    _playerVC.player    = [AVPlayer playerWithURL:videoUrl];
    
    _playerVC.player.allowsExternalPlayback                             = YES;
    _playerVC.player.usesExternalPlaybackWhileExternalScreenIsActive    = YES;

    [self performSelector:@selector(showWatermark) withObject:nil afterDelay:3.0];
}

- (void)showWatermark {
    if (_playerVC.contentOverlayView.subviews.count == 0) {
        [self.view bringSubviewToFront:_waterMarkLbl];
        UILabel *waterMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 150, 200, 70)];
        waterMarkLabel.text = @"Player Watermark";
        [waterMarkLabel sizeToFit];
        waterMarkLabel.textColor = [UIColor whiteColor];
        [_playerVC.contentOverlayView addSubview:waterMarkLabel];
    }
}

@end
