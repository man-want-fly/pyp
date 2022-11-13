//
//  BidOrderCell.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/13.
//

import UIKit

class BidOrderCell: UITableViewCell {

    var bidOrder: BidOrder? {
        didSet {
            guard let bidOrder else { return }
            nameLabel.text = bidOrder.name
            stateLabel.text = bidOrder.status.statusText
            stateLabel.textColor = stateColor(from: bidOrder.status)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.translatesAutoresizingMaskIntoConstraints = false

        [nameLabel, stateLabel].forEach(contentView.addSubview)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: 16),
            stateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }

    private func stateColor(from status: BidOrder.Status) -> UIColor {
        switch status {
        case .success: return .green
        case .fail, .boughtIn: return .red
        case .bidding: return .black
        }
    }

    private let nameLabel = UILabel()

    private let stateLabel = UILabel()
}
