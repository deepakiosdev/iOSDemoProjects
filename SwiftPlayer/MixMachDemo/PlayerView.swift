//
//  PlayerView.swift
//  Mix-MachSwiftProject
//
//  Created by Deepak on 24/09/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

/*
	KVO context used to differentiate KVO callbacks for this class versus other
	classes in its class hierarchy.
 */
private var PlayerViewKVOContext  = 0

/*!
	@protocol	PlayerViewDelegate
	@abstract	A protocol for delegates of PlayerView.
 */
@objc protocol PlayerViewDelegate {
    func playerTimeUpdate(time:Double)
    func playerReadyToPlay()
    func playerFrameRateChanged(frameRate:Float)
    func buffering()
    func bufferingFinsihed()
    func allAssetsLoaded()

}


class PlayerView: UIView, AVAssetResourceLoaderDelegate {
    
    //****************************************************
    // MARK: - Properties
    //****************************************************
    
    //MARK: - Constants
    let customScheme            = "cspum3u8"
    let bufferResume: CGFloat   = 5.0
    
    // Attempt to load and test these asset keys before playing
    let assetKeysRequiredToPlay = [
        "playable",
        "hasProtectedContent"
    ]
    
    //MARK: - Variables
    private var timeObserverToken: Any?
    private weak var delegate: AnyObject?
    var avPlayer: AVPlayerViewController!
    var queuePlayer: AVQueuePlayer!
    var frameRate: Float                = 0.0
    private var playerRate: Float       = 1.0
    var isPlayerInitialized     = false
    private var isLiveAsset             = false
    
    private var isReplacingCurrentItem  = false
    private var isBitrateSwitching      = false
    
    var curAudioTrack                   = ""
    var availableAudioTracks = [AudioTrack]()
    private var lastPlayBackTime    = 0.0
    var playerItems         = [AVPlayerItem]()
    var currentItemIndex: NSInteger = 0
    private var loadedAssetCount: NSInteger = 0
    private var liveDuration: NSInteger     = 0
    
    
    //MARK: - Computed Properties
    
    ////
    private var currentItem: AVPlayerItem? {
        get {
            return queuePlayer.currentItem
        }
        set {
        }
    }
    
    ////
    var isPlaying: Bool {
        get {
            if (queuePlayer?.rate != 0 && avPlayer.player!.error == nil) {
                return true
            }
            return false
        }
    }
    
    ////
    private var rate: Float {
        get {
            return queuePlayer.rate
        }
        set {
            queuePlayer.rate = newValue
            DLog("Player rate:\(queuePlayer.rate)")
        }
    }
    
    ////
    var currentTime: CMTime {
        guard let currentItem = queuePlayer.currentItem else { return kCMTimeInvalid}
        
        return currentItem.currentTime()
    }
    
    ////
    private(set) var currentTimeInSeconds: Double {
        get {
            return CMTimeGetSeconds(currentTime)
        }
        set {
            seek(to: CGFloat(newValue)) {_ in }
        }
    }
    
    ////
    var duration: CMTime {
        guard let currentItem = queuePlayer.currentItem else { return kCMTimeInvalid }
        
        return currentItem.duration
    }
    
    ////
    var durationInSeconds: Double {
        let time = duration
        
        if CMTIME_IS_INVALID(time) {
            return 0.0
        }
        return CMTimeGetSeconds(time)
    }
    
    ////
    private(set) var playerVolume: Float {
        get {
            return avPlayer.player!.volume
        }
        set {
            avPlayer.player!.volume = newValue
        }
    }
    
    var isMediaInitialized: Bool {
        get {
            if isPlayerInitialized && (CMTIME_IS_VALID(currentTime) && CMTIME_IS_VALID(duration)) {
                return true
            } else {
                return false
            }
        }
    }
    
    var playerLayer: AVPlayerLayer? {
        get {
            return getAVPlayerLayerFrom(playerView: avPlayer.view)
        }
    }
    
    //****************************************************
    // MARK: - Life Cycle Methods
    //****************************************************
    
