//
//  Util.swift
//  ClearBC
//
//  Created by Dipak on 12/5/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

import Foundation

/**
 Print Log only in debug mode with Class Name, Function name, Line number and your log message
 */

func DLog(_ message: String, filename: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if !NDEBUG
        NSLog("[\((filename as NSString).lastPathComponent):\(line)] \(function) -: \(message)")
    #endif
}
