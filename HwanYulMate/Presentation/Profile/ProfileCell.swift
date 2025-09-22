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
        print("🔄 [ProfileCell] prepareForReuse 호출")
        
        forceResetAllTextAttributes()
        
        chevronImageView.isHidden = false
        versionLabel.isHidden = true
        detailLabel.isHidden = false
        
        selectionStyle = .none
        backgroundColor = .white
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
            $0.trailing.lessThanOrEqualTo(chevronImageView.snp.leading).offset(-8)
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
        print("🔧 [ProfileCell] configure 호출 - 타입: \(cellType), 제목: \(title)")
        
        forceResetAllTextAttributes()
        
        switch cellType {
        case .normal:
            configureNormalCell(title: title, detail: detail, showChevron: showChevron)
            
        case .email:
            configureEmailCell(title: title, detail: detail)
            
        case .loginLink:
            configureLoginLinkCell(title: title)
            
        case .version:
            configureVersionCell(title: title, version: version)
        }
        
        /// 구성 완료 후 상태 검증
        verifyConfigurationState(expectedType: cellType, title: title)
    }
    
    // MARK: - methods (configuration)
    private func forceResetAllTextAttributes() {
        titleLabel.attributedText = nil
        detailLabel.attributedText = nil
        versionLabel.attributedText = nil
        
        titleLabel.text = nil
        detailLabel.text = nil
        versionLabel.text = nil
        
        titleLabel.font = .pretendard(size: 14, weight: .regular)
        titleLabel.textColor = .gray600
        
        let cleanAttributedString = NSMutableAttributedString(string: "")
        titleLabel.attributedText = cleanAttributedString
        
        backgroundColor = .white
        selectionStyle = .none
        
        print("🧹 [ProfileCell] 모든 텍스트 속성 강제 초기화 완료")
    }
    
    private func configureNormalCell(title: String, detail: String?, showChevron: Bool) {
        titleLabel.attributedText = nil
        titleLabel.text = title
        detailLabel.text = detail
        detailLabel.isHidden = detail == nil
        versionLabel.isHidden = true
        chevronImageView.isHidden = !showChevron
        selectionStyle = showChevron ? .default : .none
        titleLabel.textColor = .gray600
        
        print("✅ [ProfileCell] Normal 셀 구성 완료: \(title)")
    }
    
    private func configureEmailCell(title: String, detail: String?) {
        titleLabel.attributedText = nil
        titleLabel.text = title
        detailLabel.text = detail
        detailLabel.isHidden = false
        versionLabel.isHidden = true
        chevronImageView.isHidden = true
        selectionStyle = .none
        titleLabel.textColor = .gray900
        
        print("✅ [ProfileCell] Email 셀 구성 완료: \(title)")
    }
    
    private func configureLoginLinkCell(title: String) {
        detailLabel.isHidden = true
        versionLabel.isHidden = true
        chevronImageView.isHidden = false
        selectionStyle = .default
        
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: title.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.main, range: NSRange(location: 0, length: title.count))
        attributedString.addAttribute(.font, value: UIFont.pretendard(size: 14, weight: .medium), range: NSRange(location: 0, length: title.count))
        titleLabel.attributedText = attributedString
        
        print("🔍 [ProfileCell] LoginLink 설정: \(title)")
    }
    
    private func configureVersionCell(title: String, version: String?) {
        titleLabel.attributedText = nil
        titleLabel.text = title
        versionLabel.text = version
        versionLabel.isHidden = false
        detailLabel.isHidden = true
        chevronImageView.isHidden = true
        selectionStyle = .none
        titleLabel.textColor = .gray600
        
        print("✅ [ProfileCell] Version 셀 구성 완료: \(title)")
    }
    
    // MARK: - methods (debugging)
    private func verifyConfigurationState(expectedType: ProfileCellType, title: String) {
        let hasAttributedText = titleLabel.attributedText != nil
        let hasPlainText = titleLabel.text != nil
        
        print("🔍 [ProfileCell] 구성 검증:")
        print("   - 예상 타입: \(expectedType)")
        print("   - 제목: \(title)")
        print("   - AttributedText 존재: \(hasAttributedText)")
        print("   - PlainText 존재: \(hasPlainText)")
        
        /// loginLink가 아닌데 attributedText가 있으면 경고
        if expectedType != .loginLink && hasAttributedText {
            print("⚠️ [ProfileCell] 경고: loginLink가 아닌 타입(\(expectedType))에 attributedText 존재!")
            titleLabel.attributedText = nil
            titleLabel.text = title
        }
    }
}

enum ProfileCellType {
    case normal
    case email
    case loginLink
    case version
}
