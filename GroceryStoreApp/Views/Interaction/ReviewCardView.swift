//
//  ReviewCard.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-06.
//

import SwiftUI
import GooglePlaces

struct ReviewCardView: View {
    let review: GMSPlaceReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading) {
                    Text(review.authorAttribution?.name ?? "Anon")
                        .fontWeight(.medium)
                    RatingView(rating: Int(review.rating))
                }
            }
            Text(review.text ?? "No review text")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct RatingView: View {
    let rating: Int
    
    var body: some View {
        HStack {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: index < rating ? "star.fill" :
                     (index == rating && rating < 5) ? "star.leadinghalf.filled" : "star")
                    .foregroundColor(.yellow)
            }
        }
    }
}


//#Preview {
//    ReviewCardView()
//}
