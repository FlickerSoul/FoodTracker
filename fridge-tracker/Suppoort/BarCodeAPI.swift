//
//  BarCodeAPI.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/13/23.
//

import Foundation

let OPEN_FOOD_FACTS_BAR_CODE_API = "https://world.openfoodfacts.org/api/v2/product/"
let OPEN_FOOD_FACTS_QUERY_UA = "FoodTracker - iOS"

struct OpenFoodFactsProductDetail: Codable {
    var brands: String
    var generic_name: String?
    var generic_name_en: String?
    var countries: String
    var countries_hierarchy: [String]
    var product_name: String?
    var product_quantity: String
    var quantity: String
}

struct OpenFoodFactsAPIResponse: Codable {
    var code: String
    var product: OpenFoodFactsProductDetail
    var status: Int
    var status_verbose: String?
}

enum APIRequestError: CustomStringConvertible, Error {
    case decodeError(data: String)
    case requestError

    var description: String {
        "Cannot parse API output."
    }
}

class OpenFoodFactsRequestFactory {
    private let requestUrl: String

    static let current: OpenFoodFactsRequestFactory = .init()

    init(requestUrl: String = OPEN_FOOD_FACTS_BAR_CODE_API) {
        self.requestUrl = requestUrl
    }

    func makeQueryUrl(barcode: String) -> URL {
        return URL(string: "\(OPEN_FOOD_FACTS_BAR_CODE_API)\(barcode)")!
    }

    func makeFoodInfoRequest(barcode: String, initCallback: () -> Void = {}, resultCallback: @escaping (OpenFoodFactsAPIResponse?, APIRequestError?) -> Void) {
        initCallback()

        let queryUrl = makeQueryUrl(barcode: barcode)

        var request = URLRequest(url: queryUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(OPEN_FOOD_FACTS_QUERY_UA, forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                if let result = try? JSONDecoder().decode(OpenFoodFactsAPIResponse.self, from: data) {
                    resultCallback(result, nil)
                } else {
                    resultCallback(nil, APIRequestError.decodeError(data: String(decoding: data, as: UTF8.self)))
                }
            } else {
                resultCallback(nil, APIRequestError.requestError)
            }
        }.resume()
    }
}
