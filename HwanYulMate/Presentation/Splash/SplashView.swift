//
//  SplashView.swift
//  HwanYulMate
//
//  Created by 김정호 on 8/26/25.
//

import UIKit
import SnapKit
import Then

final class SplashView: BaseView {

    // MARK: - properties
    private let splashImageView = UIImageView().then {
        $0.image = .splash
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - methods
    override func configureHierarchy() {
        addSubview(splashImageView)
    }
    
    override func configureConstraints() {
        splashImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
