//
//  ForecastCollectionViewCell.swift
//  Weather
//
//  Created by Khushbuben Patel on 10/10/23.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {

    static let identifier = ForecastCollectionViewCell.description()
    
    //MARK: - Properties
    private var dateLabel: UILabel = labelUI(text: "July 21, 2022", textColor: .white)
    private var timeLabel: UILabel = labelUI(text: "10:00am", textColor: .white)
    private var tempLabel: UILabel = labelUI(text: "24c", textColor: .white)
    private var weatherTypeImageView : UIImageView = UIImageView()
    
    //MARK: - Intializers
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
    
    //    MARK: - UISetup
    private func setupUI(){
        weatherTypeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.textAlignment = .center
        timeLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        
        dateLabel.font = .robotoSlabMedium(size: 14)
        timeLabel.font = .robotoSlabLight(size: 13)
        tempLabel.font = .robotoSlabMedium(size: 36)
        
        self.addSubview(dateLabel)
        self.addSubview(timeLabel)
        self.addSubview(tempLabel)
        self.addSubview(weatherTypeImageView)
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -110),
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
            dateLabel.heightAnchor.constraint(equalToConstant: 47),
            
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor,constant: -110),
            timeLabel.heightAnchor.constraint(equalToConstant: 47),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 10),
            
            tempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor,constant: 0),
            tempLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 0),
            tempLabel.heightAnchor.constraint(equalToConstant: 47),
            
            weatherTypeImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor,constant: 110),
            weatherTypeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 0),
            weatherTypeImageView.heightAnchor.constraint(equalToConstant: 80),
            weatherTypeImageView.widthAnchor.constraint(equalToConstant: 80),
        ])
        
    }

    //MARK: - Cell Config
    func congifContent(forecastDTO:ForecastDTO){
        var date: String = ""
        date += formateDate(date: forecastDTO.date)
        self.dateLabel.text = date
        self.timeLabel.text = forecastDTO.time
        self.tempLabel.text = forecastDTO.temp
//        self.weatherTypeImageView.kf.setImage(with: forecastDTO.getURL())
        let getImgName = forecastDTO.icon
        self.weatherTypeImageView.image = UIImage(named: getImage(icon: getImgName))
    }
    
    func formateDate(date: String) -> String {
            let dateString = date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.dateFormat = "dd-MM-yyyy"
                return dateFormatter.string(from: date)
            }
            return "13-10-2023"
        }
}

