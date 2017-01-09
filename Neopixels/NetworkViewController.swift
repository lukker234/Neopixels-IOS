//
//  NetworkViewController.swift
//  Neopixels
//
//  Created by luc daalmeijer on 17/10/2016.
//  Copyright © 2016 Blue90. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import NMSSH

class NetworkViewController: UIViewController, CLLocationManagerDelegate {

    
    let screenSize: CGRect = UIScreen.main.bounds
    var UDID = String(describing: UIDevice.current.identifierForVendor!)
    var topBar = UIView()
    var textView = UIView()
    var textView2 = UIView()
    var waitView = UIView()
    let mainText = UITextField()
    let mainText2 = UITextField()
    let mainTitle = UILabel()
    let question = #imageLiteral(resourceName: "info")
    var infoWifi = UILabel()
    let infoWifiBG = UIView()
    let result = UILabel()
    var mac_adress_rasp = ""
    
    struct Variables {
        static var coinsVariable = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        self.view.backgroundColor = UIColorFromHex(0xc5C9BBF)
        
        self.textView.frame = CGRect(origin: CGPoint(x:20 ,y:screenHeight/2-screenHeight/4), size: CGSize(width: screenWidth-40, height: screenHeight/2))
        self.textView.backgroundColor = UIColorFromHex(0xcecf0f1)
        self.textView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.textView.layer.shadowOpacity = 0.3
        self.view.addSubview(textView)
        
        self.mainText.frame = CGRect(origin: CGPoint(x: 40,y :screenHeight/2-75), size: CGSize(width: screenWidth-80, height: 50))
        self.mainText.textColor = UIColor.white
        self.mainText.backgroundColor = UIColorFromHex(0xcbec3c7)
        self.mainText.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 30.0)
        self.mainText.textAlignment = NSTextAlignment.center
        self.view.addSubview(mainText)
        
