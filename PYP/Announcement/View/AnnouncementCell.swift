//
//  AnnouncementCell.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/12.
//

import UIKit

class AnnouncementCell: UICollectionViewCell {

    var announcement: Announcement? {
        didSet {
            guard let announcement = announcement else { return }
            nameLabel.text = announcement.name
            imageView.image = UIImage(systemName: announcement.imageName)?.withRenderingMode(
                .alwaysOriginal
            )
        }
    }

    var wantBidRegister: ((Announcement) -> Void)?

    override init(
        frame: CGRect
    ) {
        super.init(frame: .zero)

        setupViews()
        setupConstraints()
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        bidButton.translatesAutoresizingMaskIntoConstraints = false

        bidButton.configuration = .filled()
        bidButton.setTitleColor(.white, for: .normal)
        bidButton.setTitle("竞买登记", for: .normal)
        bidButton.addTarget(self, action: #selector(bidButtonClicked), for: .touchUpInside)

        [imageView, nameLabel, bidButton].forEach(contentView.addSubview)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            nameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            bidButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bidButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            bidButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bidButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }

    @objc private func bidButtonClicked() {
        guard let announcement = announcement else { return }
        wantBidRegister?(announcement)
    }

    private let imageView = UIImageView()

    private let nameLabel = UILabel()

    private let bidButton = UIButton()
}
