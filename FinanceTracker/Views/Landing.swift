//
//  Landing.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 13/11/24.
//

import SwiftUI
//import SafariServices
import SafariView

struct Landing: View {
        
    @ObservedObject var viewModel: LandingViewModel
    @Binding var path: NavigationPath
    
    @State var showPassword = false
    @State var showForgotPassword: Bool = false
    
    @State private var oauthURL: URL?
    @State private var showSafariView = false
        
    var body: some View {
        NavigationStack (path: $path){
            ZStack {
                Color(.accent)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Welcome")
                        .foregroundColor(.white)
                        .font(.system(size: 60))
                        .fontWeight(.light)
                        .padding(.top, 140)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                  
                    SignInBody {
                        VStack {
                            TextFieldWithUnderlineStyle(title: "Email or username", placeholder: "Enter your email or username", 
                                                        textBinding: $viewModel.emailOrUsername, required: false)
                            
                            VStack {
                                Text("Password")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ZStack {
                                    TextField("Enter your password", text: $viewModel.password)
                                        .opacity(showPassword ? 1 : 0)
                                    
                                    SecureField("Enter your password", text: $viewModel.password)
                                        .opacity(showPassword ? 0 : 1)
                                }
                                .overlay(alignment: .trailing) {
                                    Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                        .padding(16)
                                        .foregroundStyle(showPassword ? .primary : .secondary)
                                        .onTapGesture {
                                            showPassword.toggle()
                                        }
                                }
                                
                                Divider()
                                
                                Text(viewModel.errorMessage)
                                    .foregroundStyle(.red)
                                    .font(.caption)
                                
                            }.padding(.top, 20)
                            
                            
                            Button(action: {
                                viewModel.login()
                            }) {
                                Text("Sign in")
                                    .foregroundColor(.white)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width / 1.25)
                            .background(.black)
                            .cornerRadius(15)
                            .padding(.top, 30)
                            
                            
                            HStack {
                                Spacer()
                                Button("Forgot password?") {
                                    showForgotPassword.toggle()
                                }.sheet(isPresented: $showForgotPassword) {
                                    ForgotPassword(viewModel: viewModel)
                                        .presentationCornerRadius(40)
                                        .presentationDetents([.height(260)])
                                        .presentationBackground(.white)
                                        .presentationDragIndicator(.visible)
                                }
                                
                            }.padding(.top, 10)
                                .padding(.horizontal, 10)
                            
                            
                            HStack {
                                Rectangle()
                                    .frame(height: 1.5)
                                    .foregroundStyle(.gray.opacity(0.3))
                                Text("or")
                                Rectangle()
                                    .frame(height: 1.5)
                                    .foregroundStyle(.gray.opacity(0.3))
                            }
                            
                            Button(action: {
                                viewModel.initiateOauth()
                                //viewModel.googleSignIn()
                            }) {
                                
                                Image(.google).renderingMode(.template)
                                    .resizable().scaledToFill()
                                    .frame(width: 32, height: 32)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 30).stroke(lineWidth: 1.5)
                                            .frame(width: 50, height: 50)
                                            .foregroundStyle(.gray.opacity(0.3))
                                    }
                                    .padding(.vertical, 30)
                                    .tint(.black)
                            }
                            .onReceive(NotificationCenter.default.publisher(for: .openOAuthURL)) { notification in
                                if let url = notification.object as? URL {
                                    self.oauthURL = url
                                    self.showSafariView = true
                                }
                            }
                            .sheet(isPresented: $showSafariView) {
                                    SafariView(url: URL(string: "https://finance-tracking-app-api-service-743940785467.asia-southeast2.run.app/user/google")!)
                            }

                            
                        }.padding(.horizontal, 30)
                            .padding(.top, 60)
                        
                        HStack {
                            Text("Don't have an account?")
                            NavigationLink (value: AppRoutes.signup) {
                                    Text("Sign up")
                            }
                        }
                        
                        if showForgotPassword {
                            ForgotPassword(viewModel: viewModel)
                        }
                    }
                }
                .navigationDestination(for: AppRoutes.self) {
                    route in
                    if route == .signup {
                        SignUp(vm: SignUpViewModel(), path: $path)
                    }
                }
            }
        }
       
        
    }
    
    struct SignInBody<Content: View>: View {
        let content: Content
        
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    content
                }
                .frame(height: UIScreen.main.bounds.height / 1.2)
                .background(Color.white)
                .cornerRadius(35, corners: [.topLeft, .topRight])
            }
        }
    }
}



