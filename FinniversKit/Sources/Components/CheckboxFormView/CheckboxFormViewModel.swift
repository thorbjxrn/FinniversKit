import Foundation

public class CheckboxFormViewModel {
    public let submitButtonTitle: String
    public let checkboxFormSections: [CheckboxFormSectionViewModel]
    public let disclaimerText: String

    public init(submitButtonTitle: String, checkboxFormSections: [CheckboxFormSectionViewModel], disclaimerText: String) {
        self.submitButtonTitle = submitButtonTitle
        self.checkboxFormSections = checkboxFormSections
        self.disclaimerText = disclaimerText
    }
}

public class CheckboxFormSectionViewModel {
    public let title: String
    public var checkboxStatements: [CheckboxStatementViewModel]

    public init(title: String, checkboxStatements: [CheckboxStatementViewModel]) {
        self.title = title
        self.checkboxStatements = checkboxStatements
    }
}

public class CheckboxStatementViewModel {
    public let text: String
    public let id: String
    public var isSelected: Bool = false

    public init(text: String, id: String) {
        self.text = text
        self.id = id
    }
}
