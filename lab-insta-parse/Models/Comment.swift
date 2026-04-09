//
//  Comment.swift
//  lab-insta-parse
//
//  Created by kvnfrr on 4/8/26.
//

import Foundation
import ParseSwift

struct Comment: ParseObject {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    var text: String?
    var user: User?
    var post: Post?
}
