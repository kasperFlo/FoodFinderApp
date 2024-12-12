//
//  ContentView.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-11.
//

import SwiftUI
import GoogleGenerativeAI

struct BotChatView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    @State var textInput: String = ""
    @State var aiResponse: String = "Want Help Finding Something to Eat?"
    @State var logoAnimating = false
    @State var timer: Timer?
    
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

            // MARK: AI Response
            ScrollView {
                Text(aiResponse)
                    .font(.system(size: 18, weight: .regular))
                    .padding(15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.8))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal)
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.4)

            
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
                            switch buttonTitle {
                            case "Suggest Random Cuisine":
                                textInput = "Suggest a random cuisine type and explain why I might enjoy it, Give a brief, simple response in plain text without any formatting or special characters. Keep it conversational and under 3 sentences."
                            case "Popular Dishes":
                                textInput = "What are the most popular dishes to try right now, Give a brief, simple response in plain text without any formatting or special characters. Keep it conversational and under 3 sentences."
                            case "Dietary Restrictions":
                                textInput = "What are some restaurant options for someone with dietary restrictions? Give a brief, simple response in plain text without any formatting or special characters. Keep it conversational and under 3 sentences."
                            case "Local Specialties":
                                textInput = "What local food specialties should I try in this area, Give a brief, simple response in plain text without any formatting or special characters. Keep it conversational and under 3 sentences."
                            case "Quick Meal":
                                textInput = "Suggest a quick and easy meal i can eat quickly, Give a brief, simple response in plain text without any formatting or special characters. Keep it conversational and under 3 sentences."
                            case "Budget Friendly ":
                                textInput = "What are some affordable dining options nearby, Give a brief, simple response in plain text without any formatting or special characters. Keep it conversational and under 3 sentences."
                            default:
                                break
                            }
                            sendMessage()
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


            
            // MARK: Input field
            HStack {
                TextField("Enter a message", text: $textInput)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.black)
                
                Button(action: sendMessage, label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                })
            }
        }
        .foregroundColor(Color.white)
        .padding()
        .background {
            }
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .ignoresSafeArea()
        }
        .onDisappear {
            // Reset the response when leaving the view
            aiResponse = "Want Help Finding Something to Eat?"
            }
        .onAppear {
            // Reset the response when returning to the view
            aiResponse = "Want Help Finding Something to Eat?"
        }
    }
    
    // Function to handle category button presses
    func askForSuggestion(_ prompt: String) {
        textInput = prompt
        sendMessage()
    }
    
    // Existing functions remain the same
    func sendMessage() {
        let messageToSend = textInput // Store the input temporarily
        textInput = "" // Clear the input field immediately
        aiResponse = ""
        startLoadingAnimation()
        Task {
            do {
                let response = try await model.generateContent(messageToSend)
                stopLoadingAnimation()
                guard let text = response.text else {
                    aiResponse = "Sorry, I could not process that. \n Please try again"
                    return
                }
                
                aiResponse = text
            }
            catch {
                stopLoadingAnimation()
                aiResponse = "Something Went Wrong \n\(error.localizedDescription)"
            }
        }
    }

    
    func startLoadingAnimation(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {timer in logoAnimating.toggle()
        })
    }
    
    func stopLoadingAnimation(){
        logoAnimating = false
        timer?.invalidate()
        timer = nil
    }
}

//AIzaSyCLNRyvqTKygd86HwwidWsxfvxfoXHzQ1o
