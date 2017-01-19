//
//  ShowInfoViewController.swift
//  Neopixels
//
//  Created by luc daalmeijer on 13/01/2017.
//  Copyright © 2017 Blue90. All rights reserved.
//

import UIKit
import Alamofire
import ChameleonFramework
import GoogleMaps

class ShowInfoViewController: UIViewController {
    
    var UDID = String(describing: UIDevice.current.identifierForVendor!)
    let screenSize: CGRect = UIScreen.main.bounds
    var rasp_data = UIView()
    var sensor_data = UIView()
    var location_time_data = UIView()
    let sensor_details = UILabel()
    let sensor_details_2 = UILabel()
    let rasp_mac = UILabel()
    let rasp_ip = UILabel()
    let locatie_rasp = UILabel()
    let online_from = UILabel()
    typealias JSONStandard = [String : AnyObject]
    var lat = 51.56
    var long = 5.09
    var city = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = FlatSkyBlue()
        Collect_system_data()
        Menu()
        setView()
        GMSServices.provideAPIKey("AIzaSyB9qeM1DkKYqVzhp5cPCqiW8ZB7V3-JL0I")
        // Do any additional setup after loading the view.
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
    
    func setView(){
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        self.sensor_data.frame = CGRect(origin: CGPoint(x:7.5,y :100), size: CGSize(width: screenWidth-15, height: screenHeight/4-45))
        self.sensor_data.backgroundColor = UIColorFromHex(0xcecf0f1)
        self.sensor_data.layer.cornerRadius = 5
        self.sensor_data.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.sensor_data.layer.shadowOpacity = 0.3
        self.view.addSubview(sensor_data)
        
        self.rasp_data.frame = CGRect(origin: CGPoint(x:7.5,y :screenHeight/4*1+65), size: CGSize(width: screenWidth-15, height: screenHeight/4-45))
        self.rasp_data.backgroundColor = UIColorFromHex(0xcecf0f1)
        self.rasp_data.layer.cornerRadius = 5
        self.rasp_data.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.rasp_data.layer.shadowOpacity = 0.3
        self.view.addSubview(rasp_data)
        
        self.location_time_data.frame = CGRect(origin: CGPoint(x:7.5, y:screenHeight/2+30), size: CGSize(width: screenWidth-15, height: screenHeight/2-40))
        self.location_time_data.backgroundColor = UIColorFromHex(0xcecf0f1)
        self.location_time_data.layer.cornerRadius = 5
        self.location_time_data.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.location_time_data.layer.shadowOpacity = 0.3
        self.view.addSubview(location_time_data)
        
        let Image_sensor = UIImageView(frame: CGRect(origin: CGPoint(x: 30,y :100+sensor_data.frame.size.height/2-32.5), size: CGSize(width: 70, height: 65)))
        Image_sensor.image = #imageLiteral(resourceName: "ti-sensortag-cc2650")
        self.view.addSubview(Image_sensor)
        
        let Image_rasp = UIImageView(frame: CGRect(origin: CGPoint(x: 35,y :rasp_data.frame.origin.y+rasp_data.frame.size.height/2-40), size: CGSize(width: 50, height: 80)))
        Image_rasp.image = #imageLiteral(resourceName: "Raspberry-Pi-2-cutout-1500")
        self.view.addSubview(Image_rasp)
        
    }
    
