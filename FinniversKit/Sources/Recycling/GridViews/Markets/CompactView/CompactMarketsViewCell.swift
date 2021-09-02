import UIKit

class CompactMarketsViewCell: UICollectionViewCell {

    // MARK: - Internal properties

    var model: MarketsViewModel? {
        didSet {
            titleLabel.text = model?.title
            accessibilityLabel = model?.accessibilityLabel

            let showExternalLinkIcon = model?.showExternalLinkIcon ?? false
            externalLinkImageView.isHidden = !showExternalLinkIcon
        }
    }

    // MARK: - Private properties

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: Self.itemSpacing, withAutoLayout: true)
        stackView.addArrangedSubviews([titleLabel, externalLinkImageView])
        stackView.alignment = .center
        return stackView
    }()

    private lazy var externalLinkImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .webview).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .externalLinkColor
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: Self.titleLabelStyle, withAutoLayout: true)
        label.textAlignment = .left
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .cellBackgroundColor

        contentView.addSubview(stackView)
        stackView.fillInSuperview(insets: Self.contentInsets.forLayoutConstraints)

        NSLayoutConstraint.activate([
            externalLinkImageView.widthAnchor.constraint(equalToConstant: Self.externalLinkImageSize.width),
            externalLinkImageView.heightAnchor.constraint(equalToConstant: Self.externalLinkImageSize.height),
        ])
    }

    // MARK: - Superclass Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        accessibilityLabel = ""
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}

// MARK: - Size calculations

extension CompactMarketsViewCell {
    static let contentInsets = UIEdgeInsets(vertical: .spacingS, horizontal: 12)
    static let titleLabelStyle = Label.Style.captionStrong
    static let cellHeight: CGFloat = 34
    static let itemSpacing = CGFloat.spacingS
    static let externalLinkImageSize = CGSize(width: 12, height: 12)

    static func size(for model: MarketsViewModel) -> CGSize {
        var widths: [CGFloat] = [
            contentInsets.leading,
            itemSpacing,
            width(for: model.title)
        ]

        if model.showExternalLinkIcon {
            widths.append(contentsOf: [
                itemSpacing,
                externalLinkImageSize.width
            ])
        }

        widths.append(contentInsets.trailing)

        return CGSize(width: widths.reduce(0, +), height: cellHeight)
    }

    private static func width(for title: String) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: cellHeight)
        let boundingBox = title.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: titleLabelStyle.font],
            context: nil
        )

        return ceil(boundingBox.width)
    }
}

// MARK: - Private extensions

private extension UIColor {
     class var externalLinkColor: UIColor {
         return .blueGray600
     }

     class var cellBackgroundColor: UIColor {
         return .dynamicColorIfAvailable(defaultColor: .coolGray100, darkModeColor: .blueGray700)
     }
 }

private extension UIEdgeInsets {
    var forLayoutConstraints: UIEdgeInsets {
        UIEdgeInsets(top: top, leading: leading, bottom: -bottom, trailing: -trailing)
    }
}
