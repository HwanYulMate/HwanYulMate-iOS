//
//  TimeSelectionBottomSheetView.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/8/25.
//

import UIKit
import SnapKit
import Then

final class TimeSelectionBottomSheetView: BaseBottomSheetView {
    
    // MARK: - properties
    private let titleLabel = UILabel().then {
        $0.text = "언제 알림을 보낼까요?"
        $0.font = .pretendard(size: 18, weight: .semibold)
        $0.textColor = .gray900
    }
    
    private let bodyLabel = UILabel().then {
        $0.text = "알림 받을 시간을 선택해주세요."
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray800
    }
    
    let selectButton1 = UIButton().then {
        $0.setImage(.timeSelectionUnselected, for: .normal)
    }
    
    private let timeLabel1 = UILabel().then {
        $0.text = "09:00"
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray900
    }
    
    let selectButton2 = UIButton().then {
        $0.setImage(.timeSelectionUnselected, for: .normal)
    }
    
    private let timeLabel2 = UILabel().then {
        $0.text = "12:00"
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray900
    }
    
    let selectButton3 = UIButton().then {
        $0.setImage(.timeSelectionUnselected, for: .normal)
    }
    
    private let timeLabel3 = UILabel().then {
        $0.text = "14:00"
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray900
    }
    
    let selectButton4 = UIButton().then {
        $0.setImage(.timeSelectionUnselected, for: .normal)
    }
    
    private let timeLabel4 = UILabel().then {
        $0.text = "16:00"
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray900
    }
    
    // MARK: - methods
    override func configureUI() {
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(bodyLabel)
        containerView.addSubview(selectButton1)
        containerView.addSubview(timeLabel1)
        containerView.addSubview(selectButton2)
        containerView.addSubview(timeLabel2)
        containerView.addSubview(selectButton3)
        containerView.addSubview(timeLabel3)
        containerView.addSubview(selectButton4)
        containerView.addSubview(timeLabel4)
        containerView.addSubview(buttonStackView)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        bodyLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        selectButton1.snp.makeConstraints {
            $0.top.equalTo(bodyLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(28)
        }
        
        timeLabel1.snp.makeConstraints {
            $0.centerY.equalTo(selectButton1)
            $0.leading.equalTo(selectButton1.snp.trailing).offset(12)
        }
        
        selectButton2.snp.makeConstraints {
            $0.top.equalTo(selectButton1.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(28)
        }
        
        timeLabel2.snp.makeConstraints {
            $0.centerY.equalTo(selectButton2)
            $0.leading.equalTo(selectButton2.snp.trailing).offset(12)
        }
        
        selectButton3.snp.makeConstraints {
            $0.top.equalTo(selectButton2.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(28)
        }
        
        timeLabel3.snp.makeConstraints {
            $0.centerY.equalTo(selectButton3)
            $0.leading.equalTo(selectButton3.snp.trailing).offset(12)
        }
        
        selectButton4.snp.makeConstraints {
            $0.top.equalTo(selectButton3.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(28)
        }
        
        timeLabel4.snp.makeConstraints {
            $0.centerY.equalTo(selectButton4)
            $0.leading.equalTo(selectButton4.snp.trailing).offset(12)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(selectButton4.snp.bottom).offset(38)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
