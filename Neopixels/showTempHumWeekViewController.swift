//
//  showTempHumWeekViewController.swift
//  Neopixels
//
//  Created by luc daalmeijer on 14/10/2016.
//  Copyright © 2016 Blue90. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import ChameleonFramework

extension UIImage{
    
    func alpha(value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

class showTempHumWeekViewController: UIViewController {
    
    let screenSize: CGRect = UIScreen.main.bounds
//    let mac_adres = NetworkViewController.Variables.coinsVariable
    let mac_adres = "202481589565676"
    let labelTempOutside = UILabel()
    let labelTempInside = UILabel()
    let labelHumidOutside = UILabel()
    let labelHumidInside = UILabel()
    let temp_label_short_info = UILabel()
    let labelLocation = UILabel()
    let labelLocationHome = UILabel()
    let selected_circle = CAShapeLayer()
    var degrees = "\u{00B0}"
    var locatie = ""
    var showTempOutside = UIView()
    var infoSelectedDate = UIView()
    var showTempOutside2 = UIView()
    var showTempInside = UIView()
    var showWeekView = UIView()
    var topBar = UIView()
    let box = UIView()
    var i = Int()
    var b = Int()
    var temp_value = ""
    var air_value = ""
    var temp_buiten = ""
    var air_buiten = ""
    var arrayCount = Int()
    let mainTitle = UILabel()
    var dummytemps = [String]()
    var dummyhumid = [String]()
    var druppel = #imageLiteral(resourceName: "raindrop blue")
    var druppel_white = #imageLiteral(resourceName: "raindrop white")
    var rain = #imageLiteral(resourceName: "rain").alpha(value: 0.5)
    
    var lastPoint = CGPoint.zero
    var brushWidth: CGFloat = 3.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    var tempLast7Array = [Double]()
    var temps = ["0\u{00B0}": 18, "10\u{00B0}": 16.5, "20\u{00B0}": 15, "30\u{00B0}": 13.5, "40\u{00B0}": 12]
    var week = [String]()
    
    let imageView = UIImageView()
    
    var point_array = [CGPoint]()
    
    typealias JSONStandard = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Mac_adres: \(mac_adres)")
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        self.view.backgroundColor = FlatSkyBlue()
        

        let apiURLNeopixels = "http://86.82.142.15/public/api/date/temps/now/\(mac_adres)"
        
        let apiURLNeopixelsArray = "http://86.82.142.15/public/api/last7days/\(mac_adres)"
        

        self.getAPIRequestNeopixels(url_neopixels: apiURLNeopixels)
        self.getAPIRequestNeopixelsArray(url_neopixels_array: apiURLNeopixelsArray)
    
        Menu()
        //Create views for temp
        self.showTempOutside.frame = CGRect(origin: CGPoint(x:7.5,y :100), size: CGSize(width: screenWidth-15, height: screenHeight/4-45))
        self.showTempOutside.backgroundColor = FlatRedDark()
        self.showTempOutside.layer.cornerRadius = 5
        self.showTempOutside.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.showTempOutside.layer.shadowOpacity = 0.3
        self.view.addSubview(showTempOutside)

        self.showTempInside.frame = CGRect(origin: CGPoint(x:7.5,y :screenHeight/4*1+65), size: CGSize(width: screenWidth-15, height: screenHeight/4-45))
        self.showTempInside.backgroundColor = UIColorFromHex(0xcecf0f1)
        self.showTempInside.layer.cornerRadius = 5
        self.showTempInside.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.showTempInside.layer.shadowOpacity = 0.3
        self.view.addSubview(showTempInside)
        
        
        //Create view for weekview
        self.showWeekView.frame = CGRect(origin: CGPoint(x:7.5, y:screenHeight/2+30), size: CGSize(width: screenWidth-15, height: screenHeight/2-40))
        self.showWeekView.backgroundColor = UIColorFromHex(0xcecf0f1)
        self.showWeekView.layer.cornerRadius = 5
        self.showWeekView.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.showWeekView.layer.shadowOpacity = 0.3
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showTempHumWeekViewController.someAction(_:)))
        self.showWeekView.addGestureRecognizer(gesture)
        
