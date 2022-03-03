//
//  TestVIPERViewController.swift
//  HDCam
//
//  Created by liyishu on 2022/2/26.
//

import UIKit

struct Endpoints {
    static let QUOTES = "quotes"
}

class TestVIPERViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var presenter: ViewToPresenterQuotesProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension TestVIPERViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testVIPERTableViewCell") as! TestVIPERTableViewCell
        cell.titleLabel?.text = presenter?.textLabelText(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter?.didSelectRowAt(index: indexPath.row)
        presenter?.deselectRowAt(index: indexPath.row)
    }
}

extension TestVIPERViewController: PresenterToViewQuotesProtocol {
    
    func onFetchQuotesSuccess() {
        print("View receives the response from Presenter and updates itself.")
        self.tableView.reloadData()
    }
    
    func onFetchQuotesFailure(error: String) {
        print("View receives the response from Presenter with error: \(error)")
    }
    
    func deselectRowAt(row: Int) {
        self.tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
    }
}
