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
        let isValidEmail = emailTextField.isValidAndNotEmpty
        let isValidPhoneNumber = phoneNumberTextField.isValidAndNotEmpty

        return isValidName && isValidEmail && isValidPhoneNumber
    }

    public var phoneNumberRegEx: String {
        get { return phoneNumberTextField.phoneNumberRegEx }
        set { phoneNumberTextField.phoneNumberRegEx = newValue }
    }

    // MARK: - Private properties

    private let notificationCenter = NotificationCenter.default
    private lazy var scrollView = UIScrollView(withAutoLayout: true)
    private lazy var contentView = UIView(withAutoLayout: true)

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .title3
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var detailTextLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .body
        label.textColor = .textPrimary
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

    private lazy var disclaimerLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private var currentTextField: TextField? {
        if nameTextField.textField.isFirstResponder {
            return nameTextField
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
        titleLabel.text = viewModel.title
        detailTextLabel.text = viewModel.detailText
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

        emailTextField.placeholderText = viewModel.emailPlaceholder
        emailTextField.helpText = viewModel.emailErrorHelpText

        phoneNumberTextField.placeholderText = viewModel.phoneNumberPlaceholder
        phoneNumberTextField.helpText = viewModel.phoneNumberErrorHelpText

        submitButton.setTitle(viewModel.submitButtonTitle, for: .normal)
        disclaimerLabel.text = viewModel.disclaimerText
    }

    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)

        backgroundColor = .bgPrimary

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(detailTextLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(phoneNumberTextField)
        contentView.addSubview(disclaimerLabel)
        contentView.addSubview(submitButton)
        scrollView.fillInSuperview()

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .spacingXL),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -.spacingM),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .spacingM),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -.spacingM),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.spacingXL),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            detailTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXL),
            detailTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            nameTextField.topAnchor.constraint(equalTo: detailTextLabel.bottomAnchor, constant: .spacingM),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: .spacingM),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            phoneNumberTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            disclaimerLabel.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: .spacingM),
            disclaimerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            disclaimerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            submitButton.topAnchor.constraint(equalTo: disclaimerLabel.bottomAnchor, constant: .spacingM),
            submitButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            submitButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
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
