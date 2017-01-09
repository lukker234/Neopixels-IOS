//
//  SendAmountSensorViewController.swift
//  Neopixels
//
//  Created by luc daalmeijer on 16/11/2016.
//  Copyright © 2016 Blue90. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import NMSSH

class SendAmountSensorViewController: UIViewController {
    
    let screenSize: CGRect = UIScreen.main.bounds
    let mainText = UITextField()
    let mainTitle = UILabel()
    var textView = UIView()
    var ip_adres_rasp = "192.168.254.120"
    
//    let apiURLNeopixels = "http://86.82.142.15/public/api/date/regs/202481589565676"
    typealias JSONStandard = [String : AnyObject]

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.getAPIRequestNeopixels(url_neopixels: apiURLNeopixels)
        
        self.view.backgroundColor = UIColorFromHex(0xc5C9BBF)
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        self.textView.frame = CGRect(origin: CGPoint(x:20 ,y:screenSize.height/2-screenSize.height/4), size: CGSize(width: screenSize.width-40, height: screenSize.height/2))
        self.textView.backgroundColor = UIColorFromHex(0xcecf0f1)
        self.textView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.textView.layer.shadowOpacity = 0.3
        self.view.addSubview(textView)
        
        self.mainTitle.frame = CGRect(origin: CGPoint(x: screenWidth/2-200,y :screenHeight/2-125), size: CGSize(width: 400, height: 50))
        self.mainTitle.textColor = UIColorFromHex(0xc37485f)
        self.mainTitle.text = "Hoeveel sensoren heeft u?"
        self.mainTitle.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 30.0)
        self.mainTitle.textAlignment = NSTextAlignment.center
        self.view.addSubview(mainTitle)
        
        self.mainText.frame = CGRect(origin: CGPoint(x: 40,y :screenHeight/2), size: CGSize(width: screenWidth-80, height: 50))
        self.mainText.textColor = UIColor.white
        self.mainText.backgroundColor = UIColorFromHex(0xcbec3c7)
        self.mainText.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 30.0)
        self.mainText.textAlignment = NSTextAlignment.center
        self.view.addSubview(mainText)
        
        let sendData: UIButton = UIButton(frame: CGRect(origin: CGPoint(x:screenWidth/2-250 ,y :screenHeight/2+90), size: CGSize(width: 500, height: 50)))
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
    
    
    
    
//    func getAPIRequestNeopixels(url_neopixels : String){
//        
//        Alamofire.request(url_neopixels).responseJSON(completionHandler: {
//            response in
//            
//            self.parseDataNeopixels(JSONDataNeopixels: response.data!)
//        })
//    }
//    
//    func parseDataNeopixels(JSONDataNeopixels : Data){
//        do{
//            let tempJSON = try JSONSerialization.jsonObject(with: JSONDataNeopixels, options: .mutableContainers)  as! JSONStandard
//            if let registration = tempJSON["rasp__registrations"] as? [AnyObject] {
//                print(NetworkViewController.Variables.coinsVariable)
//                if(registration[0]["mac_adres"]! as! String == NetworkViewController.Variables.coinsVariable){
//                    ip_adres_rasp = registration[0]["ip_adres"]! as! String
//                    print(ip_adres_rasp)
//                }
//            }
//        }
//        catch{
//            print(error)
//        }
//    }
    
    
    
    
    func sendDataWifi(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            DispatchQueue(label: "queuename").async {
                let session = NMSSHSession.connect(toHost: self.ip_adres_rasp, withUsername: "pi")
                if (session?.isConnected)! {
                    session?.authenticate(byPassword: "Abcd_1234")
                    if (session?.isAuthorized)! {
                        print("Authentication succeeded")
                    }
                }
                
                do {
                    print("Aantal sensoren: \(self.mainText.text!)")
                    let setup = try session!.channel.execute("cd /etc/init.d && sh start_metingen_b.sh 2 && sudo pkill -o -u pi sshd")
                    print(setup)
                    session?.disconnect()
                }
                catch is Error {
                    print(Error.self)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.present(showTempHumWeekViewController(), animated: false, completion: nil)
                })
            }
        }
    }
    
    func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }

}
