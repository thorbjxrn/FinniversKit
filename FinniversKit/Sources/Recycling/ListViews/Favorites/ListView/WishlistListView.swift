//
//  WishlistListView.swift
//  FinniversKit
//
//  Created by Thorbjørn on 02/03/2022.
//

import Foundation

public protocol WishlistListViewDelegate: AnyObject {
    func wishlistListView(_ wishlistListView: WishlistListView, didSelectItemAtIndex index: Int)
    func wishlistListView(_ wishlistListView: WishlistListView, willDisplayItemAtIndex index: Int)
    func wishlistListView(_ wishlistListView: WishlistListView, didScrollInScrollView scrollView: UIScrollView)
}

public protocol WishlistListViewDataSource: AnyObject {
    func numberOfItems(inWishlistListView WishlistListView: WishlistListView) -> Int

}

public class WishlistListView: UIView {
    public static let estimatedRowHeight: CGFloat = 90.0

    // MARK: - Internal properties

    // Have the collection view be private so nobody messes with it.
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .bgPrimary
        tableView.rowHeight = WishlistListView.estimatedRowHeight
        tableView.estimatedRowHeight = WishlistListView.estimatedRowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()

    private weak var delegate: WishlistListViewDelegate?
    //private weak var dataSource: FavoritesListViewDataSource?

    // MARK: - Setup

    public init(delegate: WishlistListViewDelegate, dataSource: FavoritesListViewDataSource) {
        super.init(frame: .zero)

        self.delegate = delegate
        //self.dataSource = dataSource

        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        tableView.register(FavoritesListViewCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }

}
