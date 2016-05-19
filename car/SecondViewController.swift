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
    
    @IBOutlet weak var webView2: UIWebView!
    @IBOutlet weak var stopCameraButton: UIButton!
    
    
    @IBOutlet weak var myLabel: UILabel!
    
    var stringBuffer = ""
    var count = 0
    
    var timer       = NSTimer()
    //    var moviePlayerController : MPMoviePlayerController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.forwardButton.enabled = false
        self.backwardButton.enabled = false
        self.ccwButton.enabled = false
        self.cwButton.enabled = false
        self.stopButton.enabled = false
        self.webView.scrollView.scrollEnabled = false
        self.webView.scrollView.bounces = false
        self.webView.userInteractionEnabled = false
        self.webView2.loadHTMLString("<html lang=\"en\"><head profile=\"http://www.w3.org/2006/03/hcard\"><title>Example of vertical centering</title><style type=\"text/css\">  body {background: #ffffff; color: #000000; font-size: large;    }  /* Vertical centering: make div as large as viewport and use table layout */  div.container {top: 0; left: 0; width: 100%; height: 100%;    position: absolute; display: table}  p {display: table-cell; vertical-align: middle}  /* Also center the lines in the paragraph */  p {text-align: center}  body, html {height: 100%; margin: 0; padding: 0}  </style> </head> <body>  <div class=\"container\">   <p style=\"font-size:30px\">Camera OFF  </p></div></body></html>", baseURL: nil)
        self.view.bringSubviewToFront(self.webView)
        
        // code for timer from https://www.weheartswift.com/nstimer-in-swift/
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(SecondViewController.update), userInfo: nil, repeats: true)
        
        
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
    
            
        })

        
        
        
        

    }
    
    func update() {
        // code from http://stackoverflow.com/questions/24007518/how-can-i-use-nstimer-in-swift
        // Something cool
        count += 1
        self.myLabel.text = String(count)
        if(SharedVars.hasIP && SharedVars.connected){
            sendServoCommand("c\r\n")
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func sliderChanged(sender: AnyObject) {
        
            sliderLabel.text = String(Double(Int(slider.value))/2.0) + " seconds"
        
    }
    
    func sendServoCommand(s: String) -> Bool{
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
                (success, errmsg) = client.send(str: s)
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
    
    func controlServo(left: Int, right: Int, lastingTime: Double) -> Bool{
        return sendServoCommand(String(left) + " " + String(right) + " " + String(lastingTime) + "\r\n")
        
        
        
    }
    
    @IBAction func forwardButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP && SharedVars.connected){
            controlServo(-1, right: 1, lastingTime: Double(Int(slider.value))/2.0)
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }
    }

    @IBAction func backwardButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP && SharedVars.connected){
            controlServo(1, right: -1, lastingTime: Double(Int(slider.value))/2.0)
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }
    }
    
    @IBAction func ccwButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP && SharedVars.connected){
            controlServo(-1, right: -1, lastingTime: Double(Int(slider.value))/2.0)
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }
    }
    
    @IBAction func cwButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP && SharedVars.connected){
            controlServo(1, right: 1, lastingTime: Double(Int(slider.value))/2.0)
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }
    }
    @IBAction func connectButtonClicked(sender: AnyObject) {

        SharedVars.tryConnect(self.ipTextFiled, statusLabel:self.statusTextField, button1: self.forwardButton, button2: self.ccwButton, button3: self.cwButton, button4: self.backwardButton, stopButton: self.stopButton, webView: self.webView)
    }
    
    @IBAction func stopButtonClicked(sender: AnyObject) {
        if(SharedVars.hasIP && SharedVars.connected){
            controlServo(0, right: 0, lastingTime: 0)
            
            
        }else{
            self.statusTextField.text = "No IP retrieved"
        }

    }
    
   
    @IBAction func startCameraButtonClicked(sender: AnyObject) {

        
        self.view.bringSubviewToFront(webView)

        
    }
    
    
    @IBAction func stopCameraButtonClicked(sender: AnyObject) {
        
       
        self.view.bringSubviewToFront(webView2)
    }

    @IBAction func refreshCameraButtonClicked(sender: AnyObject) {
        SharedVars.startCamera(self.webView)
    }
}