        self.view.addSubview(showWeekView)
        
        //Create temp labels
        self.labelTempOutside.frame = CGRect(origin: CGPoint(x: 30,y :showTempOutside.frame.origin.y+showTempOutside.frame.size.height-50), size: CGSize(width: screenWidth/4-10, height: 50))
        self.labelTempOutside.textColor = UIColor.white
        self.labelTempOutside.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40.0)
        self.labelTempOutside.numberOfLines = 0
        self.labelTempOutside.minimumScaleFactor = 0.3
        self.labelTempOutside.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self.labelTempOutside.adjustsFontSizeToFitWidth = true
        self.labelTempOutside.numberOfLines = 1
        self.labelTempOutside.textAlignment = NSTextAlignment.left
        self.view.addSubview(labelTempOutside)
        
        self.labelTempInside.frame = CGRect(origin: CGPoint(x: 30,y :showTempInside.frame.origin.y+showTempInside.frame.size.height-50), size: CGSize(width: screenWidth/4-10, height: 50))
        self.labelTempInside.textColor = UIColorFromHex(0xc303d51)
        self.labelTempInside.adjustsFontSizeToFitWidth = true
        self.labelTempInside.numberOfLines = 1
        self.labelTempInside.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40.0)
        self.labelTempInside.textAlignment = NSTextAlignment.left
        self.view.addSubview(labelTempInside)
        
        self.mainTitle.frame = CGRect(origin: CGPoint(x: 30, y:screenHeight/4*1+70), size: CGSize(width: screenWidth/4-10, height: 50))
        self.mainTitle.textColor = UIColorFromHex(0xc303d51)
        self.mainTitle.text = "Home"
        self.mainTitle.adjustsFontSizeToFitWidth = true
        self.mainTitle.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40.0)
        self.mainTitle.textAlignment = NSTextAlignment.left
        self.view.addSubview(mainTitle)
        
        //Create temp_side labels
        for (key,value) in temps{
            
            let temp_side = UILabel()
            temp_side.frame = CGRect(origin: CGPoint(x: 10,y :screenHeight/20*CGFloat(value)), size: CGSize(width: 30, height: 20))
            temp_side.textColor = UIColorFromHex(0xc303d51)
            temp_side.font = UIFont(name: "AppleSDGothicNeo", size: 1.0)
            temp_side.text = key
            temp_side.textAlignment = NSTextAlignment.center
            self.view.addSubview(temp_side)
            
            let line :UIBezierPath = UIBezierPath()
            let linelayer = CAShapeLayer()
            line.move(to: CGPoint(x: 45,y :screenHeight/20*CGFloat(value)+10))
            line.addLine(to: CGPoint(x: screenWidth-30,y :screenHeight/20*CGFloat(value)+10))
            linelayer.strokeColor = UIColorFromHex(0xc303d51).withAlphaComponent(0.1).cgColor
            linelayer.lineWidth = 1.0
            line.stroke()
            linelayer.path = line.cgPath
            view.layer.addSublayer(linelayer)
        }
        
        //Create humid labels
        self.labelHumidOutside.frame = CGRect(origin: CGPoint(x: screenWidth-130,y :showTempOutside.frame.origin.y+showTempOutside.frame.size.height-50), size: CGSize(width: 100, height: 50))
        self.labelHumidOutside.textColor = UIColor.white
        self.labelHumidOutside.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 25)
        self.labelHumidOutside.textAlignment = NSTextAlignment.right
        self.view.addSubview(labelHumidOutside)
        
        self.labelHumidInside.frame = CGRect(origin: CGPoint(x: screenWidth-130,y :showTempInside.frame.origin.y+showTempInside.frame.size.height-50), size: CGSize(width: 100, height: 50))
        self.labelHumidInside.textColor = UIColorFromHex(0xc303d51)
        self.labelHumidInside.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 25.0)
        self.labelHumidInside.textAlignment = NSTextAlignment.right
        self.view.addSubview(labelHumidInside)
        
        //Create location label
        self.labelLocation.frame = CGRect(origin: CGPoint(x: 30,y :100), size: CGSize(width: screenWidth-60, height: 50))
        self.labelLocation.textColor = UIColor.white
        self.labelLocation.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 80)
        self.labelLocation.numberOfLines = 0
        self.labelLocation.minimumScaleFactor = 0.4
        self.labelLocation.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self.labelLocation.adjustsFontSizeToFitWidth = true
        self.labelLocation.textAlignment = NSTextAlignment.left
        print(self.labelLocation.font)
        view.addSubview(labelLocation)

        let imageView_water_drop_dark = UIImageView(frame: CGRect(origin: CGPoint(x: screenWidth-135,y :showTempInside.frame.origin.y+showTempInside.frame.size.height-34), size: CGSize(width: 16, height: 16)))
        imageView_water_drop_dark.image = druppel
        self.view.addSubview(imageView_water_drop_dark)
        
        let imageView_water_drop_light = UIImageView(frame: CGRect(origin: CGPoint(x: screenWidth-135,y :showTempOutside.frame.origin.y+showTempOutside.frame.size.height-34), size: CGSize(width: 16, height: 16)))
        imageView_water_drop_light.image = druppel_white
        self.view.addSubview(imageView_water_drop_light)
        
        createDot()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func getAPIRequestNeopixels(url_neopixels : String){
        
        Alamofire.request(url_neopixels).responseJSON(completionHandler: {
            response in
            
            self.parseDataNeopixels(JSONDataNeopixels: response.data!)
        })
    }
    
    func parseDataNeopixels(JSONDataNeopixels : Data){
        do{
            let tempJSON = try JSONSerialization.jsonObject(with: JSONDataNeopixels, options: .mutableContainers)  as! JSONStandard
            print("Result: \(tempJSON["temp"])")
            if let temps = tempJSON["temp"] {
                temp_value = temps["temp"] as! String
                air_value = temps["air"] as! String
                temp_buiten = temps["temp_buiten"] as! String
                air_buiten = temps["air_buiten"] as! String
                locatie = temps["Locatie"] as! String
            }
            labelTempInside.text = temp_value + degrees
            labelHumidInside.text = air_value + "%"
            labelTempOutside.text = temp_buiten + degrees
            labelHumidOutside.text = air_buiten + "%"
            labelLocation.text = locatie
        }
        catch{
            print(error)
        }
    }

    
    func getAPIRequestNeopixelsArray(url_neopixels_array : String){
        
        Alamofire.request(url_neopixels_array).responseJSON(completionHandler: {
            response in
            
            self.parseDataNeopixelsArray(JSONDataNeopixelsArray: response.data!)
        })
    }
    
    func parseDataNeopixelsArray(JSONDataNeopixelsArray : Data){
        do{
            let tempJSON = try JSONSerialization.jsonObject(with: JSONDataNeopixelsArray, options: .mutableContainers) as! [AnyObject]
            for i in 0...tempJSON.count-1 {
                var air = tempJSON[i]["avg_air"]!!
                let temp = tempJSON[i]["avg_temp"]!! as! Double
                
                dummytemps.append(String(temp))
                dummyhumid.append(String(describing: air))
                
                let calculation = 18 - temp * 0.15
                tempLast7Array.append(calculation)
                
                let datum2:String = tempJSON[i]["date"]!! as! String
                week.append(datum2)
                
                let temp_side = UILabel()
                temp_side.frame = CGRect(origin: CGPoint(x: screenSize.width/8*CGFloat(i + 1)-10,y :screenSize.height-40), size: CGSize(width: 40, height: 20))
                temp_side.textColor = UIColor.black
                temp_side.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
                temp_side.text = week[i]
                temp_side.textAlignment = NSTextAlignment.center
                self.view.addSubview(temp_side)
                
                point_array.append(CGPoint(x:screenSize.width/8*CGFloat(i + 1)+10, y:screenSize.height/20*CGFloat(tempLast7Array[i])+10))
            }
            print("Temp_array: \(tempLast7Array)")
            if(tempLast7Array.count < 7){
                let warningWeekView = UIView()
                warningWeekView.frame = CGRect(origin: CGPoint(x:7.5, y:screenSize.height/2+30), size: CGSize(width: screenSize.width-15, height: screenSize.height/2-40))
                warningWeekView.backgroundColor = FlatGray()
                warningWeekView.alpha = 0.3
                warningWeekView.layer.cornerRadius = 5
                warningWeekView.layer.shadowOffset = CGSize(width: 2, height: 5)
                warningWeekView.layer.shadowOpacity = 0.3
                self.view.addSubview(warningWeekView)
                
                let warningText = UILabel()
                warningText.frame = CGRect(origin: CGPoint(x: screenSize.width/2-100,y :warningWeekView.frame.origin.y+warningWeekView.frame.size.height/2-25), size: CGSize(width: 200, height: 50))
                warningText.textColor = UIColor.white
                warningText.text = "Not enough measurements for graph"
                warningText.numberOfLines = 0
                warningText.lineBreakMode = .byWordWrapping
                warningText.font = UIFont(name: "AppleSDGothicNeo", size: 18)
                warningText.textAlignment = NSTextAlignment.center
                view.addSubview(warningText)
            }
            else{
                createDot()
            }
        }
        catch{
            print(error)
        }
    }
    

    
    func createDot(){
        for point in point_array{
            
            let value_location = point_array.index(of: point)!
            
            if value_location+1 == 7{
                i = value_location
            }else{
                i = value_location+1
            }
            
            let line :UIBezierPath = UIBezierPath()
            let linelayer = CAShapeLayer()
            line.move(to: point)
            line.addLine(to: point_array[i])
            linelayer.strokeColor = UIColorFromHex(0xc303d51).cgColor
            linelayer.lineWidth = 1.0
            line.stroke()
            linelayer.path = line.cgPath
            view.layer.addSublayer(linelayer)
            
            let circlePath = UIBezierPath(arcCenter: point, radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = UIColorFromHex(0xcecf0f1).cgColor
            shapeLayer.strokeColor = UIColorFromHex(0xc303d51).cgColor
            shapeLayer.lineWidth = 1.0
            view.layer.addSublayer(shapeLayer)
        }
    }
    
    
    func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func someAction(_ sender:UITapGestureRecognizer){
        let location = sender.location(in: self.view)
        for c in 0..<point_array.count{
            let space_up_y = location.y + 40
            let space_down_y = location.y - 40
            let space_up_x = location.x + 40
            let space_down_x = location.x - 40
            if(point_array[c].y < space_up_y && point_array[c].y > space_down_y){
                if(point_array[c].x < space_up_x && point_array[c].x > space_down_x){
                    if(point_array[c].x > UIScreen.main.bounds.width - 80){
                        self.infoSelectedDate.frame = CGRect(origin: CGPoint(x:point_array[c].x - 50,y :point_array[c].y - 85), size: CGSize(width: 60, height: 75))
                        self.infoSelectedDate.backgroundColor = FlatRedDark()
                        self.infoSelectedDate.layer.cornerRadius = 5
                        self.infoSelectedDate.layer.shadowOffset = CGSize(width: 2, height: 5)
                        self.infoSelectedDate.layer.shadowOpacity = 0.3
                        self.view.addSubview(infoSelectedDate)
                        
                        self.temp_label_short_info.frame = CGRect(origin: CGPoint(x:point_array[c].x - 45,y :point_array[c].y - 85), size: CGSize(width: 50, height: 75))
                        self.temp_label_short_info.textColor = UIColor.white
                        self.temp_label_short_info.text = String(describing: dummytemps[c]) + degrees + "\n" + String(dummyhumid[c]) + "%" + "\n" + week[c]
                        self.temp_label_short_info.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 15.0)
                        self.temp_label_short_info.textAlignment = NSTextAlignment.left
                        self.temp_label_short_info.numberOfLines = 3
                        self.view.addSubview(temp_label_short_info)
                        
                        let circlePath = UIBezierPath(arcCenter: point_array[c], radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
                        self.selected_circle.path = circlePath.cgPath
                        self.selected_circle.fillColor = FlatRedDark().cgColor
                        self.selected_circle.strokeColor = UIColorFromHex(0xc303d51).cgColor
                        self.selected_circle.lineWidth = 1.0
                        view.layer.addSublayer(self.selected_circle)
                    }else{
                        self.infoSelectedDate.frame = CGRect(origin: CGPoint(x:point_array[c].x,y :point_array[c].y - 85), size: CGSize(width: 60, height: 75))
                        self.infoSelectedDate.backgroundColor = FlatRedDark()
                        self.infoSelectedDate.layer.cornerRadius = 5
                        self.infoSelectedDate.layer.shadowOffset = CGSize(width: 2, height: 5)
                        self.infoSelectedDate.layer.shadowOpacity = 0.3
                        self.view.addSubview(infoSelectedDate)
                        
                        self.temp_label_short_info.frame = CGRect(origin: CGPoint(x:point_array[c].x + 5,y :point_array[c].y - 85), size: CGSize(width: 50, height: 75))
                        self.temp_label_short_info.textColor = UIColor.white
                        self.temp_label_short_info.text = String(describing: dummytemps[c]) + degrees + "\n" + String(dummyhumid[c]) + "%" + "\n" + week[c]
                        self.temp_label_short_info.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 15.0)
                        self.temp_label_short_info.textAlignment = NSTextAlignment.left
                        self.temp_label_short_info.numberOfLines = 3
                        self.view.addSubview(temp_label_short_info)
                        
                        let circlePath = UIBezierPath(arcCenter: point_array[c], radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
                        self.selected_circle.path = circlePath.cgPath
                        self.selected_circle.fillColor = FlatRedDark().cgColor
                        self.selected_circle.strokeColor = UIColorFromHex(0xc303d51).cgColor
                        self.selected_circle.lineWidth = 1.0
                        view.layer.addSublayer(self.selected_circle)
                    }
                }
            }
        }
    }
    
    func Menu(){
        let menu = UIView()
        menu.frame = CGRect(origin: CGPoint(x:0, y:0), size: CGSize(width: screenSize.width, height: 80))
        menu.backgroundColor = UIColorFromHex(0xcecf0f1)
        menu.layer.shadowOffset = CGSize(width: 2, height: 5)
        menu.layer.shadowOpacity = 0.3
        self.view.addSubview(menu)
        
        let selected_menu = UIView()
        selected_menu.frame = CGRect(origin: CGPoint(x:screenSize.width/4-25, y:75), size: CGSize(width: 50, height: 5))
        selected_menu.backgroundColor = FlatRedDark()
        self.view.addSubview(selected_menu)
        
        let home_btn: UIButton = UIButton(frame: CGRect(origin: CGPoint(x:screenSize.width/4-25, y:40), size: CGSize(width: 50, height: 24)))
        home_btn.setTitleColor(FlatRedDark(), for: .normal)
        home_btn.setTitle("Home", for: .normal)
        home_btn.layer.shadowOffset = CGSize(width: 2, height: 5)
        home_btn.titleLabel!.font = UIFont(name: "AppleSDGothicNeo", size: 15.0)
        home_btn.tag = 1
        self.view.addSubview(home_btn)
        
        let btn: UIButton = UIButton(frame: CGRect(origin: CGPoint(x:screenSize.width/2-25, y:40), size: CGSize(width: 50, height: 24)))
        btn.setTitleColor(FlatRedDark(), for: .normal)
        btn.setTitle("Check", for: .normal)
        btn.layer.shadowOffset = CGSize(width: 2, height: 5)
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btn.titleLabel!.font = UIFont(name: "AppleSDGothicNeo", size: 15.0)
        btn.tag = 2
        self.view.addSubview(btn)
        
        let table_btn: UIButton = UIButton(frame: CGRect(origin: CGPoint(x:screenSize.width/4*3-25, y:40), size: CGSize(width: 50, height: 24)))
        table_btn.setTitleColor(FlatRedDark(), for: .normal)
        table_btn.setTitle("Info", for: .normal)
        table_btn.layer.shadowOffset = CGSize(width: 2, height: 5)
        table_btn.titleLabel!.font = UIFont(name: "AppleSDGothicNeo", size: 15.0)
        table_btn.tag = 3
        table_btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(table_btn)
    }
    
    func buttonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 2 {
            self.present(SecondViewController(), animated: false, completion: nil)
        }
        if btnsendtag.tag == 3 {
            self.present(ShowInfoViewController(), animated: false, completion: nil)
        }
    }
}










