//
//  ViewController.m
//  MixMachDemo
//
//  Created by Deepak on 24/09/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import "ViewController.h"

#import "MixMachDemo-Swift.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "Utility.h"
#import "VideoThumbCollectionViewCell.h"


@class PlayerView;

@interface ViewController () <PlayerViewDelegate, AudioTrackDelegate, BitrateListDelegate>

@property (nonatomic, weak) IBOutlet UISlider *seekBar;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic, weak) IBOutlet UIButton *playPauseButton;
@property (nonatomic, weak) IBOutlet UILabel *currentTime;
@property (nonatomic, weak) IBOutlet UILabel *duration;

@property (nonatomic, weak) IBOutlet UIView *playerContainerView;
@property (nonatomic, weak) IBOutlet UIView *playerContainerSuperView;
@property (nonatomic, weak) IBOutlet PlayerView *player;
@property (nonatomic, weak) IBOutlet UIView *controlsView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, weak) IBOutlet UILabel *waterMarkLbl;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIWindow      *externalWindow;
@property (nonatomic, strong) UIScreen      *externalScreen;
@property (nonatomic, weak) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) NSArray *audioTracks;
@property (nonatomic, strong) NSArray *bitRates;
@property (nonatomic, strong) UIView *externalPlayerView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //  [self.navigationItem setHidesBackButton:YES animated:YES];
  //  [[self navigationController] setNavigationBarHidden:YES animated:YES];
    _seekBar.value              = 0.0;
    _playPauseButton.enabled    = NO;
    _currentTime.text           = @"00:00:00:00";
    _duration.text              = @"00:00:00:00";
    [_controlsView setUserInteractionEnabled:NO];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     NSArray *urls = @[@"https://devimages.apple.com.edgekey.net/samplecode/avfoundationMedia/AVFoundationQueuePlayer_Progressive.mov", @"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",@"https://devimages.apple.com.edgekey.net/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8", @"http://sample.vodobox.com/planete_interdite/planete_interdite_alternat.m3u8",@"https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"];
    
    
    [_player initPlayerWithUrls:urls delegate:self];
    /*NSString *urlString = @"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";
    [_player initPlayerWithUrlString:urlString delegate:self];*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenDidConnect:) name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exteralScreenModeDidChange:) name:UIScreenModeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenDidDisconnect:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenDidDisconnect:) name:UIApplicationWillTerminateNotification object:nil];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:_waterMarkLbl];

    if (_player.isPlayerInitialized) {
        [self setupExternalScreen];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
//    if(_externalWindow) {
//        [self externalScreenDidDisconnect:nil];
//        [self removePlayerLayers];
//    }
//    [_player cleanup];
//    _player = nil;
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenDidDisconnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenModeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"PlayerView"]) {
      /* AVPlayerView *playerVC = (AVPlayerView *)
        segue.destinationViewController;
        
        _playerVC               = [PlayerView new];
        _playerVC.delegate      = self;
        _playerVC.mediaPlayer   = playerVC;
        NSString *url           = @"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";
        [_playerVC initPlayerWithUrlString:url];*/

    } else if ([segue.identifier isEqualToString:@"AudioTrackListVC"]) {
        
        AudioTrackListVC *audioTrackVC = (AudioTrackListVC *)
        segue.destinationViewController;
        audioTrackVC.audioTracks = _audioTracks;
        audioTrackVC.delegate      = self;
    } else if ([segue.identifier isEqualToString:@"BitrateListVC"]) {
        [_player pause];
        BitrateListVC *bitrateListVC = (BitrateListVC *)
        segue.destinationViewController;
        bitrateListVC.bitRates = _bitRates;
        bitrateListVC.delegate = self;
    }
}

