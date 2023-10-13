//
//  ViewController.swift
//  Weather
//
//  Created by Khushbuben Patel on 08/10/23.
//

import UIKit
import CoreLocation
import Kingfisher

class ViewController: UIViewController {
    
    //MARK: - Properties, View Models
    private var currentWeatherVM = CurrentWeatherVM()
    private var forecastWeatherVM = ForecastWeatherVM()
        
    //MARK: - UI Components
    private var topCollectionView: UICollectionView!
    private var namelabel: UILabel!
    private var dateLabel: UILabel!
    private var weatherImgView: UIImageView!
    private var tempMainLabel: UILabel!
    private var dayLabel: UILabel!
    private var viewReportBtn: UIButton!
    private var bottomCollectionView: UICollectionView!
    private var activityIndicator: UIActivityIndicatorView!
    
    private var tempLabel = labelUI(text: "Temp", textColor: .white)
    private var tempValue = labelUI(text: "", textColor: .white)
    private var humidityLabel = labelUI(text: "Humidity", textColor: .white)
    private var humidityValue = labelUI(text: "", textColor: .white)
    private var windLabel = labelUI(text: "Wind", textColor: .white)
    private var windValue = labelUI(text: "", textColor: .white)

    private var stack1: UIStackView!
    private var stack2: UIStackView!
    private var stack3: UIStackView!
    private var mainStack: UIStackView!
    
    //MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: "#828CAE")
        currentWeatherVM.locationManager.delegate = self
        
        setupUI()
        currentWeatherVMObserver()
        forecastVMObserver()
        currentWeatherVM.getCurrentWeather(location: self.currentWeatherVM.currentLocation)
        forecastWeatherVM.getForeCast(location: self.currentWeatherVM.currentLocation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - UISetup
    private func setupUI() {
        setupActivityIndicator()
        topCollectionViewUISetup()
        setupNameLabel()
        setupDateLabel()
        setupWeatherImgView()
        setupTempMainLabel()
        setupWeatherDetails()
        setupDayLabel()
        setupViewReportButton()
        setupBottomCollectionView()
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
        
    private func topCollectionViewUISetup() {
        let topCollectionLayout = UICollectionViewFlowLayout()
        topCollectionLayout.scrollDirection = .horizontal
        topCollectionLayout.minimumLineSpacing = 30
        topCollectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        topCollectionLayout.estimatedItemSize = CGSize(width: 86, height: 80)
                
        topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: topCollectionLayout)
        topCollectionView.translatesAutoresizingMaskIntoConstraints = false
        topCollectionView.backgroundColor = UIColor(hex: "#7882A7")
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topCollectionView.showsHorizontalScrollIndicator = false
        topCollectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.identifire)
        topCollectionView.layer.masksToBounds = false
        topCollectionView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        topCollectionView.layer.shadowOpacity = 1
        topCollectionView.layer.shadowRadius = 4
        topCollectionView.layer.shadowOffset = CGSize(width: 0, height: 5)

        
        self.view.addSubview(topCollectionView)
        
        NSLayoutConstraint.activate([
            topCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            topCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            topCollectionView.heightAnchor.constraint(equalToConstant: 89)
            
        ])
    }
    
