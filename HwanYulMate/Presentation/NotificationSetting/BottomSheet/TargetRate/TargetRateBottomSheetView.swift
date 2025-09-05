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
        $0.leftView = paddingLeftView
        $0.rightView = unitContainerView
        $0.leftViewMode = .always
        $0.rightViewMode = .always
        $0.keyboardType = .numberPad
        $0.backgroundColor = .textField
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
        $0.layer.cornerRadius = 6
        $0.attributedPlaceholder = NSAttributedString(
            string: "임시로 알려드려요",
            attributes: [
                .foregroundColor: UIColor.gray400,
                .font: UIFont.pretendard(size: 14, weight: .medium)
            ]
        )
    }
    
    private let paddingLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
    
    private lazy var unitContainerView = UIView()
    
    private let unitLabel = UILabel().then {
        $0.text = "원"
        $0.font = .pretendard(size: 18, weight: .semibold)
        $0.textColor = .gray500
    }
    
    // MARK: - methods
    override func configureHierarchy() {
        super.configureHierarchy()
        
        titleLabel.text = "1 USD 가 얼마가 됐을 때 알려드릴까요?"
        
        addSubview(titleLabel)
        addSubview(bodyLabel)
        addSubview(textField)
        unitContainerView.addSubview(unitLabel)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(28)
            $0.bottom.equalTo(bodyLabel.snp.top).offset(-12)
        }
        
        bodyLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(28)
            $0.bottom.equalTo(textField.snp.top).offset(-24)
        }
        
        textField.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-36)
            $0.height.equalTo(44)
        }
        
        unitLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
