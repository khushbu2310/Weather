//
//  SearchViewCollectionViewCell.swift
//  Weather
//
//  Created by Khushbuben Patel on 11/10/23.
//

import UIKit

class SearchViewCollectionViewCell: UICollectionViewCell {
    
    static let identifire = SearchViewCollectionViewCell.description()
    
    //MARK: - Components
    private var tempLabel : UILabel = labelUI(text: "30c", textColor: .black)
    private var imageview : UIImageView = UIImageView()
    private var weatherTypeLabel : UILabel = labelUI(text: "Rain", textColor: .black)
    private var cityNameLabel : UILabel = labelUI(text: "Chikhli", textColor: .black)
    
    
    //MARK: - Intializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UISetup
    private func setupUI(){
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = UIImage(named: "Zaps")
        imageview.layer.masksToBounds = false
        imageview.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        imageview.layer.shadowOpacity = 1
        imageview.layer.shadowRadius = 4
        imageview.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        tempLabel.textAlignment = .center
        weatherTypeLabel.textAlignment = .center
        cityNameLabel.textAlignment = .center
        
        tempLabel.font = .robotoSlabMedium(size: 20)
        weatherTypeLabel.font = .robotoSlabLight(size: 18)
        cityNameLabel.font = .robotoSlabMedium(size: 20)
        
        self.addSubview(tempLabel)
        self.addSubview(imageview)
        self.addSubview(weatherTypeLabel)
        self.addSubview(cityNameLabel)
        
        NSLayoutConstraint.activate([
            tempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: self.topAnchor, constant:22),
            tempLabel.heightAnchor.constraint(equalToConstant: 26),
            
            
            imageview.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageview.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 0),
            imageview.heightAnchor.constraint(equalToConstant: 80),
            imageview.widthAnchor.constraint(equalToConstant: 80),
            
            
            weatherTypeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherTypeLabel.topAnchor.constraint(equalTo: imageview.bottomAnchor, constant: 0),
            weatherTypeLabel.heightAnchor.constraint(equalToConstant: 24),
            
            cityNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cityNameLabel.topAnchor.constraint(equalTo: weatherTypeLabel.bottomAnchor, constant: 0),
            cityNameLabel.heightAnchor.constraint(equalToConstant: 26),
            cityNameLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8)
        ])
    }
    
    //MARK: - Config Content
    func configContent(currentWeatherDTO:CurrentWeatherDTO){
        self.tempLabel.text = currentWeatherDTO.temp.appending("c")
//        self.imageview.kf.setImage(with: URL(string: currentWeatherDTO.getURL()))
        let getImgName = currentWeatherDTO.icon
        self.imageview.image = UIImage(named: getImage(icon: getImgName))
        self.weatherTypeLabel.text = currentWeatherDTO.weatherType
        self.cityNameLabel.text = currentWeatherDTO.city
    }
}
