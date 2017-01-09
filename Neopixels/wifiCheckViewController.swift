//
//  wifiCheckViewController.swift
//  Neopixels
//
//  Created by luc daalmeijer on 17/10/2016.
//  Copyright © 2016 Blue90. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork

class wifiCheckViewController: UIViewController {
    
    let result = UILabel()
    let screenSize: CGRect = UIScreen.main.bounds
    var topBar = UIView()
    let wifiName = network().getSSID()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColorFromHex(0xc5C9BBF)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func showWifiSettings(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            self.present(ViewController(), animated: false, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard wifiName != nil else {
            print("no wifi name")
            return
        }
        
        print("my network name is: \(wifiName!)")
        
        if wifiName == "Neopixels Command"{
            self.present(NetworkViewController(), animated: false, completion: nil)
        }
        else{
            self.result.frame = CGRect(origin: CGPoint(x: screenSize.width/2-350,y :screenSize.height/2-25), size: CGSize(width: 700, height: 50))
            self.result.textColor = UIColor.white
            self.result.text = "U bent niet verbonden met Neopixels Command"
            self.result.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 15.0)
            self.result.textAlignment = NSTextAlignment.center
            self.view.addSubview(result)
            
            let btn: UIButton = UIButton(frame: CGRect(origin: CGPoint(x: 50,y :screenSize.height-75), size: CGSize(width: 100, height: 40)))
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.layer.cornerRadius = 5
            btn.titleLabel!.font =  UIFont(name: "AppleSDGothicNeo-Thin", size: 30.0)
            btn.setTitle("Back", for: .normal)
            btn.addTarget(self, action: #selector(showWifiSettings), for: .touchUpInside)
            btn.tag = 1
            self.view.addSubview(btn)
        }
    }
    
}

class network : NSObject {
    
    func getSSID() -> String? {
        
        let interfaces = CNCopySupportedInterfaces()
        if interfaces == nil {
            return nil
        }
        
        let interfacesArray = interfaces as! [String]
        if interfacesArray.count <= 0 {
            return nil
        }
        
        let interfaceName = interfacesArray[0] as String
        let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName as CFString)
        
        if unsafeInterfaceData == nil {
            return nil
        }
        
        let interfaceData = unsafeInterfaceData as! Dictionary <String,AnyObject>
        
        return interfaceData["SSID"] as? String
    }
    
}
