//
//  UsersList.swift
//  scalio-test-combine
//
//  Created by TOxIC on 17/05/2022.
//

import SwiftUI
import Combine

struct UsersList: View {
    
    @State private var usersSearch = UsersSearch()
    @State private(set) var users: Loadable<LazyList<User>>
    @State private var routingState: Routing = .init()
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: injected.appState, \.routing.usersList)
    }
    @Environment(\.injected) private var injected: DIContainer
    
    
    let inspection = Inspection<Self>()
    
    init(users: Loadable<LazyList<User>> = .notRequested) {
        self._users = .init(initialValue: users)
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                self.content
                    
                    .navigationBarTitle("Github Users")
                    .navigationBarHidden(self.usersSearch.keyboardHeight > 0)
                    .animation(.easeOut(duration: 0.3))
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
        .onReceive(keyboardHeightUpdate) { self.usersSearch.keyboardHeight = $0 }
        .onReceive(routingUpdate) { self.routingState = $0 }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
    
    private var content: AnyView {
        switch users {
        case .notRequested: return AnyView(notRequestedView)
        case let .isLoading(last, _): return AnyView(loadingView(last))
        case let .loaded(users): return AnyView(loadedView(users, showSearch: true, showLoading: false))
        case let .failed(error): return AnyView(failedView(error))
        }
    }
}



// MARK: - Side Effects

private extension UsersList {
    func reloadUsers() {
        
        injected.interactors.usersInteractor
            .fetchUsers(response: $users, query: usersSearch.searchText, perPage: 9, page: 1)
            
    }
}

// MARK: - Loading Content

private extension UsersList {
    var notRequestedView: some View {
        Text("").onAppear(perform: reloadUsers)
    }
    
    func loadingView(_ previouslyLoaded: LazyList<User>?) -> some View {
        if let users = previouslyLoaded {
            return AnyView(loadedView(users, showSearch: true, showLoading: true))
        } else {
            return AnyView(LoadingView().padding())
        }
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            self.reloadUsers()
        })
    }
}

// MARK: - Displaying Content

private extension UsersList {
    func loadedView(_ users: LazyList<User>, showSearch: Bool, showLoading: Bool) -> some View {
        VStack {
            if showSearch {
                SearchBar(text: $usersSearch.searchText
                    .onSet { _ in
                        self.reloadUsers()
                    }
                )
            }
            if showLoading {
                LoadingView().padding()
            }
            List(users) { user in
                NavigationLink(
                    destination: self.detailsView(user: user),
                    tag: user.id,
                    selection: self.routingBinding.userDetails) {
                        UserItemView(user: user)
                    }
            }
            .id(users.count)
        }.padding(.bottom, bottomInset)
    }
    
    func detailsView(user: User) -> some View {
        Text("User")
    }
    
    var bottomInset: CGFloat {
        if #available(iOS 14, *) {
            return 0
        } else {
            return usersSearch.keyboardHeight
        }
    }
}

// MARK: - Search State

extension UsersList {
    struct UsersSearch {
        var searchText: String = ""
        var keyboardHeight: CGFloat = 0
    }
}

// MARK: - Routing

extension UsersList {
    struct Routing: Equatable {
        var userDetails: User.ID?
    }
}

// MARK: - State Updates

private extension UsersList {
    
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.usersList)
    }
    
    var keyboardHeightUpdate: AnyPublisher<CGFloat, Never> {
        injected.appState.updates(for: \.system.keyboardHeight)
    }
}

#if DEBUG
struct UsersList_Previews: PreviewProvider {
    static var previews: some View {
        UsersList(users: .loaded(User.mockedData.lazyList))
            .inject(.preview)
    }
}
#endif

