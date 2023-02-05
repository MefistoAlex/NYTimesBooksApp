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

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50),
        ])
        configureCategoryName()
        configurePublicationDate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func configureCategoryName() {
        addSubview(categoryName)
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryName.heightAnchor.constraint(equalToConstant: 20),
            categoryName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            categoryName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            categoryName.topAnchor.constraint(equalTo: topAnchor, constant: 5),

        ])
    }

    private func configurePublicationDate() {
        addSubview(publicationDate)
        publicationDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            publicationDate.heightAnchor.constraint(equalToConstant: 20),
            publicationDate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            publicationDate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            publicationDate.topAnchor.constraint(equalTo: categoryName.bottomAnchor, constant: 5),
        ])
    }

    func setCategory(_ category: Category) {
        categoryName.text = category.name
        publicationDate.text = category.newestPublishedDate
    }
}
