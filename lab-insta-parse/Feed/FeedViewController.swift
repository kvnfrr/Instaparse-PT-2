//
//  FeedViewController.swift
//  lab-insta-parse
//
//  Created by Charlie Hieger on 11/1/22.
//

import UIKit
import ParseSwift

class FeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()

    private var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryPosts()
    }

    private func queryPosts(completion: (() -> Void)? = nil) {
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: (-1), to: Date())!

        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
            .where("createdAt" >= yesterdayDate)
            .limit(10)

        query.find { [weak self] result in
            switch result {
            case .success(let fetchedPosts):
                self?.posts = fetchedPosts

                for (index, post) in fetchedPosts.enumerated() {
                    if let commentQuery = try? Comment.query()
                        .where("post" == post)
                        .include("user")
                        .order([.ascending("createdAt")]) {

                        commentQuery.find { [weak self] result in
                            switch result {
                            case .success(let comments):
                                guard let self else { return }
                                if index < self.posts.count {
                                    self.posts[index].comments = comments
                                }
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }

                            case .failure(let error):
                                print("❌ Error fetching comments: \(error.localizedDescription)")
                            }
                        }
                    }
                }

            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }

            completion?()
        }
    }

    @IBAction func onLogOutTapped(_ sender: Any) {
        showConfirmLogoutAlert()
    }

    @objc private func onPullToRefresh() {
        refreshControl.beginRefreshing()
        queryPosts { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }

    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(
            title: "Log out of \(User.current?.username ?? "current account")?",
            message: nil,
            preferredStyle: .alert
        )
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }

        let post = posts[indexPath.row]
        cell.configure(with: post)
        cell.onCommentPosted = { [weak self] in
            self?.queryPosts()
        }

        return cell
    }
}

extension FeedViewController: UITableViewDelegate { }
