//
//  ContentView.swift
//  ChatAI
//
//  Created by Byron Gomez Jr on 4/3/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        if logStatus{
            //HOME VIEW
            DemoHome()
        }else{
            Login()
        }
    }
    @ViewBuilder
    func DemoHome()->some View{
        NavigationStack{
            Text("Logged In")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