    // MARK: Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPlayer()
    }
    
    deinit {
        DLog("PlayerView deinit.....")
        cleanup()
    }
    
    //****************************************************
    //MARK: - Priavate methods
    //****************************************************
    
    private func setupPlayer() {
        
        playerRate                      = 1.0
        queuePlayer                     = AVQueuePlayer()
        avPlayer                        = AVPlayerViewController()
        avPlayer.showsPlaybackControls  = false
        avPlayer.player                 = queuePlayer
        avPlayer.videoGravity           = AVLayerVideoGravityResizeAspect
        avPlayer.view.frame             = self.bounds
        avPlayer.player?.isClosedCaptionDisplayEnabled  = true
        avPlayer.view.isUserInteractionEnabled          = false
        addSubview(avPlayer.view)
        // NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: currentItem)
    }
    
    private func prepareToPlay() {
        currentItem = self.playerItems[currentItemIndex]
        frameRate   = getAssetFrameRate()
        currentItem?.seek(to: kCMTimeZero)
    }
    
    private func resetPlayer() {
        DLog("Reset Player")
        //removeObservers()
        stop()
        frameRate               = 25
        currentItemIndex        = 0
        self.loadedAssetCount   = 0
        playerItems.removeAll()
        queuePlayer.removeAllItems()
        currentItem = nil
    }
    
    @objc private func playerDidFinishPlaying(note: NSNotification) {
        
        if (playerItems.count > currentItemIndex + 1) {
            currentItemIndex += 1
            playSelectedItem(atIndex: currentItemIndex)
        } else if (currentItemIndex == playerItems.count - 1) {
            playerRate              = 0.0
            currentTimeInSeconds    = 0.0
            currentItemIndex        = 0
            playSelectedItem(atIndex: currentItemIndex)
        }
    }
    
    
    ////
    private func getAVPlayerLayerFrom(playerView: UIView?) -> AVPlayerLayer? {
        
        var playerLayer: AVPlayerLayer? = nil
        // Return if there are no subviews
        guard let subviews = playerView?.subviews else {
            return nil
        }
        
        // Get the subviews of the view
        for subView in subviews
        {
            if subView.layer is AVPlayerLayer {
                playerLayer = subView.layer as? AVPlayerLayer
               playerLayer?.zPosition = 1000

            }
            if playerLayer == nil {
                playerLayer = getAVPlayerLayerFrom(playerView: subView)
            } else {
                return playerLayer
            }
        }
        return playerLayer
    }
    
    public func movePlayerOnTopAndUpdate(frame: CGRect)
    {
       bringPlayerLayerOnTop(playerView: avPlayer.view, frame: frame)
    }
    
    private func bringPlayerLayerOnTop(playerView: UIView?, frame: CGRect)  {
        
        var playerLayer: AVPlayerLayer? = nil
        // Return if there are no subviews
        guard let subviews = playerView?.subviews else {
            return
        }
        
        // Get the subviews of the view
        for subView in subviews
        {
            if subView.layer is AVPlayerLayer {
                playerLayer = subView.layer as? AVPlayerLayer
                playerLayer?.zPosition = 1000
                playerLayer?.frame  = frame
                playerLayer?.contentsGravity = kCAGravityResizeAspect
            }
            if playerLayer == nil {
                bringPlayerLayerOnTop(playerView: subView, frame: frame)
            } else {
                break
                //return playerLayer
            }
        }
       // return playerLayer
    }

    
    private func getAssetFrameRate() -> Float {
        frameRate = 0.0
        
        guard let currentItem = currentItem else {
            frameRate = 25
            return frameRate
        }
        
        for track in currentItem.tracks {
            
            if(track.assetTrack.mediaType == AVMediaTypeVideo) {
                frameRate = track.currentVideoFrameRate
                break
            }
        }
        
        if (frameRate == 0) {
            if let videoTrack = currentItem.asset.tracks(withMediaType: AVMediaTypeVideo).last {
                frameRate = videoTrack.nominalFrameRate
            }
        }
        
        if (frameRate == 0) {
            frameRate = 25.0
        }
        DLog("frameRate:\(frameRate)")
        
        return frameRate
    }
    
    private func asynchronouslyLoadURLAsset(_ newAsset: AVURLAsset) {
        
        newAsset.loadValuesAsynchronously(forKeys: assetKeysRequiredToPlay) {
            
            DispatchQueue.main.async {
                self.loadedAssetCount += 1
                
                /*
                 Test whether the values of each of the keys we need have been
                 successfully loaded.
                 */
                for key in self.assetKeysRequiredToPlay {
                    var error: NSError?
                    
                    if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
                        let stringFormat = NSLocalizedString("error.asset_key_%@_failed.description", comment: "Can't use this AVAsset because one of it's keys failed to load")
                        
                        let message = String.localizedStringWithFormat(stringFormat, key)
                        self.handleErrorWithMessage(message, error: error)
                        return
                    }
                }
                
                // We can't play this asset.
                if !newAsset.isPlayable || newAsset.hasProtectedContent {
                    let message = NSLocalizedString("error.asset_not_playable.description", comment: "Can't use this AVAsset because it isn't playable or has protected content")
                    
                    self.handleErrorWithMessage(message)
                    return
                }
                
                /*
                 We can play this asset. Create a new `AVPlayerItem` and make
                 it our player's current item.
                 */
                if (self.isBitrateSwitching) {
                    self.currentItem = AVPlayerItem(asset: newAsset)
                    self.currentTimeInSeconds = self.lastPlayBackTime
                }
                
                DLog("Key loaded for asset:\(newAsset)")
                if (self.loadedAssetCount == 1) {
                    self.addObservers()
                }
                
                if (newAsset === self.playerItems[0].asset) {
                    self.prepareToPlay()
                }
                
                if (self.loadedAssetCount == self.playerItems.count) {
                    self.delegate?.allAssetsLoaded()
                }
            }
        }
    }
    
    private func addPlayerPeriodicTimeObserver() {
        // Only add the time observer if one hasn't been created yet.
        guard timeObserverToken == nil else { return }
        let frame = 1.0/frameRate
        // Make sure we don't have a strong reference cycle by only capturing self as weak.
        let interval        = CMTimeMakeWithSeconds(Float64(frame), Int32(NSEC_PER_SEC))
        timeObserverToken   = queuePlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [unowned self] time in
            if let delegate = self.delegate, delegate.responds(to: #selector(PlayerViewDelegate.playerTimeUpdate(time:))) {
                self.delegate?.playerTimeUpdate(time:self.currentTimeInSeconds)
            }
        }
    }
    
    private func removePlayerPeriodicTimeObserver() {
        
        if let timeObserverToken = timeObserverToken {
            queuePlayer.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    private func addObservers() {
        
        //Remove previous observers before adding new
      //  removeObservers()
        
        // Register as an observer of the player item's status property
        addObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.currentItem.playbackLikelyToKeepUp), options: [.old, .new], context: &PlayerViewKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.currentItem.playbackBufferEmpty), options: [.old, .new], context: &PlayerViewKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.currentItem.loadedTimeRanges), options: [.old, .new], context: &PlayerViewKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.currentItem.status), options: [.old, .new], context: &PlayerViewKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.currentItem.duration), options: [.old, .new], context: &PlayerViewKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.rate), options: [.old, .new], context: &PlayerViewKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.currentItem),
         options: [.old, .new], context: &PlayerViewKVOContext)
    }
    
    private func removeObservers() {
        DLog("Removing Observers.....")
        
        guard (self.loadedAssetCount > 0) && avPlayer?.player != nil else {
            DLog("Observers can not be removed.....")
            return
        }
        
        /*if !isPlayerInitialized {
          return
        }*/
        
        
        removeObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.currentItem.playbackLikelyToKeepUp), context: &PlayerViewKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.currentItem.playbackBufferEmpty), context: &PlayerViewKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.currentItem.loadedTimeRanges), context: &PlayerViewKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.currentItem.duration), context: &PlayerViewKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.currentItem.status), context: &PlayerViewKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.rate), context: &PlayerViewKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerView.avPlayer.player.currentItem), context: &PlayerViewKVOContext)

        DLog("Observers removed.....")
       // CMCache.removeSubDirectory("cache_m3u8")
    }
    
    
    // MARK: - Error Handling
    private func handleErrorWithMessage(_ message: String?, error: Error? = nil) {
        DLog("Player Error occured with message: \(message), error: \(error).")
    }
    
    //****************************************************
    // MARK: - Internal/Public methods
    //****************************************************
    
    func initPlayer(urlString : String?, delegate: AnyObject) {
        var urlString = urlString
        
        if urlString == nil {
            urlString = ""
        }
        
        initPlayer(urls: [urlString!], delegate: delegate)
    }
    
    func initPlayer(urls: [String], delegate: AnyObject) {
        
        self.delegate = delegate
        resetPlayer()
       // addObservers()
        let headers : [String: String] = ["User-Agent": "iPad"]
        
        for urlStr in urls {
            var urlString = urlStr
            
           /* if ((urlString.range(of: ".m3u8") != nil) && (urlString.range(of:"isml") == nil)) {
                urlString = urlString.replacingOccurrences(of:"http", with:customScheme)
            }*/
            DLog("Player URL:\(urlString)")
            let assetUrl = URL.init(string: urlString)!
            let urlAsset = AVURLAsset(url: assetUrl, options: ["AVURLAssetHTTPHeaderFieldsKey":headers])
            
            urlAsset.resourceLoader.setDelegate(self, queue:DispatchQueue.main)
            let playerItem = AVPlayerItem(asset: urlAsset)
            self.playerItems.append(playerItem)
            DLog("playerItem:\(playerItem)")
            if (queuePlayer.canInsert(playerItem, after: nil)) {
                queuePlayer.insert(playerItem, after: nil)
            }
            asynchronouslyLoadURLAsset(urlAsset)
        }
    }
    
    func cleanup() {
        DLog("PlayerView clean up")
        delegate = nil
        removeObservers()
        resetPlayer()
        // NotificationCenter.default.removeObserver(self)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        // DLog("keyPath:\(keyPath), change:\(change)")
        
        // Only handle observations for the PlayerViewKVOContext
        guard context == &PlayerViewKVOContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == #keyPath(PlayerView.avPlayer.player.currentItem.status) {
            let newStatus: AVPlayerItemStatus
            
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
            }
            else {
                newStatus = .unknown
            }
            
            if newStatus == .failed {
                DLog("Player Status: Failed to Play....Tag:\(tag)")
                self.handleErrorWithMessage(avPlayer.player?.currentItem?.error?.localizedDescription)
                
//                if let delegate = delegate, delegate.responds(to: #selector(CBCRCPlayerDelegate.playerInitializationFailed(_:))) {
//                    delegate.playerInitializationFailed!(tag)
//                    
//                }
            }
            else if newStatus == .readyToPlay {
                
                if let asset = avPlayer.player?.currentItem?.asset {
                    
                    /*
                     First test whether the values of `assetKeysRequiredToPlay` we need
                     have been successfully loaded.
                     */
                    for key in assetKeysRequiredToPlay {
                        var error: NSError?
                        if asset.statusOfValue(forKey: key, error: &error) == .failed {
                            DLog("Player Status: Asset's key is not loaded....Tag:\(tag)")
                            
                            self.handleErrorWithMessage(avPlayer.player?.currentItem?.error?.localizedDescription)
                            return
                        }
                    }
                    
                    if !asset.isPlayable || asset.hasProtectedContent {
                        // We can't play this asset.
                        self.handleErrorWithMessage(avPlayer.player?.currentItem?.error?.localizedDescription)
                        return
                    }
                    DLog("Player Status: Ready to Play....Tag:\(tag)")
                    
                    /*
                     The player item is ready to play,
                     */
                    if (self.isBitrateSwitching) {
                        self.isBitrateSwitching = false
                        self.play()
                    }
                    
                    if (!isPlayerInitialized) {
                        self.isPlayerInitialized = true
                        addPlayerPeriodicTimeObserver()
                        self.delegate?.playerReadyToPlay()

                       /* if let delegate = delegate, delegate.responds(to: #selector(CBCRCPlayerDelegate.playerInitialised(_:))) {
                            delegate.playerInitialised!(tag)
                        }*/
                    }
                }
            }
        } else if keyPath == #keyPath(PlayerView.avPlayer.player.currentItem.duration) {
            
        }
        else if keyPath == #keyPath(PlayerView.avPlayer.player.rate) {
            DLog("Player Status: Rate Changed....Rate:\(rate), Tag:\(tag)")
            
            // Update playPauseButton type.
            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).floatValue
            self.delegate?.playerFrameRateChanged(frameRate: newRate)
        }
        else if keyPath == #keyPath(PlayerView.avPlayer.player.currentItem.playbackLikelyToKeepUp) {
            DLog("Player Status: Buffering finished....Tag:\(tag)")
            self.delegate?.bufferingFinsihed()
            /*if (isAutoPlay) {
                self.rate = self.previousRate
            }*/
    
        }
        else if keyPath == #keyPath(PlayerView.avPlayer.player.currentItem.playbackBufferEmpty) {
            DLog("Player Status: Buffering....Tag:\(tag)")
            self.delegate?.buffering()

           /* if let delegate = delegate, delegate.responds(to: #selector(CBCRCPlayerDelegate.playerDidPause(_:))) {
                delegate.playerDidPause!(tag)
            }*/
            
        }
        else if keyPath == #keyPath(PlayerView.avPlayer.player.currentItem.loadedTimeRanges) {
            
            if let timeRanges = change?[NSKeyValueChangeKey.newKey] as? [AnyObject] {
                if (timeRanges.count > 0) {
                    let timerange:CMTimeRange   = timeRanges[0].timeRangeValue
                    let bufferedTime: CGFloat   = CGFloat(CMTimeGetSeconds(CMTimeAdd(timerange.start, timerange.duration)))
                    
                    let currentTime = CGFloat(self.currentTimeInSeconds)
                    
                    if (((bufferedTime - currentTime > bufferResume) || (bufferedTime == currentTime))) {
                        //DLog("Player Status: Buffering finished....")
                        self.delegate?.bufferingFinsihed()
                        /*if (isAutoPlay) {
                            self.rate = self.previousRate
                        }*/
                    }
                }
            }
        }
        else if keyPath == #keyPath(PlayerView.avPlayer.player.currentItem) {
            
            DLog("Player Status: Current Item Changed....Tag:\(tag)")
            if queuePlayer.rate == -1.0 {
                return
            }
            
            if queuePlayer.items().isEmpty {
                DLog("Play queue emptied out due to bad player item. End looping,Tag:\(tag)")
            }
            else {
                let newItem = change?[NSKeyValueChangeKey.newKey] as? AVPlayerItem
                let oldItem = change?[NSKeyValueChangeKey.oldKey] as? AVPlayerItem
                DLog("\ncurrentItem-------:\(avPlayer.player?.currentItem)")
                DLog("newItem-------:\(newItem)")
                DLog("oldItem-------:\(oldItem)\n")
                if ( newItem != nil && oldItem != nil && (newItem != oldItem)) {
                    self.advanceToNextItem()
                }
            }
        }
    }
    
    func playPause() {
        if (isPlaying) {
            pause()
        } else {
            play()
        }
    }
    
    func play() {
        queuePlayer.rate = playerRate
    }
    
    func pause() {
        queuePlayer.pause()
    }
    
    func stop() {
        pause()
        currentTimeInSeconds    = 0.0
        playerRate              = 1.0
        isPlayerInitialized     = false
        removePlayerPeriodicTimeObserver()
    }
    
    func seek(to time: CGFloat, completionHandler: ((Bool) -> Swift.Void)?) {
        if let currentItem = currentItem {
            let cmTime = CMTimeMakeWithSeconds(Float64(time), currentItem.currentTime().timescale)
            seek(toCMTime: cmTime, completionHandler: { (finished) in
                completionHandler?(finished)
            })
        } else {
            completionHandler?(false)
        }
    }
    
    func seek(toTimeCode time: String, completionHandler: ((Bool) -> Swift.Void)?) {
        
        if time.isEmpty {
            completionHandler?(false)
        } else {
          //  let seconds = getTimeCodeFromSeonds(time: 0.0)
            seek(to: 0.0, completionHandler: { (finished) in
                completionHandler?(false)
            })
        }
    }
    
    func seek(toCMTime time: CMTime, completionHandler: ((Bool) -> Swift.Void)?) {
       
        if self.queuePlayer.currentItem?.status == .readyToPlay && CMTIME_IS_VALID(time) && currentItem != nil {
            
            self.queuePlayer.currentItem?.cancelPendingSeeks()
            self.queuePlayer.seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: { (finished) in
                completionHandler?(finished)
            })
        } else {
            completionHandler?(false)
        }
    }
    
    // TODO: For |reversePlayback| and |fastForwardPlayback| put check canPlayFastForward, canPlaySlowForward, canPlayReverse etc... and make a single method
    func playReverse() {
        // Rewind no faster than -4.0.
        var playerRate = max(rate - 1, -4.0)
        if (playerRate == 0) {
            playerRate = -1.0
        }
        playFromRate(playerRate: playerRate)
    }
    
    func playForward() {
        //Fast forward no faster than 4.0.
        var playerRate = min(rate + 1.0, 4.0)
        if (playerRate == 0) {
            playerRate = 1.0
        }
        playFromRate(playerRate: playerRate)
    }
    
    func playFromRate(playerRate: Float) {
        if rate != playerRate {
            rate = playerRate
        }
    }
    
    func setPlaybackRate(_ rate: Float) {
        if self.playerRate != rate {
            self.playerRate = rate
        }
    }
    
    func playSelectedItem(atIndex selectedIndex: NSInteger) {
        
        if playerItems.count > 0 {
            stop()
            queuePlayer.removeAllItems()
            currentItem = playerItems[selectedIndex]
            if (currentItem != nil && queuePlayer.canInsert(currentItem!, after: nil)) {
                queuePlayer.insert(currentItem!, after: nil)
                currentItemIndex = selectedIndex
            }
        }
    }
    
    func advanceToNextItem() {
        DLog("advanceToNextItem....")
        currentItemIndex += 1
        //queuePlayer.advanceToNextItem()
    }
    
    func replaceCurrentItemWithSelectedItem(itemAtIndex: NSInteger) {
        DLog("Replace item at index:\(itemAtIndex)")
        isReplacingCurrentItem = true
        currentItemIndex    = itemAtIndex
        currentItem         = playerItems[currentItemIndex]
        self.queuePlayer.replaceCurrentItem(with: currentItem)
        isReplacingCurrentItem = false
    }
    
    /*
     * |numberOfFrame| +ve value represent move forward and -ve represent move backwoard
     */
    func stepFrames(byCount numberOfFrame: Int) {
        currentItem?.cancelPendingSeeks()
        var frameCount = numberOfFrame
        
        if frameCount == 0 {
            frameCount = -1
        }
        
        let secondsFromFrame    = Float(frameCount)/frameRate
        currentTimeInSeconds    += Double(secondsFromFrame)
    }
    
    func stepSeconds(byCount numberOfSecond: Int64) {
        currentItem?.cancelPendingSeeks()
        currentTimeInSeconds += Double(numberOfSecond)
    }
    
    //Determine the total duration for nonlive Asset. For live pass the current time as the max value for slider...
    func getLiveAssetDuration ()-> NSInteger {
        
        let totalDuration = NSInteger(ceilf(Float(currentTimeInSeconds)))
        
        if (self.liveDuration < totalDuration ) {
            self.liveDuration = totalDuration
            return totalDuration
        } else {
            return self.liveDuration
        }
    }
    
    func setLiveAsset(isLive: Bool) {
        isLiveAsset = isLive
    }
    
    func isUrlLiveStreaming(_ url: URL)-> Bool {
        let urlString = url.absoluteString
        return (urlString.range(of:"m3u8", options:.caseInsensitive) != nil)
    }
    
    ////////////////////////////
    
    
    public func getTimeCodeFromSeonds(time: Float) -> String {
        
        let sec             = Int(time) % 60
        let min             = (Int(time)/60) % 60
        let hours           = (Int(time)/3600) % 60
        let currentTime     = CMTimeMakeWithSeconds(Float64(time), Int32(frameRate))
        let currentTimeF    = CMTimeConvertScale(currentTime, Int32(frameRate), CMTimeRoundingMethod.default)
        let frame           = fmodf(Float(currentTimeF.value), Float(frameRate))
        let timeString      = String(format: "%02d:%02d:%02d:%02d", hours, min, sec, Int(frame))
        return timeString
    }
    
    public func getAudioTracks()-> [AudioTrack] {
        
        let urlAsset = playerItems[currentItemIndex].asset
        var audioTracks = [AudioTrack]()
        let audio: AVMediaSelectionGroup? = urlAsset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristicAudible)
        
        if let options = audio?.options {
            for index in 0..<options.count {
                let option: AVMediaSelectionOption = audio!.options[index]
                var displayName = Utility.getLanguageName(fromLanguageCode: option.displayName)
                
                if(displayName?.caseInsensitiveCompare("Track") == ComparisonResult.orderedSame) {
                    displayName = "Track \(index + 1)"
                }
                
                if index == 0 {
                    curAudioTrack = displayName!
                }
                
                let track = AudioTrack ()
                track.displayName = displayName!
                track.isAssetTrack = false
                audioTracks.append(track)
            }
            
            if(!audioTracks.isEmpty) {
                availableAudioTracks = audioTracks
                return availableAudioTracks
            }
        }
        
        //if let options = urlAsset.tracks(withMediaType: AVMediaTypeAudio) {
           let options = urlAsset.tracks(withMediaType: AVMediaTypeAudio)
            for index in 0..<options.count {
                let option = options [index]
                var displayName = Utility.getLanguageName(fromLanguageCode: option.languageCode)
                
                if(displayName?.caseInsensitiveCompare("Track") == ComparisonResult.orderedSame) {
                    displayName = "Track \(index + 1)"
                }
                
                if index == 0 {
                    curAudioTrack = displayName!
                }
                
                let track = AudioTrack ()
                track.displayName = displayName!
                track.isAssetTrack = true
                audioTracks.append(track)
            }
            if(!audioTracks.isEmpty) {
                availableAudioTracks = audioTracks
            }
      //  }
        return audioTracks
    }
    
    func switchToSelected(audioTrack track: AudioTrack) {
        
        self.pause()
        let urlAsset = playerItems[currentItemIndex].asset

        let audioTracks: AVMediaSelectionGroup? = urlAsset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristicAudible)
        
        if let audios = audioTracks?.options {
            for index in 0..<audios.count {
                let audioTrack: AVMediaSelectionOption = audios[index]
                
                var displayName = Utility.getLanguageName(fromLanguageCode: audioTrack.displayName)
                
                if(displayName?.caseInsensitiveCompare("Track") == ComparisonResult.orderedSame) {
                    displayName = "Track \(index + 1)"
                }
                
                if(displayName?.caseInsensitiveCompare(track.displayName) == ComparisonResult.orderedSame) {
                    curAudioTrack = track.displayName
                    
                    DispatchQueue.main.async {
                        self.currentItem?.select(audioTrack, in: audioTracks!)
                        self.play()
                        
                    }
                }
            }
        }
        
       // if let audioTracks = urlAsset?.tracks(withMediaType: AVMediaTypeAudio) {
        let tracks = urlAsset.tracks(withMediaType: AVMediaTypeAudio)
            for index in 0..<tracks.count {
                let audioTrack = tracks [index]
                var displayName = Utility.getLanguageName(fromLanguageCode: audioTrack.languageCode)
                
                if(displayName?.caseInsensitiveCompare("Track") == ComparisonResult.orderedSame) {
                    displayName = "Track \(index + 1)"
                }
                
                if(displayName?.caseInsensitiveCompare(track.displayName) == ComparisonResult.orderedSame) {
                    curAudioTrack = track.displayName
                    
                    var allAudioParams = [AVMutableAudioMixInputParameters]()
                    
                    for audTrack: AVAssetTrack in tracks {
                        var trackVolume: Float = 0.0
                        if (audioTrack == audTrack) {
                            trackVolume = 1.0
                        }
                        let audioInputParams = AVMutableAudioMixInputParameters(track: audTrack)
                        audioInputParams.setVolume(trackVolume, at: kCMTimeZero)
                        allAudioParams.append(audioInputParams)
                        
                    }
                    
                    let audioMix = AVMutableAudioMix()
                    audioMix.inputParameters = allAudioParams
                    DispatchQueue.main.async {
                        self.currentItem?.audioMix = audioMix
                        self.play()
                    }
                    return
                }
            }
        //}
    }
    
    func switchToSelected(bitRate: Bitrate) {
        isBitrateSwitching = true
        removePlayerPeriodicTimeObserver()
        pause()
        lastPlayBackTime = currentTimeInSeconds
        let url     = URL.init(string: bitRate.url)!
        print("Selected bitrate url:\(url)")
        let headers : [String: String] = ["User-Agent": "iPad"]
        let urlAsset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey":headers])
        urlAsset.resourceLoader.setDelegate(self, queue:DispatchQueue.main)
        let playerItem = AVPlayerItem(asset: urlAsset)
        
        self.queuePlayer.replaceCurrentItem(with: playerItem)
        self.asynchronouslyLoadURLAsset(urlAsset)
        //        DispatchQueue.main.async {
        //            self.queuePlayer.replaceCurrentItem(with: playerItem)
        //             self.asynchronouslyLoadURLAsset(urlAsset)
        //        }
        
    }
    
    public func getPlayerView ()-> UIView {
        return avPlayer.view
    }
    
    //****************************************************
    // MARK: - AVAssetResourceLoaderDelegate methods
    //****************************************************
    
    // FPS Key Fetch for Persistent Keys
    public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool
    {
        /*let scheme = (loadingRequest.request.url?.scheme)! as NSString
        
        if ((scheme.range(of: customScheme).location != NSNotFound))
        {
            let customUrl:NSString? = loadingRequest.request.url?.absoluteString as NSString?
            let urlString = customUrl?.replacingOccurrences(of: customScheme, with: "http") as NSString?
            let playlistUrl: NSString? = (NSURL(string: urlString as! String))?.absoluteString as NSString?
            print("PlaylistUrl:\(playlistUrl)")
            
            NetworkManager().startAsyncDownload(playlistUrl as String!, progress: { (CGFloat) in
                
                }, finished: { (response, errorCode) in
                    // if (errorCode == TRACE_CODE_SUCCESS)
                    if (errorCode == 0)
                    {
                        if (playlistUrl?.range(of: ".ckf").location != NSNotFound) {
                            print("Assest Loader Called........")
                            
                            //                            let strKey = CMServicesUtilities.getStreamDecryptionKey()
                            //                            let responseData = response as! NSData
                            //                            let decryptedKey: NSData = responseData.decryptData(withKey: strKey, mode: true) as NSData
                            //                            loadingRequest.dataRequest?.respond(with: decryptedKey as Data)
                            //                            loadingRequest.finishLoading()
                        }
                        else
                        {
                            let urlComponents:NSURLComponents = NSURLComponents(url: URL.init(string: playlistUrl as! String)!, resolvingAgainstBaseURL: false)!
                            
                            urlComponents.query = nil
                            var baseURL = urlComponents.url?.deletingLastPathComponent().absoluteString
                            let m3u8Str =  NSString(data: response as! Data, encoding: String.Encoding.utf8.rawValue)!
                            if (m3u8Str.range(of: ".m3u8").location != NSNotFound)
                            {
                                let subReplace = "(\"[a-z0-9/:=~._-]*(\\.m3u8))"
                                // var error:NSError? = nil
                                do
                                {
                                    
                                    let regex: NSRegularExpression = try NSRegularExpression(pattern: subReplace, options:NSRegularExpression.Options.caseInsensitive)
                                    regex.replaceMatches(in: m3u8Str as! NSMutableString, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, m3u8Str.length), withTemplate:"\"\(baseURL)^$1^\"")
                                    
                                    m3u8Str.replacingOccurrences(of:"^\"", with:"")
                                    // CMCache.setObject(m3u8Str.data(using: String.Encoding.utf8.rawValue), forKey: playlistUrl?.md5(), withNewPath: "cache_m3u8")
                                    
                                }
                                catch {
                                    print("problem in REG X")
                                }
                            }
                            else
                            {
                                let tsReplace = "([a-z0-9/:~._-]*(\\.ts))"
                                
                                if (m3u8Str.range(of: "http").location == NSNotFound)
                                {
                                    do
                                    {
                                        let regex: NSRegularExpression = try NSRegularExpression(pattern: tsReplace, options:NSRegularExpression.Options.caseInsensitive)
                                        regex.replaceMatches(in: m3u8Str as! NSMutableString, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, m3u8Str.length), withTemplate:"\(baseURL)$1")
                                    }
                                    catch {
                                        print("problem in Segments")
                                    }
                                    
                                    if (m3u8Str.range(of:"key").location == NSNotFound)
                                    {
                                        let ckfReplace = "([a-z0-9/:~._-]*\\.ckf)"
                                        urlComponents.scheme = urlComponents.scheme?.replacingOccurrences(of: "http", with: self.customScheme)
                                        do
                                        {
                                            let regX = try NSRegularExpression(pattern: ckfReplace, options:NSRegularExpression.Options.caseInsensitive)
                                            
                                            baseURL = urlComponents.url?.deletingLastPathComponent().absoluteString
                                            regX.replaceMatches(in: m3u8Str as! NSMutableString, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, m3u8Str.length), withTemplate:"\(baseURL)$1")
                                        }
                                        catch {
                                            print("problem in Segments")
                                        }
                                    }
                                    else {
                                        m3u8Str.replacingOccurrences(of:"key", with:self.customScheme)
                                    }
                                }
                                else {
                                    m3u8Str.replacingOccurrences(of:"key", with:self.customScheme)
                                }
                            }
                            print("m3u8Str....\(m3u8Str)")
                            //For Live Asset Check for ENDLIST flag
                            //
                            //                                                            if ([self.delegate respondsToSelector:@selector(isLiveAssetGrowingProxy:)])
                            //                                                            {
                            //                                                                if([m3u8Str rangeOfString:@"EXT-X-ENDLIST"].location != NSNotFound) {
                            //                                                                    [_delegate isLiveAssetGrowingProxy:NO];
                            //                                                                }
                            //                                                            }
                            let data = m3u8Str.data(using: String.Encoding.utf8.rawValue)
                            loadingRequest.dataRequest?.respond(with: data!)
                            loadingRequest.finishLoading()
                        }
                    }
                    else {
                        print("error in key response\(response)");
                    }
            })
            return true
        }*/
        return false
    }
    
    
    public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForResponseTo authenticationChallenge: URLAuthenticationChallenge) -> Bool {
        let protectionSpace = authenticationChallenge.protectionSpace
        
        if protectionSpace.authenticationMethod ==  NSURLAuthenticationMethodServerTrust {
            
            authenticationChallenge.sender?.use(URLCredential.init(trust: authenticationChallenge.protectionSpace.serverTrust!), for: authenticationChallenge)
            authenticationChallenge.sender?.continueWithoutCredential(for: authenticationChallenge)
            
        }
        return true
    }
}


///////////////Testing Urls////////////////////////
/*
 http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8
 
 let assetUrls = ["https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4","https://devimages.apple.com.edgekey.net/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8","https://devimages.apple.com.edgekey.net/samplecode/avfoundationMedia/AVFoundationQueuePlayer_Progressive.mov", "http://sample.vodobox.com/planete_interdite/planete_interdite_alternate.m3u8","https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"]
 */
