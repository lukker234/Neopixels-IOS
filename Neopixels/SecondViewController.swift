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
    var showWeekView = UIView()
    var tempdata = UIView()
    var point_array = [CGPoint]()
    var point_array2 = [CGPoint]()
    var i = Int()
    
    var dummytemps = [String]()
    var dummyhumid = [String]()
    var degrees = "\u{00B0}"
    
    var date_selected = ""
    var btn_clicked = Int()
    
    var btn1:UIButton = UIButton()
    var btn2:UIButton = UIButton()
    let selectfromdate1 = UIView()
    let selectfromdate2 = UIView()
    
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    
    var tempLast7Array = [Double]()
    var second_date = [Double]()
    var week = [String]()
    let mac_adres = "202481589565676"
    var temps = ["0": 18, "10": 16.5, "20": 15, "30": 13.5, "40": 12]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColorFromHex(0xc5C9BBF)
        setView()
        Menu()
        Date_buttons()
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
        
        
        self.tempdata.frame = CGRect(origin: CGPoint(x:7.5, y:screenHeight/4*1+65), size: CGSize(width: screenWidth-15, height: screenHeight/4-45))
        self.tempdata.backgroundColor = UIColorFromHex(0xcecf0f1)
        self.tempdata.layer.cornerRadius = 5
        self.tempdata.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.tempdata.layer.shadowOpacity = 0.3
        self.view.addSubview(tempdata)
        
        for (key,value) in temps{
            
            let temp_side = UILabel()
            temp_side.frame = CGRect(origin: CGPoint(x: 10,y :screenHeight/20*CGFloat(value)), size: CGSize(width: 25, height: 20))
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
            
            self.parseDataNeopixelsArray(JSONDataNeopixelsArray: response.data!)
        })
    }
    
    func parseDataNeopixelsArray(JSONDataNeopixelsArray : Data){
        point_array = [CGPoint]()
        tempLast7Array = [Double]()
        setView()
        createDot2()
        do{
            let tempJSON = try JSONSerialization.jsonObject(with: JSONDataNeopixelsArray, options: .mutableContainers) as! [String : AnyObject]
            if let temps = tempJSON["temps"] as? [AnyObject] {
                for i in 0...temps.count-1 {
                    
                    let air = temps[i]["air"]!!
                    let temp = (temps[i]["temp"]!! as! NSString).doubleValue
                    
                    let calculation = 18 - temp * 0.15
                    tempLast7Array.append(calculation)
                    
                    let datum2:String = temps[i]["created_at"]!! as! String
                    week.append(datum2)
                    
                    point_array.append(CGPoint(x:screenSize.width/8*CGFloat(i + 1)+10, y:screenSize.height/20*CGFloat(tempLast7Array[i])+10))
                }
            }
            createDot()
        }
        catch{
            print(error)
        }
    }
    
    
    func retrieve_data_date_2(url_date_2 : String){
        
        Alamofire.request(url_date_2).responseJSON(completionHandler: {
            response in
            
            self.use_data_date_2(JSON_date_2: response.data!)
        })
    }
    
    func use_data_date_2(JSON_date_2 : Data){
        point_array2 = [CGPoint]()
        second_date = [Double]()
        setView()
        createDot()
        do{
            let tempJSON = try JSONSerialization.jsonObject(with: JSON_date_2, options: .mutableContainers) as! [String : AnyObject]
            if let temps = tempJSON["temps"] as? [AnyObject] {
                for i in 0...temps.count-1 {
                
                    print("Count: \(tempJSON.count)")
                    let air = temps[i]["air"]!!
                    let temp = (temps[i]["temp"]!! as! NSString).doubleValue
                
                    let calculation = 18 - temp * 0.15
                    second_date.append(calculation)
                
                    let datum2:String = temps[i]["created_at"]!! as! String
                    week.append(datum2)
                
                    point_array2.append(CGPoint(x:screenSize.width/8*CGFloat(i + 1)+10, y:screenSize.height/20*CGFloat(second_date[i])+10))
                }
            }
            createDot2()
        }
        catch{
            print(error)
        }
    }
    
    
    
    func createDot(){
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
            
                print("First: \(point)")
            }
        }else if(point_array.count < 7){
            let alert = UIAlertController(title: "Te weinig metingen", message: "Helaas zijn er niet genoeg metingen voor deze dag, kies een andere dag om de vergelijking voort te zetten.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Begrepen", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func createDot2(){
        print("Count_array: \(point_array2.count)")
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
                linelayer.strokeColor = FlatRed().cgColor
                linelayer.lineWidth = 1.0
                line.stroke()
                linelayer.path = line.cgPath
                view.layer.addSublayer(linelayer)
            
                let circlePath = UIBezierPath(arcCenter: point, radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = circlePath.cgPath
                shapeLayer.fillColor = UIColorFromHex(0xcecf0f1).cgColor
                shapeLayer.strokeColor = FlatRed().cgColor
                shapeLayer.lineWidth = 1.0
                view.layer.addSublayer(shapeLayer)
            
                print("Second: \(point)")
            }
        }else if(point_array2.count < 7){
            let alert = UIAlertController(title: "Te weinig metingen", message: "Helaas zijn er niet genoeg metingen voor deze dag, kies een andere dag om de vergelijking voort te zetten.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Begrepen", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        btn.setTitle("Graph", for: .normal)
        btn.layer.shadowOffset = CGSize(width: 2, height: 5)
        btn.titleLabel!.font = UIFont(name: "AppleSDGothicNeo", size: 15.0)
        btn.tag = 3
        self.view.addSubview(btn)
        
//        let table_btn: UIButton = UIButton(frame: CGRect(origin: CGPoint(x:screenSize.width/4*3-25, y:40), size: CGSize(width: 50, height: 24)))
//        table_btn.setTitleColor(FlatRedDark(), for: .normal)
//        table_btn.setTitle("Table", for: .normal)
//        table_btn.layer.shadowOffset = CGSize(width: 2, height: 5)
//        table_btn.titleLabel!.font = UIFont(name: "AppleSDGothicNeo", size: 15.0)
//        table_btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//        table_btn.tag = 2
//        self.view.addSubview(table_btn)
    }
    
    func buttonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 2 {
            self.present(showTempHumWeekViewController(), animated: false, completion: nil)
        }else{
            showCalendar()
            btn_clicked = btnsendtag.tag
        }
    }
    
    func someAction(_ sender:UITapGestureRecognizer){
        let location = sender.location(in: self.view)
        print(location)
        
        temp_date_1.frame = CGRect(origin: CGPoint(x: 10,y :screenSize.height/3+20), size: CGSize(width: 200, height: 20))
        temp_date_1.textColor = UIColor.black
        temp_date_1.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 13.0)
        temp_date_1.text = String(describing: location)
        temp_date_1.textAlignment = NSTextAlignment.center
        self.view.addSubview(temp_date_1)
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
        //titleLabel??.text = date.stringFromFormat("dd'-'MM'-'yyyy")
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
        selectfromdate1.frame = CGRect(origin: CGPoint(x:7.5+screenSize.width/2*0, y:100), size: CGSize(width: screenSize.width/2-15, height: screenSize.height/4-45))
        selectfromdate1.backgroundColor = UIColorFromHex(0xcecf0f1)
        selectfromdate1.layer.cornerRadius = 5
        selectfromdate1.layer.shadowOffset = CGSize(width: 2, height: 5)
        selectfromdate1.layer.shadowOpacity = 0.3
        view.addSubview(selectfromdate1)
        
        selectfromdate2.frame = CGRect(origin: CGPoint(x:7.5+screenSize.width/2*1, y:100), size: CGSize(width: screenSize.width/2-15, height: screenSize.height/4-45))
        selectfromdate2.backgroundColor = UIColorFromHex(0xcecf0f1)
        selectfromdate2.layer.cornerRadius = 5
        selectfromdate2.layer.shadowOffset = CGSize(width: 2, height: 5)
        selectfromdate2.layer.shadowOpacity = 0.3
        view.addSubview(selectfromdate2)
            
        btn1 = UIButton(frame: CGRect(origin: CGPoint(x:7.5+screenSize.width/2*0+15,y :selectfromdate1.frame.height/2+80), size: CGSize(width: screenSize.width/2-50, height: 40)))
        btn1.setTitleColor(UIColorFromHex(0xc303d51), for: .normal)
        btn1.layer.cornerRadius = 5
        btn1.titleLabel!.font =  UIFont(name: "AppleSDGothicNeo-Thin", size: 30.0)
        btn1.setTitle("Select date", for: .normal)
        btn1.titleLabel?.adjustsFontSizeToFitWidth = true
        btn1.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btn1.tag = 0
        self.view.addSubview(btn1)
        
        btn2 = UIButton(frame: CGRect(origin: CGPoint(x:7.5+screenSize.width/2*1+15,y :selectfromdate2.frame.height/2+80), size: CGSize(width: screenSize.width/2-50, height: 40)))
        btn2.setTitleColor(FlatRed(), for: .normal)
        btn2.layer.cornerRadius = 5
        btn2.titleLabel!.font =  UIFont(name: "AppleSDGothicNeo-Thin", size: 30.0)
        btn2.setTitle("Select date", for: .normal)
        btn2.titleLabel?.adjustsFontSizeToFitWidth = true
        btn2.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btn2.tag = 1
        self.view.addSubview(btn2)
    }
}

