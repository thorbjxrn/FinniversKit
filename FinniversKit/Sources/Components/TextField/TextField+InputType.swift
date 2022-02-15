//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

extension TextField {
    public enum InputType {
        case normal
        case email
        case phoneNumber
        case password
        case multiline
        case age

        var isSecureMode: Bool {
            switch self {
            case .password: return true
            default: return false
            }
        }

        var keyBoardStyle: UIKeyboardType {
            switch self {
            case .email: return .emailAddress
            case .phoneNumber: return .phonePad
            case .age: return .numberPad
            default: return .default
            }
        }

        var returnKeyType: UIReturnKeyType {
            switch self {
            case .email: return .next
            case .normal, .phoneNumber, .password, .multiline, .age: return .done
            }
        }

        var textContentType: UITextContentType? {
            switch self {
            case .email:
                return .emailAddress
            case .phoneNumber:
                return .telephoneNumber
            case .password:
                return .password
            case .normal, .multiline, .age:
                return nil
            }
        }
    }
}
