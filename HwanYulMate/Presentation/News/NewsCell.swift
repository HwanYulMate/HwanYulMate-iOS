//
//  NewsCell.swift
//  HwanYulMate
//
//  Created by HanJW on 8/28/25.
//

import UIKit
import SnapKit
import Then

final class NewsCell: BaseTableViewCell {
    
    // MARK: - Properties
    static let identifier = "NewsCell"
    
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .black
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .pretendard(size: 12, weight: .regular)
        $0.textColor = .gray500
    }
    
    // MARK: - Constants
    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 18
        static let thumbnailSize: CGFloat = 56
        static let thumbnailTitleSpacing: CGFloat = 12
        static let titleDateSpacing: CGFloat = 4
        static let lineSpacing: CGFloat = 4.0
    }
    
    // MARK: - Life Cycles
    override func prepareForReuse() {
        super.prepareForReuse()
        resetContent()
    }
    
    // MARK: - Methods
    override func configureUI() {
        selectionStyle = .default
        selectedBackgroundView = UIView().then {
            $0.backgroundColor = .systemGray6
        }
    }
    
    override func configureHierarchy() {
        [thumbnailImageView, titleLabel, dateLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.horizontalPadding)
            $0.top.bottom.equalToSuperview().inset(Constants.verticalPadding)
            $0.size.equalTo(Constants.thumbnailSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(Constants.thumbnailTitleSpacing)
            $0.top.equalToSuperview().offset(Constants.verticalPadding)
            $0.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.titleDateSpacing)
            $0.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            $0.bottom.equalToSuperview().offset(-Constants.verticalPadding)
        }
    }
    
    func configure(with news: NewsModel, searchText: String = "") {
        thumbnailImageView.image = UIImage(named: "news_thumbnail")
        dateLabel.text = news.publishedDate
        titleLabel.attributedText = createAttributedTitle(news.title, searchText: searchText)
    }
    
    private func resetContent() {
        thumbnailImageView.image = nil
        titleLabel.attributedText = nil
        titleLabel.text = nil
        dateLabel.text = nil
    }
    
    private func createAttributedTitle(_ text: String, searchText: String) -> NSAttributedString {
        guard !text.isEmpty else { return NSAttributedString() }
        
        let attributedText = NSMutableAttributedString(string: text)
        applyBasicTextAttributes(to: attributedText, range: NSRange(location: 0, length: text.count))
        
        if !searchText.isEmpty {
            highlightSearchMatches(in: attributedText, text: text, searchText: searchText)
        }
        
        return attributedText
    }
    
    private func applyBasicTextAttributes(to attributedText: NSMutableAttributedString, range: NSRange) {
        attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: range)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = Constants.lineSpacing
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
    }
    
    private func highlightSearchMatches(in attributedText: NSMutableAttributedString,
                                        text: String,
                                        searchText: String) {
        let lowercaseText = text.lowercased()
        let lowercaseSearch = searchText.lowercased()
        
        var searchRange = lowercaseText.startIndex..<lowercaseText.endIndex
        
        while let foundRange = lowercaseText.range(of: lowercaseSearch, range: searchRange) {
            let nsRange = NSRange(foundRange, in: text)
            attributedText.addAttribute(.foregroundColor, value: UIColor.main, range: nsRange)
            
            searchRange = foundRange.upperBound..<lowercaseText.endIndex
        }
    }
}
