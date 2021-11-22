import Foundation

public struct SavedSearchShelfViewModel {
    public let title: String
    public let imageUrlString: String?
    public let id: String
    public let showColoredBorder: Bool

    public init(title: String, imageUrlString: String?, showColoredBorder: Bool) {
        self.title = title
        self.imageUrlString = imageUrlString
        self.showColoredBorder = showColoredBorder
        id = UUID().uuidString
    }
}

extension SavedSearchShelfViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id + title)
    }
}
