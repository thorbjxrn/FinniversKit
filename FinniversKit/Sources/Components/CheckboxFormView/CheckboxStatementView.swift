import UIKit

protocol CheckboxStatementViewDelegate: AnyObject {
    func checkboxStatementWasSelected(_ view: CheckboxStatementView)
}

class CheckboxStatementView: UIView {

    // MARK: - Internal properties

    let viewModel: CheckboxStatementViewModel

    // MARK: - Private properties

    private weak var delegate: CheckboxStatementViewDelegate?
    private lazy var checkbox = AnimatedCheckboxView(frame: .zero)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingXS, withAutoLayout: true)
        stackView.alignment = .center
        return stackView
    }()

    private lazy var textLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    init(viewModel: CheckboxStatementViewModel, delegate: CheckboxStatementViewDelegate, withAutoLayout: Bool) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        textLabel.text = viewModel.text

        addSubview(stackView)
        stackView.addArrangedSubviews([checkbox, textLabel])
        stackView.fillInSuperview()

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    // MARK: - Internal methods

    func updateView() {
        if viewModel.isSelected != checkbox.isHighlighted {
            checkbox.animateSelection(selected: viewModel.isSelected)
        }
    }

    // MARK: - Actions

    @objc private func handleTap() {
        delegate?.checkboxStatementWasSelected(self)
    }
}
