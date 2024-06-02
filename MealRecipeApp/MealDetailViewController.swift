//
//  MealDetailViewController.swift
//  MealRecipeApp
//
//  Created by Jayshree Paladiya on 2024-06-02.
//

import UIKit

class MealDetailViewController: UIViewController {

    var meal: Meal?
    @IBOutlet weak var imageViewMeal: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setUpUI()
    }
    
    func setUpUI() {
            if let meal = meal {
                self.navigationItem.title = meal.name
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: meal.thumbnailURL) {
                        // Update UI on the main queue
                        DispatchQueue.main.async {
                            self.imageViewMeal.image = UIImage(data: data)
                        }
                    }
                }
            } else {
                print("Meal is nil")
            }
        }
}
