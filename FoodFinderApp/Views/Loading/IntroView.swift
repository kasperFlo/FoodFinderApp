//
//  IntroView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.coral)
            
            VStack(spacing: 8) {
                Text("Find Your Local Resturant's")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Walk or Drive")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Text("The best resturant app in town for\nTasteful and Healthy Needs")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .font(.system(size: 16))
            
            Button(action: {
                
            }) {
                Text("LOOK NOW")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.green)
                    .cornerRadius(25)
            }
            .padding(.top, 16)
            
            Image("patio")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height * 0.6)
                    .clipped()
        }
        .padding(.horizontal, 24)
        .padding(.top, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}


extension Color {
    static let coral = Color(red: 235/255, green: 96/255, blue: 76/255)
}

#Preview {
    IntroView()
}
