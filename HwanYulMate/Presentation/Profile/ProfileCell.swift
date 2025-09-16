//
//  ProfileCell.swift
//  HwanYulMate
//
//  Created by HanJW on 9/1/25.
//

import UIKit
import SnapKit
import Then

final class ProfileCell: BaseTableViewCell {
    
    // MARK: - properties
    static let identifier = "ProfileCell"
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .regular)
        $0.textColor = .gray600
    }
    
    private let detailLabel = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .semibold)
        $0.textColor = .gray900
        $0.textAlignment = .right
    }
    
    private let chevronImageView = UIImageView().then {
        $0.image = UIImage(named: "arrow_back")
        $0.contentMode = .scaleAspectFit
    }
    
    private let versionLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .main
        $0.textAlignment = .right
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .divider
    }
    
    // MARK: - life cycles
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        detailLabel.text = nil
        versionLabel.text = nil
        
        chevronImageView.isHidden = false
        versionLabel.isHidden = true
        detailLabel.isHidden = false
        
        selectionStyle = .none
    }
    
    // MARK: - methods
    override func configureUI() {
        selectionStyle = .none
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(versionLabel)
        contentView.addSubview(chevronImageView)
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(16)
        }
        
        detailLabel.snp.makeConstraints {
            $0.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }
        
        versionLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(
        title: String,
        detail: String? = nil,
        version: String? = nil,
        showChevron: Bool = true,
        cellType: ProfileCellType = .normal
    ) {
        titleLabel.text = title
        
        switch cellType {
        case .normal:
            detailLabel.text = detail
            detailLabel.isHidden = detail == nil
            versionLabel.isHidden = true
            chevronImageView.isHidden = !showChevron
            selectionStyle = showChevron ? .default : .none
            
        case .email:
            detailLabel.text = detail
            detailLabel.isHidden = false
            versionLabel.isHidden = true
            chevronImageView.isHidden = true
            selectionStyle = .none
            titleLabel.textColor = .gray900
            
        case .version:
            versionLabel.text = version
            versionLabel.isHidden = false
            detailLabel.isHidden = true
            chevronImageView.isHidden = true
            selectionStyle = .none
            titleLabel.textColor = .gray600
        }
    }
}

enum ProfileCellType {
    case normal
    case email
    case version
}
