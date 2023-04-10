//
//  Login.swift
//  ChatAI
//
//  Created by Byron Gomez Jr on 4/3/23.
//  Copyright © 2023 Byron Gomez Jr. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct Login: View {
    @StateObject var loginModel: LoginViewModel = .init()
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                Image(systemName: "cube.fill")
                    .font(.system(size: 35))
                    .foregroundColor(.gray)
                
                (Text("Welcome to ChatAI, ")
                    .foregroundColor(.black) +
                Text("Please login to continue...")
                    .foregroundColor(.blue.opacity(0.60)))
                .font(.title)
                .fontWeight(.semibold)
                .lineSpacing(10)
                .padding(.top,15)
                .padding(.trailing,40)
                
            //Custom TextField
                CustomTextField(hint: "+1 888 888 8888", text: $loginModel.mobileNo)
                    .disabled(loginModel.showOTPField)
                    .opacity(loginModel.showOTPField ? 0.4 : 1)
                    .overlay(alignment: .trailing, content: {
                        Button("Change"){
                            withAnimation(.easeInOut){
                                loginModel.showOTPField = false
                                loginModel.otpCode = ""
                                loginModel.CLIENT_CODE = ""
                            }
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                        .opacity(loginModel.showOTPField ? 1 : 0)
                        .padding(.trailing,40)
                    })
                    .padding(.top,50)
                
                CustomTextField(hint: "OTP Code", text: $loginModel.otpCode)
                    .disabled(!loginModel.showOTPField)
                    .opacity(!loginModel.showOTPField ? 0.4 : 1)
                    .padding(.top,20)
                
                Button(action: loginModel.showOTPField ? loginModel.verifyOTPCode: loginModel.getOTPCode) {
                    HStack(spacing: 20){
                        Text(loginModel.showOTPField ? "Verify Code" : "Get Code")
                            .fontWeight(.semibold)
                            .contentTransition(.identity)
                        
                        Image(systemName: "chevron.forward")
                            .font(.title3)
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal,30)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.blue.opacity(0.20))
                    }
                }
                .padding(.top,30)
                
                Text("OR")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                    .padding(.bottom,20)
                    .padding(.leading,-60)
                    .padding(.horizontal)
                
                HStack(spacing: 8){
                    HStack{
                        Image(systemName: "applelogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .frame(height: 45)
                        
                        Text("Apple Sign In")
                            .font(.callout)
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal,15)
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.black)
                    }
                    .overlay {
                        SignInWithAppleButton { (request) in
                            loginModel.nonce = randomNonceString()
                            request.requestedScopes = [.email,.fullName]
                            request.nonce = sha256(loginModel.nonce)
                            
                        } onCompletion: { (result) in
                            switch result{
                            case .success(let user):
                                print("success")
                                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else{
                                    print("error with firebase")
                                    return
                                }
                                loginModel.appleAuthenticate(credential: credential)
                            case.failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                        .signInWithAppleButtonStyle(.white)
                        .frame(height: 55)
                        .blendMode(.overlay)
                    }
                    .clipped()
                }

            }
            .padding(.leading,50)
            .padding(.vertical,20)
        }
        .alert(loginModel.errorMessage, isPresented: $loginModel.showError) {
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
