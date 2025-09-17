//
//  WithdrawalView.swift
//  HwanYulMate
//
//  Created by HanJW on 9/5/25.
//

import UIKit
import SnapKit
import Then

final class WithdrawalView: BaseView {
    
    // MARK: - properties
    private let navigationBar = UIView().then {
        $0.backgroundColor = .white
    }
    
    let backButton = UIButton(type: .system).then {
        let image = UIImage(systemName: "chevron.left")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        )
        $0.setImage(image, for: .normal)
        $0.tintColor = .black
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(size: 20, weight: .semibold)
        $0.textColor = .black
        $0.numberOfLines = 2
        $0.textAlignment = .left
        $0.text = "00님\n정말 탈퇴하시겠어요?" // 추후 API 연동 시 userName으로 변경
    }
    
    private let descriptionBackgroundView = UIView().then {
        $0.backgroundColor = .descriptionBackground
        $0.layer.borderColor = UIColor.green100.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    private let descriptionTitleLabel = UILabel().then {
        $0.text = "환율메이트 탈퇴 안내"
        $0.font = .pretendard(size: 15, weight: .semibold)
        $0.textColor = .gray900
    }
    
    private let bulletLabel1 = UILabel().then {
        $0.text = "•"
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.textAlignment = .center
    }
    
    private let contentLabel1 = UILabel().then {
        $0.text = "지금 탈퇴하시면 환율 알림과 뉴스를 더 이상 이용 하실 수 없게 돼요!"
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.numberOfLines = 0
        $0.setLineSpacing(spacing: 4)
    }
    
    private let contentStackView1 = UIStackView().then {
        $0.spacing = 8
        $0.alignment = .firstBaseline
        $0.distribution = .fill
    }
    
    private let bulletLabel2 = UILabel().then {
        $0.text = "•"
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.textAlignment = .center
    }
    
    private let contentLabel2 = UILabel().then {
        $0.text = "탈퇴 후 적용했던 알림은 사라집니다."
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.numberOfLines = 0
        $0.setLineSpacing(spacing: 4)
    }
    
    private let contentStackView2 = UIStackView().then {
        $0.spacing = 8
        $0.alignment = .firstBaseline
        $0.distribution = .fill
    }
    
    private let bulletLabel3 = UILabel().then {
        $0.text = "•"
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.textAlignment = .center
    }
    
    private let contentLabel3 = UILabel().then {
        $0.text = "환율은 실시간으로 변동되며, 알림 시점과 실제 거래 시점의 환율이 달라질 수 있습니다."
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.numberOfLines = 0
        $0.setLineSpacing(spacing: 4)
    }
    
    private let contentStackView3 = UIStackView().then {
        $0.spacing = 8
        $0.alignment = .firstBaseline
        $0.distribution = .fill
    }
    
    private let reasonLabel = UILabel().then {
        $0.text = "탈퇴 이유를 알려주실 수 있나요? (선택사항)"
        $0.font = .pretendard(size: 16, weight: .semibold)
        $0.textColor = .gray800
    }
    
    private let reasonInputBackgroundView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.borderColor = UIColor.gray100.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    let reasonTextView = UITextView().then {
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .gray700
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.textContainer.lineFragmentPadding = 0
        $0.showsVerticalScrollIndicator = false
    }
    
    private let charCountLabel = UILabel().then {
        $0.text = "0/100"
        $0.font = .pretendard(size: 11, weight: .medium)
        $0.textColor = .gray400
        $0.textAlignment = .right
    }
    
    let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = .pretendard(size: 16, weight: .medium)
    }
    
    let withdrawButton = UIButton(type: .system).then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.main, for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.buttonLine.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = .pretendard(size: 16, weight: .medium)
    }
    
    // MARK: - methods
    override func configureUI() {
        super.configureUI()
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubview(navigationBar)
        addSubview(titleLabel)
        addSubview(descriptionBackgroundView)
        addSubview(reasonLabel)
        addSubview(reasonInputBackgroundView)
        addSubview(cancelButton)
        addSubview(withdrawButton)
        
        navigationBar.addSubview(backButton)
        
        descriptionBackgroundView.addSubview(descriptionTitleLabel)
        descriptionBackgroundView.addSubview(contentStackView1)
        descriptionBackgroundView.addSubview(contentStackView2)
        descriptionBackgroundView.addSubview(contentStackView3)
        
        contentStackView1.addArrangedSubview(bulletLabel1)
        contentStackView1.addArrangedSubview(contentLabel1)
        contentStackView2.addArrangedSubview(bulletLabel2)
        contentStackView2.addArrangedSubview(contentLabel2)
        contentStackView3.addArrangedSubview(bulletLabel3)
        contentStackView3.addArrangedSubview(contentLabel3)
        
        reasonInputBackgroundView.addSubview(reasonTextView)
        reasonInputBackgroundView.addSubview(charCountLabel)
    }
    
    override func configureConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        descriptionBackgroundView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        contentStackView1.snp.makeConstraints {
            $0.top.equalTo(descriptionTitleLabel.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentStackView2.snp.makeConstraints {
            $0.top.equalTo(contentStackView1.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentStackView3.snp.makeConstraints {
            $0.top.equalTo(contentStackView2.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        reasonLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionBackgroundView.snp.bottom).offset(75)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        reasonInputBackgroundView.snp.makeConstraints {
            $0.top.equalTo(reasonLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(128)
        }
        
        reasonTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(80)
        }
        
        charCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-18)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-24)
            $0.height.equalTo(48)
            $0.trailing.equalTo(withdrawButton.snp.leading).offset(-12)
        }
        
        withdrawButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-24)
            $0.height.equalTo(48)
            $0.width.equalTo(cancelButton.snp.width)
        }
    }
    
    func updateUserName(_ userName: String) {
        titleLabel.text = "\(userName)님\n정말 탈퇴하시겠어요?"
    }
    
    func updateCharCount(_ count: Int) {
        charCountLabel.text = "\(count)/100"
    }
}