//        func parseDataNeopixelsArray(JSONDataNeopixelsArray : Data){
//            do{
//                let tempJSON = try JSONSerialization.jsonObject(with: JSONDataNeopixelsArray, options: .mutableContainers) as! [String : AnyObject]
//                if let temps = tempJSON["temps"] as? [AnyObject] {
//                    print(temps)
//                    let last7 = temps.count - 7
//                    for i in last7..<temps.count{
//                        let tempRequested = (temps[i]["temp"]! as! NSString).doubleValue
//                        dummytemps.append(String((temps[i]["temp"]! as! NSString).doubleValue))
//                        dummyhumid.append(temps[i]["air"]! as! String)
//                        let datum = temps[i]["created_at"] as! String
//                        let rasp_mac = temps[i]["rasp_mac"] as! String
//                        print("Mac adres: \(mac_adres)")
//                        if(rasp_mac == mac_adres){
//                            print("Temperatuur: \(tempRequested)")
//
//                            let calculation = 18 - tempRequested * 0.15
//
//                            tempLast7Array.append(calculation)
//
//                            var datum2 = datum.replacingOccurrences(of: " 00:00:00", with: "")
//                            for i in 1..<6{
//                                datum2.remove(at: datum2.startIndex)
//                            }
//                            for i in 1..<10{
//                                datum2.remove(at: datum2.index(before: datum2.endIndex))
//                            }
//                            print("Datum: \(datum2)")
//                            week.append(datum2)
//                        }
//                    }
//
//                    print("Week temp: \(week)")
//                    print("Temp last 7: \(tempLast7Array)")
//                    for i in 0..<7{
//                        let temp_side = UILabel()
//                        temp_side.frame = CGRect(origin: CGPoint(x: screenSize.width/8*CGFloat(i + 1)-10,y :screenSize.height-40), size: CGSize(width: 40, height: 20))
//                        temp_side.textColor = UIColor.black
//                        temp_side.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
//                        temp_side.text = week[i]
//                        temp_side.textAlignment = NSTextAlignment.center
//                        self.view.addSubview(temp_side)
//                    }
//                    for i in 0..<7{
//                        point_array.append(CGPoint(x:screenSize.width/8*CGFloat(i + 1)+10, y:screenSize.height/20*CGFloat(tempLast7Array[i])+10))
//                    }
//                    print("Last 7 array: \(point_array)")
//                    createDot()
//                }
//            }
//            catch{
//                print(error)
//            }
