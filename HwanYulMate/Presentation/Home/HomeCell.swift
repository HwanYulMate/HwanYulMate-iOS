//
//  HomeCell.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/28/25.
//

import UIKit
import SnapKit
import Then

final class HomeCell: BaseTableViewCell {
    
    // MARK: - properties
    static let identifier = "HomeCell"
    
    private let countryImageView = UIImageView()
    
    private let currencyNameLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray900
    }
    
    private let rateStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .trailing
        $0.distribution = .equalSpacing
    }
    
    private let exchangeRateLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray900
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let rateChangeLabel = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .medium)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    // MARK: - life cycles
    override func prepareForReuse() {
        super.prepareForReuse()
        
        countryImageView.image = nil
        currencyNameLabel.text = nil
        exchangeRateLabel.text = nil
        rateChangeLabel.text = nil
    }
    
    // MARK: - methods
    override func configureUI() {
        selectionStyle = .none
    }
    
    override func configureHierarchy() {
        contentView.addSubview(countryImageView)
        contentView.addSubview(currencyNameLabel)
        contentView.addSubview(rateStackView)
        rateStackView.addArrangedSubview(exchangeRateLabel)
        rateStackView.addArrangedSubview(rateChangeLabel)
    }
    
    override func configureConstraints() {
        countryImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(28)
            $0.height.equalTo(18)
        }
        
        currencyNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(countryImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(rateStackView.snp.leading).offset(-8)
        }
        
        rateStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
