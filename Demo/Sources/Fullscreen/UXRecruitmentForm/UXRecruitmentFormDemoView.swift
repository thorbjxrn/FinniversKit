//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class UXRecruitmentFormDemoView: UIView {

    private lazy var contactFormView: UXRecruitmentFormView = {
        let view = UXRecruitmentFormView(withAutoLayout: true)
        view.delegate = self
        view.configure(with: ViewModel())
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(contactFormView)
        contactFormView.fillInSuperview()
    }
}

// MARK: - UXRecruitmentFormViewDelegate

extension UXRecruitmentFormDemoView: UXRecruitmentFormViewDelegate {
    public func uxRecruitmentFormView(_ view: UXRecruitmentFormView, didSubmitWithName name: String, email: String, phoneNumber: String?) {
        print("Name: \(name), email: \(email), phone number: \(phoneNumber ?? "-")")
    }
}

// MARK: - Private types

private struct ViewModel: UXRecruitmentFormViewModel {
    let title = "Overskrift"
    let detailText = "Tekst"
    let namePlaceholder = "Navn"
    let emailPlaceholder = "E-post"
    let phoneNumberPlaceholder = "Telefonnummer"
    let submitButtonTitle = "Kjør på!"
    var emailErrorHelpText = "Oppgi en gyldig e-postadresse."
    var phoneNumberErrorHelpText = "Oppgi et gyldig telefonnummer"
    var disclaimerText = "Disclaimer"
    var phoneNumberRequired = false
    var fullNameRequired = false
    var nameErrorHelpText: String?
}
