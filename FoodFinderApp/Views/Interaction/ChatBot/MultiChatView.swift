//
//  MultiChatView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-11.
//

//
//  MultiChatView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-11.
//

import SwiftUI

struct MultiChatView: View {
    @State var textInput = ""
    @State var logoAnimating = false
    @State var timer: Timer?
    @State var chatService = ChatService()
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                // MARK: Animated Logo
                Image(.geminiLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .opacity(logoAnimating ? 0.5 : 1)
                    .animation(.easeInOut(duration: 0.5), value: logoAnimating)
                
                // MARK: Chat Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(chatService.messages) { chatMessage in
                            chatMessageView(chatMessage)
                        }
                    }
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
                    .onChange(of: chatService.messages) { _, _ in
                        guard let recentMessage = chatService.messages.last else { return }
                        DispatchQueue.main.async {
                            withAnimation {
                                proxy.scrollTo(recentMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: chatService.loadingResponse) { _, newValue in
                        if newValue {
                            startLoadingAnimation()
                        } else {
                            stopLoadingAnimation()
                        }
                    }
                }
                
                // MARK: Category Buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach([
                            "Suggest Random Cuisine",
                            "Dietary Restrictions",
                            "Local Specialties",
                            "Quick Meal",
                            "Budget Friendly",
                            "Popular Dishes"
                        ], id: \.self) { buttonTitle in
                            Button(action: {
                                handleCategoryButton(buttonTitle)
                            }) {
                                Text(buttonTitle)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.blue.opacity(0.8))
                                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                    )
                                    .minimumScaleFactor(0.8)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                }
                
                // MARK: Input Field
                HStack {
                    TextField("Enter a message", text: $textInput)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(.black)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        }
    }
    
    // The @ViewBuilder attribute allows you to construct complex views from multiple subviews
    // in a declarative way. It makes the function capable of returning a dynamic number of views
    // based on the conditional logic inside the function. In this case, it is used to construct
    // the chat message bubble view.

    @ViewBuilder func chatMessageView(_ message: ChatMessage) -> some View {
        // ChatBubble is a custom view that handles the layout and appearance of
        // a chat message bubble. The 'direction' parameter determines whether the bubble
        // aligns to the left or right based on the role of the message (e.g., model or user).
        ChatBubble(direction: message.role == .model ? .left : .right) {
            // Inside the bubble, display the text of the message.
            Text(message.message)
                .font(.system(size: 16))         //
                .padding(.horizontal, 15)        //
                .padding(.vertical, 10)          //
                .foregroundColor(.white)         //
        }
        .padding(.horizontal, 10)                //
        .padding(.vertical, 5)                   //
    }

    
    func handleCategoryButton(_ buttonTitle: String) {
        let prompt: String
        switch buttonTitle {
        case "Suggest Random Cuisine":
            prompt = "Suggest a random cuisine type and explain why I might enjoy it, Give a brief, simple response in plain text without any formatting or special characters. Keep it conversational and under 3 sentences."
        case "Popular Dishes":
            prompt = "What are the most popular dishes to try right now, Give a brief, simple response in plain text without any formatting or special characters. Keep it conversational and under 3 sentences."
        case "Dietary Restrictions":
            prompt = "What are some restaurant options for someone with dietary restrictions? Give a brief, simple response in plain text without any formatting or special characters. Keep it conversational and under 3 sentences."
        case "Local Specialties":
            prompt = "What local food specialties should I try in this area, Give a brief, simple response in plain text without any formatting or special characters. Keep it conversational and under 3 sentences."
        case "Quick Meal":
            prompt = "Suggest a quick and easy meal i can eat quickly, Give a brief, simple response in plain text without any formatting or special characters. Keep it conversational and under 3 sentences."
        case "Budget Friendly":
            prompt = "What are some affordable dining options nearby, Give a brief, simple response in plain text without any formatting or special characters. Keep it conversational and under 3 sentences."
        default:
            prompt = buttonTitle
        }
        textInput = prompt
        sendMessage()
    }
    
    func sendMessage() {
        if !textInput.isEmpty {
            chatService.sendMessage(textInput)
            textInput = ""
        }
    }
    
    func startLoadingAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            logoAnimating.toggle()
        }
    }
    
    func stopLoadingAnimation() {
        logoAnimating = false
        timer?.invalidate()
        timer = nil
    }
}
