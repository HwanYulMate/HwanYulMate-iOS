//
//  HomeDetailCell.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/9/25.
//

import UIKit
import DGCharts
import SnapKit
import Then

final class HomeDetailCell: BaseTableViewCell {
    
    // MARK: - properties
    static let identifier = "HomeDetailCell"
    
    private let exchangeRateTitleView = UILabel().then {
        $0.text = "실시간 환율"
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray600
    }
    
    let currentRateLabel = UILabel().then {
        $0.font = .pretendard(size: 24, weight: .semibold)
        $0.textColor = .gray900
    }
    
    let rateChangeLabel = UILabel().then {
        $0.font = .pretendard(size: 24, weight: .semibold)
    }
    
    let exchangeRateChartView = LineChartView().then {
        $0.rightAxis.enabled = false
        $0.legend.enabled = false
        $0.xAxis.enabled = false
        $0.xAxis.labelRotationAngle = 0
        $0.xAxis.drawGridLinesEnabled = false
        $0.pinchZoomEnabled = false
        $0.doubleTapToZoomEnabled = false
        $0.leftAxis.gridColor = .lightGray.withAlphaComponent(0.3)
    }
    
    let segmentedControl = UISegmentedControl(items: ["1주일", "1개월", "3개월", "6개월", "1년"]).then {
        $0.selectedSegmentIndex = 0
        $0.selectedSegmentTintColor = .white
        $0.setTitleTextAttributes([.foregroundColor: UIColor.gray900], for: .selected)
        $0.setTitleTextAttributes([.foregroundColor: UIColor.gray400], for: .normal)
    }
    
    let exchangeRateChangeTitleLabel = UILabel().then {
        $0.text = "최근 1주일 환율 변동"
        $0.font = .pretendard(size: 16, weight: .semibold)
        $0.textColor = .gray900
    }
    
