//
//  MineViewController.swift
//  PYP
//
//  Created by Dongbing Hou on 2022/11/13.
//

import UIKit

class MineViewController: UITableViewController {

    enum Cell {
        case bidOrders

        var title: String {
            switch self {
            case .bidOrders: return "竞买订单"
            }
        }
    }

    private var cells: [Cell] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        cells = [.bidOrders]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath
        )
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = cells[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = cells[indexPath.row]
        switch item {
        case .bidOrders:
            let controller = BidOrderViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
