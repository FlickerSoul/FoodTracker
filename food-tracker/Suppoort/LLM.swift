//
//  LLM.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/16/23.
//

import Foundation
import OpenAIKit

protocol LLMQueryMaker {
    /// The type of the model used in the AI API query
    associatedtype ModelType

    /// The type of the client
    associatedtype ClientType

    var client: ClientType? { get set }

    /// Setup query maker, including things like http client, gpu connections, etc.
    func setup() throws -> Void

    /// Ensures client is present and setup
    func ensureClient() throws -> Void

    var defaultModel: ModelType { get }
}

enum LLMErrors: Error {
    case ClientDoesNotExit
    case ClientAPIKeyNotSet
}

class OpenAIQueryMaker: LLMQueryMaker {
    typealias ModelType = OpenAIKit.ModelID
    typealias ClientType = OpenAIKit.Client

    var client: OpenAIKit.Client? = nil
    private(set) var apiKey: String? = nil
    private(set) var organization: String? = nil

    private let maxTokens = 2048

    init(apiKey: String? = nil, organization: String? = nil) {
        self.apiKey = apiKey
        self.organization = organization
    }

    func setApiKey(_ key: String?) {
        self.apiKey = key
    }

    func setOrganization(_ org: String) {
        self.organization = org
    }

    func ensureClient() throws {
        if self.client == nil {
            throw LLMErrors.ClientDoesNotExit
        }
    }

    func setup() throws {
        guard self.client == nil else { return }

        let urlSession = URLSession(configuration: .default)

        guard let apiKey = apiKey else { throw LLMErrors.ClientAPIKeyNotSet }

        let configuration = Configuration(apiKey: apiKey, organization: organization)

        self.client = OpenAIKit.Client(session: urlSession, configuration: configuration)
    }

    var defaultModel: OpenAIKit.ModelID {
        OpenAIKit.Model.GPT3.gpt3_5Turbo16K
    }
}

class OpenAIFoodItemQueryMaker: OpenAIQueryMaker {
    static let current = OpenAIFoodItemQueryMaker()

    private var foodCategorySystemPrompt: String {
        return """
        You are a food expert and users will give you details about a food in JSON format, \
        including a string of product name, a list of keywords, a list of category hierarchy, \
        and a list of category tags. You are given a list of categories, where each entry is \
        in the format of "- <category_tag> : <category_name>" (excluding quotes). \
        Given a user input, you need to choose one category from below \
        that describes the food best. Your reply should only contain your choice of category_tag.

        Categories:
        \(FoodItemCategory.listing)
        """
    }

    private static func getFoodCategoryUserPrompt(item: OpenFoodFactsProductDetail) -> String {
        let keywords = (item._keywords ?? []).map { "\"\($0)\"" }.joined(separator: ",")
        let encodedCategoryHierachy = (item.categories_hierarchy ?? []).map { "\"\($0)\"" }.joined(separator: ",")
        let encodedCategoryTags = (item.categories_tags ?? []).map { "\"\($0)\"" }.joined(separator: ",")

        return """
        {
          "name": "\(item.name)",
          "keywords": [\(keywords)],
          "category_hierachy": [\(encodedCategoryHierachy)],
          "category_tags": [\(encodedCategoryTags)]
        }
        """
    }

    func processFoodCategory(item: OpenFoodFactsProductDetail, model: ModelType? = nil, callback: @escaping (Chat?, Error?) -> Void) async {
        do {
            let result: Chat? = try await self.client?.chats.create(
                model: model ?? self.defaultModel,
                messages: [
                    Chat.Message.system(content: self.foodCategorySystemPrompt),
                    Chat.Message.user(content: Self.getFoodCategoryUserPrompt(item: item))
                ]
            )

            callback(result, nil)
        } catch {
            callback(nil, error)
        }
    }
}

extension OpenAIFoodItemQueryMaker {
    func setupWithUserDefaulKey() -> Bool {
        let apiKey = UserDefaults.standard.string(forKey: SettingsKeys.openAIKey.rawValue)

        OpenAIFoodItemQueryMaker.current.setApiKey(apiKey)

        do {
            try OpenAIFoodItemQueryMaker.current.setup()
        } catch {
            return false
        }

        return true
    }
}