    private func setupNameLabel() {
        namelabel = labelUI(text: "Valsad", textColor: .white)
        namelabel.font = .robotoSlabMedium(size: 30)
        namelabel.textAlignment = .center
        namelabel.font = .robotoSlabMedium(size: 30)
        namelabel.layer.masksToBounds = false
        namelabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        namelabel.layer.shadowOpacity = 1
        namelabel.layer.shadowRadius = 4
        namelabel.layer.shadowOffset = CGSize(width: 0, height: 5)

        view.addSubview(namelabel)
        
        NSLayoutConstraint.activate([
            namelabel.topAnchor.constraint(equalTo: topCollectionView.bottomAnchor, constant: 42),
            namelabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            namelabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupDateLabel() {
        dateLabel = labelUI(text: "", textColor: .white)
        dateLabel.font = .robotoSlabLight(size: 15)
        dateLabel.layer.masksToBounds = false
        dateLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        dateLabel.layer.shadowOpacity = 1
        dateLabel.layer.shadowRadius = 4
        dateLabel.layer.shadowOffset = CGSize(width: 0, height: 4)

        dateLabel.textAlignment = .center
        view.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: namelabel.bottomAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupWeatherImgView() {
        weatherImgView = UIImageView()
        weatherImgView.translatesAutoresizingMaskIntoConstraints = false
        weatherImgView.layer.masksToBounds = false
        weatherImgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        weatherImgView.layer.shadowOpacity = 1
        weatherImgView.layer.shadowRadius = 4
        weatherImgView.layer.shadowOffset = CGSize(width: 0, height: 5)

        view.addSubview(weatherImgView)
        
        NSLayoutConstraint.activate([
            weatherImgView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            weatherImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherImgView.widthAnchor.constraint(equalToConstant: 155),
            weatherImgView.heightAnchor.constraint(equalToConstant: 155)
        ])
    }
    
    private func setupTempMainLabel() {
        tempMainLabel = labelUI(text: "", textColor: .white)
        tempMainLabel.font = .robotoSlabMedium(size: 70)
        tempMainLabel.textAlignment = .center
        tempMainLabel.layer.masksToBounds = false
        tempMainLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        tempMainLabel.layer.shadowOpacity = 1
        tempMainLabel.layer.shadowRadius = 4
        tempMainLabel.layer.shadowOffset = CGSize(width: 0, height: 5)

        view.addSubview(tempMainLabel)
        
        NSLayoutConstraint.activate([
            tempMainLabel.topAnchor.constraint(equalTo: weatherImgView.bottomAnchor),
            tempMainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempMainLabel.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func setupWeatherDetails() {
        view.addSubview(tempLabel)
        view.addSubview(humidityLabel)
        view.addSubview(windLabel)
        
        tempLabel.font = .robotoSlabLight(size: 15)
        humidityLabel.font = .robotoSlabLight(size: 15)
        windLabel.font = .robotoSlabLight(size: 15)
        tempValue.font = .robotoSlabMedium(size: 20)
        humidityValue.font = .robotoSlabMedium(size: 20)
        windValue.font = .robotoSlabMedium(size: 20)

        tempLabel.layer.masksToBounds = false
        tempLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        tempLabel.layer.shadowOpacity = 1
        tempLabel.layer.shadowRadius = 4
        tempLabel.layer.shadowOffset = CGSize(width: 0, height: 5)

        humidityLabel.layer.masksToBounds = false
        humidityLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        humidityLabel.layer.shadowOpacity = 1
        humidityLabel.layer.shadowRadius = 4
        humidityLabel.layer.shadowOffset = CGSize(width: 0, height: 5)

        windLabel.layer.masksToBounds = false
        windLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        windLabel.layer.shadowOpacity = 1
        windLabel.layer.shadowRadius = 4
        windLabel.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        tempValue.layer.masksToBounds = false
        tempValue.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        tempValue.layer.shadowOpacity = 1
        tempValue.layer.shadowRadius = 4
        tempValue.layer.shadowOffset = CGSize(width: 0, height: 5)

        humidityValue.layer.masksToBounds = false
        humidityValue.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        humidityValue.layer.shadowOpacity = 1
        humidityValue.layer.shadowRadius = 4
        humidityValue.layer.shadowOffset = CGSize(width: 0, height: 5)

        windValue.layer.masksToBounds = false
        windValue.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        windValue.layer.shadowOpacity = 1
        windValue.layer.shadowRadius = 4
        windValue.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        tempValue.text = "26c"
        humidityValue.text = "60%"
        windValue.text = "10km/h"
        view.addSubview(tempValue)
        view.addSubview(humidityValue)
        view.addSubview(windValue)
        
        NSLayoutConstraint.activate([
            tempLabel.topAnchor.constraint(equalTo: self.tempMainLabel.bottomAnchor, constant: 30),
            humidityLabel.topAnchor.constraint(equalTo: self.tempMainLabel.bottomAnchor, constant: 30),
            windLabel.topAnchor.constraint(equalTo: self.tempMainLabel.bottomAnchor, constant: 30),
            
            tempLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: -120),
            humidityLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: 0),
            windLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: 120),
            
            tempValue.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
            humidityValue.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor),
            windValue.topAnchor.constraint(equalTo: windLabel.bottomAnchor),
            
            tempValue.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: -120),
            humidityValue.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: 0),
            windValue.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant: 120),
            
        ])
    }
    
