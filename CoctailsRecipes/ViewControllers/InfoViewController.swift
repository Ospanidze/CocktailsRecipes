//
//  InfoViewController.swift
//  CoctailsRecipes
//
//  Created by Айдар Оспанов on 20.06.2023.
//

import UIKit

class InfoViewController: UIViewController {
    
    var drink: Drink!
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(named: "MilkBlue")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let drinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        imageView.layer.shadowOpacity  = 10
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        //label.textAlignment = .justified
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupLayout()
        title = drink.strDrink
        instructionsLabel.text = drink.strInstructions
        fetchImage()
    }
    
    private func addSubviews() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(drinkImageView)
        view.addSubview(instructionsLabel)
    }
    
    private func fetchImage() {
        NetworkManager.shared.fetchImage(form: drink.strDrinkThumb) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.drinkImageView.image = UIImage(data: imageData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension InfoViewController {
    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            backgroundView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            drinkImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            drinkImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            drinkImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            drinkImageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
            
            instructionsLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            instructionsLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}
