//
//  SecondViewController.swift
//  car
//
//  Created by Zhiyun Ren on 4/13/16.
//  Copyright © 2016 Zhiyun Ren. All rights reserved.
//

import UIKit
import Firebase
import SocketIOClientSwift
class SecondViewController: UIViewController {
    
    // Create a reference to a Firebase location
    var myRootRef = Firebase(url:"https://ece5990.firebaseio.com/ip")
    // Write data to Firebase
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
   
    @IBOutlet weak var ipTextFiled: UILabel!
    @IBOutlet weak var statusTextField: UILabel!

    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var ccwButton: UIButton!
    @IBOutlet weak var cwButton: UIButton!
   
    
    var stringBuffer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Create a reference to a Firebase location
        // Read data and react to changes

        myRootRef.observeEventType(.Value, withBlock: {
            snapshot in
//            self.secondViewSubtitle.text = 
            let str = "\(snapshot.value)"
            print(str)
            if(str != "<null>"){
                let ipStart = str.rangeOfString("ip = \"")?.endIndex
                let timeStart = str.rangeOfString("time = \"")?.endIndex
                
                let ipsubstr = str.substringFromIndex(ipStart!)
                let timesubstr = str.substringFromIndex(timeStart!)
                let ip = ipsubstr.substringToIndex((ipsubstr.rangeOfString("\"")?.startIndex)!)
                SharedVars.assignIP(self.ipTextFiled, ip: ip)
//                SharedVars.hasIP = true
                let timeStr = timesubstr.substringToIndex((timesubstr.rangeOfString("\"")?.startIndex)!)
//                self.secondViewText.text = ip
                
                SharedVars.assignTimeStamp(self.statusTextField, timestamp: timeStr)
//                print(ip)
//                print(timeStr)
                sleep(1)
            }
            
//            sleep(1)
//            
//            do{
//                print(SharedVars.ip)
//                let client:TCPClient = TCPClient(addr: SharedVars.ip, port: 8765)
//                var (success, errmsg) = client.connect(timeout: 10)
//                print(success)
//                print(errmsg)
//                var rawData = client.read(1024*10)
//                if (rawData  != nil){
//                    let data = NSData(bytes: rawData!, length: rawData!.count)
//                        
//                    
//                    
//                    if let str = String(data: data, encoding: NSUTF8StringEncoding) {
//                        print(str)
//                    } else {
//                        print("not a valid UTF-8 sequence")
//                    }
//                }else{
//                    print("raw data is nil")
//                }
//                
//                (success, errmsg) = client.send(str:"-1 1 5\r\n")
//                print(success)
//                print(errmsg)
//                rawData = client.read(1024*10)
//                if (rawData  != nil){
//
//                    
//                    let data = NSData(bytes: rawData!, length: rawData!.count)
//                
//                    if let str = String(data: data, encoding: NSUTF8StringEncoding) {
//                        print(str)
//                       
//                    } else {
//                        print("not a valid UTF-8 sequence")
//                    }
//                }else{
//                    print("raw data is nil")
//                }
//                
//                
//                
//                (success, errmsg) = client.close()
//            }
            

            
        })
//        
//        let socket = SocketIOClient(socketURL: NSURL(string: "127.0.0.1:8765")!, options: [.Log(true), .ForcePolling(true)])
//        
//        socket.on("connect") {data, ack in
//            print("socket connected")
//        }
//        
//        socket.on("currentAmount") {data, ack in
//            if let cur = data[0] as? Double {
//                socket.emitWithAck("canUpdate", cur)(timeoutAfter: 0) {data in
//                    socket.emit("update", ["amount": cur + 2.50])
//                }
//                
//                ack.with("Got your currentAmount", "dude")
//            }
//        }
//        
//        socket.connect()
        
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func sliderChanged(sender: AnyObject) {
        if(slider.value > 60.5){
        sliderLabel.text = "Infinity"
        }else{
            sliderLabel.text = String(Int(slider.value)) + " seconds"
        }
    }
    func readUntilEndOfLine(client: TCPClient) -> String{
        self.stringBuffer = ""
        var attempts = 20
        while(attempts > 0){
            attempts -= 1
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
    func controlServo(left: Int, right: Int, lastingTime: Int) -> Bool{
        
        var attempts = 10
        var ok = false
        while(!ok && attempts > 0){
            attempts -= 1
            print("Attemping to connect to " + SharedVars.ip)
            let client:TCPClient = TCPClient(addr: SharedVars.ip, port: 8765)
            var (success, errmsg) = client.connect(timeout: 3)
            if(success){
                (success, errmsg) = client.send(str: String(left) + " " + String(right) + " " + String(lastingTime) + "\r\n")
                
                if(success){
                    let response = readUntilEndOfLine(client)
                    (success, errmsg) = client.close()
                    if (response != ""){
                        ok = true
                        print(response)
                        self.statusTextField.text = response
                        return true
                    }
                }else{
                    print("failed to send command. " + errmsg)
                }
            }else{
                print("Failed to connect. " + errmsg)
            }

        }
        self.statusTextField.text = "Failed to send command after 10 attempts"
        return false
        
        
        
        
        
    }
    
    @IBAction func forwardButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP){
            controlServo(-1, right: 1, lastingTime: Int(self.slider.value))
            
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }
    }


}