    private let exchangeRateChangeContainerView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 12
    }
    
    private let lowestRateLabel = UILabel().then {
        $0.text = "최저환율"
        $0.font = .pretendard(size: 15, weight: .medium)
        $0.textColor = .gray500
    }
    
    private let lowestRateValueLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .semibold)
        $0.textColor = .increase
    }
    
    private let highestRateLabel = UILabel().then {
        $0.text = "최고환율"
        $0.font = .pretendard(size: 15, weight: .medium)
        $0.textColor = .gray500
    }
    
    private let highestRateValueLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .semibold)
        $0.textColor = .decrease
    }
    
    private let dividerView1 = UIView().then {
        $0.backgroundColor = .divider
    }
    
    private let newsTitleLabel = UILabel().then {
        $0.text = "주요 환율뉴스"
        $0.font = .pretendard(size: 20, weight: .semibold)
        $0.textColor = .black
    }
    
    private let newsImageView1 = UIImageView().then {
        $0.image = .homeDetailNews
    }
    
    private let newsHeadlineLabel1 = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .black
        $0.numberOfLines = 2
    }
    
    private let newsDateLabel1 = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .medium)
        $0.textColor = .gray500
    }
    
    private let newsImageView2 = UIImageView().then {
        $0.image = .homeDetailNews
    }
    
    private let newsHeadlineLabel2 = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .black
        $0.numberOfLines = 2
    }
    
    private let newsDateLabel2 = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .medium)
        $0.textColor = .gray500
    }
    
    private let newsImageView3 = UIImageView().then {
        $0.image = .homeDetailNews
    }
    
    private let newsHeadlineLabel3 = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .black
        $0.numberOfLines = 2
    }
    
    private let newsDateLabel3 = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .medium)
        $0.textColor = .gray500
    }
    
    private let newsImageView4 = UIImageView().then {
        $0.image = .homeDetailNews
    }
    
    private let newsHeadlineLabel4 = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .black
        $0.numberOfLines = 2
    }
    
    private let newsDateLabel4 = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .medium)
        $0.textColor = .gray500
    }
    
    private let newsImageView5 = UIImageView().then {
        $0.image = .homeDetailNews
    }
    
    private let newsHeadlineLabel5 = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .black
        $0.numberOfLines = 2
    }
    
    private let newsDateLabel5 = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .medium)
        $0.textColor = .gray500
    }
    
    private let dividerView2 = UIView().then {
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
    
    // MARK: - life cycles
    override func prepareForReuse() {
        super.prepareForReuse()
        
        currentRateLabel.text = nil
        rateChangeLabel.text = nil
        lowestRateValueLabel.text = nil
        highestRateValueLabel.text = nil
        newsImageView1.image = .homeDetailNews
        newsHeadlineLabel1.text = nil
        newsDateLabel1.text = nil
        newsImageView2.image = .homeDetailNews
        newsHeadlineLabel2.text = nil
        newsDateLabel2.text = nil
        newsImageView3.image = .homeDetailNews
        newsHeadlineLabel3.text = nil
        newsDateLabel3.text = nil
        newsImageView4.image = .homeDetailNews
        newsHeadlineLabel4.text = nil
        newsDateLabel4.text = nil
        newsImageView5.image = .homeDetailNews
        newsHeadlineLabel5.text = nil
        newsDateLabel5.text = nil
    }
    
    // MARK: - methods
    override func configureUI() {
        selectionStyle = .none
    }
    
    override func configureHierarchy() {
        contentView.addSubview(exchangeRateTitleView)
        contentView.addSubview(currentRateLabel)
        contentView.addSubview(rateChangeLabel)
        contentView.addSubview(exchangeRateChartView)
        contentView.addSubview(segmentedControl)
        contentView.addSubview(exchangeRateChangeTitleLabel)
        contentView.addSubview(exchangeRateChangeContainerView)
        contentView.addSubview(dividerView1)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(newsImageView1)
        contentView.addSubview(newsHeadlineLabel1)
        contentView.addSubview(newsDateLabel1)
        contentView.addSubview(newsImageView2)
        contentView.addSubview(newsHeadlineLabel2)
        contentView.addSubview(newsDateLabel2)
        contentView.addSubview(newsImageView3)
        contentView.addSubview(newsHeadlineLabel3)
        contentView.addSubview(newsDateLabel3)
        contentView.addSubview(newsImageView4)
        contentView.addSubview(newsHeadlineLabel4)
        contentView.addSubview(newsDateLabel4)
        contentView.addSubview(newsImageView5)
        contentView.addSubview(newsHeadlineLabel5)
        contentView.addSubview(newsDateLabel5)
        contentView.addSubview(dividerView2)
        contentView.addSubview(exchangeRateNoticeTitleLabel)
        contentView.addSubview(exchangeRateNoticeBodyStackView)
        exchangeRateChangeContainerView.addSubview(lowestRateLabel)
        exchangeRateChangeContainerView.addSubview(lowestRateValueLabel)
        exchangeRateChangeContainerView.addSubview(highestRateLabel)
        exchangeRateChangeContainerView.addSubview(highestRateValueLabel)
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
        exchangeRateTitleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(22)
        }
        
        currentRateLabel.snp.makeConstraints {
            $0.top.equalTo(exchangeRateTitleView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(22)
        }
        
        rateChangeLabel.snp.makeConstraints {
            $0.top.equalTo(currentRateLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(22)
        }
        
        exchangeRateChartView.snp.makeConstraints {
            $0.top.equalTo(rateChangeLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(200)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(exchangeRateChartView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        
        exchangeRateChangeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        exchangeRateChangeContainerView.snp.makeConstraints {
            $0.top.equalTo(exchangeRateChangeTitleLabel.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        lowestRateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(32)
        }
        
        lowestRateValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(lowestRateLabel)
            $0.trailing.equalToSuperview().offset(-32)
        }
        
        highestRateLabel.snp.makeConstraints {
            $0.top.equalTo(lowestRateLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(32)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        highestRateValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(highestRateLabel)
            $0.trailing.equalToSuperview().offset(-32)
        }
        
        dividerView1.snp.makeConstraints {
            $0.top.equalTo(exchangeRateChangeContainerView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        newsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView1.snp.bottom).offset(36)
            $0.leading.equalToSuperview().offset(16)
        }
        
        newsImageView1.snp.makeConstraints {
            $0.top.equalTo(newsTitleLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(54)
        }
        
        newsHeadlineLabel1.snp.makeConstraints {
            $0.top.equalTo(newsImageView1).offset(-4)
            $0.leading.equalTo(newsImageView1.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        newsDateLabel1.snp.makeConstraints {
            $0.top.equalTo(newsHeadlineLabel1.snp.bottom).offset(8)
            $0.leading.equalTo(newsHeadlineLabel1)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        newsImageView2.snp.makeConstraints {
            $0.top.equalTo(newsImageView1.snp.bottom).offset(52)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(54)
        }
        
        newsHeadlineLabel2.snp.makeConstraints {
            $0.top.equalTo(newsImageView2).offset(-4)
            $0.leading.equalTo(newsImageView2.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        newsDateLabel2.snp.makeConstraints {
            $0.top.equalTo(newsHeadlineLabel2.snp.bottom).offset(8)
            $0.leading.equalTo(newsHeadlineLabel2)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        newsImageView3.snp.makeConstraints {
            $0.top.equalTo(newsImageView2.snp.bottom).offset(52)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(54)
        }
        
        newsHeadlineLabel3.snp.makeConstraints {
            $0.top.equalTo(newsImageView3).offset(-4)
            $0.leading.equalTo(newsImageView3.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        newsDateLabel3.snp.makeConstraints {
            $0.top.equalTo(newsHeadlineLabel3.snp.bottom).offset(8)
            $0.leading.equalTo(newsHeadlineLabel3)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        newsImageView4.snp.makeConstraints {
            $0.top.equalTo(newsImageView3.snp.bottom).offset(52)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(54)
        }
        
        newsHeadlineLabel4.snp.makeConstraints {
            $0.top.equalTo(newsImageView4).offset(-4)
            $0.leading.equalTo(newsImageView4.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        newsDateLabel4.snp.makeConstraints {
            $0.top.equalTo(newsHeadlineLabel4.snp.bottom).offset(8)
            $0.leading.equalTo(newsHeadlineLabel4)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        newsImageView5.snp.makeConstraints {
            $0.top.equalTo(newsImageView4.snp.bottom).offset(52)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(54)
        }
        
        newsHeadlineLabel5.snp.makeConstraints {
            $0.top.equalTo(newsImageView5).offset(-4)
            $0.leading.equalTo(newsImageView5.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        newsDateLabel5.snp.makeConstraints {
            $0.top.equalTo(newsHeadlineLabel5.snp.bottom).offset(8)
            $0.leading.equalTo(newsHeadlineLabel5)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        dividerView2.snp.makeConstraints {
            $0.top.equalTo(newsImageView5.snp.bottom).offset(46)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        exchangeRateNoticeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView2.snp.bottom).offset(44)
            $0.horizontalEdges.equalToSuperview().inset(32)
        }
        
        exchangeRateNoticeBodyStackView.snp.makeConstraints {
            $0.top.equalTo(exchangeRateNoticeTitleLabel.snp.bottom).offset(22)
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().offset(-124)
        }
    }
}
