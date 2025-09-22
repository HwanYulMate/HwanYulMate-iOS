//
//  NotificationSettingView.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/30/25.
//

import UIKit
import SnapKit
import Then

final class NotificationSettingView: BaseView {
    
    // MARK: - properties
    let backBarButtonItem = UIBarButtonItem().then {
        $0.style = .done
        $0.image = .arrowLeft
        $0.tintColor = .gray900
    }
    
    let navigationTitleLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .semibold)
        $0.textColor = .gray900
        $0.textAlignment = .center
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "어떤 알림을 받을까요?"
        $0.font = .pretendard(size: 20, weight: .semibold)
    }
    
    private let alarmImageView = UIImageView().then {
        $0.image = .alarm
        $0.contentMode = .scaleAspectFill
    }
    
    private let alarmTitleLabel = UILabel().then {
        $0.text = "목표 환율 달성"
        $0.font = .pretendard(size: 16, weight: .semibold)
        $0.textColor = .gray900
    }
    
    private let alarmBodyLabel = UILabel().then {
        $0.text = "원하는 환율 도달 시 푸시로 안내 드려요."
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .gray600
    }
    
    private let alarmTextStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.distribution = .equalSpacing
    }
    
    let alarmSwitch = UISwitch().then {
        $0.onTintColor = .green500
    }
    
    private let scheduleImageView = UIImageView().then {
        $0.image = .schedule
        $0.contentMode = .scaleAspectFill
    }
    
    private let scheduleTitleLabel = UILabel().then {
        $0.text = "오늘의 환율 안내"
        $0.font = .pretendard(size: 16, weight: .semibold)
        $0.textColor = .gray900
    }
    
    private let scheduleBodyLabel = UILabel().then {
        $0.text = "매일 어제 비교 환율을 알려 드려요."
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .gray600
    }
    
    private let scheduleTextStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.distribution = .equalSpacing
    }
    
    let scheduleSwitch = UISwitch().then {
        $0.onTintColor = .green500
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .divider
    }
    
    private let exchangeRateNoticeTitleLabel = UILabel().then {
        $0.text = "환율 메이트 환율 안내"
        $0.font = .pretendard(size: 15, weight: .semibold)
        $0.textColor = .gray900
    }
    
    private let exchangeRateNoticeBodyBulletLabel1 = UILabel().then {
        $0.text = "•"
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let exchangeRateNoticeBodyLabel1 = UILabel().then {
        $0.text = "앱에서 제공하는 환율은 참고용이며, 실제 환전 시 적용되는 환율과 차이가 있을 수 있습니다."
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.numberOfLines = 0
        $0.setLineSpacing(spacing: 4)
    }
    
    private let exchangeRateNoticeBodyItemStackView1 = UIStackView().then {
        $0.spacing = 4
        $0.alignment = .firstBaseline
        $0.distribution = .equalSpacing
    }
    
    private let exchangeRateNoticeBodyBulletLabel2 = UILabel().then {
        $0.text = "•"
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let exchangeRateNoticeBodyLabel2 = UILabel().then {
        $0.text = "은행·환전소마다 수수료 및 환율 우대율이 달라 실제 금액은 변동될 수 있습니다."
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.numberOfLines = 0
        $0.setLineSpacing(spacing: 4)
    }
    
    private let exchangeRateNoticeBodyItemStackView2 = UIStackView().then {
        $0.spacing = 4
        $0.alignment = .firstBaseline
        $0.distribution = .equalSpacing
    }
    
    private let exchangeRateNoticeBodyBulletLabel3 = UILabel().then {
        $0.text = "•"
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let exchangeRateNoticeBodyLabel3 = UILabel().then {
        $0.text = "환율은 실시간으로 변동되며, 알림 시점과 실제 거래 시점의 환율이 달라질 수 있습니다."
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.numberOfLines = 0
        $0.setLineSpacing(spacing: 4)
    }
    
    private let exchangeRateNoticeBodyItemStackView3 = UIStackView().then {
        $0.spacing = 4
        $0.alignment = .firstBaseline
        $0.distribution = .equalSpacing
    }
    
    private let exchangeRateNoticeBodyBulletLabel4 = UILabel().then {
        $0.text = "•"
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let exchangeRateNoticeBodyLabel4 = UILabel().then {
        $0.text = "제공되는 환율 정보는 특정 은행 또는 외부 데이터 제공사의 환율을 기준으로 합니다."
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.numberOfLines = 0
        $0.setLineSpacing(spacing: 4)
    }
    
    private let exchangeRateNoticeBodyItemStackView4 = UIStackView().then {
        $0.spacing = 4
        $0.alignment = .firstBaseline
        $0.distribution = .equalSpacing
    }
    
    private let exchangeRateNoticeBodyBulletLabel5 = UILabel().then {
        $0.text = "•"
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let exchangeRateNoticeBodyLabel5 = UILabel().then {
        $0.text = "본 앱은 환율 정보를 제공할 뿐, 투자 및 재무적 손실에 대한 책임은 지지 않습니다."
        $0.font = .pretendard(size: 13, weight: .regular)
        $0.textColor = .descriptionText
        $0.numberOfLines = 0
        $0.setLineSpacing(spacing: 4)
    }
    
    private let exchangeRateNoticeBodyItemStackView5 = UIStackView().then {
        $0.spacing = 4
        $0.alignment = .firstBaseline
        $0.distribution = .equalSpacing
    }
    
    private let exchangeRateNoticeBodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .equalSpacing
    }
    
    // MARK: - methods
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(alarmImageView)
        addSubview(alarmTextStackView)
        addSubview(alarmSwitch)
        addSubview(scheduleImageView)
        addSubview(scheduleTextStackView)
        addSubview(scheduleSwitch)
        addSubview(dividerView)
        addSubview(exchangeRateNoticeTitleLabel)
        addSubview(exchangeRateNoticeBodyStackView)
        alarmTextStackView.addArrangedSubview(alarmTitleLabel)
        alarmTextStackView.addArrangedSubview(alarmBodyLabel)
        scheduleTextStackView.addArrangedSubview(scheduleTitleLabel)
        scheduleTextStackView.addArrangedSubview(scheduleBodyLabel)
        exchangeRateNoticeBodyStackView.addArrangedSubview(exchangeRateNoticeBodyItemStackView1)
        exchangeRateNoticeBodyStackView.addArrangedSubview(exchangeRateNoticeBodyItemStackView2)
        exchangeRateNoticeBodyStackView.addArrangedSubview(exchangeRateNoticeBodyItemStackView3)
        exchangeRateNoticeBodyStackView.addArrangedSubview(exchangeRateNoticeBodyItemStackView4)
        exchangeRateNoticeBodyStackView.addArrangedSubview(exchangeRateNoticeBodyItemStackView5)
        exchangeRateNoticeBodyItemStackView1.addArrangedSubview(exchangeRateNoticeBodyBulletLabel1)
        exchangeRateNoticeBodyItemStackView1.addArrangedSubview(exchangeRateNoticeBodyLabel1)
        exchangeRateNoticeBodyItemStackView2.addArrangedSubview(exchangeRateNoticeBodyBulletLabel2)
        exchangeRateNoticeBodyItemStackView2.addArrangedSubview(exchangeRateNoticeBodyLabel2)
        exchangeRateNoticeBodyItemStackView3.addArrangedSubview(exchangeRateNoticeBodyBulletLabel3)
        exchangeRateNoticeBodyItemStackView3.addArrangedSubview(exchangeRateNoticeBodyLabel3)
        exchangeRateNoticeBodyItemStackView4.addArrangedSubview(exchangeRateNoticeBodyBulletLabel4)
        exchangeRateNoticeBodyItemStackView4.addArrangedSubview(exchangeRateNoticeBodyLabel4)
        exchangeRateNoticeBodyItemStackView5.addArrangedSubview(exchangeRateNoticeBodyBulletLabel5)
        exchangeRateNoticeBodyItemStackView5.addArrangedSubview(exchangeRateNoticeBodyLabel5)
    }
    
    override func configureConstraints() {
        navigationTitleLabel.snp.makeConstraints {
            $0.width.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(24)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(22)
        }
        
        alarmImageView.snp.makeConstraints {
            $0.centerY.equalTo(alarmTextStackView)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(16)
            $0.size.equalTo(28)
        }
        
        alarmTextStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(44)
            $0.leading.equalTo(alarmImageView.snp.trailing).offset(20)
        }
        
        alarmSwitch.snp.makeConstraints {
            $0.centerY.equalTo(alarmTextStackView)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        scheduleImageView.snp.makeConstraints {
            $0.centerY.equalTo(scheduleTextStackView)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(16)
            $0.size.equalTo(28)
        }
        
        scheduleTextStackView.snp.makeConstraints {
            $0.top.equalTo(alarmTextStackView.snp.bottom).offset(28)
            $0.leading.equalTo(scheduleImageView.snp.trailing).offset(20)
        }
        
        scheduleSwitch.snp.makeConstraints {
            $0.centerY.equalTo(scheduleTextStackView)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(exchangeRateNoticeTitleLabel.snp.top).offset(-42)
            $0.height.equalTo(10)
        }
        
        exchangeRateNoticeTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(32)
            $0.bottom.equalTo(exchangeRateNoticeBodyStackView.snp.top).offset(-20)
        }
        
        exchangeRateNoticeBodyStackView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(32)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-47)
        }
    }
    
    func bind(navigationTitle: String) {
        navigationTitleLabel.text = navigationTitle
    }
    
    func bind(alertSetting: AlertSetting) {
        alarmSwitch.setOn(alertSetting.isTargetPriceEnabled, animated: false)
        scheduleSwitch.setOn(alertSetting.isDailyAlertEnabled, animated: false)
    }
    
    func bind(isAlarmSwitchOn: Bool) {
        alarmSwitch.setOn(isAlarmSwitchOn, animated: false)
    }
    
    func bind(isScheduleSwitchOn: Bool) {
        scheduleSwitch.setOn(isScheduleSwitchOn, animated: false)
    }
}
