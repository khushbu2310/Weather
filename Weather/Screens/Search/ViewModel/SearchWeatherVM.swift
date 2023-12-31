//
//  SearchWeatherVM.swift
//  Weather
//
//  Created by Khushbuben Patel on 11/10/23.
//

import Foundation

class SearchWeatherVM {
    
    var repository : Repository
    var coreRepository : CoreRepo
    var searchResults : [CurrentWeatherDTO] = []
    var eventHandler: ((_ event: Event) -> Void)?
    
    init(_repository: Repository = WeatherRepository(),
         _coreReporitory: CoreRepo = CDWeatherRepository()){
        repository = _repository
        coreRepository = _coreReporitory
    }
    
    func getAllCity(){
        let response = coreRepository.getList()
        switch response {
        case .success(let data) : self.searchResults = data
        }
    }
    
    func getCityLocation(city: String){
        self.eventHandler?(.loading)
        if searchResults.contains(where: { $0.city == city }) {
            self.eventHandler?(.stopLoading)
            self.eventHandler?(.error("Aleardy exist"))
        }
        else{
            repository.getCityLocation(city: city) { result in
                switch result {
                case .success(let data) :
                    self.getWeather(location: data, index: nil)
                case .failure(let error) :
                    self.eventHandler?(.stopLoading)
                    self.eventHandler?(.error(error.rawValue))
                }
            }
        }
    }
    
    func getWeather(location: LocationModel, index: Int?){
        repository.getCurrentWeather(location: location) { result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let data) :
                let response = self.coreRepository.create(currentWeatherDTO: data)
                switch response {
                case .success(let ans) :
                    if ans == true {
                        self.searchResults.insert(data, at: 0)
                        self.eventHandler?(.dataLoaded)
                    }
                case .failure(let coreError) :
                    self.eventHandler?(.error(coreError.rawValue))
                }
            case .failure(let error) :
                self.eventHandler?(.error(error.rawValue))
            }
        }
    }
    
    func update(index: Int){
        self.eventHandler?(.loading)
        if index < searchResults.count {
            let data = searchResults[index]
            repository.getCurrentWeather(location: LocationModel(lat: data.lat, lon: data.lon)) { result in
                switch result {
                case .success(let data) :
                    let res = self.coreRepository.update(currentWeatherDTO: data)
                    self.eventHandler?(.stopLoading)
                    switch res {
                    case .success(let ans) :
                        if ans {
                            self.searchResults[index] = data
                            self.eventHandler?(.dataLoaded)
                        }
                    case .failure(let error) :
                        self.eventHandler?(.error(error.rawValue))
                    }
                case .failure(let error) :
                    self.eventHandler?(.stopLoading)
                    self.eventHandler?(.error(error.rawValue))
                }
            }
        }
        
    }
    
    func deleteRecord(index:Int){
        if index < searchResults.count {
            let response = coreRepository.delete(city: searchResults[index].city)
            switch response {
            case .success(let res) :
                if res {
                    self.searchResults.remove(at: index)
                    self.eventHandler?(.dataLoaded)
                }
            case .failure(let error) :
                self.eventHandler?(.error(error.rawValue))
            }
        }
    }
}

extension SearchWeatherVM {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String)
    }
}