- (void)dealloc
{
    NSLog(@"Dealloc called....");
   /* _externalWindow = nil;
    _externalScreen = nil;
    _player         = nil;
    _playerLayer    = nil;
    _playerContainerView = nil;
    _playerContainerSuperView = nil;*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackButtonAction:(id)sender {
    NSLog(@"back button pressed....");
    return;
    ((UIButton *)sender).userInteractionEnabled = NO;
  //  [_player cleanup];
    //_player = nil;
    if(_externalWindow) {
        [self externalScreenDidDisconnect:nil];
        //[self removePlayerLayers];
    }
    //[self performSelector:@selector(popView) withObject:nil afterDelay:8];
}

-(void)popView {
    NSLog(@"popView....");
    [self.navigationController popViewControllerAnimated:YES];
}

//****************************************************
// MARK: - Private Methods
//****************************************************


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

-(void)externalScreenDidConnect:(NSNotification*)notification
{
    UIScreen *externalScreen = [notification object];
    [self configureExternalScreen:externalScreen];
}

-(void)configureExternalScreen:(UIScreen *)externalScreen
{
    NSLog(@"configureExternalScreen....");
    self.externalScreen = externalScreen;
    if(!_externalWindow) {
        _externalWindow = [[UIWindow alloc] initWithFrame:[self.externalScreen bounds]];
    }
    [_externalWindow setHidden:NO];
    
    [[_externalWindow layer] setContentsGravity:AVLayerVideoGravityResizeAspect];
    [_externalWindow setScreen:self.externalScreen];
    [[_externalWindow screen] setOverscanCompensation:UIScreenOverscanCompensationScale];
    
    
    [_playerContainerView setFrame:[_externalWindow bounds]];
    // [_externalWindow addSubview:_playerContainerView];
    [self configurePlayerForExternalDisplay];

    [_playerContainerView updateConstraintsIfNeeded];
    [_playerContainerView setNeedsLayout];
    [_playerContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    for(NSLayoutConstraint *c in _playerContainerSuperView.constraints)
    {
        if(c.firstItem == _playerContainerView || c.secondItem == _playerContainerView) {
            [_playerContainerSuperView removeConstraint:c];
        }
    }
    [_externalWindow makeKeyAndVisible];
}


-(void)externalScreenDidDisconnect:(NSNotification*)notification
{
    NSLog(@"externalScreenDidDisconnect....");
    _player.hidden = NO;
    [_playerContainerView setFrame:[_playerContainerSuperView bounds]];
    _playerLayer.frame = _playerContainerView.bounds;
    [_playerContainerSuperView addSubview:_playerContainerView];

    [_playerContainerView updateConstraintsIfNeeded];
    [_playerContainerView setNeedsLayout];
    [_playerContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    if(_externalWindow)
    {
        self.externalScreen = nil;
        [self removeSubviews:_externalWindow];
        [_externalWindow setHidden:YES];
        [_externalWindow resignKeyWindow];
    }
    _externalWindow = nil;
    [self.view bringSubviewToFront:_waterMarkLbl];
}

-(void)exteralScreenModeDidChange:(NSNotification*)notification
{
}

-(void)configurePlayerForExternalDisplay {
    NSLog(@"sublayers.count----:%ld",_playerContainerView.layer.sublayers.count);

    _playerLayer        = _player.playerLayer;
    _playerLayer.frame  = [_externalWindow bounds];
    [_playerLayer setContentsGravity:kCAGravityResizeAspect];
   // _externalPlayerView  = [[UIView alloc] initWithFrame:_externalWindow.frame];
  // [_externalPlayerView.layer addSublayer:_playerLayer];
   // [_playerContainerView.layer addSublayer:_externalPlayerView.layer];
    //[_playerContainerView addSubview:_externalPlayerView];

    [_playerLayer removeFromSuperlayer];
   [_playerContainerView.layer insertSublayer:_playerLayer atIndex:0];

   _player.hidden = YES;
    [_externalWindow addSubview:_playerContainerView];
   // [self performSelector:@selector(movePlayerOnTop) withObject:nil afterDelay:3];
}

-(void)removePlayerLayers
{
    for(CALayer __strong *layer in _playerLayer.sublayers) {
        NSLog(@"layer----:%@",layer);
        [layer removeFromSuperlayer];
        layer = nil;
    }
    
    [_playerLayer removeFromSuperlayer];
    _playerLayer.sublayers = nil;
    _playerLayer = nil;
}

-(void)removeSubviews:(UIView *)view {
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    // Return if there are no subviews
    if ([subviews count] == 0) return;
    
    for (UIView __strong *subview in subviews) {
        NSLog(@"++++++++view:%@",subview);
        [subview removeFromSuperview];
        subview = nil;
    }
}

- (void)movePlayerOnTop {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_player movePlayerOnTopAndUpdateWithFrame:_externalWindow.frame];
    });

}
//****************************************************
// MARK: - PlayerViewDelegate Methods
//****************************************************

- (void)playerTimeUpdateWithTime:(double)time {
    self.seekBar.value  = time;
    _currentTime.text   = [_player getTimeCodeFromSeondsWithTime:time];
}

- (void)playerReadyToPlay {
    NSLog(@"playerReadyToPlay....");
    self.seekBar.maximumValue   = _player.durationInSeconds;
    _playPauseButton.enabled    = YES;
    _duration.text              = [_player getTimeCodeFromSeondsWithTime:_player.durationInSeconds];
    [_controlsView setUserInteractionEnabled:YES];
    [_loadingIndicator stopAnimating];
    
    _audioTracks                = [_player getAudioTracks];

    if (!_bitRates) {
        NSString *fileName      = @"test";
        NSString* path          = [[NSBundle mainBundle] pathForResource:fileName ofType:@"m3u8"];
        //Then loading the content into a NSString is even easier.
        NSString *m3u8String    = [NSString stringWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:NULL];
        _bitRates               = [[Utility getBitratesFromM3u8:m3u8String withURL:nil] mutableCopy];
    }
}

- (void)playerFrameRateChangedWithFrameRate:(float)frameRate {
    
    if (frameRate == 0) {
        _playPauseButton.selected = NO;
    } else {
        _playPauseButton.selected = YES;

    }
}

- (void)buffering
{
    NSLog(@"buffering.....");
    [_controlsView setUserInteractionEnabled:NO];
    [_loadingIndicator startAnimating];
    //[_playerVC pause];
}

- (void)bufferingFinsihed
{
    NSLog(@"bufferingFinsihed.....");
    [_controlsView setUserInteractionEnabled:YES];
    [_loadingIndicator stopAnimating];
    //[_playerVC play];
}

- (void)allAssetsLoaded {
    [self.collectionView reloadData];
}
//****************************************************
// MARK: - Action Methods
//****************************************************

- (IBAction)seekBarValueChanged:(UISlider *)sender {
    [_player seekTo:sender.value completionHandler:nil];
}

- (IBAction)playPause:(UIButton *)sender {
    [_player playPause];
    //sender.selected = !sender.selected;
}

- (IBAction)moveToPreviousFrame:(id)sender {
    [_player pause];
    [_player stepFramesByCount:-1];
}

- (IBAction)moveToNextFrame:(id)sender {
    [_player pause];
    [_player stepFramesByCount:1];
}

- (IBAction)moveBackwordBySec:(id)sender {
    [_player pause];
    [_player stepSecondsByCount:-1];
}

- (IBAction)moveForwordBySec:(id)sender {
    [_player pause];
    [_player stepSecondsByCount:1];
}


- (IBAction)revsersePlayback:(id)sender {
    [_player playReverse];
}

- (IBAction)fastForward:(id)sender {
    [_player playForward];
}

//****************************************************
// MARK: - AudioTrackDelegate Method
//****************************************************

- (void)selectedWithAudioTrack:(AudioTrack *)track {
    [_player switchToSelectedWithAudioTrack:track];
}

//****************************************************
// MARK: - BitrateListDelegate Method
//****************************************************


-(void)selectedWithBitrate:(Bitrate *)bitrate {
    [_player switchToSelectedWithBitRate:bitrate];
}

//****************************************************
// MARK: - UICollectionViewDelegate Method
//****************************************************

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _player.playerItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoThumbCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoThumbCollectionViewCell" forIndexPath:indexPath];
    if (_player.currentItemIndex == indexPath.item) {
        cell.titleLabel.backgroundColor = [UIColor blueColor];
    } else {
        cell.titleLabel.backgroundColor = [UIColor lightGrayColor];
    }
    [cell.titleLabel setText:[NSString stringWithFormat:@"Asset %ld", (long)indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_player replaceCurrentItemWithSelectedItemWithItemAtIndex:indexPath.item];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 50);
}
@end
