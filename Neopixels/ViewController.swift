//
//  ViewController.swift
//  Neopixels
//
//  Created by luc daalmeijer on 10/10/2016.
//  Copyright © 2016 Blue90. All rights reserved.
//

import UIKit
import Alamofire
import NMSSH
import ChameleonFramework

class ViewController: UIViewController{
    
    var UDID = String(describing: UIDevice.current.identifierForVendor!)
    typealias JSONStandard = [String : AnyObject]
    var device_mac = ""
    let screenSize: CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UDID)
        let url_neopixels = "http://86.82.142.15/public/api/check/registerUser/\(UDID)"
        self.getAPIRequestNeopixels(url_neopixels: url_neopixels)
        
        let imageView = #imageLiteral(resourceName: "Image")
        
        let imageView_water_drop_light = UIImageView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: screenSize.width, height: screenSize.height)))
        imageView_water_drop_light.image = imageView
        self.view.addSubview(imageView_water_drop_light)
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
    
    func getAPIRequestNeopixels(url_neopixels : String){
        
        Alamofire.request(url_neopixels).responseJSON(completionHandler: {
            response in
            self.parseDataNeopixels(JSONDataNeopixels: response.data!)
        })
    }
    
//    func showTempData(sender: UIButton!) {
//        let btnsendtag: UIButton = sender
//        if btnsendtag.tag == 1 {
//            self.present(showTempHumWeekViewController(), animated: false, completion: nil)
////            self.present(SendAmountSensorViewController(), animated: false, completion: nil)
//
//        }
//    }
//    
//    func setupSystem(sender: UIButton!) {
//        let btnsendtag: UIButton = sender
//        if btnsendtag.tag == 1 {
//            self.present(connectInfoViewController(), animated: false, completion: nil)
//        }
//    }
    
    func parseDataNeopixels(JSONDataNeopixels : Data){
        print("Data: \(String(describing: JSONDataNeopixels))")
        if(String(describing: JSONDataNeopixels) == "2 bytes"){
            self.present(connectInfoViewController(), animated: false, completion: nil)
        }
        else{
            do{
                let tempJSON = try JSONSerialization.jsonObject(with: JSONDataNeopixels, options: .mutableContainers)  as! JSONStandard
                if let registrations = tempJSON["user_registrations"] as? [AnyObject] {
                    device_mac = registrations[0]["device_mac"] as! String
                    if (device_mac == UDID){
                        print("gelijk")
                        self.present(showTempHumWeekViewController(), animated: false, completion: nil)
                    }
                    else{
                        print("niet gelijk")
                        self.present(connectInfoViewController(), animated: false, completion: nil)
                    }
                }
            }
            catch{
                print(error)
            }
        }
        print("Hans: \(device_mac)")
    }
}

