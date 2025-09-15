//
//  HomeDetailView.swift
//  HwanYulMate
//
//  Created by 김정호 on 9/9/25.
//

import UIKit
import DGCharts
import SnapKit
import Then

final class HomeDetailView: BaseView {
    
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
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    private let exchangeRateTitleView = UILabel().then {
        $0.text = "실시간 환율"
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray600
    }
    
    private let currentRateLabel = UILabel().then {
        $0.font = .pretendard(size: 24, weight: .semibold)
        $0.textColor = .gray900
    }
    
    private let rateChangeLabel = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .semibold)
    }
    
    private let exchangeRateChartView = LineChartView().then {
        $0.chartDescription.enabled = false
        $0.noDataText = "데이터가 없습니다."
        $0.legend.enabled = false
        $0.doubleTapToZoomEnabled = false
        $0.dragEnabled = false
        $0.setScaleEnabled(false)
        $0.pinchZoomEnabled = false
        $0.highlightPerTapEnabled = false
        $0.highlightPerDragEnabled = false
        $0.xAxis.labelPosition = .bottom
        $0.xAxis.drawGridLinesEnabled = false
        $0.xAxis.drawAxisLineEnabled = false
        $0.xAxis.avoidFirstLastClippingEnabled = true
        $0.xAxis.labelFont = .pretendard(size: 10, weight: .regular)
        $0.xAxis.labelTextColor = .gray800
        $0.xAxis.setLabelCount(2, force: true)
        $0.leftAxis.labelFont = .pretendard(size: 11, weight: .medium)
        $0.leftAxis.labelTextColor = .gray500
        $0.leftAxis.axisLineColor = .clear
        $0.leftAxis.setLabelCount(4, force: true)
        $0.leftAxis.gridColor = UIColor(white: 0.9, alpha: 1.0)
        $0.leftAxis.gridLineWidth = 1
        $0.rightAxis.enabled = false
    }
    
    let segmentedControl = UISegmentedControl(items: ["1주일", "1개월", "3개월", "6개월", "1년"]).then {
        $0.selectedSegmentIndex = 0
        $0.selectedSegmentTintColor = .white
        $0.setTitleTextAttributes([.foregroundColor: UIColor.gray900], for: .selected)
        $0.setTitleTextAttributes([.foregroundColor: UIColor.gray400], for: .normal)
    }
    
    private let exchangeRateChangeTitleLabel = UILabel().then {
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
    
    let newsButton1 = UIButton()
    
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
    
    let newsButton2 = UIButton()
    
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
    
    let newsButton3 = UIButton()
    
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
    
    let newsButton4 = UIButton()
    
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
    
    let newsButton5 = UIButton()
    
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
    
    let exchangeEstimateComparisonButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.contentInsets = .init(top: 14, leading: 0, bottom: 14, trailing: 0)
        config.attributedTitle = "환전 예상 금액 비교"
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
    
    // MARK: - methods
    override func configureHierarchy() {
        addSubview(scrollView)
        addSubview(exchangeEstimateComparisonButton)
        scrollView.addSubview(contentView)
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
        contentView.addSubview(newsButton1)
        contentView.addSubview(newsImageView2)
        contentView.addSubview(newsHeadlineLabel2)
        contentView.addSubview(newsDateLabel2)
        contentView.addSubview(newsButton2)
        contentView.addSubview(newsImageView3)
        contentView.addSubview(newsHeadlineLabel3)
        contentView.addSubview(newsDateLabel3)
        contentView.addSubview(newsButton3)
        contentView.addSubview(newsImageView4)
        contentView.addSubview(newsHeadlineLabel4)
        contentView.addSubview(newsDateLabel4)
        contentView.addSubview(newsButton4)
        contentView.addSubview(newsImageView5)
        contentView.addSubview(newsHeadlineLabel5)
        contentView.addSubview(newsDateLabel5)
        contentView.addSubview(newsButton5)
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
        navigationTitleLabel.snp.makeConstraints {
            $0.width.equalTo(200)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
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
        
        newsButton1.snp.makeConstraints {
            $0.top.equalTo(newsHeadlineLabel1)
            $0.bottom.equalTo(newsDateLabel1)
            $0.horizontalEdges.equalToSuperview()
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
        
        newsButton2.snp.makeConstraints {
            $0.top.equalTo(newsHeadlineLabel2)
            $0.bottom.equalTo(newsDateLabel2)
            $0.horizontalEdges.equalToSuperview()
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
        
        newsButton3.snp.makeConstraints {
            $0.top.equalTo(newsHeadlineLabel3)
            $0.bottom.equalTo(newsDateLabel3)
            $0.horizontalEdges.equalToSuperview()
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
        
        newsButton4.snp.makeConstraints {
            $0.top.equalTo(newsHeadlineLabel4)
            $0.bottom.equalTo(newsDateLabel4)
            $0.horizontalEdges.equalToSuperview()
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
        
        newsButton5.snp.makeConstraints {
            $0.top.equalTo(newsHeadlineLabel5)
            $0.bottom.equalTo(newsDateLabel5)
            $0.horizontalEdges.equalToSuperview()
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
        
        exchangeEstimateComparisonButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(32)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
    
    func bind(navigationTitle: String) {
        navigationTitleLabel.text = navigationTitle
    }
    
    func bind(exchangeRate: ExchangeRate) {
        currentRateLabel.text = exchangeRate.exchangeRate.toCurrencyString() + "원"
        
        let changeAmount = exchangeRate.changeAmount.toCurrencyString()
        let changePercent = exchangeRate.changePercent.toCurrencyString()
        
        switch exchangeRate.changeDirection {
        case .up:
            rateChangeLabel.text = "+" + changeAmount + "원 (" + changePercent + "%)"
            rateChangeLabel.textColor = .increase
        case .down:
            rateChangeLabel.text = "-" + changeAmount + "원 (" + changePercent + "%)"
            rateChangeLabel.textColor = .decrease
        case .stable:
            rateChangeLabel.text = changeAmount + "원 (" + changePercent + "%)"
            rateChangeLabel.textColor = .gray900
        }
    }
    
    func bind(chart: [Chart]) {
        var entries: [ChartDataEntry] = []
        
        for (index, element) in chart.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: element.rate))
        }
        
        let formattedDates = chart.map {
            let year = $0.date.prefix(4)
            let month = $0.date.dropFirst(4).prefix(2)
            let day = $0.date.suffix(2)
            
            return "\(year).\(month).\(day)"
        }
        
        exchangeRateChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: formattedDates)
        
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.mode = .linear
        dataSet.lineWidth = 2
        dataSet.setColor(.increase)
        dataSet.drawCirclesEnabled = false
        
        let datas = LineChartData(dataSet: dataSet)
        datas.setDrawValues(false)
        
        exchangeRateChartView.data = datas
    }
    
    func bind(exchangeRateChangeTitle: String) {
        exchangeRateChangeTitleLabel.text = exchangeRateChangeTitle
    }
    
    func bind(news: News) {
        newsHeadlineLabel1.text = news.newsList[0].title
        newsDateLabel1.text = news.newsList[0].pubDate
        newsHeadlineLabel2.text = news.newsList[1].title
        newsDateLabel2.text = news.newsList[1].pubDate
        newsHeadlineLabel3.text = news.newsList[2].title
        newsDateLabel3.text = news.newsList[2].pubDate
        newsHeadlineLabel4.text = news.newsList[3].title
        newsDateLabel4.text = news.newsList[3].pubDate
        newsHeadlineLabel5.text = news.newsList[4].title
        newsDateLabel5.text = news.newsList[4].pubDate
    }
}
