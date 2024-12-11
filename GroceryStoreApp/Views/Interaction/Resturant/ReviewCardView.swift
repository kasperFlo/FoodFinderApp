//
//  ReviewCard.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-06.
//

import SwiftUI
import GooglePlaces

struct ReviewCardView: View {
    
    // data of the customer reviews from the restaurants
    let review: GMSPlaceReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                
                // displaying the image of the user giving the review
                if let photoURL = review.authorAttribution?.photoURI {
                    AsyncImage(url: photoURL) { image in
                        image
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    }
                } else {
                    
                    // if we cant get that image we display a grey screen
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                }
                
                // displaying the review rating itself
                VStack(alignment: .leading) {
                    Text(review.authorAttribution?.name ?? "Anon")
                        .fontWeight(.medium)
                    RatingView(rating: Int(review.rating))
                }
            }
            
            // what the reviewer had to say about their experience
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
    
    // displaying the stars for the user for the rating they gave the place out of 5 stars
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

