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
    static var hasIP: Bool = false
    static var ip: String = ""
    static var client:TCPClient = TCPClient(addr: "", port: 8765)
    static var connected = false
    static var stringBuffer = ""
    
    static func assignIP(label:UILabel!, statusLabel:UILabel!, ip: String, button1:UIButton, button2:UIButton,button3:UIButton,button4:UIButton, stopButton:UIButton, webView:UIWebView ){
        self.ip = ip
        label.text = ip
        hasIP = true
        client = TCPClient(addr: SharedVars.ip, port: 8765)
        tryConnect(label, statusLabel: statusLabel, button1: button1, button2: button2, button3: button3, button4: button4, stopButton: stopButton, webView:webView)
//                print(ip)
    }
    
    static func tryConnect(label:UILabel!, statusLabel:UILabel!, button1:UIButton, button2:UIButton,button3:UIButton,button4:UIButton, stopButton:UIButton, webView:UIWebView){
        print("trying to connect")
        let (success, errmsg) = client.connect(timeout: 1)
        if(success){
//            readUntilEndOfLine()
            statusLabel.text = "connected"
            connected = true
            button1.enabled = true
            button2.enabled = true
            button3.enabled = true
            button4.enabled = true
            stopButton.enabled = true
            startCamera(webView)
        }else{
            statusLabel.text = errmsg
            connected = false
            button1.enabled = false
            button2.enabled = false
            button3.enabled = false
            button4.enabled = false
            stopButton.enabled = false
        }

    }
    static func assignTimeStamp(label:UILabel!, timestamp: String){
        label.text = timestamp
        print(timestamp)
    }
    static func readUntilEndOfLine() -> String{
        self.stringBuffer = ""
        var attempts = 20
        print(attempts)
        while(attempts > 0){
            attempts -= 1
            print(attempts)
            print("trying to read")
            let rawData = client.read(1024*10)
            
            if (rawData  != nil){
                let data = NSData(bytes: rawData!, length: rawData!.count)
                
                
                
                if let str = String(data: data, encoding: NSUTF8StringEncoding) {
                    self.stringBuffer += str
                    //                    print(str)
                    if(self.stringBuffer.containsString("\r\n")){
                        //                        print(str)
                        
                        let range = self.stringBuffer.rangeOfString("\r\n")
                        let response = self.stringBuffer.substringToIndex((range?.startIndex)!)
                        self.stringBuffer = self.stringBuffer.substringFromIndex((range?.endIndex)!)
                        return response
                    }
                } else {
                    print("not a valid UTF-8 sequence")
                }
            }else{
                print("raw data is nil")
            }
            
        }
        print("failed to read after 20 attemps, current buffer is " + self.stringBuffer)
        return ""
        
    }
    static func startCamera(webView:UIWebView){
        if(SharedVars.hasIP && SharedVars.connected){
            
            webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://" + SharedVars.ip + ":8080/stream")!))
        }
    }
//    static func stopCamera(webView:UIWebView){
//        
//        // code from 
////        webView.
//    }
}