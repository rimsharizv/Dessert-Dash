//
//  MealInfoView.swift
//  Displaying the detailed view of each item
//  DessertDash
//
//  Created by Rimsha Rizvi on 7/7/24.
//

import SwiftUI

// displaying the detailed view of all items
struct MealInfoView: View {
    let mealID: String
    @State private var mealInfo: MealInfo?
    @State private var showIngredients = false

    var body: some View {
        VStack {
            if let mealInfo = mealInfo {
                ScrollView {
                    VStack {
                        AsyncImage(url: URL(string: mealInfo.strMealThumb)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 200)
                        .cornerRadius(8)
                        .padding()

                        // title of the dessert item
                        Text(mealInfo.strMeal)
                            .font(.title)
                            .bold()
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .padding()
                        
                        // displaying ingredients
                        if showIngredients {
                            VStack(alignment: .leading) {
                                Text("Ingredients")
                                    .font(.title2)
                                    .bold()
                                    .padding(.bottom, 5)

                                ForEach(createTableRows(from: mealInfo), id: \.id) { row in
                                    HStack {
                                        Text(row.left)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(row.right)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    Divider()
                                }
                            }
                            .padding()
                            .background(Color(red: 192/255, green: 214/255, blue: 232/255)) // ingredients box color
                            .cornerRadius(10)
                            .padding()
                        } else {    // displaying instructions
                            VStack(alignment: .leading) {
                                Text("Instructions")
                                    .font(.title2)
                                    .bold()
                                    .padding(.bottom, 5)

                                
                                ForEach(mealInfo.strInstructions.split(separator: "\r\n").filter { !$0.isEmpty }, id: \.self) { line in
                                    HStack(alignment: .top) {
                                        Text("•")
                                        Text(line)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.bottom, 2)
                                }
                            }
                                .padding()
                                .background(Color(red: 255/255, green: 182/255, blue: 193/255)) // instructions box color
                                .cornerRadius(10)
                                .padding()
                        }

                        Button(action: {
                            withAnimation {
                                showIngredients.toggle()
                            }
                        }) {
                            Text(showIngredients ? "Show Instructions" : "Show Ingredients")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            } else {
                ProgressView()
            }
        }
        .background(Color(red: 251/255, green: 248/255, blue: 221/255))
        .onAppear {
            Task {
                do {
                    mealInfo = try await MealDB.shared.fetchMealInfo(mealID: mealID)
                } catch {
                    print("Failed to fetch meal details: \(error)")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image("dessert-dash-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    Text(mealInfo?.strMeal ?? "Meal Details")
                        .font(.headline)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .gesture(DragGesture().onEnded { value in
            if value.translation.width < 0 {
                withAnimation {
                    showIngredients = true
                }
            } else if value.translation.width > 0 {
                withAnimation {
                    showIngredients = false
                }
            }
        })
    }
    
    // filtering out any null or empty values from the API before displaying them
    func createTableRows(from mealInfo: MealInfo) -> [TableRow] {
        var rows: [TableRow] = []
        
        let mirror = Mirror(reflecting: mealInfo)
        // looping through all elements of ingredients and measurements
        for i in 1...20 {
            if let ingredient = mirror.children.first(where: { $0.label == "strIngredient\(i)" })?.value as? String,
               let measure = mirror.children.first(where: { $0.label == "strMeasure\(i)" })?.value as? String,
               !ingredient.isEmpty, !measure.isEmpty {
                rows.append(TableRow(left: ingredient, right: measure))
            }
        }
        
        return rows
    }
}

struct TableRow: Identifiable {
    let id = UUID()
    let left: String
    let right: String
}
