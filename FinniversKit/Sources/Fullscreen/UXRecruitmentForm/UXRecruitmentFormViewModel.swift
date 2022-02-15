//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol UXRecruitmentFormViewModel {
    var detailText: String { get }
    var subtitle: String { get }
    var namePlaceholder: String { get }
    var agePlaceholder: String { get }
    var ageErrorHelpText: String { get }
    var emailPlaceholder: String { get }
    var phoneNumberPlaceholder: String { get }
    var submitButtonTitle: String { get }
    var emailErrorHelpText: String { get }
    var phoneNumberErrorHelpText: String { get }
    var phoneNumberRequired: Bool { get }
    var fullNameRequired: Bool { get }
    var nameErrorHelpText: String? { get }
}
