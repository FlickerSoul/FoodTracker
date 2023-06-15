//
//  BarCodeAPI.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/13/23.
//

import Foundation

let OPEN_FOOD_FACTS_BAR_CODE_API = "https://world.openfoodfacts.org/api/v2/product/"

struct OpenFoodFactsProductDetail: Codable {
    var brands: String
    var generic_name: String
    var generic_name_en: String?
    var countries: String
    var countries_hierarchy: String
    var product_name: String
    var product_name_en: String?
}

struct OpenFoodFactsAPIResponse: Codable {
    var code: String
    var product: OpenFoodFactsProductDetail
    var status: Int
}

struct APIRequestDecodeError: CustomStringConvertible, Error {
    var detail: String = "unknown"

    var description: String {
        "Cannot decode API output. Reasons: \(detail)"
    }
}

class OpenFoodFactsRequestFactory {
    private let requestUrl: String

    init(requestUrl: String = OPEN_FOOD_FACTS_BAR_CODE_API) {
        self.requestUrl = requestUrl
    }

    func makeQueryUrl(barcode: String) -> URL {
        return URL(string: "\(OPEN_FOOD_FACTS_BAR_CODE_API)\(barcode)")!
    }

    func makeFoodInfoRequest(barcode: String, callback: @escaping (OpenFoodFactsAPIResponse?, Error?) -> Void) {
        let queryUrl = makeQueryUrl(barcode: barcode)

        var request = URLRequest(url: queryUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("", forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                if let result = try? JSONDecoder().decode(OpenFoodFactsAPIResponse.self, from: data) {
                    callback(result, nil)
                } else {
                    callback(nil, APIRequestDecodeError())
                }
            } else {
                callback(nil, error)
            }
        }
    }
}
