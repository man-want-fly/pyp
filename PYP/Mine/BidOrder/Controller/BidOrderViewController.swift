//
//  BidOrderViewController.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/13.
//

import UIKit

class BidOrderViewController: UITableViewController {

    private var orders: [BidOrder] = [] {
        didSet {
            emptyView.isHidden = !orders.isEmpty
            tableView.reloadData()
        }
    }

    let service: BidOrderService

    init(service: BidOrderService = .init()) {
        self.service = service
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "竞买订单"

        tableView.register(BidOrderCell.self, forCellReuseIdentifier: "BidOrderCell")
        tableView.backgroundColor = .white
        tableView.backgroundView = emptyView

        fetchBidOrders()
    }

    func fetchBidOrders() {
        service.loadBidOrders { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let items):
                self.orders = items
            case .failure(let err):
                self.showError(message: err.localizedDescription)
            }
        }
    }

    private lazy var emptyView: BidOrderEmptyView = {
        let view = BidOrderEmptyView()
        view.isHidden = true
        return view
    }()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "BidOrderCell",
                for: indexPath
            ) as? BidOrderCell
        else { return .init() }
        cell.bidOrder = orders[indexPath.row]
        return cell
    }
}
