//
//  AVPlayerVC.swift
//  Mix-MachSwiftProject
//
//  Created by Deepak on 24/09/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

@objc class AVPlayerVC: UIViewController, AVAssetResourceLoaderDelegate {
    var player: AVPlayer! // <-- the fix
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if I change m3u8 to different file extension, it's working good
        let url = NSURL(string: "cplp://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")
        
        let asset = AVURLAsset(url: url! as URL, options: nil)
        asset.resourceLoader.setDelegate(self, queue: DispatchQueue(label: "AVARLDelegateDemo loader"))
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem) // <-- the fix
        player.play()
    }
    
    private func resourceLoader(resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        NSLog("This method is never called in case of m3u8 url")
        
        return true
    }
}
