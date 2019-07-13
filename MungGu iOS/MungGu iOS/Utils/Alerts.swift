//
//  Alerts.swift
//  MungGu iOS
//
//  Created by juhee on 13/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

enum Alerts {
    case serverErrorExit
    case serverErrorWarning
    case exitText
    case removeTestData
    case noFile
    case noHighlighting

    var title: String {
        switch self {
        case .serverErrorExit, .serverErrorWarning:
            return "서버접속이 원활하지 않습니다."
        case .exitText, .removeTestData:
            return "경고"
        case .noFile:
            return "파일이 없습니다. 파일을 선택하세요."
        case .noHighlighting:
            return "어떤 부분을 시험칠까요?"
        }
    }

    var message: String {
        switch self {
        case .serverErrorExit:
            return "잠시후에 다시 시도해주십시오.\n불편을 드려 죄송합니다."
        case .serverErrorWarning:
            return "인터넷 연결을 확인하시거나 잠시후에 다시 시도해주십시오.\n불편을 드려 죄송합니다."
        case .exitText:
            return "시험을 종료하시겠습니까? 데이터가 삭제됩니다."
        case .removeTestData:
            return "시험 히스토리를 삭제합니다."
        case .noFile:
            return ""
        case .noHighlighting:
            return "중요한 부분을 드래그하여 하이라이팅해주세요!"
        }
    }

    var logMessage: String? {
        let logHeader = "[MungGu iOS] "
        switch self {
        case .serverErrorExit:
            return "\(logHeader)서버 접속 장애"
        case .serverErrorWarning:
            return "\(logHeader)서버 접속 실패"
        default:
            return nil
        }
    }

}
