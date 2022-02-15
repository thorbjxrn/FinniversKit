import Foundation
import UIKit

public protocol CheckboxFormViewDelegate: AnyObject {
    func checkboxFormViewDidFinish(_ checkboxFormView: CheckboxFormView) // pass on relevant values..
}

public class CheckboxFormView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingL, withAutoLayout: true)
        return stackView
    }()

    private lazy var submitButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var disclaimerLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private let viewModel: CheckboxFormViewModel
    private weak var delegate: CheckboxFormViewDelegate?

    public init(viewModel: CheckboxFormViewModel, delegate: CheckboxFormViewDelegate?, withAutoLayout: Bool) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()

        let sectionsViews = viewModel.checkboxFormSections.map({
            CheckboxFormSectionView(viewModel: $0, withAutoLayout: true)
        })
        stackView.addArrangedSubviews(sectionsViews)
        stackView.addArrangedSubviews([submitButton, disclaimerLabel])

        submitButton.setTitle(viewModel.submitButtonTitle, for: .normal)
        disclaimerLabel.text = viewModel.disclaimerText
    }

    @objc func submitButtonTapped() {
        delegate?.checkboxFormViewDidFinish(self)
    }
}
