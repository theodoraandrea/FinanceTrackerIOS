//
//  SignUp.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 13/11/24.
//

import SwiftUI

struct SignUp: View {
        
    @ObservedObject var vm: SignUpViewModel
    
    @Binding var path: NavigationPath
    
    @State var passwordError: Bool = true
    @State var emailValid: Bool = true
    @State var showPassword: Bool = false
    @State var showConfirmPassword: Bool = false
        
    var body: some View {
            ScrollView {
                Text("Sign up")
                    .font(.title)
                    .padding(30)
                
                VStack(spacing: 25) {
                    
                    VStack (alignment: .leading) {
                        TextFieldWithUnderlineStyle(title: "Email", textBinding: $vm.email)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .textContentType(.emailAddress)
                            .onChange(of: vm.email) {
                                if (isValidEmail(email: vm.email)) {
                                    emailValid = true
                                } else {
                                    emailValid = false
                                }
                            }
                        
                        if(!emailValid) {
                            Text("Please enter a valid email address.")
                                .font(.caption)
                                .foregroundStyle(Color.black.opacity(0.4))
                        }
                    }

                    TextFieldWithUnderlineStyle(title: "Name", textBinding: $vm.fullname)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                        .textContentType(.name)
                    
                    TextFieldWithUnderlineStyle(title: "Username", textBinding: $vm.username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .textContentType(.username)
                    
                    VStack {
                        Text("Balance")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.black)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        
                        HStack {
                            Text("IDR")
                            TextField("", text: $vm.balanceString)
                                .keyboardType(.numberPad)
                                .onKeyPress(keys: [.delete]) { key in
                                    if (vm.balanceString.count > 0) {
                                        vm.balanceString.removeLast()
                                    }
                                    let formatted = formatBalance(value: vm.balanceString)
                                    vm.balanceString = formatted

                                    return .handled
                                }
                                .onKeyPress(characters: .decimalDigits) { key in
                                    vm.balanceString.append(key.key.character)
                                    let formatted = formatBalance(value: vm.balanceString)
                                    vm.balanceString = formatted
                                    
                                    return .handled
                                }
                        }
                        
                        Divider()
                    }
                    
                    VStack (spacing: 10) {
                        HStack {
                            Text("Password")
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            Text("*")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }

                        
                        ZStack (alignment: .leading){
                            TextField("", text: $vm.password)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .opacity(showPassword ? 1 : 0)
                            
                            SecureField("", text: $vm.password)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
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
                        Text("Password must contain at least 8 characters, 1 uppercase letter, and 1 special character")
                            .font(.caption)
                            .foregroundStyle(Color.black.opacity(0.4))
                    }
                    
                    VStack (spacing: 10) {
                        HStack {
                            Text("Confirm password")
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            Text("*")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }

                        
                        ZStack (alignment: .leading){
                            TextField("", text: $vm.confPassword)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .opacity(showConfirmPassword ? 1 : 0)
                            
                            SecureField("", text: $vm.confPassword)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .opacity(showConfirmPassword ? 0 : 1)
                        }
                        .overlay(alignment: .trailing) {
                            Image(systemName: showConfirmPassword ? "eye.fill" : "eye.slash.fill")
                                .padding(16)
                                .foregroundStyle(showConfirmPassword ? .primary : .secondary)
                                .onTapGesture {
                                    showConfirmPassword.toggle()
                                }
                        }
                        Divider()
                    }

                    Button(action: {
                        vm.signup { success in
                            if success {
                                print("Signup succeeded")
                                path.removeLast()
                                
                            } else {
                                print("Signup failed")
                                //path.removeLast()

                            }
                        }
                       
                    }) {
                        Text("Submit")
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width / 1.25)
                    .background(.black)
                    .cornerRadius(15)
                    
                }
                .padding(.horizontal, 30)
            }
    }
}


