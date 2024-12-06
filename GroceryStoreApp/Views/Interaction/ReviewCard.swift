//
//  ReviewCard.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-06.
//

import SwiftUI

struct ReviewCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading) {
                    Text("John Doe")
                        .fontWeight(.medium)
                    HStack {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        Text("• 2 days ago")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Text("Great food and atmosphere! The service was excellent and the prices are reasonable.")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}


#Preview {
    ReviewCard()
}
