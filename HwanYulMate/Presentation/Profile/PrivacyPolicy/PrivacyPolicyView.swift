//
//  PrivacyPolicyView.swift
//  HwanYulMate
//
//  Created by HanJW on 9/3/25.
//

import UIKit
import SnapKit
import Then

final class PrivacyPolicyView: BaseView {
    
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
        $0.text = "개인정보 처리방침"
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
        환율메이트는 이용자의 개인정보를 소중히 다루고 있습니다. 저희는 ‘개인정보보호법'과 ‘정보통신망 이용 촉진 및 정보 보호 등에 관한 법률' 등 모든 관련 법규를 준수하며 회원님의 개인정보가 보호받을 수 있도록 최선을 다하고 있습니다. 
        개인정보 보호정책을 통해 이용자가 제공한 개인정보가 어떠한 용도와 방식으로 이용되며, 개인정보를 위해 어떠한 방법을 통해 관리되고 있는지에 대해 알려드립니다.
        
        제 1조 개인정보의 수집과 이용 목적
        
        회사는 아래와 같은 목적을 위해 개인정보를 수집하여 활용합니다. 이용자가 제공한 모든 정보는 목적 외 용도로 사용되지 않으며, 이용 목적이 변경될 때에는 사전에 이용자의 동의를 구합니다.
        
        • 회원관리 : 회원제 서비스 제공, 개인 식별, 불량 회원의 부정 이용 방지와 비인가 사용 방지, 가입 의사 확인, 만 14세 미만 아동 개인정보 수집 시 법정 대리인 동의 여부 확인, 불만 처리 등 민원 처리
        • 신규 서비스 개발 및 마케팅 활용 : 통계학적 특성, 이용 형태, 접속 빈도, 회원의 서비스 이용에 대한 통계
        
        제 2조 개인정보의 수집 항목과 수집 방법
        
        회사는 원활한 서비스 제공을 위해 이용자의 동의를 얻어 아래와 같은 개인정보를 수집하고 있으며, 반드시 사전에 이용자에게 해당 사실을 알리고 동의를 구하도록 하겠습니다.
        
        1. 개인정보 수집항목
        • 회원 가입
        • 수집 및 이용 목적 : 회원제 서비스 제공
        • 수집항목
        • 필수 : SNS 계정명, 이메일, 닉네임, 생년월일
        
        제 3조 개인정보 수집에 대한 동의
        
        • 회사는 이용자가 개인정보 보호정책 또는 이용약관의 내용에 대해 ‘ 동의함’ 버튼을 통해 동의 여부를 선택할 수 있는 절차를 마련하여, ‘동의함’ 버튼을 선택할 경우 입력하신 개인 정보가 당사의 고객 DB에 저장되어 상기 명시된 이용목적에 적합하게 이용되는 것으로 간주합니다.
        • 개인정보 수정 등을 통해 추가로 수집하는 개인정보를 기재한 후 저장하면, 개인정보 수집에 동의한 것으로 간주합니다.
        • 제휴사 등 제 3자를 통해 개인정보 수집에 대한 동의를 받을 경우에도, 이용자가 개인정보 보호정책 또는 이용약관의 내용에 대해 ‘동의함’ 버튼을 통해 동의 여부를 선택할 수 있는 절차를 마련하여, ‘동의함’ 버튼을 선택할 경우 동의하신 것과 동일하게 간주합니다.
        
        제 4조 개인정보의 처리 및 보유기간
        
        1. 개인 정보의 보유 및 이용기간
        
        회사는 이용자의 개인정보를 회원 탈퇴, 동의 철회, 수집 및 이용목적이 달성 시 지체없이 파기하고 있습니다. 또한 아래와 같이 관련법령에 따라 해당 기간 동안 개인정보를 안전하게 보관합니다.
        
        • 전자상거래법률
        • 계약 또는 청약철회 등에 관한 기록 : 5년
        • 대금결제 및 재화 등의 공급에 관한 기록 : 5년
        • 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년
        • 표시/광고에 관한 기록 : 6개월
        • 전자금융거래법
        • 전자금융 거래에 관한 기록 : 5년
        • 통신비밀보호법
        • 웹사이트 방문 기록 : 3개월
        1. 회원 탈퇴와 재가입
        
        탈퇴 완료된 계정의 개인 정보 및 활동 정보는 탈퇴 즉시 영구적으로 삭제되며 복구할 수 없습니다. 또한, 해당 계정의 모든 SNS 계정과의 연동이 해제됩니다. 탈퇴 이후에는 탈퇴 이전과 동일한 이메일 주소 또는 SNS 계정으로 재가입이 가능합니다.
        
        1. 개인정보 주체의 관리
        
        원칙적으로는 이용자는 개인정보 보호법에 의해 개인정보 수집 동의를 거부할 권리가 있습니다. 다만 필수 항목의 수집을 거부하면 회원가입 및 서비스 이용이 불가합니다.
        
        제 5조 개인정보의 파기 절차 및 방법
        
        회사는 이용자의 별도 동의가 있거나 법령에 규정된 경우를 제외하고는 이용자의 개인정보를 제3자에게 제공하지 않습니다. 단, 서비스 제공을 위해서 반드시 필요한 경우에 한하여 아래와 같이 개인정보를 처리하고 있습니다.
        
        1. 개인정보의 위탁
        
        서비스 제공이 있어 반드시 필요한 업무 중 일부를 외부업체에서 수행할 수 있도록 개인정보를 위탁하고 있습니다. 또한 개인정보 보호법에 따라 회사는 위탁업무의 내용이나 수탁자가 변경될 경우 본 ‘개인정보 처리방침’ 을 통하여 고지하겠습니다.
        
        제 6조 개인정보의 파기 절차 및 방법
        
        회사는 개인정보 수집 및 이용 목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 파기 절차와 방법은 아래와 같습니다.
        
        1. 파기절차
        • 이용자가 회원 가입 등을 위해 입력하신 정보는 목적이 달성된 후 별도의 DB로 옮겨져 내부 방침 및 기타 관련 법령에 의한 정보 보호 사유에 따라 일정 기간 동안 저장된 후 파기됩니다.
        • 별도 DB 로 옮겨진 개인정보는 법률에 의한 경우 이외의 다른 목적으로 이용되지 않습니다.
        • 회사는 파기 사유가 발생한 개인정보를 선정하고, 회사의 개인정보 책임자의 승인을 받아 개인정보를 파기합니다.
        
        제 7조 개인정보 자동 수집 장치에 관한 사항 (설치, 운영 및 거부)
        
        제 8조 행태정보의 수집, 이용 및 거부 등에 관한 사항
        
        제 9조 개인정보의 관리적 보호 대책
        
        제 10조 고지의 의무
        
        이 개인정보처리방침은 2025년 09월 15일부터 적용되며, 변경이 있을 시에는 변경 사항의 시행  7일 전부터 웹사이트의 공지사항 또는 별도 공지를 통하여 고지할 것 입니다.
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
