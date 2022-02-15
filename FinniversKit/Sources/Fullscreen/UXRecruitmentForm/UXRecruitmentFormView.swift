//
//  Copyright © 2022 FINN AS. All rights reserved.
//

import UIKit

public protocol UXRecruitmentFormViewDelegate: AnyObject {
    func uxRecruitmentFormView(_ view: UXRecruitmentFormView, didSubmitWithName name: String, email: String, phoneNumber: String?)
}

public final class UXRecruitmentFormView: UIView {
    public weak var delegate: UXRecruitmentFormViewDelegate?

    public var isValid: Bool {
        let isValidName = nameTextField.isValidAndNotEmpty
        let isValidAge = ageTextField.isValidAndNotEmpty
        let isValidEmail = emailTextField.isValidAndNotEmpty
        let isValidPhoneNumber = phoneNumberTextField.isValidAndNotEmpty

        return isValidName && isValidAge && isValidEmail && isValidPhoneNumber
    }

    public var phoneNumberRegEx: String {
        get { return phoneNumberTextField.phoneNumberRegEx }
        set { phoneNumberTextField.phoneNumberRegEx = newValue }
    }

    // MARK: - Private properties

    private let notificationCenter = NotificationCenter.default
    private lazy var scrollView = UIScrollView(withAutoLayout: true)
    private lazy var contentView = UIView(withAutoLayout: true)

    private lazy var detailTextLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var nameTextField: TextField = {
        let textField = TextField(inputType: .normal)
        textField.textField.returnKeyType = .next
        textField.textField.textContentType = .name
        textField.textField.autocapitalizationType = .words
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    private lazy var ageTextField: TextField = {
        let textField = TextField(inputType: .age)
        textField.textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    private lazy var emailTextField: TextField = {
        let textField = TextField(inputType: .email)
        textField.textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    private lazy var phoneNumberTextField: TextField = {
        let textField = TextField(inputType: .phoneNumber)
        textField.textField.returnKeyType = .send
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()

    private lazy var submitButton: Button = {
        let button = Button(style: .callToAction)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return button
    }()

    private var currentTextField: TextField? {
        if nameTextField.textField.isFirstResponder {
            return nameTextField
        } else if ageTextField.isFirstResponder {
            return ageTextField
        } else if emailTextField.textField.isFirstResponder {
            return emailTextField
        } else if phoneNumberTextField.textField.isFirstResponder {
            return phoneNumberTextField
        } else {
            return nil
        }
    }

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addObserverForKeyboardNotifications()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        addObserverForKeyboardNotifications()
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    // MARK: - Setup

    public func configure(with viewModel: UXRecruitmentFormViewModel) {
        detailTextLabel.text = viewModel.detailText
        subtitleLabel.text = viewModel.subtitle
        nameTextField.placeholderText = viewModel.namePlaceholder

        if viewModel.fullNameRequired {
            nameTextField.customValidator = { text in
                return text.split(
                    separator: " ",
                    maxSplits: 2,
                    omittingEmptySubsequences: true
                ).count > 1
            }
            nameTextField.helpText = viewModel.nameErrorHelpText
        } else {
            nameTextField.customValidator = nil
            nameTextField.helpText = nil
        }

        ageTextField.placeholderText = viewModel.agePlaceholder
        ageTextField.helpText = viewModel.ageErrorHelpText

        emailTextField.placeholderText = viewModel.emailPlaceholder
        emailTextField.helpText = viewModel.emailErrorHelpText

        phoneNumberTextField.placeholderText = viewModel.phoneNumberPlaceholder
        phoneNumberTextField.helpText = viewModel.phoneNumberErrorHelpText

        submitButton.setTitle(viewModel.submitButtonTitle, for: .normal)
    }

    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)

        backgroundColor = .bgPrimary

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(detailTextLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(ageTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(phoneNumberTextField)
        contentView.addSubview(submitButton)
        scrollView.fillInSuperview()

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .spacingXL),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -.spacingM),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .spacingM),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -.spacingM),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.spacingXL),

            detailTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            detailTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: detailTextLabel.bottomAnchor, constant: .spacingXL + .spacingS),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            nameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: .spacingM),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: .spacingM),
            ageTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ageTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            emailTextField.topAnchor.constraint(equalTo: ageTextField.bottomAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            phoneNumberTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            submitButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: .spacingM),
            submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingXXL),
        ])
    }

    // MARK: - Actions

    @objc private func handleTap() {
        endEditing(true)
    }

    @objc private func submit() {
        guard let name = nameTextField.text, let email = emailTextField.text else {
            return
        }

        var phoneNumber = phoneNumberTextField.isHidden ? nil : phoneNumberTextField.text
        phoneNumber = phoneNumber?.replacingOccurrences(of: " ", with: "")

        if isValid {
            delegate?.uxRecruitmentFormView(self, didSubmitWithName: name, email: email, phoneNumber: phoneNumber)
        }
    }

    private func scrollToBottom(animated: Bool) {
        var yOffset = scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom

        if let currentTextField = currentTextField, currentTextField != phoneNumberTextField {
            yOffset = min(yOffset, currentTextField.frame.minY + .spacingM)
        }

        if yOffset > 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
        }
    }

    // MARK: - Keyboard notifications

    private func addObserverForKeyboardNotifications() {
        addObserverForKeyboardNotification(named: UIResponder.keyboardWillHideNotification)
        addObserverForKeyboardNotification(named: UIResponder.keyboardWillShowNotification)
    }

    private func addObserverForKeyboardNotification(named name: NSNotification.Name) {
        notificationCenter.addObserver(self, selector: #selector(adjustScrollViewForKeyboard(_:)), name: name, object: nil)
    }

    @objc private func adjustScrollViewForKeyboard(_ notification: Notification) {
        guard let keyboardInfo = KeyboardNotificationInfo(notification) else { return }
        let keyboardHeight = keyboardInfo.keyboardFrameEndIntersectHeight(inView: self)

        if keyboardInfo.action == .willShow {
            UIView.animateAlongsideKeyboard(keyboardInfo: keyboardInfo, animations: { [weak self] in
                guard let self = self else { return }
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
                self.scrollToBottom(animated: false)
                self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
            }, completion: { _ in
                // If iPad, compensate and recalculate intersection for potential changes to
                // presentation thanks to `UIModalPresentationStyle.formSheet`.
                if UITraitCollection.isHorizontalSizeClassRegular {
                    UIView.animate(withDuration: 0.1, animations: { [weak self] in
                        guard let self = self else { return }
                        let correctedKeyboardHeight = keyboardInfo.keyboardFrameEndIntersectHeight(inView: self)
                        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: correctedKeyboardHeight, right: 0)
                        self.scrollToBottom(animated: false)
                        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
                    })
                }
            })
        }

        if keyboardInfo.action == .willHide {
            UIView.animateAlongsideKeyboard(keyboardInfo: keyboardInfo) { [weak self] in
                guard let self = self else { return }
                self.scrollView.contentInset = .zero
                self.scrollView.contentOffset = .zero
                self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
            }
        }
    }
}

// MARK: - TextFieldDelegate

extension UXRecruitmentFormView: TextFieldDelegate {
    public func textFieldShouldReturn(_ textField: TextField) -> Bool {
        if textField == nameTextField {
            emailTextField.textField.becomeFirstResponder()
        } else if textField == emailTextField, !phoneNumberTextField.isHidden {
            phoneNumberTextField.textField.becomeFirstResponder()
        } else {
            textField.textField.resignFirstResponder()
        }

        return true
    }

    public func textFieldDidChange(_ textField: TextField) {
        submitButton.isEnabled = isValid
    }
}
