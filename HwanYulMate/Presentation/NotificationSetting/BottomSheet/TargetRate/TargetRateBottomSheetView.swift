//
//  TargetRateBottomSheetView.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/4/25.
//

import UIKit
import SnapKit
import Then

final class TargetRateBottomSheetView: BaseBottomSheetView {
    
    // MARK: - properties
    private let backgroundView = UIView().then {
        $0.backgroundColor = .modalBackdrop
    }
    
    let containerView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(size: 18, weight: .semibold)
        $0.textColor = .gray900
    }
    
    private let bodyLabel = UILabel().then {
        $0.text = "목표 환율을 적어주세요."
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray800
    }
    
    lazy var textField = UITextField().then {
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .gray900
        $0.tintColor = .cursor
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        $0.rightView = unitContainerView
        $0.leftViewMode = .always
        $0.rightViewMode = .always
        $0.keyboardType = .numberPad
        $0.backgroundColor = .textField
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
        $0.layer.cornerRadius = 6
    }
    
    private let unitContainerView = UIView()
    
    private let unitLabel = UILabel().then {
        $0.text = "원"
        $0.font = .pretendard(size: 18, weight: .semibold)
        $0.textColor = .gray500
    }
    
    var containerBottomConstraint: Constraint?
    
    // MARK: - methods
    override func configureUI() {
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        addSubview(backgroundView)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(bodyLabel)
        containerView.addSubview(textField)
        containerView.addSubview(buttonStackView)
        unitContainerView.addSubview(unitLabel)
    }
    
    override func configureConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            containerBottomConstraint = $0.bottom.equalToSuperview().offset(290).constraint
            $0.height.equalTo(290)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        bodyLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(bodyLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        unitLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
