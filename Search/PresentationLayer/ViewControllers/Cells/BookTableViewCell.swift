//
//  BookTableViewCell.swift
//  Search
//
//  Created by Amaduddin Ayub on 8/10/21.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var publisherLabel: UILabel!
    @IBOutlet private var publishYearLabel: UILabel!

    var book: Book? {
        didSet {
            updateContents()
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()

        resetContents()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        resetContents()
    }

    private func resetContents() {
        titleLabel.text = nil
        authorLabel.text = nil
        publisherLabel.text = nil
        publishYearLabel.text = nil
    }

    private func updateContents() {
        guard let book = book else {
            return
        }

        titleLabel.text = book.title
        authorLabel.text = "Author: \(book.authors?.first ?? "")"
        publisherLabel.text = "Publisher: \(book.publishers?.first ?? "")"
        publishYearLabel.text = "Published in: \(book.firstPublishYear ?? 0)"
    }
    
}
