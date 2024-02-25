import SwiftUI
import GoogleGenerativeAI

struct ChatBot: View {
    @State var userInput: String = ""
    @State private var chatMessages: [String] = []
    private let apiKey = "AIzaSyBEH0mo0PAabKy80amr5_nzBf6Gh5VdiAA"
    @State var chat: Chat?

    var body: some View {
        VStack {
        HStack {
            Spacer()
            Text("FIN.AI")
                .padding([.bottom], 28)
                .font(.system(size: 32, weight: .heavy))
                .foregroundColor(.white)
                .bold()
            Spacer()
        }
       
            // Display chat messages
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    ForEach(chatMessages, id: \.self) { message in
                        HStack {
                            Text(message)
                                .foregroundColor(.white)
                                .bold()
                            Spacer()
                        }
                    }
                }
            }
            .padding()
            

            // Text input and send button
            HStack {
                TextField("Type a message...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    

                Button("Send") {
                    sendMessage()
                }
            }
            .padding()
            //.background(K.colors.blue)
        }
        .onAppear {
            // Initialize the chat
            chatMessages = []
            chat = initializeChat()
            sendMessage(showUser: false, message: "You are going to be an investors assistant who prioritizes learning. Each response should be at most 3 sentences long. Your goal is to give advice while teaching. To get started, say: Hi I'm FIN.AI, and I can help you with all things stocks.")
        }
        .background(K.colors.grayGreen)
    }

    func initializeChat() -> Chat {
        let config = GenerationConfig(
            temperature: 0.9,
            topP: 1,
            topK: 1
            //maxOutputTokens: 2048
        )

        return GenerativeModel(
            name: "gemini-pro",
            apiKey: apiKey,
            generationConfig: config,
            safetySettings: [
                SafetySetting(harmCategory: .harassment, threshold: .blockMediumAndAbove),
                SafetySetting(harmCategory: .hateSpeech, threshold: .blockMediumAndAbove),
                SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockMediumAndAbove),
                SafetySetting(harmCategory: .dangerousContent, threshold: .blockMediumAndAbove)
            ]
        ).startChat(history: [])
    }

    func sendMessage(showUser: Bool = true, message: String? = nil) {
        Task {
            do {
                guard let chat = chat else {
                    print("Chat not initialized")
                    return
                }
                
                if showUser {
                    addChatMessage("You: \(userInput)")
                }
                
                if let message = message {
                    let response = try await chat.sendMessage(message)
                    addChatMessage("FIN.AI: \(response.text ?? "No response received")")
                } else {
                    let response = try await chat.sendMessage(userInput)
                    addChatMessage("FIN.AI: \(response.text ?? "No response received")")
                }
                userInput = ""
            } catch {
                addChatMessage("Error: Unable to get response")  // Display a simple error message
                userInput = ""
            }
        }
    }

    func addChatMessage(_ message: String) {
        chatMessages.append(message)
    }
}

#Preview {
    ChatBot()
}
