//
//  SecondViewController.swift
//  car
//
//  Created by Zhiyun Ren on 4/13/16.
//  Copyright © 2016 Zhiyun Ren. All rights reserved.
//
// code for TCP socket from https://github.com/swiftsocket/SwiftSocket

import UIKit
import Firebase
import AVFoundation
import AVKit
//import MediaPlayer
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
    @IBOutlet weak var startCameraButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    var stringBuffer = ""
//    var moviePlayerController : MPMoviePlayerController
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
                SharedVars.assignIP(self.ipTextFiled, statusLabel: self.statusTextField, ip: ip, button1: self.forwardButton, button2: self.ccwButton, button3: self.cwButton, button4: self.backwardButton, stopButton: self.stopButton, webView:self.webView)
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
    
//     func aviewDidAppear(animated: Bool) {
////        super.viewDidAppear(animated)
////        var filepath: String = NSBundle.mainBundle().pathForResource("vid", ofType: "mp4")
//        var fileURL: NSURL = NSURL.fileURLWithPath("10.148.1.155:8767")
//        self.moviePlayerController = MPMoviePlayerController(contentURL: fileURL)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "introMovieFinished:", name: MPMoviePlayerPlaybackDidFinishNotification, object: self.moviePlayerController)
//        // Hide the video controls from the user
//        self.moviePlayerController.controlStyle = .None
//        self.moviePlayerController.prepareToPlay()
//        self.moviePlayerController.view!.frame = CGRectMake(0, 0, 640 , 480)
//        self.view!.addSubview(self.moviePlayerController.view!)
//        self.moviePlayerController.play()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func sliderChanged(sender: AnyObject) {
        
            sliderLabel.text = String(Double(Int(slider.value))/2.0) + " seconds"
        
    }
    
    func controlServo(left: Int, right: Int, lastingTime: Double) -> Bool{
//        var status = ""
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
            controlServo(-1, right: 1, lastingTime: Double(Int(slider.value))/2.0)
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }
    }

    @IBAction func backwardButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP){
            controlServo(1, right: -1, lastingTime: Double(Int(slider.value))/2.0)
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }
    }
    
    @IBAction func ccwButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP){
            controlServo(-1, right: -1, lastingTime: Double(Int(slider.value))/2.0)
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }
    }
    
    @IBAction func cwButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP){
            controlServo(1, right: 1, lastingTime: Double(Int(slider.value))/2.0)
            
            
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
        SharedVars.tryConnect(self.ipTextFiled, statusLabel:self.statusTextField, button1: self.forwardButton, button2: self.ccwButton, button3: self.cwButton, button4: self.backwardButton, stopButton: self.stopButton, webView: self.webView)
    }
    
    @IBAction func stopButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP){
            controlServo(0, right: 0, lastingTime: 0)
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }

    }
    
   
    @IBAction func startCameraButtonClicked(sender: AnyObject) {
        //code from http://stackoverflow.com/questions/25932570/how-to-play-video-with-avplayerviewcontroller-avkit-in-swift
//        var player:AVPlayer!
        
//        let steamingURL:NSURL = NSURL(string: "http://p.events-delivery.apple.com.edgesuite.net/1603kjbnadcpjhbasdvpjbasdvpjb/vod2/16ouhbadvouhbasdv03c.mp4")!
//        let player = AVPlayer(URL: steamingURL)
//        let avPlayerLayer:AVPlayerLayer = AVPlayerLayer(player: player)
////        avPlayerLayer.frame = self.view.bounds
//        avPlayerLayer.frame = CGRectMake(0, 400, 320, 240)
//        avPlayerLayer.hidden = false
//        self.view.layer.addSublayer(avPlayerLayer)
//        
//        player.play()
        
        
        
//        let videoURL = NSURL(string: "data://" + SharedVars.ip + ":8767")
//        let videoURL = NSURL(string: "http://p.events-delivery.apple.com.edgesuite.net/1603kjbnadcpjhbasdvpjbasdvpjb/vod2/16ouhbadvouhbasdv03c.mp4")
//        let player = AVPlayer(URL: videoURL!)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.presentViewController(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
        SharedVars.startCamera(self.webView)
        
        
        
    }
    
    

}

