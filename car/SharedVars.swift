//
//  SharedVars.swift
//  car
//
//  Created by Zhiyun Ren on 5/7/16.
//  Copyright © 2016 Zhiyun Ren. All rights reserved.
//
import UIKit
import Foundation
class SharedVars {
    static var hasIP = false
    static var ip: String = ""
    
    static func assignIP(label:UILabel!, ip: String){
        label.text = ip
        hasIP = true
        print(ip)
    }
    static func assignTimeStamp(label:UILabel!, timestamp: String){
        label.text = timestamp
        print(timestamp)
    }
}