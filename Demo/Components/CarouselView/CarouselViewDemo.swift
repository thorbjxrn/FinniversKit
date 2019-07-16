//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class CarouselViewDemoView: UIView {

    let data = (1 ... 3).map({ "\($0)" })

    private lazy var carouselView: CarouselView = {
        let carouselView = CarouselView(dataSource: self, delegate: self)
        carouselView.backgroundColor = .white
        carouselView.register(CarouselViewDemoCell.self)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        return carouselView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CarouselViewDemoView: CarouselViewDataSource {
    func numberOfItems(in carouselView: CarouselView) -> Int {
        return data.count
    }

    func carouselView(_ carouselView: CarouselView, cellForItemAt indexPath: IndexPath) -> CarouselViewCell {
        let cell = carouselView.dequeue(CarouselViewDemoCell.self, for: indexPath)
        cell.text = data[indexPath.item]
        return cell
    }
}

extension CarouselViewDemoView: CarouselViewDelegate {
    func carouselView(_ carouselView: CarouselView, didSelectItemAt indexPath: IndexPath) {
        print("Did select item at: \(indexPath)")
    }

    func carouselViewDidEndDecelerating(_ carouselView: CarouselView) {}
}

private extension CarouselViewDemoView {
    func setup() {
        addSubview(carouselView)

        NSLayoutConstraint.activate([
            carouselView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: trailingAnchor),
            carouselView.centerYAnchor.constraint(equalTo: centerYAnchor),
            carouselView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
        ])
    }
}