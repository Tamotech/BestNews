//
//  TestTextField.swift
//  EULoginTemp
//
//  Created by lip on 17/4/6.
//  Copyright © 2017年 lip. All rights reserved.
//

import UIKit


protocol SwiftyTextFieldDeleteDelegate {
    func didClickBackWard()
}

class SwiftyTextField: UITextField {
    
    var deleteDelegate:SwiftyTextFieldDeleteDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let line = UIView(frame: CGRect.init(x: 0, y: frame.size.height-1, width: frame.size.width, height: 1))
        line.backgroundColor = barLightGrayColor
        self.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        deleteDelegate?.didClickBackWard()

    }

}
