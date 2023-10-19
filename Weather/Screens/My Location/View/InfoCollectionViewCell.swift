//
//  InfoCollectionViewCell.swift
//  Weather
//
//  Created by Khushbuben Patel on 09/10/23.
//

import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    
    static let identifire = "InfoCollectionViewCell"
    
    //  MARK: - UIComponent
    private var weatherTypeImageView : UIImageView = UIImageView()
    private var weatherType : UILabel  = UILabel()
    
    // MARK: - Intializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UISetup
    private func setupUI(){
        setUpWeatherTypeImageView()
        setUpweatherType()
        
    }
    private func setUpWeatherTypeImageView(){
        weatherTypeImageView.image = UIImage(named: "Zaps")
        weatherTypeImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(weatherTypeImageView)
        weatherTypeImageView.layer.masksToBounds = false
        weatherTypeImageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        weatherTypeImageView.layer.shadowOpacity = 1
        weatherTypeImageView.layer.shadowRadius = 4
        weatherTypeImageView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        NSLayoutConstraint.activate([
            weatherTypeImageView.topAnchor.constraint(equalTo: self.topAnchor),
            weatherTypeImageView.widthAnchor.constraint(equalToConstant: 60),
            weatherTypeImageView.heightAnchor.constraint(equalToConstant: 60),
            weatherTypeImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func setUpweatherType(){
        weatherType.text = ""
        weatherType.translatesAutoresizingMaskIntoConstraints = false
        weatherType.textAlignment = .center
        weatherType.textColor = .white
        weatherType.font = .robotoSlabMedium(size: 15)
        weatherType.layer.masksToBounds = false
        weatherType.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        weatherType.layer.shadowOpacity = 1
        weatherType.layer.shadowRadius = 4
        weatherType.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.addSubview(weatherType)
        
        NSLayoutConstraint.activate([
            weatherType.topAnchor.constraint(equalTo: weatherTypeImageView.bottomAnchor),
            weatherType.leftAnchor.constraint(equalTo: self.leftAnchor),
            weatherType.rightAnchor.constraint(equalTo: self.rightAnchor),
            weatherType.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    //MARK: - Cell Config
    func configContent(weatherType:String,weatherTypeImageName:String){
        self.weatherTypeImageView.image = UIImage(named: weatherTypeImageName)
        self.weatherType.text = weatherType
    }
}

