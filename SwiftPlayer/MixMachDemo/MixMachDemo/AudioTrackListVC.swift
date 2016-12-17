//
//  AudioTrackListVC.swift
//  MixMachDemo
//
//  Created by Dipak on 10/20/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

import UIKit

/*!
	@protocol	AudioTrackDelegate
	@abstract	A protocol for delegates of AudioTrackListVC.
 */
@objc protocol AudioTrackDelegate {
    func selected(audioTrack track:AudioTrack)
    
}

class AudioTrackListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: AudioTrackDelegate?
    var audioTracks = [AudioTrack]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioTracks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AudioTrackCell
        cell.trackName.text = (audioTracks[indexPath.row] as AudioTrack).displayName
        cell.accessoryType = .none
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let lastSelectedCell = tableView.cellForRow(at: tableView.indexPathForSelectedRow)
        let selectedCell     = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .checkmark
        delegate?.selected(audioTrack:audioTracks[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }

}
