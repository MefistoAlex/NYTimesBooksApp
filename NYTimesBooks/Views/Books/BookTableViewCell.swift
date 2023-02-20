//
//  BookTableViewCell.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 06.02.2023.
//

import Kingfisher
import UIKit

class BookTableViewCell: UITableViewCell {
    // MARK: - Properties

    private let bookImage = UIImageView()

    private let titleLabel = UILabel()
    private let annotationLabel = UILabel()
    private let authorLabel = UILabel()
    private let publisherLabel = UILabel()
    private let rankLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()

        bookImageConfigure()
        titleLabelConfigure()
        annotationLabelConfigure()
        authorLabelConfigure()
        publisherLabelConfigure()
        rankLabelConfigure()
    }

    // MARK: - Cell Confirure

    private func bookImageConfigure() {
        self.tintColor = .gray
        addSubview(bookImage)
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookImage.heightAnchor.constraint(equalToConstant: 100),
            bookImage.widthAnchor.constraint(equalToConstant: 75),
            bookImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bookImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            bookImage.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5)
        ])

        bookImage.contentMode = .scaleAspectFit
    }

    private func titleLabelConfigure() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5)
        ])

        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: FontContstants.bookTitle, size: 20)
    }

    private func annotationLabelConfigure() {
        addSubview(annotationLabel)
        annotationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            annotationLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20),
            annotationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            annotationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])

        annotationLabel.numberOfLines = 0
        annotationLabel.font = UIFont(name: FontContstants.bookAnnotation, size: 17)
    }

    private func authorLabelConfigure() {
        addSubview(authorLabel)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorLabel.heightAnchor.constraint(equalToConstant: 20),
            authorLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            authorLabel.topAnchor.constraint(equalTo: annotationLabel.bottomAnchor, constant: 10)
        ])
        authorLabel.font = UIFont(name: FontContstants.bookAuthor, size: 15)
    }

    private func publisherLabelConfigure() {
        addSubview(publisherLabel)
        publisherLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            publisherLabel.heightAnchor.constraint(equalToConstant: 20),
            publisherLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20),
            publisherLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            publisherLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10)
        ])
        publisherLabel.font = UIFont(name: FontContstants.bookPublisher, size: 15)
    }

    private func rankLabelConfigure() {
        addSubview(rankLabel)
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rankLabel.heightAnchor.constraint(equalToConstant: 20),
            rankLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20),
            rankLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            rankLabel.topAnchor.constraint(equalTo: publisherLabel.bottomAnchor, constant: 10),
            rankLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        rankLabel.font = UIFont(name: FontContstants.bookRank, size: 15)
    }

    // MARK: - Data Setting

    func setBook(_ book: Book) {
        let placeholder = UIImage(systemName: "book")

        if let imageURL = book.imageURL {
            let url = URL(string: imageURL)
            bookImage.kf.setImage(with: url, placeholder: placeholder)
        } else {
            bookImage.image = placeholder
        }

        titleLabel.text = book.title
        annotationLabel.text = book.annotation

        let authorString = NSLocalizedString("BOOK_AUTHOR", comment: "book athor label")
        let publisherString = NSLocalizedString("BOOK_PUBLISHER", comment: "book publisher label")
        let rankString = NSLocalizedString("BOOK_RANK", comment: "book rank label")

        authorLabel.text = "\(authorString): \(book.author)"
        publisherLabel.text = "\(publisherString): \(book.publisher)"
        rankLabel.text = "\(rankString): \(book.rank)"
    }
}
