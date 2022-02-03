//
//  ContainerView.swift
//  OneScreenApp
//
//  Created by Egor Mikhalevich on 3.02.22.
//

import UIKit

class ContainerView: UIView {

    private let backView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Constants.Color.inner
        view.setupCornerRadius(Constants.Radius.inner)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backView)
        setupView()

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backView.addInnerShadow(Constants.Color.innerShadow, Constants.ShadowOffset.inner, Constants.ShadowRadius.inner, opacity: 0.07)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Constants.Color.container
        translatesAutoresizingMaskIntoConstraints = false
        setupCornerRadius(Constants.Radius.container)
        setupShadow(Constants.Color.containerShadow, Constants.ShadowOffset.container, Constants.ShadowRadius.container, opacity: 1)

        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Layout.topIndent),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.sideIndent),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.sideIndent),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Layout.bottomIndent)
        ])
    }

}
