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
   

    @IBOutlet weak var secondViewText: UILabel!
    @IBOutlet weak var secondViewSubtitle: UILabel!
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
                SharedVars.ip = ip
                let timeStr = timesubstr.substringToIndex((timesubstr.rangeOfString("\"")?.startIndex)!)
                self.secondViewText.text = ip
                self.secondViewSubtitle.text = timeStr
            }
            
            
            
            
            

            
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
        
        
//        var client:TCPClient = TCPClient(addr: "127.0.0.1", port: 8765)
//        var (success, errmsg) = client.connect(timeout: 10)
//        (success, errmsg) = client.send(str:"GET / HTTP/1.0\n\n")
//        var rawData = client.read(1024*10)
//        let data = NSData(bytes: rawData!, length: rawData!.count)
//        let str = NSString(data: data, encoding: NSUTF8StringEncoding)
//        if let str = String(data: data, encoding: NSUTF8StringEncoding) {
//            print(str)
//        } else {
//            print("not a valid UTF-8 sequence")
//        }
//        
//        (success, errmsg) = client.close()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