    private func setupDayLabel() {
        dayLabel = labelUI(text: "Today", textColor: .white)
        dayLabel.font = .robotoSlabLight(size: 20)
        dayLabel.layer.masksToBounds = false
        dayLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        dayLabel.layer.shadowOpacity = 1
        dayLabel.layer.shadowRadius = 4
        dayLabel.layer.shadowOffset = CGSize(width: 0, height: 5)

        view.addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: self.tempMainLabel.bottomAnchor,constant: 100),
            dayLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,constant: 24),
            dayLabel.widthAnchor.constraint(equalToConstant: 58),
            dayLabel.heightAnchor.constraint(equalToConstant: 26),
        ])

    }
    
    private func setupViewReportButton() {
        viewReportBtn = UIButton()
        viewReportBtn.translatesAutoresizingMaskIntoConstraints = false
        viewReportBtn.setTitle("View Report", for: .normal)
        viewReportBtn.titleLabel?.font = .robotoSlabLight(size: 20)
        viewReportBtn.setTitleColor(UIColor(red: 0, green: 0.149, blue: 0.533, alpha: 1 ), for: .normal)
        viewReportBtn.layer.masksToBounds = false
        viewReportBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        viewReportBtn.layer.shadowOpacity = 1
        viewReportBtn.layer.shadowRadius = 4
        viewReportBtn.layer.shadowOffset = CGSize(width: 0, height: 5)
        viewReportBtn.addTarget(self, action: #selector(ViewController.viewReportButtonTapped), for: .touchUpInside)
        
        view.addSubview(viewReportBtn)
        
        NSLayoutConstraint.activate([
            viewReportBtn.topAnchor.constraint(equalTo: self.tempMainLabel.bottomAnchor, constant: 100),
            viewReportBtn.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,constant: -21),
            viewReportBtn.widthAnchor.constraint(equalToConstant: 130),
            viewReportBtn.heightAnchor.constraint(equalToConstant: 26),
        ])
    }
    
    private func setupBottomCollectionView() {
        let bottomCollectionLayout = UICollectionViewFlowLayout()
        bottomCollectionLayout.scrollDirection = .horizontal
        bottomCollectionLayout.minimumLineSpacing = 20
        bottomCollectionLayout.sectionInset = UIEdgeInsets(top: -5, left: 17, bottom: 0, right: 13)
        bottomCollectionLayout.estimatedItemSize = CGSize(width: 166, height: 80)
        
        bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: bottomCollectionLayout)
        bottomCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomCollectionView.backgroundColor = UIColor(red: 0.51, green: 0.549, blue: 0.682, alpha: 1)
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.showsHorizontalScrollIndicator = false
        bottomCollectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifire)
        
        self.view.addSubview(bottomCollectionView)
        
        NSLayoutConstraint.activate([
            bottomCollectionView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor,constant: 24),
            bottomCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
//            bottomCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -158),
            bottomCollectionView.heightAnchor.constraint(equalToConstant: 85),
        ])
    }
    
    //MARK: - Config Content
    private func currentWeatherVMObserver() {
        currentWeatherVM.eventHandler = { [weak self] event in
            switch event {
            case .loading: DispatchQueue.main.async { self?.activityIndicator.startAnimating() }
            case .stopLoading: DispatchQueue.main.async { self?.activityIndicator.stopAnimating() }
            case .dataLoaded: DispatchQueue.main.async { self?.configCurrentWeatherContent() }
            case .error(let error): DispatchQueue.main.async { self?.showToast(message: error?.localizedDescription ?? "", font: .boldSystemFont(ofSize: 15))}
            }
        }
    }
    
    private func forecastVMObserver() {
        forecastWeatherVM.eventHandler = { [weak self] event in
            switch event {
            case .loading: DispatchQueue.main.async {
                self?.activityIndicator.startAnimating()
            }
            case .stopLoading: DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            case .dataLoaded: DispatchQueue.main.async {
                self?.configForecastContent()
            }
            case .error(let error): DispatchQueue.main.async {
                self?.showToast(message: error?.localizedDescription ?? "", font: .boldSystemFont(ofSize: 15))
            }
            }
        }
    }
    
    private func configCurrentWeatherContent() {
        print(currentWeatherVM.currentWeatherDTO!)
//        self.namelabel.text = currentWeatherVM.currentWeatherDTO?.city
        self.tempMainLabel.text = currentWeatherVM.currentWeatherDTO?.temp.appending(" c")
        self.windValue.text = currentWeatherVM.currentWeatherDTO?.wind.appending("km/h")
        self.humidityValue.text = currentWeatherVM.currentWeatherDTO?.humidity.appending("%") ?? "" + "%"
        self.tempValue.text = currentWeatherVM.currentWeatherDTO?.temp.appending("c")
        self.weatherImgView.image = UIImage(named: currentWeatherVM.currentWeatherDTO?.weatherType ?? "ClearSky")
//        self.weatherImgView.kf.setImage(with: URL(string: (currentWeatherVM.currentWeatherDTO?.getURL())!))
        let getImgName = currentWeatherVM.currentWeatherDTO?.icon
        self.weatherImgView.image = UIImage(named: getImage(icon: getImgName!))
        self.dateLabel.text = currentWeatherVM.currentWeatherDTO?.date
    }
    
    private func configForecastContent() {
        self.bottomCollectionView.reloadData()
    }
    
    @objc func viewReportButtonTapped() {
        let fcVC = ForecastViewController()
        fcVC.configContent(forecastData: forecastWeatherVM.nextFourDaysForecast)
        self.navigationController?.pushViewController(fcVC, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }

}

