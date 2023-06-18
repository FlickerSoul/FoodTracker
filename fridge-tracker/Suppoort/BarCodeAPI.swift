//
//  BarCodeAPI.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/13/23.
//

import Foundation
import os

let OPEN_FOOD_FACTS_BAR_CODE_API = "https://world.openfoodfacts.org/api/v2/product/"
let OPEN_FOOD_FACTS_QUERY_UA = "FoodTracker - iOS"

let API_LOGGER = Logger(subsystem: Bundle.main.bundlePath, category: "API")

struct OpenFoodFactsProductDetail: Codable {
    var brands: String?
    var generic_name: String?
    var countries: String?
    var countries_hierarchy: [String]?
    var product_name: String?
    var product_quantity: String?
    var quantity: String?
    var categories_tags: [String]?
    var categories_hierarchy: [String]?
    var _keywords: [String]?

    var name: String {
        self.product_name ??
            self.generic_name ?? ""
    }
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
        let urlString = "\(OPEN_FOOD_FACTS_BAR_CODE_API)\(barcode)"
        API_LOGGER.debug("URL \(urlString) made")
        return URL(string: urlString)!
    }

    func makeFoodInfoRequest(barcode: String, initCallback: () -> Void = {}, resultCallback: @escaping (OpenFoodFactsAPIResponse?, APIRequestError?) -> Void) {
        initCallback()

        let queryUrl = self.makeQueryUrl(barcode: barcode)

        var request = URLRequest(url: queryUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(OPEN_FOOD_FACTS_QUERY_UA, forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, response, error in
            API_LOGGER.debug("received open food fact api response with \n data: \(String(decoding: data ?? Data(), as: UTF8.self))\n response: \(response)\n error: \(error)")

            if let data = data {
                if let result = try? JSONDecoder().decode(OpenFoodFactsAPIResponse.self, from: data) {
                    API_LOGGER.debug("API parse successfully")

                    resultCallback(result, nil)
                } else {
                    API_LOGGER.error("API parse error")

                    resultCallback(nil, APIRequestError.decodeError(data: String(decoding: data, as: UTF8.self)))
                }
            } else {
                API_LOGGER.debug("API Request Error")

                resultCallback(nil, APIRequestError.requestError)
            }
        }.resume()
    }
}
