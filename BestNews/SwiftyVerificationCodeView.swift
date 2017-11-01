//
//  SwiftyVerificationCodeView.swift
//  EULoginTemp
//
//  Created by lip on 17/4/6.
//  Copyright © 2017年 lip. All rights reserved.
//

import UIKit
/**
 滴滴验证码的逻辑
 不允许用户点击，顺序已经定死，可以用删除键回退，最后一个输完自动登陆
 */

protocol SwiftyVerificationCodeViewDelegate {
    func verificationCodeDidFinishedInput(verificationCodeView:SwiftyVerificationCodeView,code:String)
}
class SwiftyVerificationCodeView: UIView {
    
    /// 代理回调
    var delegate:SwiftyVerificationCodeViewDelegate?
    
    /// 一堆框框的数组
    var textfieldarray = [UITextField]()

    /// 框框之间的间隔
    var margin:CGFloat = 10
    
    /// 框框的大小
    var wid:CGFloat = 50
    
    var hei: CGFloat = 50
    
    /// 框框个数
    var numOfRect = 4

    /// 构造函数
    ///
    /// - Parameters:
    ///   - frame: frame，宽度最好设置为屏幕宽度
    ///   - num: 框框个数，默认 4 个
    ///   - margin: 框框之间的间距，默认 10
    init(frame: CGRect,num:Int = 4,margin:CGFloat = 10, wid: CGFloat = 50, hei: CGFloat = 50) {
        super.init(frame: frame)
        self.numOfRect = num
        self.margin = margin
        self.wid = wid
        self.hei = hei
        setupUI()
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cleanVerificationCodeView(){
     
        for tv in textfieldarray {
            tv.text = ""
        }
        textfieldarray.first?.becomeFirstResponder()
        
        
    }
    
    func setText(text: String) {
        var len = numOfRect
        if text.characters.count < len {
            len = text.characters.count
        }
        for i in 0..<len {
            let start = text.index(text.startIndex, offsetBy: i)
            let end = text.index(start, offsetBy: 1)
            let subText = text.substring(with: start..<end)
            let tv = textfieldarray[i]
            tv.text = subText
        }
    }
    
}

// MARK: - UI 相关方法
extension SwiftyVerificationCodeView{
    
    fileprivate func setupUI(){
        
        // 不允许用户直接操作验证码框
        self.isUserInteractionEnabled = false
     
        // 计算左间距
        let leftmargin = margin
        
        // 创建 n个 UITextFiedl
        for i in 0..<numOfRect{
            
            let rect = CGRect(x: leftmargin + CGFloat(i)*wid + CGFloat(i)*margin, y: 0, width: wid, height: hei)
            let tv = createTextField(frame: rect)
            tv.tag = i
            textfieldarray.append(tv)
            
        }
        
        // 防止搞事
        if numOfRect < 1 {
            return
        }
        
        textfieldarray.first?.becomeFirstResponder()
        
    }
    
    private func createTextField(frame:CGRect)->UITextField{
        
        let tv = SwiftyTextField(frame: frame)
        tv.borderStyle = .none
        tv.textAlignment = .center
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.textColor = UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        tv.delegate = self
        tv.deleteDelegate = self
        addSubview(tv)
//        tv.keyboardType = .numbersAndPunctuation
        return tv
        
    }
    
}



extension SwiftyVerificationCodeView:UITextFieldDelegate,SwiftyTextFieldDeleteDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
         textField.keyboardType = .default
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !textField.hasText {
            
            // tag 对应数组下标
            let index = textField.tag
            
            textField.resignFirstResponder()
            if index == numOfRect - 1 {
                textfieldarray[index].text = string
                // 拼接结果
                var code = ""
                for tv in textfieldarray{
                    code += tv.text ?? ""
                }
                delegate?.verificationCodeDidFinishedInput(verificationCodeView: self, code: code)
                return false
            }
            
            textfieldarray[index].text = string
            textfieldarray[index + 1].becomeFirstResponder()
            
        }
            return false
        
    }
    
    /// 监听键盘删除键
    func didClickBackWard() {
        
        for i in 1..<numOfRect{
            
            if !textfieldarray[i].isFirstResponder {
                continue
            }
            textfieldarray[i].resignFirstResponder()
            textfieldarray[i-1].becomeFirstResponder()
            textfieldarray[i-1].text = ""
            
        }
    }
    
    
}
