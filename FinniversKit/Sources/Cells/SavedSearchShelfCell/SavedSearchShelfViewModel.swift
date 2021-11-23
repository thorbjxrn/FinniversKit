import Foundation

public struct SavedSearchShelfViewModel {
    public let title: String
    public let imageUrlString: String?
    public let id: Int
    public let adId: Int
    public let created: Date
    public let isRead: Bool

    public init(id: Int = Int.random(in: 0...100_000), title: String, imageUrlString: String?, adId: Int = Int.random(in: 0...100_000), created: Date = Date(), isRead: Bool) {
        self.title = title
        self.imageUrlString = imageUrlString
        self.id = id
        self.adId = adId
        self.created = created
        self.isRead = isRead
    }
}

extension SavedSearchShelfViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(id)" + "\(adId)" + title)
    }
}
