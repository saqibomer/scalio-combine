//
//  UserItemView.swift
//  scalio-test-combine
//
//  Created by TOxIC on 18/05/2022.
//

import SwiftUI

struct UserItemView: View {
    
    let user: User
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(user.login)
                .font(.title)
            Text(user.profileUrl)
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
    }
}

#if DEBUG
struct UserItemView_Previews: PreviewProvider {
    static var previews: some View {
        UserItemView(user: User.mockedData[0])
            .previewLayout(.fixed(width: 375, height: 60))
    }
}
#endif
