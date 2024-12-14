//
//  TextField.swift
//  testui
//
//  Created by Theodora Andrea on 20/11/24.
//

import SwiftUI

struct TextFieldWithUnderlineStyle: View {
    var title: String
    var placeholder: String = ""
    var textBinding: Binding<String> = .constant("")
    var required:Bool = true
    var color: Color = .black
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(color)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if (required) {
                    Spacer()
                    Text("*")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.red)
                }
            }

            TextField(placeholder, text: textBinding)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            
            Divider()
        }
    }
}

