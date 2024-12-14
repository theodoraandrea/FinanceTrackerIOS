//
//  ForgotPassword.swift
//  testui
//
//  Created by Theodora Andrea on 21/11/24.
//

import SwiftUI

struct ForgotPassword: View {
    
    @ObservedObject var viewModel: LandingViewModel
    
    var body: some View {
        ZStack {
            if viewModel.forgotPasswordSuccessful {
                Text("Email sent!")
                    .font(.title)
            } else {
                
                VStack(spacing: 20) {
                    Text("Forgot password?")
                        .font(.headline)
                        .padding(.top, 40)
                    
                    TextFieldWithUnderlineStyle(title: "Email", placeholder: "Enter your email", textBinding: $viewModel.forgotPasswordEmail, color: .black)
                    
                    Button(action: {
                        viewModel.forgotPassword()
                    }) {
                        Text("Submit")
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width / 1.25)
                    .background(.black)
                    .cornerRadius(15)
                    .padding(.top, 30)
                }
                .padding(.horizontal, 30)
            }
        }
        .foregroundColor(.black)
        .cornerRadius(40, corners: [.topLeft, .topRight])
        .frame(height: 320, alignment: .center)
        .onAppear {
            viewModel.forgotPasswordSuccessful = false
        }
    }
}

