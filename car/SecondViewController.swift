//
//  SecondViewController.swift
//  car
//
//  Created by Zhiyun Ren on 4/13/16.
//  Copyright © 2016 Zhiyun Ren. All rights reserved.
//

import UIKit
import Firebase

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
            let ipStart = str.rangeOfString("ip = \"")?.endIndex
            let timeStart = str.rangeOfString("time = \"")?.endIndex

            let ipsubstr = str.substringFromIndex(ipStart!)
            let timesubstr = str.substringFromIndex(timeStart!)
            let ip = ipsubstr.substringToIndex((ipsubstr.rangeOfString("\"")?.startIndex)!)
            let timeStr = timesubstr.substringToIndex((timesubstr.rangeOfString("\"")?.startIndex)!)
            self.secondViewText.text = ip
            self.secondViewSubtitle.text = timeStr
        })
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

