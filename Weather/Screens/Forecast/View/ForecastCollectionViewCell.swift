//
//  ForecastCollectionViewCell.swift
//  Weather
//
//  Created by Khushbuben Patel on 10/10/23.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    static let identifire = ForecastCollectionViewCell.description()
    
    private var timeLabel: UILabel = labelUI(text: "10:00am", textColor: .white)
    private var tempLabel: UILabel = labelUI(text: "24c", textColor: .white)
    private var weatherTypeImageView : UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: "#828CAE")
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
    
    private func setupUI(){
        weatherTypeImageView.translatesAutoresizingMaskIntoConstraints = false

        timeLabel.font = .robotoSlabMedium(size: 16)
        tempLabel.font = .robotoSlabMedium(size: 36)
        
        self.addSubview(timeLabel)
        self.addSubview(tempLabel)
        self.addSubview(weatherTypeImageView)
        
        NSLayoutConstraint.activate([

            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor,constant: -110),
            timeLabel.heightAnchor.constraint(equalToConstant: 47),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 0),
            
            tempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor,constant: 0),
            tempLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 0),
            tempLabel.heightAnchor.constraint(equalToConstant: 47),
            
            weatherTypeImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor,constant: 110),
            weatherTypeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 0),
            weatherTypeImageView.heightAnchor.constraint(equalToConstant: 80),
            weatherTypeImageView.widthAnchor.constraint(equalToConstant: 80),
        ])
        
    }
    
    func congifContent(forecastDTO:ForecastDTO){
        self.timeLabel.text = forecastDTO.time
        self.tempLabel.text = forecastDTO.temp
        let getImgName = forecastDTO.icon
        self.weatherTypeImageView.image = UIImage(named: getImage(icon: getImgName))
    }
}

