//
//  connectInfoViewController.swift
//  Neopixels
//
//  Created by luc daalmeijer on 18/12/2016.
//  Copyright © 2016 Blue90. All rights reserved.
//

import UIKit
import NMSSH

class connectInfoViewController: UIViewController {

    let screenSize: CGRect = UIScreen.main.bounds
    var topBar = UIView()
    let tutorial = #imageLiteral(resourceName: "connect to wifi")
    let confirmation = #imageLiteral(resourceName: "Connection confirmation")
    let mainTitle = UILabel()
    let subText = UILabel()
    var UDID = String(describing: UIDevice.current.identifierForVendor!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        self.view.backgroundColor = UIColorFromHex(0xc5C9BBF)
        
        self.mainTitle.frame = CGRect(origin: CGPoint(x: 10,y :30), size: CGSize(width: screenWidth-20, height: 50))
        self.mainTitle.textColor = UIColor.white
        self.mainTitle.text = "Verbind met 'Neopixels Command'"
        self.mainTitle.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 20)
        self.mainTitle.numberOfLines = 0
        self.mainTitle.minimumScaleFactor = 0.4
        self.mainTitle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self.mainTitle.adjustsFontSizeToFitWidth = true
        self.mainTitle.textAlignment = NSTextAlignment.center
        self.view.addSubview(mainTitle)
        
        self.subText.frame = CGRect(origin: CGPoint(x: 10,y :60), size: CGSize(width: screenWidth-20, height: 50))
        self.subText.textColor = UIColor.white
        self.subText.text = "'Settings' - 'Wi-Fi' - 'Neopixels Command'"
        self.subText.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 15.0)
        self.subText.numberOfLines = 0
        self.subText.minimumScaleFactor = 0.4
        self.subText.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self.subText.adjustsFontSizeToFitWidth = true
        self.subText.textAlignment = NSTextAlignment.center
        self.subText.textAlignment = NSTextAlignment.center
        self.view.addSubview(subText)
        
        let btn: UIButton = UIButton(frame: CGRect(origin: CGPoint(x: screenWidth-150,y :screenHeight-75), size: CGSize(width: 100, height: 40)))
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 5
        btn.titleLabel!.font =  UIFont(name: "AppleSDGothicNeo-Thin", size: 30.0)
        btn.setTitle("Next", for: .normal)
        btn.addTarget(self, action: #selector(showWifiSettings), for: .touchUpInside)
        btn.tag = 1
        self.view.addSubview(btn)
        
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
            self.present(wifiCheckViewController(), animated: false, completion: nil)
            //            self.present(showTempHumWeekViewController(), animated: false, completion: nil)
        }
    }


}
