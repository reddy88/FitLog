//
//  CustomSegmentedControl.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/15/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

@IBDesignable class CustomSegmentedControl: UIControl {
    
    // MARK: - IBInspectable
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var commaSeparatedButtonTitles: String = "" {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable var textColor: UIColor = .lightGray {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable var selectorColor: UIColor = .darkGray {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable var selectorTextColor: UIColor = .white {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Properties
    
    var buttons = [UIButton]()
    var selector: UIView!
    var selectedSegmentIndex = 0
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        updateSelector()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        updateSelector()
//    }
    
    // MARK: - Methods
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height / 2
    }
    
    func updateSelector() {
        for button in buttons {
            button.setTitleColor(textColor, for: .normal)
        }
        
        let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(selectedSegmentIndex)
        selector.frame.origin.x = selectorStartPosition
        buttons[selectedSegmentIndex].setTitleColor(selectorTextColor, for: .normal)
    }
    
    func updateViews() {
        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        let buttonTitles = commaSeparatedButtonTitles.components(separatedBy: ",")
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selector.layer.cornerRadius = frame.height / 2
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    func buttonTapped(button: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == button {
                selectedSegmentIndex = buttonIndex
                let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3, animations: { 
                    self.selector.frame.origin.x = selectorStartPosition
                    btn.setTitleColor(self.selectorTextColor, for: .normal)
                })
                
            }
        }
        
        sendActions(for: .valueChanged)
    }
    
}
