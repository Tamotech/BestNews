//
//  ApplyFamousController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/10.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import PopupDialog
import ImagePicker

///申请名人
class ApplyFamousController: BaseViewController, ImagePickerDelegate, ProfessionListControllerDelegate {

    @IBOutlet weak var nicknameLb: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var phonetf: UITextField!
    
    @IBOutlet weak var icodetf: UITextField!
    
    @IBOutlet weak var companytf: UITextField!
    
    @IBOutlet weak var professiontf: UITextField!
    
    @IBOutlet weak var jobtf: UITextField!
    
    @IBOutlet weak var labelsContainerView: LabelsContainerView!
    
    @IBOutlet weak var labelsContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var businessCardBtn: UIButton!
    
    @IBOutlet weak var submitbt: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var model = ApplyFamousModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showCustomTitle(title: "申请名人")
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "iconBack"), style: .plain, target: self, action: #selector(handleTapBackButton(_:)))
        navigationItem.leftBarButtonItem = backBtn
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if SessionManager.sharedInstance.famousTagArr.count == 0 {
            SessionManager.sharedInstance.getTags()
        }
        companytf.addTarget(self, action: #selector(textfieldValueChanged(_:)), for: .valueChanged)
        professiontf.addTarget(self, action: #selector(textfieldValueChanged(_:)), for: .valueChanged)
        jobtf.addTarget(self, action: #selector(textfieldValueChanged(_:)), for: .valueChanged)
        labelsContainerView.selectCallback = {
            [weak self] tags in
            self?.model.tags = tags
            self?.updateSunmitBtStatus()
        }
        submitbt.isEnabled = false
        self.updateUI()
    }
    
    func updateUI() {
        
        if let user = SessionManager.sharedInstance.userInfo {
            phonetf.text = user.mobile
            nicknameLb.text = user.name
            nameField.text = user.idname
            icodetf.text = user.idnumber
        }
        if SessionManager.sharedInstance.famousTagArr.count > 0 {
           labelsContainerView.style = 1
            labelsContainerView.updateUI(SessionManager.sharedInstance.famousTagArr)
            labelsContainerHeight.constant = labelsContainerView.height
        }
        
    }
    
    @objc func textfieldValueChanged(_ sender: Any) {
        updateSunmitBtStatus()
    }
    
    func updateSunmitBtStatus() {
        model.company = companytf.text ?? ""
        model.trade = professiontf.text ?? ""
        model.position = jobtf.text ?? ""
        if model.completeFlag() {
            submitbt.backgroundColor = themeColor
            submitbt.isEnabled = true
        }
        else {
            submitbt.backgroundColor = UIColor(hexString: "#dddddd")
            submitbt.isEnabled = false
        }
    }

    //MARK: - image picker
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true) {
            [weak self] in
            self?.businessCardBtn.setImage(images.first!, for: .normal)
            
            //上传图片
            let hud = self?.pleaseWait()
            let img = images.first?.imageWithMaxSize(maxSize: 1920)
            let data = UIImageJPEGRepresentation(img!, 0.8)
            APIManager.shareInstance.uploadFile(data: data!, result: { [weak self](JSON, code, msg) in
                if code == 0 {
                    hud?.hide()
                    self?.model.businesscard = JSON!["data"]["url"].stringValue
                    self?.updateSunmitBtStatus()
                }
                else {
                    hud?.noticeError(msg)
                }
            })
        }
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - actions
    
    func handleTapBackButton(_:Any) {
        let dialog = PopupDialog(title: "确认要离开本页?", message: "离开后已填写的信息将不再保存", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
            
        }
        //PopupDialog(title: "确认要离开本页?", message: "离开后已填写的信息将不再保存")
        dialog.addButton(PopupDialogButton(title: "取消", action: {
            
        }))
        dialog.addButton(PopupDialogButton(title: "确认", action: {
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(dialog, animated: true, completion: {
            
        })
        
    }
    
    @IBAction func handleTapProfession(_ sender: UITapGestureRecognizer) {
        let vc = ProfessionListController()
        vc.type = 1
        vc.delegate = self
        presentr.viewControllerForContext = self
        presentr.shouldIgnoreTapOutsideContext = false
        presentr.dismissOnTap = true
        customPresentViewController(presentr, viewController: vc, animated: true) {
            
        }
    }
    
    @IBAction func handleTapBusinessCard(_ sender: UIButton) {
        let picker = ImagePickerController()
        picker.imageLimit = 1
        picker.delegate = self
        self.present(picker, animated: true) {
            
        }
    }
    
    @IBAction func handleTapSubmitBt(_ sender: UIButton) {
        model.trade = professiontf.text ?? ""
        model.position = jobtf.text ?? ""
        self.view.pleaseWait()
        APIRequest.applyFamousIdentiify(model: model) { [weak self](success) in
            self?.view.clearAllNotice()
            if success {
                DispatchQueue.main.async {
                    
                    let alert = ApplyFamousComplateController(nibName: "ApplyFamousComplateController", bundle: nil)
                    alert.complete = {
                        [weak self] in
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                    self?.customPresentViewController(self!.presentr, viewController: alert, animated: false, completion: nil)
                }
            }
        }
        
    }
    
    func handleTapConfirmBtn(vc: ProfessionListController, item: String) {
        professiontf.text = item
    }
    
    
}
