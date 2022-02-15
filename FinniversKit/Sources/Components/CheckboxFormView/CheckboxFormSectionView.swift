import Foundation
import UIKit

public class CheckboxFormSectionView: UIView {
    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        return label
    }()

    private lazy var checkboxStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
        return stackView
    }()

    private let viewModel: CheckboxFormSectionViewModel

    init(viewModel: CheckboxFormSectionViewModel, withAutoLayout: Bool) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(titleLabel)
        addSubview(checkboxStackView)

        configure(with: viewModel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            checkboxStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            checkboxStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkboxStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkboxStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configure(with viewModel: CheckboxFormSectionViewModel) {
        titleLabel.text = viewModel.title

        let statementViews = viewModel.checkboxStatements.map {
            CheckboxStatementView(viewModel: $0, delegate: self, withAutoLayout: true)
        }
        checkboxStackView.addArrangedSubviews(statementViews)
    }
}

extension CheckboxFormSectionView: CheckboxStatementViewDelegate {
    func checkboxStatementWasSelected(_ view: CheckboxStatementView) {
        view.viewModel.isSelected.toggle()
        view.updateView()
    }
}
