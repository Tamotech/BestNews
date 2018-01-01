//
//  ActivityRegistController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/4.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import PopupDialog
import Presentr
import Kingfisher
import ImagePicker


typealias ActivityApplySuccessCallback = (ActivityPayResult)->()

class ActivityRegistController: BaseViewController, UINavigationControllerDelegate, ProfessionListControllerDelegate, ImagePickerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var captchaBtn: UIButton!
    
    @IBOutlet weak var captchaField: UITextField!
    
    @IBOutlet weak var maleBtn: UIButton!
    
    @IBOutlet weak var femaleBtn: UIButton!
    
    @IBOutlet weak var idCardField: UITextField!
    
    @IBOutlet weak var companyField: UITextField!
    
    @IBOutlet weak var professionField: UITextField!
    
    @IBOutlet weak var jobField: UITextField!
    
    @IBOutlet weak var businessCardBtn: UIButton!
    
    @IBOutlet weak var coverPhoto: UIImageView!
    
    @IBOutlet weak var activityTitleLb: UILabel!
    
    @IBOutlet weak var activityDescLb: UILabel!
    
    @IBOutlet weak var ticketPriceLb: UILabel!
    
    @IBOutlet weak var totalPriceLb: UILabel!
    
    @IBOutlet weak var ticketNumLb: UILabel!
    
    @IBOutlet weak var aliPaySwitch: UIImageView!
    
    @IBOutlet weak var wechatSwitch: UIImageView!
    
    @IBOutlet weak var priceLb: UILabel!
    

    var activity: ActivityDetail?
    var ticket: ActivityTicket?
    var prepare = ActivityPrepare()
    var captcha: String?
    var completeApplyCallback: ActivityApplySuccessCallback?
    var payType = "zhifubao"        //weixin/zhifubao
    var payResult = ActivityPayResult()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.showCustomTitle(title: "活动报名")
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "iconBack"), style: .plain, target: self, action: #selector(handleTapBackButton(_:)))
        navigationItem.leftBarButtonItem = backBtn
        
        
        updateUI()
        loadPrepareInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(zhifubaoPaySuccess(_:)), name: kZhifubaoPaySuccessNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(zhifubaoPayFail(_:)), name: kZhifubaoPayFailNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(zhifubaoPaySuccess(_:)), name: kWexinPaySuccessNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(zhifubaoPayFail(_:)), name: kWexinPayFailNotify, object: nil)
    }

    // MARK: - Navigation
    
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

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController != self {
            
        }
    }
    
    //MARK: - actions
    @IBAction func handleTapAliPay(_ sender: UITapGestureRecognizer) {
        aliPaySwitch.image = #imageLiteral(resourceName: "TickOnM3-3b")
        wechatSwitch.image = #imageLiteral(resourceName: "TickOffM3-3b")
        payType = "zhifubao"
    }
    
    @IBAction func handleTapWechatPay(_ sender: UITapGestureRecognizer) {
        aliPaySwitch.image = #imageLiteral(resourceName: "TickOffM3-3b")
        wechatSwitch.image = #imageLiteral(resourceName: "TickOnM3-3b")
        payType = "weixin"
    }
    
    @IBAction func handleTapMale(_ sender: UIButton) {
        maleBtn.setTitleColor(themeColor, for: .normal)
        maleBtn.layer.borderColor = themeColor?.cgColor
        femaleBtn.setTitleColor(UIColor.init(hexString: "#bbbbbb"), for: .normal)
        femaleBtn.layer.borderColor = UIColor.init(hexString: "#bbbbbb")?.cgColor
        prepare.sex = "male"
    }
    
    @IBAction func handleTapFemale(_ sender: UIButton) {
        femaleBtn.setTitleColor(themeColor, for: .normal)
        femaleBtn.layer.borderColor = themeColor?.cgColor
        maleBtn.setTitleColor(UIColor.init(hexString: "#bbbbbb"), for: .normal)
        maleBtn.layer.borderColor = UIColor.init(hexString: "#bbbbbb")?.cgColor
        prepare.sex = "female"
    }
    
    @IBAction func handleTapSendCaptcha(_ sender: UIButton) {
        
        guard let phone = phoneField.text else {
            return
        }
        
        APIRequest.checkMobile(phone: phone) { (success) in
            if success {
                APIRequest.sendSMSCode(phone: phone, result: { [weak self] (success, code) in
                    if success {
                        self?.captchaField.text = code
                        self?.captcha = code!
                        BLHUDBarManager.showSuccess(msg: "验证码已发送", seconds: 0.5)
                    }
                    else {
                        BLHUDBarManager.showError(msg: "网络异常")
                    }
                })
            }
        }
    }
    
    
    @IBAction func handleTapUploadBtn(_ sender: UIButton) {
        
        let picker = ImagePickerController()
        picker.imageLimit = 1
        picker.delegate = self
        self.present(picker, animated: true) {
            
        }
        
    }
    
    @IBAction func handleTapProfessionBtn(_ sender: UITapGestureRecognizer) {
        
        let vc = ProfessionListController()
        vc.delegate = self
        presentr.viewControllerForContext = self
        presentr.shouldIgnoreTapOutsideContext = false
        presentr.dismissOnTap = true
        customPresentViewController(presentr, viewController: vc, animated: true) {
            
        }
    }
    
    
    ///参加报名
    @IBAction func handleTapApplyBtn(_ sender: UIButton) {
        
        prepare.name = nameField.text ?? ""
        prepare.mobile = phoneField.text ?? ""
        prepare.idnum = idCardField.text ?? ""
        prepare.company = companyField.text ?? ""
        prepare.trade = professionField.text ?? ""
        prepare.profession = jobField.text ?? ""
        prepare.aid = activity?.id ?? ""
        prepare.tid = ticket?.id ?? ""
        prepare.payway = payType
        if !prepare.isCompleteFill() {
            BLHUDBarManager.showError(msg: "请填写完整")
            return
        }
        
        APIRequest.applyActivityAPI(activity: prepare) { [weak self](data) in
            
            //支付结果
            self?.pay(result: data as! ActivityPayResult)
        }
    }
    
    func pay(result: ActivityPayResult) {
        payResult = result
        if payType == "zhifubao" {
            //支付宝
            AlipaySDK.defaultService().payOrder(result.zhifubao, fromScheme: "xinhuacaijing", callback: { (resultDic) in
                
            })
        }
        else {
            let req = PayReq()
            req.partnerId = result.weixin.partnerid
            req.prepayId = result.weixin.prepayid
            req.package = result.weixin.package
            req.nonceStr = result.weixin.noncestr
            req.timeStamp = UInt32(result.weixin.timestamp)!
            req.sign = result.weixin.sign
            WXApi.send(req)
        }
    }
    
    func zhifubaoPaySuccess(_: Any?) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: false)
            if self.completeApplyCallback != nil {
                self.completeApplyCallback!(self.payResult)
            }
        }
        
    }
    
    func zhifubaoPayFail(_: Any?) {
        DispatchQueue.main.async {
            BLHUDBarManager.showError(msg: "支付失败")
        }
    }
    
    
    func handleTapConfirmBtn(vc: ProfessionListController, item: String) {
        professionField.text = item
    }
    
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
                    self?.prepare.buscard = JSON!["data"]["url"].stringValue
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
}