        self.mainText2.frame = CGRect(origin: CGPoint(x: 40,y :screenHeight/2), size: CGSize(width: screenWidth-80, height: 50))
        self.mainText2.isSecureTextEntry = true
        self.mainText2.textColor = UIColor.white
        self.mainText2.backgroundColor = UIColorFromHex(0xcbec3c7)
        self.mainText2.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 30.0)
        self.mainText2.textAlignment = NSTextAlignment.center
        self.mainText2.isUserInteractionEnabled = true
        self.view.addSubview(mainText2)
        
        self.mainTitle.frame = CGRect(origin: CGPoint(x: 40,y :screenHeight/4+50), size: CGSize(width: screenWidth-80, height: 50))
        self.mainTitle.textColor = UIColorFromHex(0xc37485f)
        self.mainTitle.text = "Geef netwerkgegevens op"
        self.mainTitle.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 20.0)
        self.mainTitle.textAlignment = NSTextAlignment.center
        self.view.addSubview(mainTitle)
        
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: screenWidth/2+150,y :screenHeight/2-120), size: CGSize(width: 20, height: 20)))
        imageView.image = question
        self.view.addSubview(imageView)
        
        
        let btn: UIButton = UIButton(frame: CGRect(origin: CGPoint(x: screenWidth/2+140,y :screenHeight/2-130), size: CGSize(width: 40, height: 40)))
        btn.backgroundColor = UIColor.gray.withAlphaComponent(0)
        btn.setTitleColor(UIColorFromHex(0xc303d51), for: .normal)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(getInfoWifi), for: .touchUpInside)
        btn.tag = 1
        self.view.addSubview(btn)
        
        self.infoWifiBG.frame = CGRect(origin: CGPoint(x: screenWidth/2-75,y :screenHeight/2-80), size: CGSize(width: 300, height: 150))
        self.infoWifiBG.layer.cornerRadius = 5
        self.infoWifiBG.layer.shadowOpacity = 0.3
        self.infoWifiBG.layer.opacity = 0
        self.infoWifiBG.backgroundColor = UIColorFromHex(0xc37485f)
        self.view.addSubview(infoWifiBG)
        
        self.infoWifi.frame = CGRect(origin: CGPoint(x: screenWidth/2-50,y :screenHeight/2-80), size: CGSize(width: 250, height: 150))
        self.infoWifi.textColor = UIColor.white
        self.infoWifi.text = "Vul hieronder uw SSID (naam van uw Wifi) en uw wachtwoord in, klik hierna op 'Volgende stap' en het systeem maakt zichzelf klaar"
        self.infoWifi.numberOfLines = 10
        self.infoWifi.layer.opacity = 0
        self.infoWifi.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 15.0)
        self.infoWifi.textAlignment = NSTextAlignment.center
        self.view.addSubview(infoWifi)
        
        let sendData: UIButton = UIButton(frame: CGRect(origin: CGPoint(x:screenWidth/2-250 ,y :screenHeight/2+80), size: CGSize(width: 500, height: 50)))
        sendData.setTitleColor(UIColorFromHex(0xc303d51), for: .normal)
        sendData.layer.cornerRadius = 5
        sendData.titleLabel!.font =  UIFont(name: "AppleSDGothicNeo-Thin", size: 30.0)
        sendData.setTitle("Volgende stap", for: .normal)
        sendData.addTarget(self, action: #selector(sendDataWifi), for: .touchUpInside)
        sendData.tag = 1
        self.view.addSubview(sendData)
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
    
    func getInfoWifi(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            if self.infoWifi.layer.opacity == 0{
                self.infoWifi.layer.opacity = 1
                self.infoWifiBG.layer.opacity = 1
            }
            else{
                self.infoWifi.layer.opacity = 0
                self.infoWifiBG.layer.opacity = 0
            }
        }
    }
    
    func sendDataWifi(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        self.textView2.frame = CGRect(origin: CGPoint(x:20 ,y:screenSize.height/2-screenSize.height/4), size: CGSize(width: screenSize.width-40, height: screenSize.height/2))
        self.textView2.backgroundColor = self.UIColorFromHex(0xcecf0f1)
        self.textView2.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.textView2.layer.shadowOpacity = 0.3
        self.view.addSubview(self.textView2)
        
        self.result.frame = CGRect(origin: CGPoint(x: 20,y :self.screenSize.height/2-25), size: CGSize(width: screenSize.width-40, height: 50))
        self.result.textColor = self.UIColorFromHex(0xc303d51)
        self.result.text = "Moment geduld A.U.B"
        self.result.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 35.0)
        self.result.textAlignment = NSTextAlignment.center
        self.view.addSubview(self.result)
        
            DispatchQueue(label: "queuename").async {
                let session = NMSSHSession.connect(toHost: "192.168.150.1:22", withUsername: "pi")
                if (session?.isConnected)! {
                    session?.authenticate(byPassword: "Abcd_1234")
                    if (session?.isAuthorized)! {
                        print("Authentication succeeded")
                    }
                }
                
                try! session?.channel.execute("cd / && python register_device.py \(self.UDID) && cd /etc/wpa_supplicant/ && sudo python create_wifi.py \(self.mainText.text!) \(self.mainText2.text!)")
                
                self.mac_adress_rasp = try! session!.channel.execute("cd / && python get_mac.py")
                let ns_mac_adress:NSString = self.mac_adress_rasp as NSString
                let range:NSRange = ns_mac_adress.range(of: "\n")
                self.mac_adress_rasp = ns_mac_adress.replacingCharacters(in: range, with: "")
                
                do {
                    let setup = try session!.channel.execute("cd /etc/init.d/ && sudo mv start.sh start_backup.sh && sudo mv register_rasp_b.sh register_rasp.sh && sudo pkill -o -u pi sshd && sudo reboot")
                    print(setup)
                    session?.disconnect()
                }
                catch is Error {
                    print(Error.self)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(60), execute: {
                    NetworkViewController.Variables.coinsVariable = self.mac_adress_rasp
                        self.present(SendAmountSensorViewController(), animated: false, completion: nil)
                })
            }
    }

}


