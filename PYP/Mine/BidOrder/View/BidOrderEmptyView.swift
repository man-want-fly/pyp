//
//  BidOrderEmptyView.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/13.
//

import UIKit

class BidOrderEmptyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "暂无订单"
        addSubview(label)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private let label = UILabel()
}
