//
//  CustomUITextField.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-20.
//

import Foundation
import UIKit
class CustomUITextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.keyboardType = .numberPad
        addDoneButtonOnKeyboard()
    }
    
    init(placeholder: String?) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = .numberPad
        addDoneButtonOnKeyboard()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar = UIToolbar()
        doneToolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        doneToolbar.items = [flexSpace, doneButton]
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
