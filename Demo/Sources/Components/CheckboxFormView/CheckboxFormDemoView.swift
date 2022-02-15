import Foundation
import FinniversKit

class CheckboxFormDemoView: UIView {
    private lazy var checkboxFormView: CheckboxFormView = {
        let checkboxFormView = CheckboxFormView(viewModel: viewModel, withAutoLayout: true)
        return checkboxFormView
    }()

    let viewModel = CheckboxFormViewModel(
        submitButtonTitle: "Registrer deg",
        checkboxFormSections: [
            CheckboxFormSectionViewModel(
                title: "Bolig",
                checkboxStatements: [
                    CheckboxStatementViewModel(text: "Eier bolig", id: ""),
                    CheckboxStatementViewModel(text: "Leier bolig", id: ""),
                    CheckboxStatementViewModel(text: "Skal kjøpe/har nylig kjøpt bolig", id: ""),
                    CheckboxStatementViewModel(text: "Skal selge/har nylig solgt bolig", id: "")
                ]
            ),
            CheckboxFormSectionViewModel(
                title: "Jobb",
                checkboxStatements: [
                    CheckboxStatementViewModel(text: "Er på jobbjakt/har nylig byttet jobb", id: ""),
                    CheckboxStatementViewModel(text: "Leter etter nye ansatte", id: "")
                ]
            )
        ],
        disclaimerText: "Ved å registrere deg her samtykker du til at FINN tar vare på informasjonen om deg og kan invitere deg til å teste nye tjenester."
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(checkboxFormView)
        NSLayoutConstraint.activate([
            checkboxFormView.topAnchor.constraint(equalTo: topAnchor),
            checkboxFormView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            checkboxFormView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            checkboxFormView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
        ])
    }
}
