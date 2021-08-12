//
//  UserCell.swift
//  RandomUser
//
//  Created by Prateek Raj on 02/08/21.
//

import Foundation
import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    func configureCell(withResult user: Result) {
        userImageView.layer.cornerRadius = 27
        nameLabel.text = user.name.title + " " + user.name.first + " " + user.name.last
        addressLabel.text = String(user.location.street.number) + " " + user.location.street.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: user.dob.date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM, yyyy"
            dobLabel.text = formatter.string(from: date)
        }
        if let url = URL(string: user.picture.thumbnail) {
            URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, _, _) in
                guard let weakSelf = self else { return }
                guard let data = data else { return }
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        weakSelf.userImageView.image = image
                    }
                }
            }).resume()
        }
    }
}