//MARK: - CurrentLocation Delegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentWeatherVM.currentLocation = Location(lat: String(manager.location?.coordinate.latitude ?? 0.0), lon: String(manager.location?.coordinate.longitude ?? 0.0))
    }
}


//MARK: - CollectionView Delegate
extension ViewController: UICollectionViewDelegate {
    
}

//MARK: - CollectionView DataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.topCollectionView:
            return currentWeatherVM.topCollectionViewData.count
        case self.bottomCollectionView:
            return forecastWeatherVM.todayForecast.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.topCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifire, for: indexPath) as? InfoCollectionViewCell
            if let cell = cell {
                cell.configContent(weatherType: currentWeatherVM.topCollectionViewData[indexPath.row].0, weatherTypeImageName: currentWeatherVM.topCollectionViewData[indexPath.row].1)
                return cell
            }
            return UICollectionViewCell()
            
        case self.bottomCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifire, for: indexPath) as? HourlyCollectionViewCell
            if let cell = cell {
                cell.configContent(forecastDTO: forecastWeatherVM.todayForecast[indexPath.row])
                return cell
            }
            return UICollectionViewCell()
         default:
            return UICollectionViewCell()
        }
    }
    
}

//  MARK: - Show Tost
extension ViewController {
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 10, y: 250, width: view.frame.width-30, height: 80))
        toastLabel.backgroundColor = UIColor(red: 0.656, green: 0.706, blue: 0.879, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}






