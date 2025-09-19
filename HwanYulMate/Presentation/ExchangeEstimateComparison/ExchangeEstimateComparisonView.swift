//
//  ExchangeEstimateComparisonView.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/12/25.
//

import UIKit
import SnapKit
import Then

final class ExchangeEstimateComparisonView: BaseView {
    
    // MARK: - properties
    let backButton = UIButton().then {
        $0.setImage(.dismiss, for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "환전 예상 금액 비교"
        $0.font = .pretendard(size: 16, weight: .semibold)
        $0.textColor = .gray900
        $0.textAlignment = .center
    }
    
    let calculationBaseLabel = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textColor = .descriptionText
    }
    
    let row0Column0Label = UILabel().then {
        $0.text = "은행명"
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .tableBackground
    }
    
    let row1Column0Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row2Column0Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row3Column0Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row4Column0Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row5Column0Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row6Column0Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row7Column0Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    private let column0StackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 1
        $0.distribution = .fillEqually
    }
    
    let row0Column1Label = UILabel().then {
        $0.text = "적용환율"
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .tableBackground
    }
    
    let row1Column1Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row2Column1Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row3Column1Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row4Column1Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row5Column1Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row6Column1Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row7Column1Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    private let column1StackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 1
        $0.distribution = .fillEqually
    }
    
    let row0Column2Label = UILabel().then {
        $0.text = "수수료"
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .tableBackground
    }
    
    let row1Column2Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row2Column2Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row3Column2Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row4Column2Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row5Column2Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row6Column2Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row7Column2Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    private let column2StackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 1
        $0.distribution = .fillEqually
    }
    
    let row0Column3Label = UILabel().then {
        $0.text = "우대율"
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .tableBackground
    }
    
    let row1Column3Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row2Column3Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row3Column3Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row4Column3Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row5Column3Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row6Column3Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row7Column3Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    private let column3StackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 1
        $0.distribution = .fillEqually
    }
    
    let row0Column4Label = UILabel().then {
        $0.text = "최종 수령액"
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .tableBackground
    }
    
    let row1Column4Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row2Column4Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row3Column4Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row4Column4Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row5Column4Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row6Column4Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    let row7Column4Label = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .white
    }
    
    private let column4StackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 1
        $0.distribution = .fillEqually
    }
    
    private let stackView = UIStackView().then {
        $0.spacing = 1
        $0.distribution = .fillProportionally
        $0.backgroundColor = .tableLine
    }
    
    private let topLineView = UIView().then {
        $0.backgroundColor = .tableLine
    }
    
    private let bottomLineView = UIView().then {
        $0.backgroundColor = .tableLine
    }
    
    private let leadingLineView = UIView().then {
        $0.backgroundColor = .tableLine
    }
    
    private let trailingLineView = UIView().then {
        $0.backgroundColor = .tableLine
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
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(calculationBaseLabel)
        addSubview(stackView)
        addSubview(topLineView)
        addSubview(bottomLineView)
        addSubview(leadingLineView)
        addSubview(trailingLineView)
        addSubview(dividerView)
        addSubview(exchangeRateNoticeTitleLabel)
        addSubview(exchangeRateNoticeBodyStackView)
        stackView.addArrangedSubview(column0StackView)
        stackView.addArrangedSubview(column1StackView)
        stackView.addArrangedSubview(column2StackView)
        stackView.addArrangedSubview(column3StackView)
        stackView.addArrangedSubview(column4StackView)
        column0StackView.addArrangedSubview(row0Column0Label)
        column0StackView.addArrangedSubview(row1Column0Label)
        column0StackView.addArrangedSubview(row2Column0Label)
        column0StackView.addArrangedSubview(row3Column0Label)
        column0StackView.addArrangedSubview(row4Column0Label)
        column0StackView.addArrangedSubview(row5Column0Label)
        column0StackView.addArrangedSubview(row6Column0Label)
        column0StackView.addArrangedSubview(row7Column0Label)
        column1StackView.addArrangedSubview(row0Column1Label)
        column1StackView.addArrangedSubview(row1Column1Label)
        column1StackView.addArrangedSubview(row2Column1Label)
        column1StackView.addArrangedSubview(row3Column1Label)
        column1StackView.addArrangedSubview(row4Column1Label)
        column1StackView.addArrangedSubview(row5Column1Label)
        column1StackView.addArrangedSubview(row6Column1Label)
        column1StackView.addArrangedSubview(row7Column1Label)
        column2StackView.addArrangedSubview(row0Column2Label)
        column2StackView.addArrangedSubview(row1Column2Label)
        column2StackView.addArrangedSubview(row2Column2Label)
        column2StackView.addArrangedSubview(row3Column2Label)
        column2StackView.addArrangedSubview(row4Column2Label)
        column2StackView.addArrangedSubview(row5Column2Label)
        column2StackView.addArrangedSubview(row6Column2Label)
        column2StackView.addArrangedSubview(row7Column2Label)
        column3StackView.addArrangedSubview(row0Column3Label)
        column3StackView.addArrangedSubview(row1Column3Label)
        column3StackView.addArrangedSubview(row2Column3Label)
        column3StackView.addArrangedSubview(row3Column3Label)
        column3StackView.addArrangedSubview(row4Column3Label)
        column3StackView.addArrangedSubview(row5Column3Label)
        column3StackView.addArrangedSubview(row6Column3Label)
        column3StackView.addArrangedSubview(row7Column3Label)
        column4StackView.addArrangedSubview(row0Column4Label)
        column4StackView.addArrangedSubview(row1Column4Label)
        column4StackView.addArrangedSubview(row2Column4Label)
        column4StackView.addArrangedSubview(row3Column4Label)
        column4StackView.addArrangedSubview(row4Column4Label)
        column4StackView.addArrangedSubview(row5Column4Label)
        column4StackView.addArrangedSubview(row6Column4Label)
        column4StackView.addArrangedSubview(row7Column4Label)
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
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(22)
            $0.size.equalTo(12)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        calculationBaseLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-22)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(calculationBaseLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(22)
            $0.height.equalTo(272)
        }
        
        [row0Column0Label,
         row1Column0Label,
         row2Column0Label,
         row3Column0Label,
         row4Column0Label,
         row5Column0Label,
         row6Column0Label,
         row7Column0Label,
         row0Column1Label,
         row1Column1Label,
         row2Column1Label,
         row3Column1Label,
         row4Column1Label,
         row5Column1Label,
         row6Column1Label,
         row7Column1Label,
         row0Column2Label,
         row1Column2Label,
         row2Column2Label,
         row3Column2Label,
         row4Column2Label,
         row5Column2Label,
         row6Column2Label,
         row7Column2Label,
         row0Column3Label,
         row1Column3Label,
         row2Column3Label,
         row3Column3Label,
         row4Column3Label,
         row5Column3Label,
         row6Column3Label,
         row7Column3Label,
         row0Column4Label,
         row1Column4Label,
         row2Column4Label,
         row3Column4Label,
         row4Column4Label,
         row5Column4Label,
         row6Column4Label,
         row7Column4Label
        ].forEach { label in
            label.snp.makeConstraints {
                $0.height.equalTo(34)
            }
        }
        
        topLineView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(stackView)
            $0.bottom.equalTo(stackView.snp.top)
            $0.height.equalTo(1)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(stackView)
            $0.top.equalTo(stackView.snp.bottom)
            $0.height.equalTo(1)
        }
        
        leadingLineView.snp.makeConstraints {
            $0.verticalEdges.equalTo(stackView)
            $0.trailing.equalTo(stackView.snp.leading)
            $0.width.equalTo(1)
        }
        
        trailingLineView.snp.makeConstraints {
            $0.verticalEdges.equalTo(stackView)
            $0.leading.equalTo(stackView.snp.trailing)
            $0.width.equalTo(1)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(bottomLineView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        exchangeRateNoticeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(44)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(32)
        }
        
        exchangeRateNoticeBodyStackView.snp.makeConstraints {
            $0.top.equalTo(exchangeRateNoticeTitleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(32)
        }
    }
    
    func bind(banks: [Bank]) {
        row1Column0Label.text = banks[0].bankName
        row2Column0Label.text = banks[1].bankName
        row3Column0Label.text = banks[2].bankName
        row4Column0Label.text = banks[3].bankName
        row5Column0Label.text = banks[4].bankName
        row6Column0Label.text = banks[5].bankName
        row7Column0Label.text = banks[6].bankName
        row1Column1Label.text = banks[0].appliedRate.toCurrencyString()
        row2Column1Label.text = banks[1].appliedRate.toCurrencyString()
        row3Column1Label.text = banks[2].appliedRate.toCurrencyString()
        row4Column1Label.text = banks[3].appliedRate.toCurrencyString()
        row5Column1Label.text = banks[4].appliedRate.toCurrencyString()
        row6Column1Label.text = banks[5].appliedRate.toCurrencyString()
        row7Column1Label.text = banks[6].appliedRate.toCurrencyString()
        row1Column2Label.text = banks[0].totalFee.toCurrencyString()
        row2Column2Label.text = banks[1].totalFee.toCurrencyString()
        row3Column2Label.text = banks[2].totalFee.toCurrencyString()
        row4Column2Label.text = banks[3].totalFee.toCurrencyString()
        row5Column2Label.text = banks[4].totalFee.toCurrencyString()
        row6Column2Label.text = banks[5].totalFee.toCurrencyString()
        row7Column2Label.text = banks[6].totalFee.toCurrencyString()
        row1Column3Label.text = banks[0].preferentialRate.toCurrencyString() + "%"
        row2Column3Label.text = banks[1].preferentialRate.toCurrencyString() + "%"
        row3Column3Label.text = banks[2].preferentialRate.toCurrencyString() + "%"
        row4Column3Label.text = banks[3].preferentialRate.toCurrencyString() + "%"
        row5Column3Label.text = banks[4].preferentialRate.toCurrencyString() + "%"
        row6Column3Label.text = banks[5].preferentialRate.toCurrencyString() + "%"
        row7Column3Label.text = banks[6].preferentialRate.toCurrencyString() + "%"
        row1Column4Label.text = banks[0].finalAmount.toCurrencyString()
        row2Column4Label.text = banks[1].finalAmount.toCurrencyString()
        row3Column4Label.text = banks[2].finalAmount.toCurrencyString()
        row4Column4Label.text = banks[3].finalAmount.toCurrencyString()
        row5Column4Label.text = banks[4].finalAmount.toCurrencyString()
        row6Column4Label.text = banks[5].finalAmount.toCurrencyString()
        row7Column4Label.text = banks[6].finalAmount.toCurrencyString()
    }
}