extension ActivityRegistController {
    
    func loadPrepareInfo() {
        
        if activity == nil {
            return
        }
        APIRequest.activityPrepareAPI(id: activity!.id) { [weak self](data) in
            self?.prepare = data as! ActivityPrepare
            if self!.prepare.sex.contains("null") {
                self?.prepare.sex = "male"
            }
            self?.updateUI()
        }
    }
    
    func updateUI() {
        
        phoneField.text = SessionManager.sharedInstance.userInfo?.mobile
        if activity == nil {
            return
        }
        activityTitleLb.text = activity?.title
        if let url = URL(string: activity!.preimgpath) {
            let rc = ImageResource(downloadURL: url)
            coverPhoto.kf.setImage(with: rc)
        }
        activityDescLb.text = "时间: \(activity!.dateStr())\n地点: \(activity!.address)"
        ticketPriceLb.text = "¥\(ticket!.money)"
        ticketNumLb.text = "x1"
        totalPriceLb.text = "¥\(ticket!.money)"
        priceLb.text = "\(ticket!.money)"
        
        if prepare.name.contains("null") {
            return
        }
        nameField.text = prepare.name
        phoneField.text = prepare.mobile
        if prepare.sex == "female" {
            femaleBtn.setTitleColor(themeColor, for: .normal)
            femaleBtn.layer.borderColor = themeColor?.cgColor
            maleBtn.setTitleColor(UIColor.init(hexString: "#bbbbbb"), for: .normal)
            maleBtn.layer.borderColor = UIColor.init(hexString: "#bbbbbb")?.cgColor
        }
        else {
            prepare.sex = "male"
            maleBtn.setTitleColor(themeColor, for: .normal)
            maleBtn.layer.borderColor = themeColor?.cgColor
            femaleBtn.setTitleColor(UIColor.init(hexString: "#bbbbbb"), for: .normal)
            femaleBtn.layer.borderColor = UIColor.init(hexString: "#bbbbbb")?.cgColor
        }
        idCardField.text = prepare.idnum
        companyField.text = prepare.company
        professionField.text = prepare.trade
        jobField.text = prepare.profession
        if let url = URL(string: prepare.buscard) {
            let rc = ImageResource(downloadURL: url)
            businessCardBtn.kf.setImage(with: rc, for: .normal)
        }
        
    }
}
