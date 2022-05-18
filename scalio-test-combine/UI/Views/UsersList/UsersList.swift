import SwiftUI
import Combine

struct UsersList: View {
    
    @State private var usersSearch = UsersSearch()
    @State private(set) var users: Loadable<LazyList<User>>
    @State private var routingState: Routing = .init()
    @Environment(\.injected) private var injected: DIContainer
    
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: injected.appState, \.routing.usersList)
    }
    
    @State private var currentPage: Int = 1
    
    let inspection = Inspection<Self>()
    
    init(users: Loadable<LazyList<User>> = .notRequested) {
        self._users = .init(initialValue: users)
    }
    
    var bottomInset: CGFloat {
        if #available(iOS 14, *) {
            return 0
        } else {
            return usersSearch.keyboardHeight
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack{
                    VStack {
                        SearchBar(text: $usersSearch.searchText
                            .onSet { _ in
                                currentPage = 1
                            }
                        )
                        searchButtonView
                        
                        
                        switch users {
                        case let .isLoading(last, _):
                            AnyView(loadingView(last))
                        case .notRequested:
                            Text("")
                        case let .loaded(users):
                            usersView(users, showLoading: false)
                        case let .failed(error):
                            errorView(error)
                        }
                        Spacer()
                    }
                    .navigationBarTitle("Github Users")
                    .navigationBarHidden(self.usersSearch.keyboardHeight > 0)
                    
                }
                
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
        
        .onReceive(routingUpdate) { self.routingState = $0 }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
    
}

extension UsersList {
    
    var searchButtonView: some View {
        Button {
            fetchUsers()
        } label: {
            Text("Search")
                .frame(maxWidth: .infinity)
        }
        .padding()
        .buttonStyle(.borderedProminent)
        
    }
}

extension UsersList {
    struct UsersSearch {
        var searchText: String = ""
        var keyboardHeight: CGFloat = 0
    }
}

private extension UsersList {
    
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.usersList)
    }
    
    var keyboardHeightUpdate: AnyPublisher<CGFloat, Never> {
        injected.appState.updates(for: \.system.keyboardHeight)
    }
}

// MARK: - Routing

extension UsersList {
    struct Routing: Equatable {
        var userDetails: User.ID?
    }
}

// MARK: - Error View

extension UsersList {
    
    func errorView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            
        })
    }
    
    func loadingView(_ previouslyLoaded: LazyList<User>?) -> some View {
        if let users = previouslyLoaded {
            return AnyView(usersView(users, showLoading: true))
        } else {
            return AnyView(LoadingView().padding())
        }
    }
}

// MARK: - Users list view

extension UsersList {
    
    func usersView(_ users: LazyList<User>, showLoading: Bool) -> some View {
        ZStack {
            VStack {
                
                List(users) { user in
                    NavigationLink(
                        destination: self.detailsView(user: user),
                        tag: user.id,
                        selection: self.routingBinding.userDetails) {
                            UserItemView(user: user)
                        }
                    if user == users.last {
                        Text("Fetching more...")
                            .onAppear(perform: {
                                currentPage = currentPage + 1
                                fetchUsers()
                            })
                    }
                }
                .id(users.count)
            }.padding(.bottom, bottomInset)
            if showLoading {
                LoadingView().padding()
            }
        }
        
    }
    
    func detailsView(user: User) -> some View {
        Text("User")
    }
}


private extension UsersList {
    func fetchUsers() {
        injected.interactors.usersInteractor
            .fetchUsers(
                response: $users,
                query: usersSearch.searchText,
                perPage: 9, page: currentPage)
    }
}

