//
//  CategoryTableViewCell.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 05.02.2023.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    private let categoryName = UILabel()
    private let publicationDate = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCategoryName()
        configurePublicationDate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func configureCategoryName() {
        addSubview(categoryName)
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            categoryName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            categoryName.topAnchor.constraint(equalTo: topAnchor, constant: 5)
        ])
        categoryName.numberOfLines = 0
        categoryName.font = UIFont.preferredFont(forTextStyle: .title2)
    }

    private func configurePublicationDate() {
        addSubview(publicationDate)
        publicationDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            publicationDate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            publicationDate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            publicationDate.topAnchor.constraint(equalTo: categoryName.bottomAnchor, constant: 15),
            publicationDate.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        publicationDate.textAlignment = .right
        publicationDate.font = UIFont.preferredFont(forTextStyle: .callout)
    }

    func setCategory(_ category: Category) {
        categoryName.text = category.name
        publicationDate.text = category.newestPublishedDate
    }
}
