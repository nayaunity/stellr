//
//  RatingCategoryView.swift
//  Intent
//
//  Created by Nyaradzo Bere on 9/7/23.
//

import Foundation
import SwiftUI

struct RatingCategoryView: View {
    var category: String
    @Binding var rating: Int
    var infoButtonAction: () -> Void // Action for info button

    var body: some View {
        VStack {
            HStack {
                Text(category)
                    .font(.headline)
                    .padding()

                // Info Button
                Button(action: {
                    self.infoButtonAction()
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                }
                .padding(.leading, 4)
            }

            HStack {
                ForEach(1 ..< 6) { star in
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.yellow)
                        .onTapGesture {
                            self.rating = star
                        }
                }
            }
        }
    }
}
