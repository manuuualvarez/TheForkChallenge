//
//  HomeViewModel.swift
//  TheForkChallenge
//
//  Created by Manuel Alvarez on 1/25/22.
//
import Foundation
import UIKit


protocol HomeViewModel: BaseViewModel {
    var tableRestaurantData: TheForkObservable<[Restorant]> { get }
    var tableRestaurantDataSort: TheForkObservable<[Restorant]> { get }
    func pullToRefres()
    func likeImageDidTap(name: String, status: Bool)
    func sorButtonDidTapped(type: SortedType)
    var oderListTitle: TheForkObservable<String> { get }
}

enum SortedType: String {
    case byNameAsc = "Sort by Name Asc"
    case byNameDesc = "Sort by Name Desc"
    case byForkRating = "Sort by The Fork Rating"
    case byTripAdvisorRating = "Sort by Trip Advisor Rating"
}

final class HomeViewModelImplementation: BaseViewModelImplementation, HomeViewModel {

//    MARK: Properties
    var navigator: HomeNavigator?
    var tableRestaurantData: TheForkObservable<[Restorant]> = TheForkObservable([])
    var tableRestaurantDataSort: TheForkObservable<[Restorant]> = TheForkObservable([])
    var oderListTitle: TheForkObservable<String> = TheForkObservable("Sort by Name Asc")
    
//    MARK: Service
    var restaurantsServices = RestaurantsServices()
    var favoritesResturants: [FavoriteRestaurantEntity]?

//    MARK: Life cycle
    override func viewDidLoad() {
        fetchRedditData()
    }
        
//    MARK: Methods
    private func fetchRedditData() {
        animationName = .loader
        isLoadingObservable.value = true
        restaurantsServices.getRestaurants { [weak self] (result) in
            self?.isLoadingObservable.value = false
            switch result {
                case .failure(_):
                    print("DEBUG: - Error fail")
                case .success(let restaurants):
                    guard let data = restaurants.data  else { return }
                    self?.tableRestaurantData.value = data
                    self?.getFavoritesItems()
                    self?.orderList(type: .byNameAsc)
            }
        }
    }
    
    func pullToRefres() {
        tableRestaurantData.value = []
        fetchRedditData()
    }
    
    func likeImageDidTap(name: String, status: Bool) {
        if status {
            removeFromCoreData(name: name)
        } else {
            let favoriteItem = FavoriteRestaurantEntity(context: PersistenceService.context)
            favoriteItem.id = name
            PersistenceService.saveContext()
        }

        getFavoritesItems()
    }
    
    private func removeFromCoreData(name: String) {
        PersistenceService.deleteItemInCoreData(uid:name)
        PersistenceService.saveContext()
    }
    
    private func getFavoritesItems() {
        self.favoritesResturants = PersistenceService.getFavoriteRestoCoreData()
        updateFavoriteStatus()
    }
    
    private func updateFavoriteStatus() {
        tableRestaurantData.value = tableRestaurantData.value.map{ (item) -> Restorant in
            var resto = item
            
            if let favorites = favoritesResturants {
                resto.favorite = favorites.contains{ $0.id == resto.name }
            } else {
                resto.favorite = false
            }
            return resto
        }
    }
    
    internal func sorButtonDidTapped(type: SortedType) {
        orderList(type: type)
    }
    
    private func orderList(type: SortedType) {
        switch type {
            case .byNameAsc:
                tableRestaurantDataSort.value = tableRestaurantData.value.sorted{ $0.name.lowercased() < $1.name.lowercased()}
            case .byNameDesc:
                tableRestaurantDataSort.value = tableRestaurantData.value.sorted{ $0.name.lowercased() > $1.name.lowercased()}
            case .byTripAdvisorRating:
                tableRestaurantDataSort.value = tableRestaurantData.value.sorted{
                    $0.aggregateRatings?.tripadvisor?.ratingValue ?? 0 >
                    $1.aggregateRatings?.tripadvisor?.ratingValue ?? 0
                }
            case .byForkRating:
                tableRestaurantDataSort.value = tableRestaurantData.value.sorted{
                    $0.aggregateRatings?.thefork?.ratingValue ?? 0 >
                    $1.aggregateRatings?.thefork?.ratingValue ?? 0
                }
        }
        
        oderListTitle.value = type.rawValue
        
    }
    
}
    
    
