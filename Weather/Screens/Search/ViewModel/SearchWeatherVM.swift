//
//  SearchWeatherVM.swift
//  Weather
//
//  Created by Khushbuben Patel on 11/10/23.
//

import Foundation

class SearchWeatherVM {
    
    //MARK: - Properties
    var repository : Repository
    var coreRepository : CDWeatherRepository
    var searchResults : [CurrentWeatherDTO]
    var eventHandler: ((_ event: Event) -> Void)?
    
    //MARK: - Init
    init(_repository:Repository = WeatherRepository(),
         _searchResults:[CurrentWeatherDTO] = [],
         _coreReporitory:CDWeatherRepository = CDWeatherRepository(managedObjectContext: PersistentStorage.shared.mainContext)){
        repository = _repository
        searchResults = _searchResults
        coreRepository = _coreReporitory
    }
    
    //MARK: - Methods
    
    func getAllCity(){
        self.searchResults = self.coreRepository.getList()
        
    }
    func checkDublicate(city: String)->Int?{
        if let index = self.searchResults.firstIndex(where: { $0.city == city}) {
            return index
        }
        return nil
        
    }
    func getCityLocation(city: String){
        self.eventHandler?(.loading)
        //       Dublicate Check
        if let index = checkDublicate(city: city) {
            //            Find weather with locations
            self.getWeather(location: LocationModel(lat: self.searchResults[index].lat, lon: self.searchResults[index].lon),index: index, searchText: city)
        }
        else{
            //          Search location
            repository.getCityLocation(city: city) { location, errorMessage in
                self.eventHandler?(.stopLoading)
                guard let cityLocation = location else {
                    self.eventHandler?(.stopLoading)
                    self.eventHandler?(.error(errorMessage ?? ""))
                    return
                }
                //                after searching get weather data
                self.getWeather(location: cityLocation, index: nil,searchText: city)
            }
        }
    }
    
    func getWeather(location: LocationModel, index: Int?,searchText:String){
        self.eventHandler?(.loading)
        self.repository.getCurrentWeather(location: location) { currentWeatherDTO, errorMessage in
            self.eventHandler?(.stopLoading)
            guard let currentWeatherDTO = currentWeatherDTO else {
                
                self.eventHandler?(.error(errorMessage ?? ""))
                return
            }
            if currentWeatherDTO.city == searchText {
                self.eventHandler?(.dataLoaded)
                //          if city exists update its weather
                if let index = index {
                    let response = self.coreRepository.update(currentWeatherDTO: currentWeatherDTO)
                    if response.isUpdate {
                        self.searchResults[index] = currentWeatherDTO
                        self.eventHandler?(.dataLoaded)
                    }
                    else{
                        self.eventHandler?(.error(response.errorMessage))
                    }
                }
                else{
                    let response = self.coreRepository.create(currentWeatherDTO: currentWeatherDTO)
                    if response.isSaved {
                        self.searchResults.insert(currentWeatherDTO, at: 0)
                        self.eventHandler?(.dataLoaded)
                    }
                    else{
                        self.eventHandler?(.error(response.errorMessage))
                    }
                }
            }
            else{
                self.eventHandler?(.error("City not found"))
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
