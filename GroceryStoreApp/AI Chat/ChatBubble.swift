//
//  ChatBubble.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-11.
//

import SwiftUI

struct ChatBubble<Content: View>: View {
    let direction: Direction
    let content: Content
    
    enum Direction {
        case left
        case right
    }
    
    init(direction: Direction, @ViewBuilder content: () -> Content) {
        self.direction = direction
        self.content = content()
    }
    
    var body: some View {
        HStack {
            if direction == .left {
                content
                    .font(.system(size: 18, weight: .regular))
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.7))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                Spacer(minLength: 30)
            } else {
                Spacer(minLength: 30)
                content
                    .font(.system(size: 18, weight: .regular))
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.7))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
    }
}
