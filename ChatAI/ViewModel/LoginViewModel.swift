//
//  LoginViewModel.swift
//  ChatAI
//
//  Created by Byron Gomez Jr on 4/5/23.
//  Copyright © 2023 Byron Gomez Jr. All rights reserved.
//

import SwiftUI
import Firebase
import CryptoKit
import AuthenticationServices

class LoginViewModel: ObservableObject {
    //View Properties
    
    @Published var mobileNo: String = ""
    @Published var otpCode: String = ""
    @Published var CLIENT_CODE: String = ""
    @Published var showOTPField: Bool = false
    
    //Error Properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    //App Log Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    //Apple Sign In Properties
    @Published var nonce: String = ""
    
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
                await MainActor.run(body: {
                    withAnimation(.easeInOut){logStatus = true}
                })
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
    //Apple Sign In API
    func appleAuthenticate(credential: ASAuthorizationAppleIDCredential){
        
        //Get Token
        guard let token = credential.identityToken else{
            print("Error With Firebase.")
            
            return
        }
        //Token String
        guard let tokenString = String(data: token, encoding: .utf8) else{
            print("Error With Token.")
            
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString,rawNonce: nonce)
        
        Auth.auth().signIn(with: firebaseCredential) { (result, err) in
            if let error = err{
                print(error.localizedDescription)
                
                return
            }
            //Successfully Loggin Into Firebase.
            print("Logged In Successfully.")
            withAnimation(.easeInOut){self.logStatus = true}
        }
    }
}

//Enxtensions
extension UIApplication{
    func closeKeyboard(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//Apple Sign In
func sha256(_ input: String) -> String {
    let inputData  = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}
