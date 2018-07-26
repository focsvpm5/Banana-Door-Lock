//
//  FSCalendarScopeViewController.swift
//  Banana Door Lock
//
//  Created by Apple Macintosh on 7/12/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import UIKit
import FSCalendar
import Alamofire
import RealmSwift

class FSCalendarScopeExampleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    // history API
    var ok = "ok"
    
    // Realm
    let realm = try! Realm()
    var items : Results<historyDate>?
    var item:historyDate!
    
    var historyToRoom : selectedRoom!
    
    var tokenWithUserDoor : String = ""
    
    let identifier = "historyCellIdentifier"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var datePicked: UILabel!
    
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" //"yyyy/MM/dd"
        return formatter
    }()
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Image needs to be added to project.
        let buttonIcon = UIImage(named: "back")
        
        let leftBarButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.done, target: self, action: #selector(FSCalendarScopeExampleViewController.myLeftSideBarButtonItemTapped))
        leftBarButton.image = buttonIcon
        leftBarButton.tintColor = .white
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        if let userDoorlock = realm.objects(userDoor.self).last {
            self.tokenWithUserDoor = userDoorlock.token
            print("Token is : \(tokenWithUserDoor)")
        }
        
        let nib = UINib(nibName: "historyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        
        // set date for label
        datePicked.text = self.dateFormatter.string(from: Date())
        
        historyAPI {
            self.tableView.reloadData()
        }
        
        // Realm
        self.items = realm.objects(historyDate.self)
        try! realm.write {
            realm.delete(items!)
        }
        
        setStatusBarBackgroundColor(color: .init(red: 65/255.0, green: 195/255.0, blue: 0, alpha: 1))
        
        
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
    }
    
    deinit {
        print("\(#function)")
    }
    
    @objc func myLeftSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        print("myLeftSideBarButtonItemTapped")
        let userRoomView = storyboard?.instantiateViewController(withIdentifier: "userController")as! userController
        let userSelect = self.historyToRoom
        userRoomView.selectToRoom = userSelect
        print("AAAAAAAAAAAAAAAAAAAAA: \(userSelect!)")
        //present(userView, animated: true, completion: nil)
        self.navigationController?.pushViewController(userRoomView, animated: true)
    }
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        datePicked.text = self.dateFormatter.string(from: date)          // set datePicked
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        historyAPI {
            self.tableView.reloadData()
        }
        self.items = self.realm.objects(historyDate.self)
        try! self.realm.write {
            self.realm.delete(self.items!)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    // MARK:- UITableViewDataSource
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? historyTableViewCell
        let data = self.items![indexPath.row]
        cell?.configure(withRealm: data)
        return cell!
    }
    
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("select")
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.5
//    }
    
    // API history day
    func historyAPI (completetion : @escaping () -> ()) {
        
        let parameters: Parameters = ["room_id": "\(historyToRoom.room_id)", "day": "\(datePicked.text!)"]
        let baseURL = "http://january.banana.co.th/api/admin/room-history-day"
        //let header = ["Apikey": "banana_app_iot", "Content-Type": "application/x-www-form-urlencoded"]
        let header = ["token": "\(tokenWithUserDoor)"]
        print(parameters)
        Alamofire.request(baseURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                //print(response.description)
                if let result = response.result.value {

                    let JSON = result as! NSDictionary
                    let status = JSON["status"] as! String
                    if status == self.ok {
                        self.noDataLabel.isHidden = true
                        let messageData = JSON["message"] as? [[String:String]]
                        let localArray = messageData
                        print("Local Array:", localArray!)
                        for i in 0..<localArray!.count {
                            let dic = localArray![i]
                            let firstname = dic["firstname"]
                            let lastname = dic["lastname"]
                            let date = dic["date"]
                            let indexStartOfText = date!.index((date?.startIndex)!, offsetBy: 11)
                            let substringDay = date![indexStartOfText...]
                            print(substringDay)
                            let history = historyDate(_firstName: firstname!, _lastName: lastname!, _date: String(substringDay))
                            print(history)
                            RealmService.share.create(history)
                        }
                    } else {
                        print(status)
                        self.noDataLabel.isHidden = false
                    }
                }
                completetion()
            }
    }
    
    // MARK:- Target actions
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}
