//
//  SearchViewController.swift
//  Weather
//
//  Created by Khushbuben Patel on 09/10/23.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    //MARK: - Properties
    private var searchWeatherVM = SearchWeatherVM()
    
    //MARK: - UIComponents
    private var weatherSearchBar: UISearchBar!
    private var searchResultView: UICollectionView!
    private var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.51, green: 0.549, blue: 0.682, alpha: 1)
        searchWeatherVM.getAllCity()
        setupUI()
        observeEvent()
    }
    
    private  func setupUI() {
        setupWeatherSearchBar()
        setupSearchResultView()
        setupActivityIndicator()
    }
    
    private func setupWeatherSearchBar() {
        let titleLabel = labelUI(text: "Pick a location", textColor: .white)
        titleLabel.font = .robotoSlabMedium(size: 30)
        titleLabel.textAlignment = .center
        titleLabel.layer.masksToBounds = false
        titleLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowRadius = 4
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        let detailsLabel = labelUI(text: "Type the area or city you want to know the \n detailed weather information at \n this time", textColor: .white)
        detailsLabel.font = .robotoSlabLight(size: 15)
        detailsLabel.textAlignment = .center
        detailsLabel.numberOfLines = 0
        detailsLabel.sizeToFit()
        detailsLabel.layer.masksToBounds = false
        detailsLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        detailsLabel.layer.shadowOpacity = 1
        detailsLabel.layer.shadowRadius = 4
        detailsLabel.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        weatherSearchBar = UISearchBar(frame: .zero)
        weatherSearchBar.delegate = self
        weatherSearchBar.translatesAutoresizingMaskIntoConstraints = false
        weatherSearchBar.placeholder = "Search"
        weatherSearchBar.searchTextField.font = .robotoSlabLight(size: 17)
        weatherSearchBar.showsCancelButton = false
        weatherSearchBar.showsSearchResultsButton = false
        weatherSearchBar.searchTextField.textColor = .white
        weatherSearchBar.searchTextField.backgroundColor = UIColor(red: 0.656, green: 0.706, blue: 0.879, alpha: 1)
        weatherSearchBar.barTintColor = UIColor(red: 0.656, green: 0.706, blue: 0.879, alpha: 1)
        weatherSearchBar.searchBarStyle = .prominent
        weatherSearchBar.layer.cornerRadius = 20
        weatherSearchBar.layer.masksToBounds = true
        
        view.addSubview(titleLabel)
        view.addSubview(detailsLabel)
        view.addSubview(weatherSearchBar)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            detailsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            detailsLabel.heightAnchor.constraint(equalToConstant: 60),
            
            weatherSearchBar.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 21),
            weatherSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 45),
            weatherSearchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -45)
        ])
    }
    
    private func setupSearchResultView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 162, height: 200)
        layout.minimumLineSpacing = 39
        layout.minimumInteritemSpacing = 17
        
        searchResultView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        searchResultView.translatesAutoresizingMaskIntoConstraints = false
        searchResultView.delegate = self
        searchResultView.dataSource = self
        searchResultView.backgroundColor = UIColor(red: 0.51, green: 0.549, blue: 0.682, alpha: 1)
        searchResultView.showsVerticalScrollIndicator = false
        searchResultView.register(SearchViewCollectionViewCell.self, forCellWithReuseIdentifier: SearchViewCollectionViewCell.identifire)
        view.addSubview(searchResultView)
        
        NSLayoutConstraint.activate([
            searchResultView.topAnchor.constraint(equalTo: weatherSearchBar.bottomAnchor, constant: 31),
            searchResultView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -79),
            searchResultView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            searchResultView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28)
        ])
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //MARK: - ObserveEvent
    private func observeEvent() {
        searchWeatherVM.eventHandler = { [weak self] event in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch event {
                case .loading: self.activityIndicator.startAnimating()
                case .stopLoading: self.activityIndicator.stopAnimating()
                case .dataLoaded: self.configContent()
                case .error(let errorMessage):
                    if errorMessage == "City not found" {
                        self.showAlert(title: "", message: "City not found!" )
                    }
                    else{
                        self.showAlert(title: "Server Error", message: "Try again after some time" )
                    }
                }
            }
        }
    }
    
    private func configContent() {
        self.searchResultView.reloadData()
    }
    
}

//MARK: - SearchBar Delegate

extension SearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let city = searchBar.text?.trimmingCharacters(in: .whitespaces) {
            searchWeatherVM.getCityLocation(city: city)
            searchBar.text = ""
        }
    }
}

//MARK: - CollectionView Datasource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchWeatherVM.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCollectionViewCell.identifire, for: indexPath) as! SearchViewCollectionViewCell
        cell.configContent(currentWeatherDTO: searchWeatherVM.searchResults[indexPath.row])
        return cell
    }
}

//TODO: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = searchWeatherVM.searchResults[indexPath.row]
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: NSNotification.Name("LocationSelected"), object: data)
    }
}
