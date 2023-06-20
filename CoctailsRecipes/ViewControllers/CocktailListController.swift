//
//  ViewController.swift
//  CocktailsRecipes
//
//  Created by Айдар Оспанов on 20.06.2023.
//

import UIKit

final class CocktailListController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    private var drinks: [Drink] = []
    
    private let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        fetchDrink()
        tableView.rowHeight = 70
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        //tableView.reloadData()
        
    }
    
    private func transmit(drink: Drink) {
        let infoVC = InfoViewController()
        //infoVC.modalPresentationStyle = .fullScreen
        infoVC.drink = drink
        //present(infoVC, animated: true)
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
}

//MARK: CocktailListController DataSource

extension CocktailListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        drinks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let drink = drinks[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = drink.strDrink
        content.secondaryText = drink.strCategory
        
        networkManager.fetchImage(form: drink.strDrinkThumb) { result in
            switch result {
            case .success(let imageData):
                content.image = UIImage(data: imageData)
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        
        content.imageProperties.cornerRadius = tableView.rowHeight / 2
        cell.contentConfiguration = content
        return cell
    }
}

//MARK: CocktailListController Delegate

extension CocktailListController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drink = drinks[indexPath.row]
        transmit(drink: drink)
    }
}

//MARK: fetchDrink

extension CocktailListController {
    private func fetchDrink() {
        networkManager.fetchCoctail(from: Link.coctailURL.url) { [weak self] result in
            switch result {
            case .success(let coctail):
                self?.drinks = coctail.drinks
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
//    private func fetchImage(from drink: String) {
//        networkManager.fetchImage(form: drink) { result in
//            switch result {
//            case .success(let imageData):
//                content.image = UIImage(data: imageData)
//                DispatchQueue.main.async {
//                    tableView.reloadData()
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
}

//MARK: SetupNavigationBar

extension CocktailListController {
    private func setupNavigationBar() {
        title = "Coctail List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(named: "MilkBlue") ?? .white
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .white
    }
}
