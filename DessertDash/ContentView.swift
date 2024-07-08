//
//  ContentView.swift
//  Displaying the main screen
//  DessertDash
//
//  Created by Rimsha Rizvi on 7/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var desserts: [Meal] = []
    @State private var searchText = ""

    // searching feature implementation
    var filteredDesserts: [Meal] {
        if searchText.isEmpty {
            return desserts
        } else {
            return desserts.filter { $0.strMeal.lowercased().contains(searchText.lowercased()) }
        }
    }

    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    // app bar
                    HStack {
                        Spacer()
                        HStack {
                            Image("app-bar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 306, height: 37)
                        }
                        Spacer()
                    }
                    .background(Color(red: 163/255, green: 67/255, blue: 67/255))
                    
                    // search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                        TextField("Search desserts...", text: $searchText)
                            .padding(7)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding([.leading, .trailing, .top])
                }
                .padding()
                .background(Color(red: 163/255, green: 67/255, blue: 67/255))

                // list of meals in the Dessert category sorted alphabetically
                List {
                    ForEach(Array(filteredDesserts.sorted(by: { $0.strMeal < $1.strMeal }).enumerated()), id: \.element.idMeal) { index, meal in
                        ZStack {
                            Color(red: 251/255, green: 248/255, blue: 221/255) // List item background color
                            NavigationLink(destination: MealInfoView(mealID: meal.idMeal)) {
                                MealRow(meal: meal)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .listRowInsets(EdgeInsets())
                        .frame(maxWidth: .infinity) // covering the entire tile
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("")
                .background(Color(red: 163/255, green: 67/255, blue: 67/255))
                .onAppear {
                    Task {
                        do {
                            desserts = try await MealDB.shared.fetchDesserts() // calling the api for just the item names
                        } catch {
                            print("Failed to fetch desserts: \(error)")
                        }
                    }
                }
            }
        }
    }
}

struct MealRow: View {
    var meal: Meal

    var body: some View {
        HStack {
            // calling api for image
            AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)

            Text(meal.strMeal)
                .font(.body)
                .padding(.leading, 10)
        }
        .padding()
    }
}
