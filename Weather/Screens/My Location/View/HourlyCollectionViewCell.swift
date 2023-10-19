//
//  HourlyCollectionViewCell.swift
//  Weather
//
//  Created by Khushbuben Patel on 10/10/23.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    static let identifire = HourlyCollectionViewCell.description()
    
    private var hrStack: UIStackView!
    private var weatherImgView: UIImageView = UIImageView(frame: .zero)
    private var timeLabel: UILabel = labelUI(text: "10:00am", textColor: .white)
    private var tempLabel: UILabel = labelUI(text: "24c", textColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.656, green: 0.706, blue: 0.879, alpha: 1)
        self.layer.cornerRadius = 30
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
        let verticalView = UIView()
        verticalView.translatesAutoresizingMaskIntoConstraints = false
        verticalView.addSubview(timeLabel)
        verticalView.addSubview(tempLabel)
        timeLabel.font = .robotoSlabMedium(size: 12)
        tempLabel.font = .robotoSlabMedium(size: 17)
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: verticalView.leadingAnchor, constant: 10),
            timeLabel.centerYAnchor.constraint(equalTo: verticalView.centerYAnchor,constant: -10),
            tempLabel.leadingAnchor.constraint(equalTo: verticalView.leadingAnchor, constant: 10),
            tempLabel.centerYAnchor.constraint(equalTo: verticalView.centerYAnchor,constant: 10),
        ])
        
        weatherImgView.layer.masksToBounds = false
        weatherImgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        weatherImgView.layer.shadowOpacity = 1
        weatherImgView.layer.shadowRadius = 4
        weatherImgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        hrStack = UIStackView(arrangedSubviews: [weatherImgView,verticalView])
        hrStack.axis = .horizontal
        hrStack.distribution = .fillEqually
        hrStack.alignment = .center
        hrStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(hrStack)
        
        hrStack.arrangedSubviews.forEach { child in
            NSLayoutConstraint.activate([
                child.heightAnchor.constraint(equalToConstant: self.frame.height),
                child.widthAnchor.constraint(equalToConstant: self.frame.width/2),
            ])
        }
        
        NSLayoutConstraint.activate([
            hrStack.topAnchor.constraint(equalTo: self.topAnchor),
            hrStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            hrStack.leftAnchor.constraint(equalTo: self.leftAnchor),
            hrStack.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    func configContent(forecastDTO:ForecastDTO, textColor: UIColor, cellBGColor: UIColor){
        self.backgroundColor = cellBGColor
        let getImgName = forecastDTO.icon
        weatherImgView.image = UIImage(named: getImage(icon: getImgName))
        timeLabel.text = forecastDTO.time
        tempLabel.text = forecastDTO.temp
        timeLabel.textColor = textColor
        tempLabel.textColor = textColor
    }
}
