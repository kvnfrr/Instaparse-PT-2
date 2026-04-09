//
//  PostCell.swift
//  lab-insta-parse
//
//  Created by Charlie Hieger on 11/3/22.
//

import UIKit
import Alamofire
import AlamofireImage
import ParseSwift

class PostCell: UITableViewCell {

    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var commentsLabel: UILabel!
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet private weak var commentButton: UIButton!

    // Blur view to blur out "hidden" posts
    @IBOutlet private weak var blurView: UIVisualEffectView!

    private var imageDataRequest: DataRequest?
    private var currentPost: Post?

    var onCommentPosted: (() -> Void)?

    func configure(with post: Post) {
        currentPost = post

        // Username
        if let user = post.user {
            usernameLabel.text = user.username
        } else {
            usernameLabel.text = ""
        }

        // Image
        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {

            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    self?.postImageView.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                }
            }
        }

        // Caption
        captionLabel.text = post.caption

        // Date / Time
        if let date = post.createdAt {
            dateLabel.text = DateFormatter.postFormatter.string(from: date)
        } else {
            dateLabel.text = ""
        }

        // Location
        if let latitude = post.latitude, let longitude = post.longitude {
            locationLabel.text = "Lat: \(latitude), Lon: \(longitude)"
        } else {
            locationLabel.text = "No location"
        }

        // Comments
        if let comments = post.comments, !comments.isEmpty {
            let commentText = comments.compactMap { comment in
                guard let username = comment.user?.username,
                      let text = comment.text else { return nil }
                return "\(username): \(text)"
            }.joined(separator: "\n")

            commentsLabel.text = commentText
        } else {
            commentsLabel.text = "No comments yet"
        }

        // Blur logic
        if let currentUser = User.current,
           let lastPostedDate = currentUser.lastPostedDate,
           let postCreatedDate = post.createdAt,
           let diffHours = Calendar.current.dateComponents([.hour],
                                                           from: postCreatedDate,
                                                           to: lastPostedDate).hour {

            blurView.isHidden = abs(diffHours) < 24
        } else {
            blurView.isHidden = false
        }
    }

    @IBAction func onCommentButtonTapped(_ sender: UIButton) {
        guard let post = currentPost,
              let text = commentTextField.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        var comment = Comment()
        comment.text = text
        comment.user = User.current
        comment.post = post

        comment.save { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.commentTextField.text = ""
                    self?.onCommentPosted?()
                }
            case .failure(let error):
                print("❌ Error saving comment: \(error.localizedDescription)")
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        postImageView.image = nil
        imageDataRequest?.cancel()

        commentsLabel.text = nil
        commentTextField.text = nil
        currentPost = nil
    }
}
