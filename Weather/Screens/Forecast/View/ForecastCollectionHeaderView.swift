//
//  ForecastCollectionHeaderView.swift
//  Weather
//
//  Created by Khushbuben Patel on 18/10/23.
//

import UIKit

class ForecastCollectionHeaderView: UICollectionReusableView {
    
    static let identifire = ForecastCollectionHeaderView.description()
    
    private let dayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius =  20
        button.clipsToBounds = false
        button.backgroundColor = .white
        button.setTitleColor( ColorConstant.lightBlue, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellSetupUI()
        setupUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cellSetupUI(){
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    private func setupUI(){
        self.addSubview(dayButton)
    }
    
    private func setupConstraint(){
        dayButton.sizeThatFits(self.frame.size)
        
        NSLayoutConstraint.activate([
            dayButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            dayButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 5),
            dayButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10),
            dayButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 5)
        ])
    }
    
    func configContent(day:String){
        dayButton.setTitle(dateToDay(date: day), for: .normal)
    }
    
    private func dateToDay(date:String)->String{
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = dateformater.date(from: date)!
        return currentDate.toWeekDay().appending(" | ").appending(currentDate.toMediumStyle())
    }
}
