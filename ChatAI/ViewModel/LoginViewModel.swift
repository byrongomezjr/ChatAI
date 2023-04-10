//
//  LoginViewModel.swift
//  ChatAI
//
//  Created by Byron Gomez Jr on 4/5/23.
//  Copyright © 2023 Byron Gomez Jr. All rights reserved.
//

import SwiftUI
import Firebase

class LoginViewModel: ObservableObject {
    //View Properties
    
    @Published var mobileNo: String = ""
    @Published var otpCode: String = ""
    @Published var CLIENT_CODE: String = ""
    @Published var showOTPField: Bool = false
    
    //Error Properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    //Firebase API's
    func getOTPCode(){
        UIApplication.shared.closeKeyboard()
        Task{
            do {
                //Disable when testing with real device
                Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                
                let code = try await PhoneAuthProvider.provider().verifyPhoneNumber("+\(mobileNo)", uiDelegate: nil)
                await MainActor.run(body: {
                    CLIENT_CODE = code
                    //Enabling OTP Field when successful
                    withAnimation(.easeInOut){showOTPField = true}
                })
            } catch {
                await handleError(error: error)
            }
        }
        
    }
    func verifyOTPCode(){
        UIApplication.shared.closeKeyboard()
        Task{
            do{
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: CLIENT_CODE, verificationCode: otpCode)
                
                try await Auth.auth().signIn(with: credential)
                
                //User logged in successfully
                print("Success!")
            } catch {
                    await handleError(error: error)
            }
        }
    }
    
    //Handling Error
    func handleError(error: Error)async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

//Enxtensions
extension UIApplication{
    func closeKeyboard(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
