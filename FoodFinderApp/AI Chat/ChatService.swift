//
//  GeminiChatApp.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-11.
//

import Foundation
import SwiftUI
import GoogleGenerativeAI

// Defines whether the message is from the user or the AI model.
enum ChatRole {
    case user
    case model
}

// Represents a single message in the chat, with an ID, role, and content.
struct ChatMessage: Identifiable, Equatable {
    let id = UUID().uuidString  // Unique ID for the message.
    var role: ChatRole          // The sender's role (user or AI).
    var message: String         // The content of the message.
}

// Manages the chat logic, including sending messages and storing conversation history.
@Observable
class ChatService {
    private var chat: Chat?                 // Handles communication with the AI.
    private(set) var messages = [ChatMessage]()  // List of all chat messages.
    private(set) var loadingResponse = false    // Indicates if AI response is loading.
    
    // Sends a message to the AI and updates the conversation.
    func sendMessage(_ message: String) {
        loadingResponse = true  // Mark that we're waiting for a response.

        // Initialize the chat session if not already created.
        if chat == nil {
            let history: [ModelContent] = messages.map {
                ModelContent(role: $0.role == .user ? "user" : "model", parts: $0.message)
            }
            chat = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default).startChat(history: history)
        }
        
        // Add the user's message to the chat history.
        messages.append(.init(role: .user, message: message))
        
        // Fetch the AI's response asynchronously.
        Task {
            do {
                let response = try await chat?.sendMessage(message)
                loadingResponse = false  // Done loading.
                
                // Add the AI's response to the chat or show an error if it fails.
                guard let text = response?.text else {
                    messages.append(.init(role: .model, message: "Something went wrong, please try again."))
                    return
                }
                
                messages.append(.init(role: .model, message: text))
            } catch {
                // Handle any errors during the response.
                loadingResponse = false
                messages.append(.init(role: .model, message: "Something went wrong, please try again."))
            }
        }
    }
}
