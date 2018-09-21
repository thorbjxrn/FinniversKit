//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import UIKit

public enum ConsentTag {
    case detail, action
}

public struct ConsentViewCellModel {

    public enum State: String {
        case on = "På", off = "Av"
    }

    public let detailModel: ConsentDetailViewModel
    public let state: State?
    public let tag: ConsentTag

    public init(detailModel: ConsentDetailViewModel, state: State?, tag: ConsentTag) {
        self.detailModel = detailModel
        self.state = state
        self.tag = tag
    }
}

public class ConsentViewCell: UITableViewCell {
    static public let identifier = "consent-cell"

    lazy var titleLabel: UILabel = {
        let label = Label(style: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var stateLabel: UILabel = {
        let label = Label(style: .body)
        label.textColor = .stone
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var arrowView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .sardine
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var hairLine: UIView = {
        let line = UIView(frame: .zero)
        line.backgroundColor = .sardine
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    public var model: ConsentViewCellModel? {
        didSet { set(model: model) }
    }

    public var labelInset: CGFloat = 14

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func removeHairLine() {
        hairLine.backgroundColor = .clear
    }
}

private extension ConsentViewCell {

    func set(model: ConsentViewCellModel?) {
        guard let model = model else { return }
        titleLabel.text = model.detailModel.purpose.heading
        stateLabel.text = model.state?.rawValue
    }

    func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stateLabel)
        contentView.addSubview(arrowView)
        contentView.addSubview(hairLine)

        let constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: labelInset),
            titleLabel.trailingAnchor.constraint(equalTo: stateLabel.leadingAnchor, constant: -.smallSpacing),

            stateLabel.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -.mediumLargeSpacing),
            stateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            arrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            arrowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            hairLine.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            hairLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hairLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hairLine.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),

            contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: labelInset)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
