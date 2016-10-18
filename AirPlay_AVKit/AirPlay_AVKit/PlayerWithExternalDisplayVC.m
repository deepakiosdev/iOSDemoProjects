//
//  PlayerWithExternalDisplayVC.m
//  AirPlay_AVKit
//
//  Created by Dipak on 10/18/16.
//  Copyright © 2016 Dipak. All rights reserved.
//

#import "PlayerWithExternalDisplayVC.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerViewController+FullScreen.h"

@interface PlayerWithExternalDisplayVC ()

@property (nonatomic, strong) IBOutlet UIView *playerContainerView;
@property (nonatomic, strong) IBOutlet UIView *playerContainerSuperView;
@property (weak, nonatomic) IBOutlet UIButton *playPauseBtn;
@property (weak, nonatomic) IBOutlet UILabel *waterMarkLbl;

@property (nonatomic, strong) UIWindow                      *externalWindow;
@property (nonatomic, strong) UIScreen                      *externalScreen;
@property (nonatomic, strong) AVPlayerViewController        *playerVC;

@end

@implementation PlayerWithExternalDisplayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setUpPlayer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenDidConnect:) name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exteralScreenModeDidChange:) name:UIScreenModeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenDidDisconnect:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenDidDisconnect:) name:UIApplicationWillTerminateNotification object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_playerVC) {
        [self setupExternalScreen];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self externalScreenDidDisconnect:nil];
    [super viewWillDisappear: animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenDidDisconnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenModeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
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

- (void)setUpPlayer {
    _playerVC           = [[AVPlayerViewController alloc] init];
    NSURL *videoUrl     = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    _playerVC.player    = [AVPlayer playerWithURL:videoUrl];
    _playerVC.view.frame = self.playerContainerView.frame;

    _playerVC.showsPlaybackControls                                     = NO;
    _playerVC.player.allowsExternalPlayback                             = NO;
    _playerVC.player.usesExternalPlaybackWhileExternalScreenIsActive    = NO;

    [_playerContainerView addSubview:_playerVC.view];
    [self performSelector:@selector(showWatermark) withObject:nil afterDelay:3.0];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _playerVC           = [[AVPlayerViewController alloc] init];
    _playerVC           = (AVPlayerViewController *)segue.destinationViewController;
    NSURL *videoUrl     = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    _playerVC.player    = [AVPlayer playerWithURL:videoUrl];
    
    _playerVC.showsPlaybackControls                                     = NO;
    _playerVC.player.allowsExternalPlayback                             = NO;
    _playerVC.player.usesExternalPlaybackWhileExternalScreenIsActive    = NO;
    
    [self performSelector:@selector(showWatermark) withObject:nil afterDelay:3.0];
}



- (void)showWatermark {
    if (_playerVC.contentOverlayView.subviews.count == 0) {
        
        UILabel *waterMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 150, 200, 70)];
        waterMarkLabel.text = @"PFT Copyright Overlay View";
        [waterMarkLabel sizeToFit];
        waterMarkLabel.textColor = [UIColor whiteColor];
        [_playerVC.contentOverlayView addSubview:waterMarkLabel];
        [self.playerContainerView bringSubviewToFront:_waterMarkLbl];
    }
}


#pragma mark - EXternal Display Methods
- (void)setupExternalScreen
{
    // Setup screen mirroring for an existing screen
    NSArray *connectedScreens = [UIScreen screens];
    NSLog(@"connectedScreens count:%lu: ",(unsigned long)connectedScreens.count);
    if ([connectedScreens count] > 1)
    {
        UIScreen *mainScreen = [UIScreen mainScreen];
        for (UIScreen *aScreen in connectedScreens)
        {
            if (aScreen != mainScreen)
            {
                [self configureExternalScreen:aScreen];
                break;
            }
        }
    }
}


-(void)configureExternalScreen:(UIScreen *)externalScreen
{
    NSLog(@"configureExternalScreen....");
    
    self.externalScreen = externalScreen;
   // self.connectedLabel.hidden = NO;
    if(!_externalWindow) {
        _externalWindow = [[UIWindow alloc] initWithFrame:[self.externalScreen bounds]];
    }
    [_externalWindow setHidden:NO];
    
    [[_externalWindow layer] setContentsGravity:kCAGravityResizeAspect];
    [_externalWindow setScreen:self.externalScreen];
    [[_externalWindow screen] setOverscanCompensation:UIScreenOverscanCompensationScale];
    
    [_playerContainerView setFrame:[_externalWindow bounds]];
    [_externalWindow addSubview:_playerContainerView];
    
    [_playerContainerView updateConstraintsIfNeeded];
    [_playerContainerView setNeedsLayout];
    [_playerContainerView setTranslatesAutoresizingMaskIntoConstraints:YES];
    for(NSLayoutConstraint *c in _playerContainerSuperView.constraints)
    {
        if(c.firstItem == _playerContainerView || c.secondItem == _playerContainerView) {
            [_playerContainerSuperView removeConstraint:c];
        }
    }
    
    [_externalWindow makeKeyAndVisible];

    
}

-(void)externalScreenDidConnect:(NSNotification*)notification
{
    UIScreen *externalScreen = [notification object];
    [self configureExternalScreen:externalScreen];
}

-(void)externalScreenDidDisconnect:(NSNotification*)notification
{
    NSLog(@"externalScreenDidDisconnect....");
   // self.connectedLabel.hidden = YES;
    [_playerContainerView setFrame:[_playerContainerSuperView bounds]];
    [_playerContainerSuperView addSubview:_playerContainerView];
    
    [_playerContainerView updateConstraintsIfNeeded];
    [_playerContainerView setNeedsLayout];
    [_playerContainerView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    if(_externalWindow)
    {
        self.externalScreen = nil;
        [_externalWindow setHidden:YES];
        [_externalWindow resignKeyWindow];
    }
    _externalWindow = nil;
    
}

-(void)exteralScreenModeDidChange:(NSNotification*)notification
{
}

@end
