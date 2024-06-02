//
//  MealDetailView.swift
//  MealRecipeApp
//
//  Created by Jayshree Paladiya on 2024-06-02.
//

import SwiftUI

struct MealDetailView: View {
    var meal: Meal
    var image: UIImage
    
    var body: some View {
        VStack {
            Text(meal.name)
                .font(.title)
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200) // Adjust the frame size as needed
        }
        .navigationBarTitle(Text(meal.name), displayMode: .inline)
    }
}