    func Menu(){
        //Menu bar
        let menu = UIView()
        menu.frame = CGRect(origin: CGPoint(x:0, y:0), size: CGSize(width: screenSize.width, height: 80))
        menu.backgroundColor = UIColorFromHex(0xcecf0f1)
        menu.layer.shadowOffset = CGSize(width: 2, height: 5)
        menu.layer.shadowOpacity = 0.3
        self.view.addSubview(menu)
        
        let selected_menu = UIView()
        selected_menu.frame = CGRect(origin: CGPoint(x:screenSize.width/4*3-25, y:75), size: CGSize(width: 50, height: 5))
        selected_menu.backgroundColor = FlatRedDark()
        self.view.addSubview(selected_menu)
        
        let home_btn: UIButton = UIButton(frame: CGRect(origin: CGPoint(x:screenSize.width/4-25, y:40), size: CGSize(width: 50, height: 24)))
        home_btn.setTitleColor(FlatRedDark(), for: .normal)
        home_btn.setTitle("Home", for: .normal)
        home_btn.layer.shadowOffset = CGSize(width: 2, height: 5)
        home_btn.titleLabel!.font = UIFont(name: "AppleSDGothicNeo", size: 15.0)
        home_btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        home_btn.tag = 2
        self.view.addSubview(home_btn)
        
        let btn: UIButton = UIButton(frame: CGRect(origin: CGPoint(x:screenSize.width/2-25, y:40), size: CGSize(width: 50, height: 24)))
        btn.setTitleColor(FlatRedDark(), for: .normal)
        btn.setTitle("Check", for: .normal)
        btn.layer.shadowOffset = CGSize(width: 2, height: 5)
        btn.titleLabel!.font = UIFont(name: "AppleSDGothicNeo", size: 15.0)
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btn.tag = 3
        self.view.addSubview(btn)
        
        let table_btn: UIButton = UIButton(frame: CGRect(origin: CGPoint(x:screenSize.width/4*3-25, y:40), size: CGSize(width: 50, height: 24)))
        table_btn.setTitleColor(FlatRedDark(), for: .normal)
        table_btn.setTitle("Info", for: .normal)
        table_btn.layer.shadowOffset = CGSize(width: 2, height: 5)
        table_btn.titleLabel!.font = UIFont(name: "AppleSDGothicNeo", size: 15.0)
        table_btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        table_btn.tag = 4
        self.view.addSubview(table_btn)
    }
    
