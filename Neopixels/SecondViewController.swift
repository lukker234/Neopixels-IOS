//
//  SecondViewController.swift
//  Neopixels
//
//  Created by luc daalmeijer on 12/10/2016.
//  Copyright © 2016 Blue90. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import ChameleonFramework
import WWCalendarTimeSelector

class SecondViewController: UIViewController, WWCalendarTimeSelectorProtocol{

    let screenSize: CGRect = UIScreen.main.bounds
    var topBar = UIView()
    let label = UILabel()
    var dateFormatter = DateFormatter()
    let labelTempInside = UILabel()
    let temp_date_1 = UILabel()
    let temp_outside_1 = UILabel()
    let temp_outside_2 = UILabel()
    let humid_outside_1 = UILabel()
    let humid_outside_2 = UILabel()
    let temp_date_2 = UILabel()
    let humid_date_1 = UILabel()
    let humid_date_2 = UILabel()
    let compare_temp = UILabel()
    var showWeekView = UIView()
    var tempdata_1 = UIView()
    var tempdata_2 = UIView()
    var point_array = [CGPoint]()
    var point_array2 = [CGPoint]()
    var i = Int()
    let selected_circle = CAShapeLayer()
    let selected_circle2 = CAShapeLayer()
    
    var instruction_line = UILabel()
    var instruction_line_2 = UILabel()
    
    var temp_1 = [String]()
    var humid_1 = [String]()
    var outside_temp_1 = [String]()
    var outside_humid_1 = [String]()
    var outside_temp_2 = [String]()
    var outside_humid_2 = [String]()
    var temp_2 = [String]()
    var humid_2 = [String]()
    var degrees = "\u{00B0}"
    
    var date_selected = ""
    var btn_clicked = Int()
    
    var btn1:UIButton = UIButton()
    var btn2:UIButton = UIButton()
    let selectfromdate1 = UIView()
    let selectfromdate2 = UIView()
    
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    
    let date = Date()
    let formatter = DateFormatter()
    var result = ""
    
    var tempLast7Array = [Double]()
    var second_date = [Double]()
    var week = [String]()
    let mac_adres = "202481589565676"
    var temps = ["0\u{00B0}": 18, "10\u{00B0}": 16.5, "20\u{00B0}": 15, "30\u{00B0}": 13.5, "40\u{00B0}": 12]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        self.view.backgroundColor = FlatSkyBlue()
        formatter.dateFormat = "yyyy-MM-dd"
        result = formatter.string(from: date)
        print("date: \(result)")
        setView()
        Menu()
        Date_buttons()
        
        self.instruction_line.frame = CGRect(origin: CGPoint(x: 7.5,y :tempdata_1.frame.origin.y+tempdata_1.frame.size.height/2-10), size: CGSize(width: screenWidth/2-15, height: 20))
        self.instruction_line.text = "Select date to compare."
        self.instruction_line.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
        self.instruction_line.textColor = FlatWhite()
        self.instruction_line.textAlignment = .center
        self.view.addSubview(instruction_line)
        
