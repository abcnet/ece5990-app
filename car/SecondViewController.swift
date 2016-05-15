//
//  SecondViewController.swift
//  car
//
//  Created by Zhiyun Ren on 4/13/16.
//  Copyright © 2016 Zhiyun Ren. All rights reserved.
//

import UIKit
import Firebase
//import SocketIOClientSwift
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
   
    @IBOutlet weak var backwardButton: UIButton!
    
    @IBOutlet weak var connectButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
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
                SharedVars.assignIP(self.ipTextFiled, statusLabel: self.statusTextField, ip: ip, button1: self.forwardButton, button2: self.ccwButton, button3: self.cwButton, button4: self.backwardButton)
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
        
            sliderLabel.text = String(Int(slider.value)) + " seconds"
        
    }
    
    func controlServo(left: Int, right: Int, lastingTime: Int) -> Bool{
        var status = ""
        var attempts = 1
        var ok = false
        while(!ok && attempts > 0){
            attempts -= 1
//            status =
//            self.statusTextField.text = ("Trying to connect to " + SharedVars.ip)
//            let client:TCPClient = TCPClient(addr: SharedVars.ip, port: 8765)
            let client = SharedVars.client
//            var (success, errmsg) = client.connect(timeout: 1)
            var success = SharedVars.connected
            var errmsg = ""
            if(success){
//                readUntilEndOfLine(client)
                print("Sending command")
                (success, errmsg) = client.send(str: String(left) + " " + String(right) + " " + String(lastingTime) + "\r\n")
                if(!success){
                    SharedVars.connected = false
                    forwardButton.enabled = false
                    ccwButton.enabled = false
                    cwButton.enabled = false
                    backwardButton.enabled = false
                }
                if(success){
                    print("reading response")
                    let response = SharedVars.readUntilEndOfLine()
//                    (success, errmsg) = client.close()
                    if (response != ""){
                        ok = true
                        print(response)
                        self.statusTextField.text = response
                        return true
                    }
                }else{
                    self.statusTextField.text = ("failed to send command. " + errmsg)
                }
            }else{
                self.statusTextField.text = ("Failed to connect. " + errmsg)
            }

        }
//        self.statusTextField.text = "Failed to send command"
        SharedVars.connected = false
        forwardButton.enabled = false
        ccwButton.enabled = false
        cwButton.enabled = false
        backwardButton.enabled = false

        return false
        
        
        
        
        
    }
    
    @IBAction func forwardButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP){
            controlServo(-1, right: 1, lastingTime: Int(self.slider.value))
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }
    }

    @IBAction func backwardButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP){
            controlServo(1, right: -1, lastingTime: Int(self.slider.value))
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }
    }
    
    @IBAction func ccwButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP){
            controlServo(1, right: 1, lastingTime: Int(self.slider.value))
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }
    }
    
    @IBAction func cwButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP){
            controlServo(-1, right: -1, lastingTime: Int(self.slider.value))
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }
    }
    @IBAction func connectButtonClicked(sender: AnyObject) {
//        let (success, errmsg) = SharedVars.client.connect(timeout: 1)
//        if(success){
//            SharedVars.connected = true
//            SharedVars.readUntilEndOfLine()
//            forwardButton.enabled = true
//            ccwButton.enabled = true
//            cwButton.enabled = true
//            backwardButton.enabled = true
//
//        }
//        self.statusTextField.text = errmsg
        SharedVars.tryConnect(self.ipTextFiled, statusLabel:self.statusTextField, button1: self.forwardButton, button2: self.ccwButton, button3: self.cwButton, button4: self.backwardButton)
    }
    
    @IBAction func stopButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP){
            controlServo(0, right: 0, lastingTime: 0)
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }

    }
    

}

