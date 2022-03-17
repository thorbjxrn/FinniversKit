//
//  WishlistButton.swift
//  FinniversKit
//
//  Created by Thorbjørn Throndsen Bonvik on 09/02/2022.
//

import UIKit

public protocol WishlistButtonViewModel {
    var title: String { get }
    var isWishlisted: Bool { get }
}

public protocol WishlistButtonViewDelegate: AnyObject {
    func wishlistButtonDidSelect(_ wishlistButtonView: WishlistButtonView, button: Button, viewModel: WishlistButtonViewModel)
}


public class WishlistButtonView: UIView {

    // MARK: - Public properties

    public weak var delegate: WishlistButtonViewDelegate?

    // MARK: - Private properties

    private var viewModel: WishlistButtonViewModel?

    private lazy var button: Button = {
        let button = Button(style: .callToAction, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        return button
    }()
    
    

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with viewModel: WishlistButtonViewModel) {
        self.viewModel = viewModel
        
        button.setTitle(viewModel.title, for: .normal)
        
        button.titleLabel?.dropShadow(color: UIColor.black, opacity: 1.0, offset: CGSize.zero, radius: CGFloat.init(2.5))
        
        button.setBackgroundImage(UIImage(named: .floral), for: .normal)
        button.clipsToBounds = true
    }

    // MARK: - Private methods

    @objc private func handleButtonTap() {
        guard let viewModel = viewModel else { return }
        delegate?.wishlistButtonDidSelect(self, button: button, viewModel: viewModel)
    }
}
