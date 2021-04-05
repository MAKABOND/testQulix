//
//  NewsTableViewCell.swift
//  TestNewsApp
//
//  Created by пользователь on 4/3/21.
//

import UIKit
import Kingfisher

protocol NewsTableViewCellDelegate: class {
    func readMoreButtonPressed(serialNumber: Int)
}

class NewsTableViewCell: UITableViewCell {
    
    // MARK: - UIElem declaration
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var ownerNewsView: UIView!
    @IBOutlet private weak var titleNewsLabel: UILabel!
    @IBOutlet private weak var descriptionNewsLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    weak var delegate: NewsTableViewCellDelegate?
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        ownerNewsView.layer.cornerRadius = 10
        ownerNewsView.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        ownerNewsView.layer.borderWidth = 0.5
        ownerNewsView.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
    }
    
    @IBAction func readMoreButtonPressed(_ sender: UIButton) {
        delegate?.readMoreButtonPressed(serialNumber: readMoreButton.tag)
    }
    
    func configure(news: Articles, serialNumber: Int) {
        titleNewsLabel.text = news.title
        descriptionNewsLabel.text = news.description
        newsImageView.image = nil
        readMoreButton.isHidden = descriptionNewsLabel.calculateMaxLines() > 3 ? false : true
        readMoreButton.tag = serialNumber
        
        if let date = news.newsDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            formatter.calendar = Calendar(identifier: .gregorian)
            dateLabel.text = "date: \(formatter.string(from: date))"
        } else {
            dateLabel.text = ""
        }
        
        if let imageURL = news.imageURL {
            newsImageView.kf.setImage(with: imageURL)
            newsImageView.contentMode = .scaleAspectFill
        } else if let image = news.defaultImageNews {
            newsImageView.image = image
        }
    }
}
