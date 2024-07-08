//
//  MealDB.swift
//  Calling the API and fetching the data
//  DessertDash
//
//  Created by Rimsha Rizvi on 7/7/24.
//

import Foundation

class MealDB {
    static let shared = MealDB()
    
    private init() {}
    
    // fetching the list of meals in the Dessert category, following Swift Concurrency (async/await)
    func fetchDesserts() async throws -> [Meal] {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode([String: [Meal]].self, from: data)
        return response["meals"] ?? []
    }
    
    // fetching the meal details by its ID, following Swift Concurrency (async/await)
    func fetchMealInfo(mealID: String) async throws -> MealInfo {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode([String: [MealInfo]].self, from: data)
        return response["meals"]?.first ?? MealInfo(idMeal: "", strMeal: "", strInstructions: "", strMealThumb: "", strIngredient1: nil, strMeasure1: nil, strIngredient2: nil, strMeasure2: nil, strIngredient3: nil, strMeasure3: nil, strIngredient4: nil, strMeasure4: nil, strIngredient5: nil, strMeasure5: nil, strIngredient6: nil, strMeasure6: nil, strIngredient7: nil, strMeasure7: nil, strIngredient8: nil, strMeasure8: nil, strIngredient9: nil, strMeasure9: nil, strIngredient10: nil, strMeasure10: nil, strIngredient11: nil, strMeasure11: nil, strIngredient12: nil, strMeasure12: nil, strIngredient13: nil, strMeasure13: nil, strIngredient14: nil, strMeasure14: nil, strIngredient15: nil, strMeasure15: nil, strIngredient16: nil, strMeasure16: nil, strIngredient17: nil, strMeasure17: nil, strIngredient18: nil, strMeasure18: nil, strIngredient19: nil, strMeasure19: nil, strIngredient20: nil, strMeasure20: nil)
    }
}