    func buttonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 2 {
            self.present(showTempHumWeekViewController(), animated: false, completion: nil)
        }
        if btnsendtag.tag == 3 {
            self.present(SecondViewController(), animated: false, completion: nil)
        }
    }
    
    func Collect_system_data(){
        let retrieve_info = "http://86.82.142.15/public/api/system/\(UDID)/collectData"
        self.getAPIRequestNeopixels(url_neopixels: retrieve_info)
    }
    
    func getAPIRequestNeopixels(url_neopixels : String){
        
        Alamofire.request(url_neopixels).responseJSON(completionHandler: {
            response in
            
            self.parseDataNeopixels(JSONDataNeopixels: response.data!)
        })
    }
    
    func parseDataNeopixels(JSONDataNeopixels : Data){
        do{
            let tempJSON = try JSONSerialization.jsonObject(with: JSONDataNeopixels, options: .mutableContainers)  as! [AnyObject]
            if let temps = tempJSON[0] as? [String : AnyObject] {
                let created_at = temps["date"]!["date"]!!
                let ip_adres = temps["ip_adres"]!
                let mac_adres = temps["mac_adres"]!
                let locatie = temps["location"]!
                let sensor = temps["sensor"]!["0"]!!
                let sensor_2 = temps["sensor"]!["15"]!!
                
                self.city = locatie as! String
                
//                for i in 1...temps["sensor"]!.count-1{
//                    print(temps["sensor"]!)
//                }
                
                self.sensor_details.frame = CGRect(origin: CGPoint(x: screenSize.width/2-50, y:sensor_data.frame.origin.y+10), size: CGSize(width: screenSize.width/3*2, height: 50))
                self.sensor_details.textColor = UIColorFromHex(0xc303d51)
                self.sensor_details.text = String(describing: sensor)
                self.sensor_details.adjustsFontSizeToFitWidth = true
                self.sensor_details.font = UIFont(name: "AppleSDGothicNeo", size: 40.0)
                self.sensor_details.textAlignment = NSTextAlignment.left
                self.view.addSubview(sensor_details)
                
                self.sensor_details_2.frame = CGRect(origin: CGPoint(x: screenSize.width/2-50, y:sensor_data.frame.origin.y+40), size: CGSize(width: screenSize.width/3*2, height: 50))
                self.sensor_details_2.textColor = UIColorFromHex(0xc303d51)
                self.sensor_details_2.text = String(describing: sensor_2)
                self.sensor_details_2.adjustsFontSizeToFitWidth = true
                self.sensor_details_2.font = UIFont(name: "AppleSDGothicNeo", size: 40.0)
                self.sensor_details_2.textAlignment = NSTextAlignment.left
                self.view.addSubview(sensor_details_2)
                
                self.rasp_ip.frame = CGRect(origin: CGPoint(x: screenSize.width/2-50, y:rasp_data.frame.origin.y+10), size: CGSize(width: screenSize.width/3*2, height: 50))
                self.rasp_ip.textColor = UIColorFromHex(0xc303d51)
                self.rasp_ip.text = String(describing: "IP: \(ip_adres)")
                self.rasp_ip.adjustsFontSizeToFitWidth = true
                self.rasp_ip.font = UIFont(name: "AppleSDGothicNeo", size: 40.0)
                self.rasp_ip.textAlignment = NSTextAlignment.left
                self.view.addSubview(rasp_ip)
                
                self.rasp_mac.frame = CGRect(origin: CGPoint(x: screenSize.width/2-50, y:rasp_data.frame.origin.y+40), size: CGSize(width: screenSize.width/3*2, height: 50))
                self.rasp_mac.textColor = UIColorFromHex(0xc303d51)
                self.rasp_mac.text = String(describing: "Mac: \(mac_adres)")
                self.rasp_mac.font = UIFont(name: "AppleSDGothicNeo", size: 40.0)
                self.rasp_mac.textAlignment = NSTextAlignment.left
                self.view.addSubview(rasp_mac)
                
                self.locatie_rasp.frame = CGRect(origin: CGPoint(x: 30, y:location_time_data.frame.origin.y+10), size: CGSize(width: screenSize.width-60, height: 50))
                self.locatie_rasp.textColor = UIColorFromHex(0xc303d51)
                self.locatie_rasp.text = String(describing: "Location: \(locatie)")
                self.locatie_rasp.adjustsFontSizeToFitWidth = true
                self.locatie_rasp.font = UIFont(name: "AppleSDGothicNeo", size: 40.0)
                self.locatie_rasp.textAlignment = NSTextAlignment.left
                self.view.addSubview(locatie_rasp)
                
                self.online_from.frame = CGRect(origin: CGPoint(x: 30, y:location_time_data.frame.origin.y+40), size: CGSize(width: screenSize.width-60, height: 50))
                self.online_from.textColor = UIColorFromHex(0xc303d51)
                self.online_from.text = String(describing: "Online from: \(created_at)")
                self.online_from.font = UIFont(name: "AppleSDGothicNeo", size: 40.0)
                self.online_from.textAlignment = NSTextAlignment.left
                self.view.addSubview(online_from)
                
                let apiURL = "http://api.openweathermap.org/data/2.5/weather?q=\(self.city),nl&appid=c4d0492babc63c1e63f3afa08893b14d"
                self.getAPIRequest(url: apiURL)
            }
        }
        catch{
            print(error)
        }
    }
    
        func getAPIRequest(url : String){
    
            Alamofire.request(url).responseJSON(completionHandler: {
                response in
    
                self.parseData(JSONData: response.data!)
            })
        }
    
        func parseData(JSONData : Data){
            do{
                let tempJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! [String : AnyObject]
                lat = tempJSON["coord"]!["lat"]! as! Double
                long = tempJSON["coord"]!["lon"]! as! Double
                print(lat)
                
                let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 12.0)
                let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                mapView.frame = CGRect(origin: CGPoint(x:7.5, y:screenSize.height/2+120), size: CGSize(width: screenSize.width-15, height: screenSize.height/2-130))
                mapView.layer.cornerRadius = 5
                mapView.layer.shadowOffset = CGSize(width: 2, height: 5)
                mapView.settings.scrollGestures = false
                mapView.settings.zoomGestures = false
                mapView.layer.shadowOpacity = 0.3
                self.view.addSubview(mapView)
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                marker.map = mapView
            }
            catch{
                print(error)
            }
        }
    

}
