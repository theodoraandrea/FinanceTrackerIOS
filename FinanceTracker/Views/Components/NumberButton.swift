//
//  NumberButton.swift
//  testui
//
//  Created by Theodora Andrea on 25/11/24.
//

import SwiftUI


struct NumberButton: View {
    @State var character:String
    @State var textColor:Color  = .white
    @State var size:CGFloat = 50
    @State var fontSize:CGFloat = 25
    @State var bgColor:Color = .accentColor
    @State var strokeColor:Color = .accentColor
    
    @State var isTapped:Bool = false
    
    @Binding var amount:String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isTapped ? .gray : bgColor)
                .stroke(strokeColor)
                .frame(width: size, height: size)
            Text(character)
                .foregroundStyle(textColor)
                .font(.system(size: fontSize))
        }
        .onTapGesture {
            
            withAnimation(.easeInOut(duration: 0.2)) {
                isTapped = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isTapped = false
                }
            }
            
            if (amount.count > 10) {
                return
            }
            
            if (amount == "0") {
                amount = ""
            }
            
            amount.append(character)

        }
    }
}


