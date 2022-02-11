//
//  WishlistButton.swift
//  FinniversKit
//
//  Created by Thorbjørn Throndsen Bonvik on 09/02/2022.
//

import UIKit

public protocol WishlistButtonViewModel {
    var title: String { get }
    var subtitle: String? { get }
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
    private let flatButtonStyle = Button.Style.flat.overrideStyle(margins: UIEdgeInsets.zero)

    private lazy var button: Button = {
        /*
        let button = Button(style: flatButtonStyle, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(leading: .spacingS)
        button.imageEdgeInsets = UIEdgeInsets(top: -.spacingXS)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.contentHorizontalAlignment = .leading
        button.adjustsImageWhenHighlighted = false
        return button
         */
        let button = Button(style: .default, withAutoLayout: true)
        //button.setTitle("wishlist.actionButtonTitle".localized(), for: .normal)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [button, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .textSecondary
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
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
        subtitleLabel.text = viewModel.subtitle
        let image = viewModel.isWishlisted ? UIImage(named: .carsIllustration) : UIImage(named: .betaPill)
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .btnAction
    }

    // MARK: - Private methods

    @objc private func handleButtonTap() {
        guard let viewModel = viewModel else { return }
        delegate?.wishlistButtonDidSelect(self, button: button, viewModel: viewModel)
        print("WISHLIST BUTTON!!")
    }
}
