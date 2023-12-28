//
//  CustomButton.swift
//  SwiftCalculator
//
//  Created by kazu on 2023/12/27.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    private func updateCornerRadius() {
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.clipsToBounds = true
    }
    
    
    private func loadNib() {
        guard let button = Bundle.main.loadNibNamed("CustomButton", owner: self, options: nil)?.first as? UIButton else { return }
        button.frame = self.bounds
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(button)
    }
}
