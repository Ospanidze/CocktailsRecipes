//
//  CocktailTableViewCell.swift
//  CocktailsRecipes
//
//  Created by Айдар Оспанов on 20.06.2023.
//

import UIKit

class CocktailTableViewCell: UITableViewCell {
    
    private let cocktailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
//        imageView.layer.shadowColor = UIColor.black.cgColor
//        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
//        imageView.layer.shadowOpacity  = 10
        imageView.layer.cornerCurve = .circular
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let caterogyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubviews()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(drink: Drink) {
        nameLabel.text = drink.strDrink
        caterogyLabel.text = drink.strCategory
        
        NetworkManager.shared.fetchImage(form: drink.strDrinkThumb) { [weak self] result in
            switch result {
            case .success(let data):
                self?.cocktailImageView.image = UIImage(data: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func addSubviews() {
        addSubview(cocktailImageView)
        addSubview(nameLabel)
        addSubview(caterogyLabel)
        contentView.addSubview(plusButton)
    }
}

extension CocktailTableViewCell {
    private func setupLayout() {
        NSLayoutConstraint.activate([
            cocktailImageView.topAnchor.constraint(equalTo: topAnchor),
            cocktailImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cocktailImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cocktailImageView.widthAnchor.constraint(equalTo: heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: cocktailImageView.trailingAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            nameLabel.widthAnchor.constraint(equalToConstant: 150),
            
            caterogyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            caterogyLabel.leadingAnchor.constraint(equalTo: cocktailImageView.trailingAnchor, constant: 20),
            caterogyLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 10),
            caterogyLabel.widthAnchor.constraint(equalToConstant: 150),
            
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 100),
            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
