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
    
    // MARK: - Life Cycles
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImageView.image = nil
        titleLabel.attributedText = nil
        titleLabel.text = nil
        dateLabel.text = nil
    }
    
    // MARK: - Methods
    override func configureUI() {
        selectionStyle = .none
    }
    
    override func configureHierarchy() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
    }
    
    override func configureConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(18)
            $0.bottom.equalToSuperview().offset(-18)
            $0.width.height.equalTo(56)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-18)
        }
    }
    
    func configure(with news: NewsModel, searchText: String = "") {
        thumbnailImageView.image = UIImage(named: "news_thumbnail")
        dateLabel.text = news.publishedDate
        
        let finalAttributed: NSAttributedString
        if searchText.isEmpty {
            finalAttributed = formattedText(news.title)
        } else {
            finalAttributed = highlightSearchText(in: news.title, searchText: searchText)
        }
        titleLabel.attributedText = finalAttributed
    }
    
    private func formattedText(_ text: String) -> NSAttributedString {
        guard !text.isEmpty else { return NSAttributedString() }
        
        let attr = NSMutableAttributedString(string: text)
        let full = NSRange(location: 0, length: text.count)
        
        attr.addAttribute(.foregroundColor, value: UIColor.black, range: full)
        
        let lineSpacing: CGFloat = 4.0
        if lineSpacing.isFinite && lineSpacing >= 0 {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            style.lineBreakMode = .byTruncatingTail
            attr.addAttribute(.paragraphStyle, value: style, range: full)
        }
        
        return attr
    }
    
    private func highlightSearchText(in text: String, searchText: String) -> NSAttributedString {
        guard !text.isEmpty && !searchText.isEmpty else {
            return formattedText(text)
        }
        
        let attr = NSMutableAttributedString(string: text)
        let full = NSRange(location: 0, length: text.count)
        
        attr.addAttribute(.foregroundColor, value: UIColor.black, range: full)
        
        let lineSpacing: CGFloat = 4.0
        if lineSpacing.isFinite && lineSpacing >= 0 {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            style.lineBreakMode = .byTruncatingTail
            attr.addAttribute(.paragraphStyle, value: style, range: full)
        }
        
        let lowerText = text.lowercased()
        let lowerSearch = searchText.lowercased()
        var searchRange = lowerText.range(of: lowerSearch)
        
        while let found = searchRange {
            let nsRange = NSRange(found, in: text)
            if nsRange.location != NSNotFound &&
                nsRange.location >= 0 &&
                nsRange.location + nsRange.length <= text.count {
                attr.addAttribute(.foregroundColor, value: UIColor.main, range: nsRange)
            }
            
            let nextStart = found.upperBound..<lowerText.endIndex
            searchRange = lowerText.range(of: lowerSearch, range: nextStart)
        }
        
        return attr
    }
}
