//
//  LoadingView.swift
//  scalio-test-combine
//
//  Created by TOxIC on 18/05/2022.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    @State private var fill: CGFloat = 1
    let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    
    var animation: Animation {
        Animation.linear(duration: 1)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 14)
                .frame(width: 100, height: 100)
            
            Circle()
                .trim(from: self.fill, to: 1)
                .stroke(Color.darkPrimaryButton, lineWidth: 7)
                .animation(Animation.linear(duration: 0.5), value: self.fill)
                .frame(width: 100, height: 100)
                .onAppear() {
                    self.isLoading = true
                    
                }
                .onReceive(timer) { input in
                    if fill >= 1 {
                        fill = 0
                    } else {
                        fill = fill + 0.1
                    }
                }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

