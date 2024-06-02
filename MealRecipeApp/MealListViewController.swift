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
        guard let imageUrl = URL(string: meal.thumbnailURL.absoluteString) else {
            return
        }
        
        DispatchQueue.global().async { [self] in
            if let data = try? Data(contentsOf: imageUrl) {
               
                if let image = UIImage(data: data) {
                    
                    DispatchQueue.main.async { [weak self] in
                       
                        let mealDetailView = MealDetailView(meal: meal, image: image)
                        let hostingController = UIHostingController(rootView: mealDetailView)
                        self?.navigationController?.pushViewController(hostingController, animated: true)
                    }
                }
            }
        }
    }
}
