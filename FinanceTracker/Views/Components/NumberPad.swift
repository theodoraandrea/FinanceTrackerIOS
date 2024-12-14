//
//  NumberPad.swift
//  testui
//
//  Created by Theodora Andrea on 25/11/24.
//

import SwiftUI

struct NumberPad: View {
    
    @Binding var amount:String
    @Binding var showKeypad:Bool
    
    @State var hGap:CGFloat = 20
    @State var vGap:CGFloat = 15
    
    var body: some View {
        VStack (spacing:vGap){
            HStack (spacing: hGap){
                NumberButton(character: "1", textColor: .black, size: 85, fontSize: 40, bgColor: .white, strokeColor: .black, amount: $amount)
                NumberButton(character: "2", textColor: .black, size: 85, fontSize: 40, bgColor: .white, strokeColor: .black, amount: $amount)
                NumberButton(character: "3", textColor: .black, size: 85, fontSize: 40, bgColor: .white, strokeColor: .black, amount: $amount)
            }
            
            HStack (spacing: hGap){
                NumberButton(character: "4", textColor: .black, size: 85, fontSize: 40, bgColor: .white, strokeColor: .black, amount: $amount)
                NumberButton(character: "5", textColor: .black, size: 85, fontSize: 40, bgColor: .white, strokeColor: .black, amount: $amount)
                NumberButton(character: "6", textColor: .black, size: 85, fontSize: 40, bgColor: .white, strokeColor: .black, amount: $amount)
            }

            HStack (spacing: hGap){
                NumberButton(character: "7", textColor: .black, size: 85, fontSize: 40, bgColor: .white, strokeColor: .black, amount: $amount)
                NumberButton(character: "8", textColor: .black, size: 85, fontSize: 40, bgColor: .white, strokeColor: .black, amount: $amount)
                NumberButton(character: "9", textColor: .black, size: 85, fontSize: 40, bgColor: .white, strokeColor: .black, amount: $amount)
            }
            
            HStack (spacing: vGap){
                Image(systemName: "delete.left")
                    .font(.system(size: 70))
                    .fontWeight(.ultraLight)
                    .onTapGesture {
                        if (amount.isEmpty) {
                            return
                        } else {
                            amount.removeLast()
                        }
                    }

                NumberButton(character: "0", textColor: .black, size: 85, fontSize: 40, bgColor: .white, strokeColor: .black, amount: $amount)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 70))
                    .fontWeight(.ultraLight)
                    .onTapGesture {
                        showKeypad.toggle()
                    }
            }
        }    }
}

struct Test: View {
    
    @State var amount = "0"
    @State var showKeypad = false
    var body: some View {
        NumberPad(amount: $amount, showKeypad: $showKeypad)

    }
}
#Preview {
    Test()
}
