//
//  BaseBottomSheetView.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/3/25.
//

import UIKit
import SnapKit
import Then

class BaseBottomSheetView: BaseView {
    
    // MARK: - properties
    let leadingButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        config.attributedTitle = "닫기"
        config.attributedTitle?.font = UIFont.pretendard(size: 16, weight: .medium)
        config.attributedTitle?.foregroundColor = UIColor.green500
        config.background.strokeWidth = 1
        config.background.cornerRadius = 10
        $0.configuration = config
        $0.configurationUpdateHandler = { btn in
            var config = btn.configuration
            config?.baseBackgroundColor = btn.isHighlighted ? .green50 : .white
            config?.background.strokeColor = btn.isHighlighted ? .green300 : .buttonLine
            btn.configuration = config
        }
    }
    
    let trailingButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        config.attributedTitle = "완료"
        config.attributedTitle?.font = UIFont.pretendard(size: 16, weight: .medium)
        config.attributedTitle?.foregroundColor = UIColor.white
        config.background.cornerRadius = 10
        $0.configuration = config
        $0.configurationUpdateHandler = { btn in
            var config = btn.configuration
            config?.baseBackgroundColor = btn.isHighlighted ? .green600 : .green500
            btn.configuration = config
        }
    }
    
    let buttonStackView = UIStackView().then {
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    // MARK: - methods
    override func configureHierarchy() {
        buttonStackView.addArrangedSubview(leadingButton)
        buttonStackView.addArrangedSubview(trailingButton)
    }
}
