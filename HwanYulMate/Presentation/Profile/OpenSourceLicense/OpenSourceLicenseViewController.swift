//
//  OpenSourceLicenseView.swift
//  HwanYulMate
//
//  Created by HanJW on 9/3/25.
//

import UIKit
import SnapKit
import Then

final class OpenSourceLicenseView: BaseView {
    
    // MARK: - properties
    private let navigationBar = UIView().then {
        $0.backgroundColor = .white
    }
    
    let backButton = UIButton(type: .system).then {
        let image = UIImage(systemName: "chevron.left")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        )
        $0.setImage(image, for: .normal)
        $0.tintColor = .gray900
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "오픈소스 라이선스"
        $0.font = .pretendard(size: 16, weight: .semibold)
        $0.textColor = .gray900
        $0.textAlignment = .center
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
    }
    
    private let contentView = UIView()
    
    private let contentLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .regular)
        $0.textColor = .gray700
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.text = """
        Auth.swift
        
        Copyright (c) 2016 AuthO
        
        https://github.com/auth0/Auth0.swift
        
        The MIT License (MIT)
        
        Copyright (c) 2016 Auth0, Inc. (http://auth0.com)
        
        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
        associated documentation files (the "Software"), to deal in the Software without restriction, 
        including without limitation the rights to use, copy, modify, merge, publish, distribute, 
        sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is 
        furnished to do so, subject to the following conditions:
        
        The above copyright notice and this permission notice shall be included in all copies or 
        substantial portions of the Software.
        
        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
        BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
        NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
        DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
        
        
        Lock.swift
        
        Copyright (c) 2016 Auth0
        
        https://github.com/auth0/Auth0.swift
        
        The MIT License (MIT)
        
        Copyright (c) 2016 Auth0, Inc. (http://auth0.com)
        
        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
        associated documentation files (the "Software"), to deal in the Software without restriction, 
        including without limitation the rights to use, copy, modify, merge, publish, distribute, 
        sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is 
        furnished to do so, subject to the following conditions:
        
        The above copyright notice and this permission notice shall be included in all copies or 
        substantial portions of the Software.
        
        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
        BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
        NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
        DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
        """
    }
    
    // MARK: - methods
    override func configureUI() {
        super.configureUI()
        backgroundColor = .white
    }
    
    override func configureHierarchy() {
        addSubview(navigationBar)
        addSubview(scrollView)
        
        navigationBar.addSubview(backButton)
        navigationBar.addSubview(titleLabel)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(contentLabel)
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
            $0.center.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
