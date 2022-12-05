//
//  AnnouncementViewController.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/12.
//

import UIKit

private let reuseIdentifier = "AnnouncementCell"

class AnnouncementViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var announcements: [Announcement] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    let service: AnnouncementService = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(
            AnnouncementCell.self,
            forCellWithReuseIdentifier: reuseIdentifier
        )

        announcements = [
            .init(id: "1", name: "A", imageName: "globe.americas", lotId: "1"),
            .init(id: "2", name: "B", imageName: "tortoise.fill", lotId: "2"),
            .init(id: "3", name: "C", imageName: "ladybug.fill", lotId: "3"),
            .init(id: "4", name: "D", imageName: "leaf.fill", lotId: "4"),
            .init(id: "5", name: "E", imageName: "globe.europe.africa.fill", lotId: "5"),
        ]
    }

    private func bidRegister(id: String) {
        service.bidRegister(id: id) { [weak self] result in
            guard let self else { return }
            if case .retry = result {
                self.bidRegisterRetryCompletion(id)
            } else {
                self.bidRegisterSuccessOrFailureCompletion(result)
            }
        }
    }

    private func retryBidRegister(id: String) {
        service.retryBidRegister(id: id) { [weak self] result in
            switch result {
            case .success:
                self?.showSuccess(message: "您的登记已提交")
            case .failure(let err):
                self?.showError(message: err.message)
            }
        }
    }

    private func bidRegisterSuccessOrFailureCompletion(
        _ result: AnnouncementService.BidRegisterStatus
    ) {
        switch result {
        case .success:
            showSuccess(message: "您的登记已提交")
        case .failure(let err):
            showError(message: err.message)
        case .retry: break
        }
    }

    private func bidRegisterRetryCompletion(_ id: String) {
        showRetryAlert(message: "可能发生了错误，请重试") { [weak self] in
            self?.retryBidRegister(id: id)
        }
    }

    private func showRetryAlert(message: String?, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(
            .init(
                title: "OK",
                style: .default,
                handler: { _ in
                    completion()
                }
            )
        )
        present(alert, animated: true)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        announcements.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            ) as? AnnouncementCell
        else { return .init() }

        cell.announcement = announcements[indexPath.item]
        cell.wantBidRegister = { [weak self] announcement in
            self?.bidRegister(id: announcement.lotId)
        }

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let w = collectionView.bounds.width * 0.5
        return .init(width: w, height: w)
    }
}
