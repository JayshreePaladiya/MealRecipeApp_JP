//
//  MealListViewController.swift
//  MealRecipeApp
//
//  Created by Jayshree Paladiya on 2024-06-02.
//

import Foundation
import UIKit
import SwiftUI

struct MealListResponse: Codable {
    let meals: [Meal]
}


class MealListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var meals: [Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        fetchMeals()
    }
    
    func fetchMeals() {
        let urlString = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let responseData = data else {
                if let error = error {
                    print("Error fetching meals: \(error.localizedDescription)")
                } else {
                    print("No data received")
                }
                return
            }
            
            print("Response Data: \(String(data: responseData, encoding: .utf8) ?? "")")
            
            do {
                let result = try JSONDecoder().decode(MealListResponse.self, from: responseData)
                self.meals = result.meals
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding meal data: \(error.localizedDescription)")
                print("Decoding Error: \(error)")
            }
        }.resume()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let meal = meals[indexPath.row]
        cell.textLabel?.text = meal.name
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = meals[indexPath.row]
        showMealDetail(meal)
    }
    
    func showMealDetail(_ meal: Meal) {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(meal.idMeal)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching meal details: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let result = try JSONDecoder().decode(MealDetailResponse.self, from: data)
                if let mealDetail = result.meals.first {
                    DispatchQueue.main.async {
                        let mealDetailView = MealDetailView(meal: meal, mealDetail: mealDetail)
                        let hostingController = UIHostingController(rootView: mealDetailView)
                        self.navigationController?.pushViewController(hostingController, animated: true)
                    }
                }
            } catch {
                print("Error decoding meal details: \(error.localizedDescription)")
            }
        }.resume()
    }

}
