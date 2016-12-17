//
//  BitrateListVC.swift
//  MixMachDemo
//
//  Created by Deepak on 22/10/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

import UIKit
/*!
	@protocol	BitrateListDelegate
	@abstract	A protocol for delegates of BitrateListVC.
 */

@objc protocol BitrateListDelegate {
    func selected(bitrate :Bitrate)
}

class BitrateListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: BitrateListDelegate?
    var bitRates = [Bitrate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bitRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AudioTrackCell
        cell.trackName.text = (bitRates[indexPath.row] as Bitrate).birtateTitle
        cell.accessoryType  = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let lastSelectedCell = tableView.cellForRow(at: tableView.indexPathForSelectedRow)
        let selectedCell            = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .checkmark
        delegate?.selected(bitrate: bitRates[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
}
