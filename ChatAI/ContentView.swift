//
//  ContentView.swift
//  ChatAI
//
//  Created by Byron Gomez Jr on 4/3/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

import OpenAISwift

//OpenAI API
final class ViewModel: ObservableObject {
    init() {}
    
    private var client: OpenAISwift?
    
    func setup() {
        client = OpenAISwift(authToken: "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")
    }
    
    func send(text: String,
              completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text,
                               maxTokens: 500,
                               completionHandler: {result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(output)
            case .failure:
                break
            }
        })
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        if logStatus{
            //HOME VIEW
            MainHome()
        }else{
            Login()
        }
    }
    
    @ViewBuilder
    func MainHome()-> some View{
        NavigationStack{
            
            
                VStack(alignment: .leading) {
                    ForEach(models, id: \.self) { string in
                        Text(string)
                    }
                    Spacer()
                    
                    HStack {
                        TextField("Type Here...", text: $text)
                            .padding()
                        Button("Send") {
                            send()
                        }
                        .padding()
                    }
                }
                .onAppear() {
                    viewModel.setup()
                }
                .padding()
                .navigationTitle("Hello Human!")
                .toolbar {
                    ToolbarItem{
                        Button("Log Out"){
                            try? Auth.auth().signOut()
                            GIDSignIn.sharedInstance.signOut()
                            withAnimation(.easeInOut){
                                logStatus = false
                            }
                        }
                    }
                }
        }
        
    }
    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        models.append("Me: \(text)")
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                self.models.append("ChatAI: "+response)
                self.text = ""
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
