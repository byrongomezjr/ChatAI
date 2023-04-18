//
//  Login.swift
//  ChatAI
//
//  Created by Byron Gomez Jr on 4/3/23.
//  Copyright © 2023 Byron Gomez Jr. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import GoogleSignIn
import GoogleSignInSwift
import Firebase

//Custom Color
struct CustomColor {
    static let myColor = Color("oceanBlue")
}

struct Login: View {
    @StateObject var loginModel: LoginViewModel = .init()
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                Image(systemName: "cube.fill")
                    .font(.system(size: 35))
                    .foregroundColor(.gray)
                
                (Text("Welcome to ChatAI, ")
                    .foregroundColor(.gray) +
                 Text("Please login to continue...")
                    .foregroundColor(CustomColor.myColor.opacity(0.80)))
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
                            .fill(.blue.opacity(0.30))
                    }
                }
                .padding(.top,30)
                
                //Image Logo & Text
                Image("robot")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.top,40)
                    .padding(.bottom,10)
                    .padding(.leading,-60)
                    .padding(.horizontal)
                
            }
                .padding(.leading,50)
                .padding(.vertical,30)
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
