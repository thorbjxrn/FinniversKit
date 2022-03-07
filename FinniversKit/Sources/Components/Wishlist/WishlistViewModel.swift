//
//  WishlistViewModel.swift
//  FinniversKit
//
//  Created by Thorbjørn on 28/02/2022.
//

import Foundation


public struct WishListViewModel {
    public struct Page {
        let title: String
        let text: String
        let accessoryButtonTitle: String?
        let actionButtonIcon: UIImage?
        let actionButtonTitle: String

        public init(title: String, text: String, accessoryButtonTitle: String?, actionButtonIcon: UIImage?, actionButtonTitle: String) {
            self.title = title
            self.text = text
            self.accessoryButtonTitle = accessoryButtonTitle
            self.actionButtonIcon = actionButtonIcon
            self.actionButtonTitle = actionButtonTitle
        }
    }

    let firstPage: Page
    let secondPage: Page

    public init(firstPage: Page, secondPage: Page) {
        self.firstPage = firstPage
        self.secondPage = secondPage
    }
}