        self.instruction_line_2.frame = CGRect(origin: CGPoint(x: screenWidth/2+7.5,y :tempdata_2.frame.origin.y+tempdata_2.frame.size.height/2-10), size: CGSize(width: screenWidth/2-15, height: 20))
        self.instruction_line_2.text = "Select date to compare."
        self.instruction_line_2.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
        self.instruction_line_2.textColor = UIColorFromHex(0xc303d51)
        self.instruction_line_2.textAlignment = .center
        self.view.addSubview(instruction_line_2)
    }
    
    func setView(){
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //Create view for weekview
        self.showWeekView.frame = CGRect(origin: CGPoint(x:7.5, y:screenHeight/2+30), size: CGSize(width: screenWidth-15, height: screenHeight/2-40))
        self.showWeekView.backgroundColor = UIColorFromHex(0xcecf0f1)
        self.showWeekView.layer.cornerRadius = 5
        self.showWeekView.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.showWeekView.layer.shadowOpacity = 0.3
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someAction(_:)))
        self.showWeekView.addGestureRecognizer(gesture)
        self.view.addSubview(showWeekView)
        
        
        self.tempdata_1.frame = CGRect(origin: CGPoint(x:7.5, y:screenHeight/6*1+65), size: CGSize(width: screenWidth/2-15, height: screenHeight/4-45))
        self.tempdata_1.backgroundColor = FlatRedDark()
        self.tempdata_1.layer.cornerRadius = 5
        self.tempdata_1.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.tempdata_1.layer.shadowOpacity = 0.3
        self.view.addSubview(tempdata_1)
        
        self.tempdata_2.frame = CGRect(origin: CGPoint(x:screenWidth/2+7.5, y:screenHeight/6*1+65), size: CGSize(width: screenWidth/2-15, height: screenHeight/4-45))
        self.tempdata_2.backgroundColor = UIColorFromHex(0xcecf0f1)
        self.tempdata_2.layer.cornerRadius = 5
        self.tempdata_2.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.tempdata_2.layer.shadowOpacity = 0.3
        self.view.addSubview(tempdata_2)
        
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
    
    
    
    func getAPIRequestNeopixelsArray(url_neopixels_array : String){
        
        Alamofire.request(url_neopixels_array).responseJSON(completionHandler: {
            response in
            print("Response: \(response.response!.statusCode)")
            if(response.response!.statusCode == 500){
                self.low_Mes()
            }
            else{
                self.parseDataNeopixelsArray(JSONDataNeopixelsArray: response.data!)
            }
        })
    }
    
    func parseDataNeopixelsArray(JSONDataNeopixelsArray : Data){
        point_array = [CGPoint]()
        tempLast7Array = [Double]()
        temp_1 = [String]()
        humid_1 = [String]()
        outside_temp_1 = [String]()
        outside_humid_1 = [String]()
        setView()
        createDot2()
            do{
                let tempJSON = try JSONSerialization.jsonObject(with: JSONDataNeopixelsArray, options: .mutableContainers) as! [AnyObject]
                print("Count_JSON: \(tempJSON.count)")
                if(tempJSON.count == 7){
                    for i in 0...tempJSON.count-1 {
                    
                        let air = tempJSON[i]["air"]!!
                        let air_outside = tempJSON[i]["air_buiten"]!!
                        let temp = tempJSON[i]["temp"]!! as! Double
                        let temp_outside = tempJSON[i]["temp_buiten"]!! as! Double
                        
                        let calculation = 18 - temp * 0.15
                        tempLast7Array.append(calculation)
                        temp_1.append(String(temp))
                        humid_1.append(String(describing: air))
                        outside_temp_1.append(String(temp_outside))
                        outside_humid_1.append(String(describing: air_outside))
                    
                        let datum2:String = tempJSON[i]["time"]!! as! String
                        week.append(datum2)
                        
                        let temp_side = UILabel()
                        temp_side.frame = CGRect(origin: CGPoint(x: screenSize.width/8*CGFloat(i + 1)-10,y :screenSize.height-40), size: CGSize(width: 40, height: 20))
                        temp_side.textColor = UIColor.black
                        temp_side.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
                        temp_side.text = week[i]
                        temp_side.textAlignment = NSTextAlignment.center
                        self.view.addSubview(temp_side)
                    
                        point_array.append(CGPoint(x:screenSize.width/8*CGFloat(i + 1)+10, y:screenSize.height/20*CGFloat(tempLast7Array[i])+10))
                        print(tempJSON[i]["temp"]!!)
                    }
                    self.instruction_line.text = ""
                    createDot()
                }
                else{
                    low_Mes()
                }
        }
        catch{
            print(error)
        }
    }
    
    
    func retrieve_data_date_2(url_date_2 : String){
        
        Alamofire.request(url_date_2).responseJSON(completionHandler: {
            response in
            if(response.response!.statusCode == 500){
                self.low_Mes()
            }
            else{
                self.use_data_date_2(JSON_date_2: response.data!)
            }
        })
    }
    
    func use_data_date_2(JSON_date_2 : Data){
        point_array2 = [CGPoint]()
        second_date = [Double]()
        temp_2 = [String]()
        humid_2 = [String]()
        outside_temp_2 = [String]()
        outside_humid_2 = [String]()
        setView()
        createDot()
        print("Dots: \(JSON_date_2.count)")
        do{
            let tempJSON = try JSONSerialization.jsonObject(with: JSON_date_2, options: .mutableContainers) as! [AnyObject]
            if(tempJSON.count == 7){
                for i in 0...tempJSON.count-1 {
                    let air = tempJSON[i]["air"]!!
                    let air_outside = tempJSON[i]["air_buiten"]!!
                    let temp = tempJSON[i]["temp"]!! as! Double
                    let temp_outside = tempJSON[i]["temp_buiten"]!! as! Double
                    
                    let calculation = 18 - temp * 0.15
                    second_date.append(calculation)
                    temp_2.append(String(temp))
                    humid_2.append(String(describing: air))
                    outside_temp_2.append(String(temp_outside))
                    outside_humid_2.append(String(describing: air_outside))
                
                    let datum2:String = tempJSON[i]["time"]!! as! String
                    week.append(datum2)
                    
                    let temp_side = UILabel()
                    temp_side.frame = CGRect(origin: CGPoint(x: screenSize.width/8*CGFloat(i + 1)-10,y :screenSize.height-40), size: CGSize(width: 40, height: 20))
                    temp_side.textColor = UIColor.black
                    temp_side.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
                    temp_side.text = week[i]
                    temp_side.textAlignment = NSTextAlignment.center
                    self.view.addSubview(temp_side)
                    
                    point_array2.append(CGPoint(x:screenSize.width/8*CGFloat(i + 1)+10, y:screenSize.height/20*CGFloat(second_date[i])+10))
                }
            self.instruction_line_2.text = ""
            print("Datums: \(week)")
            createDot2()
            }else{
                low_Mes()
            }
        }
        catch{
            print(error)
        }
    }
    
    
    
    func createDot(){
        print("Count_array_1: \(point_array.count)")
        if (point_array.count == 7){
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
                linelayer.strokeColor = FlatRedDark().cgColor
                linelayer.lineWidth = 1.0
                line.stroke()
                linelayer.path = line.cgPath
                view.layer.addSublayer(linelayer)
            
                let circlePath = UIBezierPath(arcCenter: point, radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = circlePath.cgPath
                shapeLayer.fillColor = UIColorFromHex(0xcecf0f1).cgColor
                shapeLayer.strokeColor = FlatRedDark().cgColor
                shapeLayer.lineWidth = 1.0
                view.layer.addSublayer(shapeLayer)
            
                print("First: \(point)")
            }
        }
    }
    
    
    func createDot2(){
        print("Count_array_2: \(point_array2.count)")
        if (point_array2.count == 7){
            for point in point_array2{
            
                let value_location = point_array2.index(of: point)!
            
                if value_location+1 == 7{
                    i = value_location
                    print("Value location-1: \(i)")
                }else{
                    i = value_location+1
                    print("Value location-2: \(i)")
                }
            
                let line :UIBezierPath = UIBezierPath()
                let linelayer = CAShapeLayer()
                line.move(to: point)
                line.addLine(to: point_array2[i])
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
            
                print("Second: \(point)")
            }
        }
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
        selected_menu.frame = CGRect(origin: CGPoint(x:screenSize.width/2-25, y:75), size: CGSize(width: 50, height: 5))
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
        self.view.addSubview(btn)
        
        let table_btn: UIButton = UIButton(frame: CGRect(origin: CGPoint(x:screenSize.width/4*3-25, y:40), size: CGSize(width: 50, height: 24)))
        table_btn.setTitleColor(FlatRedDark(), for: .normal)
        table_btn.setTitle("Info", for: .normal)
        table_btn.layer.shadowOffset = CGSize(width: 2, height: 5)
        table_btn.titleLabel!.font = UIFont(name: "AppleSDGothicNeo", size: 15.0)
        table_btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        table_btn.tag = 3
        self.view.addSubview(table_btn)
    }
    
    func buttonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 2 {
            self.present(showTempHumWeekViewController(), animated: false, completion: nil)
        }
        if btnsendtag.tag == 3 {
            self.present(ShowInfoViewController(), animated: false, completion: nil)
        }
        else{
            showCalendar()
            btn_clicked = btnsendtag.tag
        }
    }
    
    func someAction(_ sender:UITapGestureRecognizer){
        let location = sender.location(in: self.view)
        print(location)
        
        for c in 0..<point_array.count{
            let space_up_x = location.x + 20
            let space_down_x = location.x - 20
            if(point_array[c].x < space_up_x && point_array[c].x > space_down_x){
                
                temp_date_1.frame = CGRect(origin: CGPoint(x: 10,y :screenSize.height/4+30), size: CGSize(width: screenSize.width/4-15, height: 50))
                temp_date_1.textColor = FlatWhite()
                temp_date_1.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
                temp_date_1.text = String(describing: temp_1[c]) + degrees
                temp_date_1.textAlignment = NSTextAlignment.center
                self.view.addSubview(temp_date_1)
                
                temp_date_2.frame = CGRect(origin: CGPoint(x: screenSize.width/2+5,y :screenSize.height/4+30), size: CGSize(width: screenSize.width/4-15, height: 50))
                temp_date_2.textColor = UIColor.black
                temp_date_2.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
                temp_date_2.text = String(describing: temp_2[c]) + degrees
                temp_date_2.textAlignment = NSTextAlignment.center
                self.view.addSubview(temp_date_2)
                
                humid_date_1.frame = CGRect(origin: CGPoint(x: 10,y :screenSize.height/4+50), size: CGSize(width: screenSize.width/4-15, height: 50))
                humid_date_1.textColor = FlatWhite()
                humid_date_1.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
                humid_date_1.text = String(describing: humid_1[c]) + "%"
                humid_date_1.textAlignment = NSTextAlignment.center
                self.view.addSubview(humid_date_1)
                
                humid_date_2.frame = CGRect(origin: CGPoint(x: screenSize.width/2+5,y :screenSize.height/4+50), size: CGSize(width: screenSize.width/4-15, height: 50))
                humid_date_2.textColor = UIColor.black
                humid_date_2.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
                humid_date_2.text = String(describing: humid_2[c]) + "%"
                humid_date_2.textAlignment = NSTextAlignment.center
                self.view.addSubview(humid_date_2)
                
                temp_outside_1.frame = CGRect(origin: CGPoint(x: screenSize.width/4*1,y :screenSize.height/4+30), size: CGSize(width: screenSize.width/4-15, height: 50))
                temp_outside_1.textColor = FlatWhite()
                temp_outside_1.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
                temp_outside_1.text = String(describing: outside_temp_1[c]) + degrees
                temp_outside_1.textAlignment = NSTextAlignment.center
                self.view.addSubview(temp_outside_1)
                
                humid_outside_1.frame = CGRect(origin: CGPoint(x: screenSize.width/4*1,y :screenSize.height/4+50), size: CGSize(width: screenSize.width/4-15, height: 50))
                humid_outside_1.textColor = FlatWhite()
                humid_outside_1.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
                humid_outside_1.text = String(describing: outside_humid_1[c]) + "%"
                humid_outside_1.textAlignment = NSTextAlignment.center
                self.view.addSubview(humid_outside_1)
                
                temp_outside_2.frame = CGRect(origin: CGPoint(x: screenSize.width/4*3,y :screenSize.height/4+30), size: CGSize(width: screenSize.width/4-15, height: 50))
                temp_outside_2.textColor = UIColor.black
                temp_outside_2.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
                temp_outside_2.text = String(describing: outside_temp_2[c]) + degrees
                temp_outside_2.textAlignment = NSTextAlignment.center
                self.view.addSubview(temp_outside_2)
                
                humid_outside_2.frame = CGRect(origin: CGPoint(x: screenSize.width/4*3,y :screenSize.height/4+50), size: CGSize(width: screenSize.width/4-15, height: 50))
                humid_outside_2.textColor = UIColor.black
                humid_outside_2.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
                humid_outside_2.text = String(describing: outside_humid_2[c]) + "%"
                humid_outside_2.textAlignment = NSTextAlignment.center
                self.view.addSubview(humid_outside_2)
                
                let home_label = UILabel()
                home_label.frame = CGRect(origin: CGPoint(x: 7.5,y :tempdata_1.frame.origin.y+7.5), size: CGSize(width: tempdata_1.frame.size.width/2, height: 20))
                home_label.textColor = FlatWhite()
                home_label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 18.0)
                home_label.text = "Home"
                home_label.textAlignment = NSTextAlignment.center
                self.view.addSubview(home_label)
                
                let home_label_2 = UILabel()
                home_label_2.frame = CGRect(origin: CGPoint(x: tempdata_2.frame.origin.x ,y :tempdata_2.frame.origin.y+7.5), size: CGSize(width: tempdata_2.frame.size.width/2, height: 20))
                home_label_2.textColor = UIColor.black
                home_label_2.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 18.0)
                home_label_2.text = "Home"
                home_label_2.textAlignment = NSTextAlignment.center
                self.view.addSubview(home_label_2)
                
                let outside_label = UILabel()
                outside_label.frame = CGRect(origin: CGPoint(x: 7.5+tempdata_1.frame.size.width/2,y :tempdata_1.frame.origin.y+7.5), size: CGSize(width: tempdata_1.frame.size.width/2, height: 20))
                outside_label.textColor = FlatWhite()
                outside_label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 18.0)
                outside_label.text = "Outside"
                outside_label.textAlignment = NSTextAlignment.center
                self.view.addSubview(outside_label)
                
                let outside_label_2 = UILabel()
                outside_label_2.frame = CGRect(origin: CGPoint(x: tempdata_2.frame.origin.x+tempdata_2.frame.size.width/2 ,y :tempdata_2.frame.origin.y+7.5), size: CGSize(width: tempdata_2.frame.size.width/2, height: 20))
                outside_label_2.textColor = UIColor.black
                outside_label_2.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 18.0)
                outside_label_2.text = "Outside"
                outside_label_2.textAlignment = NSTextAlignment.center
                self.view.addSubview(outside_label_2)
                
                let line :UIBezierPath = UIBezierPath()
                let linelayer = CAShapeLayer()
                line.move(to: CGPoint(x: 15,y :tempdata_1.frame.origin.y+27.5))
                line.addLine(to: CGPoint(x: tempdata_1.frame.size.width,y :tempdata_1.frame.origin.y+27.5))
                linelayer.strokeColor = FlatWhite().cgColor
                linelayer.lineWidth = 0.5
                line.stroke()
                linelayer.path = line.cgPath
                view.layer.addSublayer(linelayer)
                
                let line_2 :UIBezierPath = UIBezierPath()
                let linelayer_2 = CAShapeLayer()
                line_2.move(to: CGPoint(x: tempdata_2.frame.origin.x+7.5,y :tempdata_2.frame.origin.y+27.5))
                line_2.addLine(to: CGPoint(x: tempdata_2.frame.origin.x+tempdata_2.frame.size.width-7.5,y :tempdata_2.frame.origin.y+27.5))
                linelayer_2.strokeColor = FlatBlack().cgColor
                linelayer_2.lineWidth = 0.5
                line_2.stroke()
                linelayer_2.path = line_2.cgPath
                view.layer.addSublayer(linelayer_2)
                
                let line_vertical_1 :UIBezierPath = UIBezierPath()
                let linelayer_vertical_1 = CAShapeLayer()
                line_vertical_1.move(to: CGPoint(x: tempdata_1.frame.origin.x+tempdata_1.frame.size.width/2,y :tempdata_1.frame.origin.y+27.5))
                line_vertical_1.addLine(to: CGPoint(x: tempdata_1.frame.origin.x+tempdata_1.frame.size.width/2,y :tempdata_1.frame.origin.y+tempdata_1.frame.size.height-7.5))
                linelayer_vertical_1.strokeColor = FlatWhite().cgColor
                linelayer_vertical_1.lineWidth = 0.5
                line_vertical_1.stroke()
                linelayer_vertical_1.path = line_vertical_1.cgPath
                view.layer.addSublayer(linelayer_vertical_1)
                
                let line_vertical_2 :UIBezierPath = UIBezierPath()
                let linelayer_vertical_2 = CAShapeLayer()
                line_vertical_2.move(to: CGPoint(x: tempdata_2.frame.origin.x+tempdata_2.frame.size.width/2,y :tempdata_2.frame.origin.y+27.5))
                line_vertical_2.addLine(to: CGPoint(x: tempdata_2.frame.origin.x+tempdata_2.frame.size.width/2,y :tempdata_2.frame.origin.y+tempdata_2.frame.size.height-7.5))
                linelayer_vertical_2.strokeColor = FlatBlack().cgColor
                linelayer_vertical_2.lineWidth = 0.5
                line_vertical_2.stroke()
                linelayer_vertical_2.path = line_vertical_2.cgPath
                view.layer.addSublayer(linelayer_vertical_2)
                
                let circlePath = UIBezierPath(arcCenter: point_array[c], radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
                self.selected_circle.path = circlePath.cgPath
                self.selected_circle.fillColor = FlatRedDark().cgColor
                self.selected_circle.strokeColor = UIColorFromHex(0xc303d51).cgColor
                self.selected_circle.lineWidth = 1.0
                view.layer.addSublayer(self.selected_circle)
                
                let circlePath2 = UIBezierPath(arcCenter: point_array2[c], radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
                self.selected_circle2.path = circlePath2.cgPath
                self.selected_circle2.fillColor = FlatRedDark().cgColor
                self.selected_circle2.strokeColor = UIColorFromHex(0xc303d51).cgColor
                self.selected_circle2.lineWidth = 1.0
                view.layer.addSublayer(self.selected_circle2)
            }
        }
    }
    
    func showCalendar() {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        
        selector.optionStyles.showDateMonth(true)
        
        selector.optionTopPanelBackgroundColor = FlatRedDark()
        selector.optionSelectorPanelBackgroundColor = FlatRed()
        selector.optionButtonFontColorDone = FlatRedDark()
        selector.optionButtonFontColorCancel = FlatRedDark()
        selector.optionCalendarBackgroundColorTodayHighlight = FlatRed()
        selector.optionCalendarBackgroundColorPastDatesHighlight = FlatRed()
        selector.optionCalendarBackgroundColorFutureDatesHighlight = FlatRed()
        /*
         Any other options are to be set before presenting selector!
         */
        present(selector, animated: true, completion: nil)
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print(date)
        date_selected = date.stringFromFormat("yyyy'-'MM'-'dd")
        if btn_clicked == 0{
            btn1.titleLabel?.text = date.stringFromFormat("dd'-'MM'-'yyyy")
            let set_date_1 = "http://86.82.142.15/public/api/date/\(date_selected)/temps/\(mac_adres)"
            self.getAPIRequestNeopixelsArray(url_neopixels_array: set_date_1)
        }
        if btn_clicked == 1{
            btn2.titleLabel?.text = date.stringFromFormat("dd'-'MM'-'yyyy")
            let set_date_2 = "http://86.82.142.15/public/api/date/\(date_selected)/temps/\(mac_adres)"
            self.retrieve_data_date_2(url_date_2: set_date_2)
        }
    }
    
    func Date_buttons(){
        selectfromdate1.frame = CGRect(origin: CGPoint(x:7.5+screenSize.width/2*0, y:100), size: CGSize(width: screenSize.width/2-15, height: screenSize.height/6-45))
        selectfromdate1.backgroundColor = FlatRedDark()
        selectfromdate1.layer.cornerRadius = 5
        selectfromdate1.layer.shadowOffset = CGSize(width: 2, height: 5)
        selectfromdate1.layer.shadowOpacity = 0.3
        view.addSubview(selectfromdate1)
        
        selectfromdate2.frame = CGRect(origin: CGPoint(x:7.5+screenSize.width/2*1, y:100), size: CGSize(width: screenSize.width/2-15, height: screenSize.height/6-45))
        selectfromdate2.backgroundColor = UIColorFromHex(0xcecf0f1)
        selectfromdate2.layer.cornerRadius = 5
        selectfromdate2.layer.shadowOffset = CGSize(width: 2, height: 5)
        selectfromdate2.layer.shadowOpacity = 0.3
        view.addSubview(selectfromdate2)
            
        btn1 = UIButton(frame: CGRect(origin: CGPoint(x:7.5+screenSize.width/2*0+15, y:selectfromdate1.frame.height/2+80), size: CGSize(width: screenSize.width/2-50, height: 40)))
        btn1.setTitleColor(FlatWhite(), for: .normal)
        btn1.layer.cornerRadius = 5
        btn1.titleLabel!.font =  UIFont(name: "AppleSDGothicNeo-Thin", size: 30.0)
        btn1.setTitle("Select date", for: .normal)
        btn1.titleLabel?.adjustsFontSizeToFitWidth = true
        btn1.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btn1.tag = 0
        self.view.addSubview(btn1)
        
        btn2 = UIButton(frame: CGRect(origin: CGPoint(x:7.5+screenSize.width/2*1+15,y :selectfromdate2.frame.height/2+80), size: CGSize(width: screenSize.width/2-50, height: 40)))
        btn2.setTitleColor(UIColorFromHex(0xc303d51), for: .normal)
        btn2.layer.cornerRadius = 5
        btn2.titleLabel!.font =  UIFont(name: "AppleSDGothicNeo-Thin", size: 30.0)
        btn2.setTitle("Select date", for: .normal)
        btn2.titleLabel?.adjustsFontSizeToFitWidth = true
        btn2.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btn2.tag = 1
        self.view.addSubview(btn2)
    }
    
    func low_Mes(){
        let alert = UIAlertController(title: "Not enough measurements", message: "Unfortunately, there are not enough measurements for this day, choose another day to continue the comparison.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

