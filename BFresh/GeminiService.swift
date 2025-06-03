import Foundation
import GoogleGenerativeAI

class GeminiService {
    private let model: GenerativeModel

    init() {
        // Get API key from configuration
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String else {
            fatalError("GEMINI_API_KEY not found in Info.plist")
        }
        
        // Match this to what you're using in AI Studio. Options: "gemini-1.5-flash-latest", etc.
        self.model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: apiKey)
    }

    func determineIfPerishable(item: String, completion: @escaping (Bool) -> Void) {
        let prompt = """
        Is \(item) a perishable food item that needs to be stored in the fridge?
        Examples of perishable items that need refrigeration: milk, eggs, meat, fish, cheese, yogurt, fresh vegetables, fresh fruits.
        Examples of non-perishable items: rice, pasta, canned goods, dry beans, flour, sugar.
        Answer with only 'yes' or 'no'.
        """

        Task {
            do {
                print("\n=== Gemini SDK Request ===")
                print("Item: \(item)")
                print("Prompt: \(prompt)")

                let response = try await model.generateContent(prompt)
                
                if let text = response.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
                    print("Raw response: \(text)")
                    let isPerishable = text == "yes"
                    print("Is perishable: \(isPerishable)")
                    print("=== End Response ===\n")
                    completion(isPerishable)
                } else {
                    print("Error: No text found in response")
                    completion(false)
                }
            } catch {
                print("Error generating content: \(error)")
                completion(false)
            }
        }
    }
    
    func getExpirationDays(for item: String, completion: @escaping (Int?) -> Void) {
        let prompt = """
        What is the average shelf life of \(item) in days when stored properly?
        Consider both fridge and pantry storage.
        Answer with only a number of days, nothing else.
        """

        Task {
            do {
                print("\n=== Gemini SDK Request ===")
                print("Item: \(item)")
                print("Prompt: \(prompt)")

                let response = try await model.generateContent(prompt)
                
                if let text = response.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    print("Raw response: \(text)")
                    if let days = Int(text) {
                        print("Expiration days: \(days)")
                        print("=== End Response ===\n")
                        completion(days)
                    } else {
                        print("Error: Could not parse days from response")
                        completion(nil)
                    }
                } else {
                    print("Error: No text found in response")
                    completion(nil)
                }
            } catch {
                print("Error generating content: \(error)")
                completion(nil)
            }
        }
    }
}

