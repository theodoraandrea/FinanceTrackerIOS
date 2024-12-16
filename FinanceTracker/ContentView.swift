//
//  ContentView.swift
//  FinanceTracker
//
//  Created by Theodora Andrea on 12/11/24.
//

import SwiftUI

enum AppRoutes: Hashable {
    case home
    case signup
    case landing
}

struct ContentView: View {
    @State private var path = NavigationPath()
    
    @EnvironmentObject var landingViewModel: LandingViewModel

    //@StateObject private var transactionViewModel = TransactionViewModel()
    
    var body: some View {
        if landingViewModel.isAuthenticated {
            Home(viewModel: HomeViewModel(), landingVM: landingViewModel, path: $path)
         } else {
             Landing(viewModel: landingViewModel, path: $path)
         }
    }
}

extension View {
    func cornerRadius(_ radius:CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius:radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
        byRoundingCorners: corners,
                                cornerRadii: CGSize(width:radius, height: radius))
        
        return Path(path.cgPath)
    }
}

struct signAccount: View {
    var image:ImageResource
    var width:CGFloat
    var height:CGFloat
    var action: () -> Void
    
    var body: some View {
        Button(action: {}, label: {
            Image(image).renderingMode(.template)
                .resizable().scaledToFill()
                .frame(width: width, height: height)
                .overlay {
                    RoundedRectangle(cornerRadius: 30).stroke(lineWidth: 1.5)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.gray.opacity(0.3))
                }
        })
        .tint(.primary)
    }
}


#Preview {
    ContentView()
}
