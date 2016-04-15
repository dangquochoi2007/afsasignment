//
//  AFSATMViewController.swift
//  assignment
//
//  Created by QuocHoi on 9/4/16.
//  Copyright © 2016 CHOX. All rights reserved.
//

import UIKit
import RealmSwift

class AFSATMViewController: AFSBaseViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, AFSATMEmptyBackgroundDelegate, AFSPositionTableViewCellDelegate {
    
    static var identifier = "AFSATMViewController"
    var userDefaulsValue = NSUserDefaults.standardUserDefaults()
    
    enum atmObjectKeyValue: String {
        case Name
        case City
        case Address
        case Quality
        case Avaiability
        case Longtitude
        case Latitude
    }
    
    @IBOutlet weak var afsAtmScrollView: UIScrollView!
    
    @IBOutlet weak var nameBankTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longtitudeTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var avaiableTextField: UITextField!
    
    var groupTextField = [UITextField]()
    
    var atm: AFSATM?
    var atmListLocal = [AFSATM]() {
        didSet {
            self.atmLocationTableView.reloadData()
        }
    }
    
    @IBOutlet weak var atmLocationTableView: UITableView!
    
    lazy var emptyBackgroundView: UIView? = {
        let emptybackground = AFSATMEmptyBackgroundView.loadNib()
        emptybackground.delegate = self
        return emptybackground
    }()
    
    
    private var userDefaultDataForm = NSUserDefaults.standardUserDefaults()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initAppearance()
        self.setupKeyboardNotifcationListenerForScrollView()
        self.makeRefresh()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.removeKeyboardNotificationListeners()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        self.atm = nil
        self.makeRefresh()
        self.removeUserDefaultTextField()
        self.clearDefaultValueTextField()
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        self.save()
    }

    func initAppearance() {
        self.nameBankTextField.text = userDefaulsValue[atmObjectKeyValue.Name.rawValue].stringValue
        self.latitudeTextField.text = userDefaulsValue[atmObjectKeyValue.Latitude.rawValue].stringValue
        self.longtitudeTextField.text = userDefaulsValue[atmObjectKeyValue.Longtitude.rawValue].stringValue
        self.cityTextField.text = userDefaulsValue[atmObjectKeyValue.City.rawValue].stringValue
        self.addressTextField.text = userDefaulsValue[atmObjectKeyValue.Address.rawValue].stringValue
        self.avaiableTextField.text = userDefaulsValue[atmObjectKeyValue.Avaiability.rawValue].stringValue
        
        self.groupTextField = [nameBankTextField,self.latitudeTextField, self.longtitudeTextField, self.cityTextField ,self.addressTextField, self.avaiableTextField]
        
        for item in groupTextField {
            item.delegate = self
        }
        
        self.atmLocationTableView.delegate = self
        self.atmLocationTableView.dataSource = self
        self.atmLocationTableView.registerNib(UINib(nibName: AFSPositionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AFSPositionTableViewCell.identifier)
        
        self.afsAtmScrollView.delaysContentTouches = true
        self.afsAtmScrollView.canCancelContentTouches = false
    }
    
    
    // MARK: AFSATMEmptyBackgroundDelegate
    func makeRefresh() {
        do {
            guard let atmLocalDatabase = try AFSATM.find() else {
                return
            }
            self.atmListLocal = atmLocalDatabase
        } catch {
            
        }
        
    }
    
    
    
    // MARK:
    
    // MARK: Show and Hide keyboard
    func setupKeyboardNotifcationListenerForScrollView() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        let tapGescognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardFromView(_:)))
        tapGescognizer.delegate = self
        self.view.addGestureRecognizer(tapGescognizer)
    }
    
    func removeKeyboardNotificationListeners() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.adjustingKeyboardFromView(isShow: true, notification: notification)
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        self.adjustingKeyboardFromView(isShow: false, notification: notification)
    }
    
    
    func dismissKeyboardFromView(recognizer: UITapGestureRecognizer) {
        self.resignTextField()
        self.view.endEditing(true)
    }
    
    func adjustingKeyboardFromView(isShow isShow: Bool, notification: NSNotification) {
        if isShow {
            let userInfo = notification.userInfo!
            let keyboardViewEndFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardViewEndFrame.height, 0.0)
            
            self.afsAtmScrollView.contentInset = contentInsets
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardViewEndFrame.height
            
            if (activeTextField != nil && !CGRectContainsPoint(aRect, activeTextField.frame.origin)) {
                self.afsAtmScrollView.scrollRectToVisible(self.activeTextField.frame, animated: true)
            }
        } else {
            let contentInsets = UIEdgeInsetsZero
            self.afsAtmScrollView.contentInset = contentInsets
            self.afsAtmScrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    func resignTextField() {
        self.activeTextField = nil
        for textField in groupTextField {
            textField.resignFirstResponder()
        }
    }
    
    
    func keepUserDefaultTextField() {
        userDefaulsValue[atmObjectKeyValue.Name.rawValue] = self.nameBankTextField.text
        userDefaulsValue[atmObjectKeyValue.Latitude.rawValue] = self.latitudeTextField.text
        userDefaulsValue[atmObjectKeyValue.Longtitude.rawValue] = self.longtitudeTextField.text
        userDefaulsValue[atmObjectKeyValue.City.rawValue] = self.cityTextField.text
        userDefaulsValue[atmObjectKeyValue.Address.rawValue] = self.addressTextField.text
        userDefaulsValue[atmObjectKeyValue.Avaiability.rawValue] = self.avaiableTextField.text
    }
    
    func removeUserDefaultTextField() {
        userDefaulsValue[atmObjectKeyValue.Name.rawValue] = nil
        userDefaulsValue[atmObjectKeyValue.Latitude.rawValue] = nil
        userDefaulsValue[atmObjectKeyValue.Longtitude.rawValue] = nil
        userDefaulsValue[atmObjectKeyValue.City.rawValue] = nil
        userDefaulsValue[atmObjectKeyValue.Address.rawValue] = nil
        userDefaulsValue[atmObjectKeyValue.Avaiability.rawValue] = nil
    }
    
    
    func clearDefaultValueTextField() {
        self.nameBankTextField.text = nil
        self.latitudeTextField.text = nil
        self.longtitudeTextField.text = nil
        self.cityTextField.text = nil
        self.addressTextField.text = nil
        self.avaiableTextField.text = nil
    }
    
    
    // MARK: TextField Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeTextField = nil
        self.keepUserDefaultTextField()
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.resignTextField()
        return true
    }
    
    
    
    
    // Validate ATM
    func atmValidateSuccess() -> Bool {
        
        self.keepUserDefaultTextField()
        self.resignTextField()
        
        for field in groupTextField {
            field.removeRedBorder()
            guard let _ =  field.text where Validator.required(field.text!) else {
                field.addRedBorder()
                field.shake()
                return false
            }
            
        }
        
        return true
    }
    
    // save reaml object
    func save() {
        if self.atmValidateSuccess() {
            guard
                let nameBank = self.nameBankTextField.text,
                let latitude = Double(self.latitudeTextField.text!)  ,
                let longtitude = Double(self.longtitudeTextField.text!),
                let city = self.cityTextField.text,
                let address = self.addressTextField.text,
                let avaiable = self.avaiableTextField.text else {
                    return
            }
            
            let value = [
                "bank": nameBank,
                "latidude": latitude,
                "longtitude" : longtitude,
                "city": city,
                "address": address,
                "service": avaiable
            ]
            
            if self.atm == nil {
                
                atm = AFSATM(value: value)
                do {
                    try atm?.insert()
                    atm = nil
                    self.makeRefresh()
                    self.clearDefaultValueTextField()
                    self.removeUserDefaultTextField()
                }catch {
                }
            } else {
                do {
                    try atm?.update(bank: nameBank, city: city, address: address, quality: 0, service: avaiable, latitude: latitude, longitude: longtitude)
                    atm = nil
                    self.makeRefresh()
                    self.clearDefaultValueTextField()
                    self.removeUserDefaultTextField()
                } catch {
                }
            }
        }
    }
    
    // Table View Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.atmListLocal.count <= 0 {
            self.atmLocationTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            self.atmLocationTableView.backgroundView?.hidden = false
            self.atmLocationTableView.backgroundView = self.emptyBackgroundView
        } else {
            self.atmLocationTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            self.atmLocationTableView.backgroundView?.hidden = true
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.atmListLocal.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AFSPositionTableViewCell.identifier, forIndexPath: indexPath) as! AFSPositionTableViewCell
        cell.atm = self.atmListLocal[indexPath.row]
        cell.delegate = self
        cell.initAppearance()
        return cell
    }
    
    
    func makeChooseAtm(atm: AFSATM?) {
        guard let _ = atm else {
            return
        }
        self.atm = atm
    
        self.nameBankTextField.text = self.atm?.bank
        self.latitudeTextField.text = String(format: "%.1f",self.atm!.latitude)
        self.longtitudeTextField.text = String(format: "%.1f",self.atm!.longitude)
        self.cityTextField.text = self.atm?.city
        self.addressTextField.text = self.atm?.address
        self.avaiableTextField.text = self.atm?.service

    }

}
