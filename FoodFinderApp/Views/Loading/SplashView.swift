//
//  SplashView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-05.
//

import SwiftUI


struct SplashView: View {
    @State private var isShowingIntro = false
    
    var body: some View {
        ZStack {
            if isShowingIntro {
                IntroView()
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                    
                    Text("Resturant\nApp")
                        .font(.system(size: 40, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
                .ignoresSafeArea()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            isShowingIntro = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}

