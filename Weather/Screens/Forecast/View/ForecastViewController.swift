//
//  ForecastViewController.swift
//  Weather
//
//  Created by Khushbuben Patel on 09/10/23.
//

import Foundation
import UIKit

class ForecastViewController: UIViewController {
    
    private var topLabel : UILabel!
    private var reportCollectionView : UICollectionView!
    private var foreCastData : [Int:[ForecastDTO]] = [:]
    
    init(_foreCastData: [Int:[ForecastDTO]] = [:]){
        foreCastData  =  _foreCastData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: "#828CAE")
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    private func setupUI(){
        setupTopLabel()
        setupReportCollectionView()
    }
    
    private func setupTopLabel(){
        topLabel = labelUI(text: "Forecast Report", textColor: .white)
        topLabel.font = .robotoSlabMedium(size: 30)
        topLabel.layer.masksToBounds = false
        topLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        topLabel.layer.shadowOpacity = 1
        topLabel.layer.shadowRadius = 4
        topLabel.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        view.addSubview(topLabel)
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func setupReportCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 352 , height: 84)
        
        layout.accessibilityNavigationStyle = .separate
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        reportCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        reportCollectionView.translatesAutoresizingMaskIntoConstraints = false
        reportCollectionView.backgroundColor = UIColor(hex: "#7882A7")
        reportCollectionView.delegate = self
        reportCollectionView.dataSource = self
        reportCollectionView.showsHorizontalScrollIndicator = false
        reportCollectionView.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell.identifire)
        reportCollectionView.register(ForecastCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ForecastCollectionHeaderView.identifire)

        self.view.addSubview(reportCollectionView)
        
        NSLayoutConstraint.activate([
            reportCollectionView.topAnchor.constraint(equalTo: topLabel.bottomAnchor,constant: 30),
            reportCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            reportCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            reportCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
        ])
    }
    
    func configContent(forecastData: [Int: [ForecastDTO]]) {
        self.foreCastData = forecastData
    }
}

//MARK: - CollectionView Datasource
extension ForecastViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return foreCastData.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return (foreCastData[section]?.count ?? 0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifire, for: indexPath) as? ForecastCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.congifContent(forecastDTO: foreCastData[indexPath.section]![indexPath.row])
        return cell
    }
}

//  MARK: - CollectionViewDelegateFlowLayout
extension ForecastViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 200, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ForecastCollectionHeaderView.identifire, for: indexPath) as?
                    ForecastCollectionHeaderView else {
                return UICollectionReusableView()
            }
            headerView.configContent(day: String(foreCastData[indexPath.section]?.first?.date ??  "Next Day"))
            return headerView
        default:  return UICollectionReusableView()
            
        }
    }
}
