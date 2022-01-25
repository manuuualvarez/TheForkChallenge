// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//

import Foundation

    // MARK: - APIData
struct APIData: Codable {
    var data: [Restorant]?
}

    // MARK: - Datum
struct Restorant: Codable {
    var name, uuid, servesCuisine: String
    var priceRange: Int?
    var currenciesAccepted: CurrenciesAccepted?
    var address: Address?
    var aggregateRatings: AggregateRatings?
    var mainPhoto: MainPhoto?
    var bestOffer: BestOffer?
    var favorite: Bool?
}

    // MARK: - Address
struct Address: Codable {
    var street, postalCode: String?
    var locality: Locality?
    var country: Country?
}

enum Country: String, Codable {
    case france = "France"
}

enum Locality: String, Codable {
    case paris = "Paris"
}

    // MARK: - AggregateRatings
struct AggregateRatings: Codable {
    var thefork, tripadvisor: Thefork?
}

    // MARK: - Thefork
struct Thefork: Codable {
    var ratingValue: Double?
    var reviewCount: Int?
}

    // MARK: - BestOffer
struct BestOffer: Codable {
    var name: Name?
    var label: Label?
}

enum Label: String, Codable {
    case the20 = "-20%"
    case the30 = "-30%"
    case the40 = "-40%"
}

enum Name: String, Codable {
    case the20OffTheALaCarteMenu = "20% off the 'a la carte' menu"
    case the30OffTheALaCarteMenu = "30% off the 'a la carte' menu"
    case the40OffTheALaCarteMenu = "40% off the 'a la carte' menu"
}

enum CurrenciesAccepted: String, Codable {
    case eur = "EUR"
}

    // MARK: - MainPhoto
struct MainPhoto: Codable {
    var source, the612X344, the480X270, the240X135: String?
    var the664X374, the1350X759, the160X120, the80X60: String?
    var the92X92, the184X184: String?
    
    enum CodingKeys: String, CodingKey {
        case source
        case the612X344 = "612x344"
        case the480X270 = "480x270"
        case the240X135 = "240x135"
        case the664X374 = "664x374"
        case the1350X759 = "1350x759"
        case the160X120 = "160x120"
        case the80X60 = "80x60"
        case the92X92 = "92x92"
        case the184X184 = "184x184"
    }
}
