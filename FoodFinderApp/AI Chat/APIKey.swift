//
//  APIKey.swift
//  GroceryStoreApp
//
//  Created by Suthakaran Siva on 2024-12-11.
//

import Foundation

// The `APIKey` enum is used to manage and retrieve the API key securely.
enum APIKey {
    // A static property `default` to fetch the API key.
    static var `default`: String {
        // looks for "GenerativeAI-Info.plist" file in the app bundle.
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist") else {
            // If the file is not found, the app stops with a fatal error message.
            fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
        }

        // Load the contents of the .plist file as a dictionary.
        let plist = NSDictionary(contentsOfFile: filePath)!
        guard let value = plist.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist'.")
        }

        // Check if the API key starts with an underscore ("_").
        // This might indicate the API key hasn't been set properly.
        if value.starts(with: "_") {
            fatalError("""
                "Follow the instructions at http://ai.google.dev/tutorials/setup to get an API key."
            """)
        }

        // Step 5: If all checks pass, return the API key.
        return value
    }
}
