//
//  AlertController.swift
//  BookmarkApp
//
//  Created by Cody on 2020/02/26.
//  Copyright © 2020 AnAppPerTwoWeeks. All rights reserved.
//

import Foundation
import UIKit

enum AlertType {
    case TextfieldCanBeNull, CopiedBookmark
}
class AlertController {
    static func alert(type: AlertType, withViewController viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: getAlertMessage(withType: type), preferredStyle: .alert)
        viewController.present(alert, animated:true)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    private static func getAlertMessage(withType type: AlertType) -> String {
        switch type {
        case .TextfieldCanBeNull:
            return "모든 텍스트 필드를 입력해주세요."
        case .CopiedBookmark:
            return "URL이 복사 되었습니다."
        }
    }
}
