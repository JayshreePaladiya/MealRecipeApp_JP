//
//  Meal.swift
//  MealRecipeApp
//
//  Created by Jayshree Paladiya on 2024-06-02.
//

import Foundation
struct Meal: Codable {
    let idMeal: String
    let name: String
    let thumbnailURL: URL
    
    enum CodingKeys: String, CodingKey {
        case idMeal
        case name = "strMeal"
        case thumbnailURL = "strMealThumb"
    }
}

