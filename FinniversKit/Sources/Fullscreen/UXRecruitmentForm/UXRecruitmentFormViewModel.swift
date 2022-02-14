//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol UXRecruitmentFormViewModel {
    var title: String { get }
    var detailText: String { get }
    var namePlaceholder: String { get }
    var emailPlaceholder: String { get }
    var phoneNumberPlaceholder: String { get }
    var submitButtonTitle: String { get }
    var emailErrorHelpText: String { get }
    var phoneNumberErrorHelpText: String { get }
    var disclaimerText: String { get }
    var phoneNumberRequired: Bool { get }
    var fullNameRequired: Bool { get }
    var nameErrorHelpText: String? { get }
}
