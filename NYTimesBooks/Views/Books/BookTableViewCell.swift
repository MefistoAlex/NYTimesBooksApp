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

        cellConfigure()
        bookImageConfigure()
        titleLabelConfigure()
        annotationLabelConfigure()
        authorLabelConfigure()
        publisherLabelConfigure()
        rankLabelConfigure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Cell Confirure

    private func cellConfigure() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 210),
        ])
    }

    private func bookImageConfigure() {
        addSubview(bookImage)
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookImage.heightAnchor.constraint(equalToConstant: 200),
            bookImage.widthAnchor.constraint(equalToConstant: 200),
            bookImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bookImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            bookImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }

    private func titleLabelConfigure() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
        ])
    }

    private func annotationLabelConfigure() {
        addSubview(annotationLabel)
        annotationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            annotationLabel.heightAnchor.constraint(equalToConstant: 20),
            annotationLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20),
            annotationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            annotationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
        ])
    }

    private func authorLabelConfigure() {
        addSubview(authorLabel)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorLabel.heightAnchor.constraint(equalToConstant: 20),
            authorLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            authorLabel.topAnchor.constraint(equalTo: annotationLabel.bottomAnchor, constant: 5),
        ])
    }

    private func publisherLabelConfigure() {
        addSubview(publisherLabel)
        publisherLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            publisherLabel.heightAnchor.constraint(equalToConstant: 20),
            publisherLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20),
            publisherLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            publisherLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
        ])
    }

    private func rankLabelConfigure() {
        addSubview(rankLabel)
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rankLabel.heightAnchor.constraint(equalToConstant: 20),
            rankLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 20),
            rankLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            rankLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
        ])
    }

    // MARK: - Data Setting

    func setBook(_ book: Book) {
        let url = URL(string: book.imageURL)
        bookImage.kf.setImage(with: url)

        titleLabel.text = book.title
        annotationLabel.text = book.annotation
        authorLabel.text = book.author
        publisherLabel.text = book.publisher
        rankLabel.text = String(book.rank)
    }
}
