//
//  ViewController.swift
//  RandomUser
//
//  Created by Prateek Raj on 02/08/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NetworkCLientAdapter {
    var userArray = [Result]()
    var pageCount = 1
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        callTheAPIWithPageCount(with: pageCount)
    }

    func callTheAPIWithPageCount(with page: Int) {
        sendRequest(withPageCount: pageCount, responseModel: RandomUsers.self) { [weak self] models, _ in
            guard let weakSelf = self else { return }
            guard let randomUsers = models as? RandomUsers else { return }
            weakSelf.userArray.append(contentsOf: randomUsers.results)
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.tableView.reloadData()
            }
        }
    }
    // MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else {return UserCell()}
        cell.configureCell(withResult: userArray[indexPath.row])
        return cell
    }
    // MARK: TableView Delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == userArray.count - 2 {
            pageCount += 1
            callTheAPIWithPageCount(with: pageCount)
        }
    }
}
