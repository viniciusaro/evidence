@testable import EvidenceLab

import ComposableArchitecture
import SwiftUI
import XCTest

/*:
 Reference:
 https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/gettingstarted
 
 ### State
 Estrutura que guarda dados que serão utilizados posteriormente pela view para renderizar
 as informações necessárias para a feature.
*/
@ObservableState
struct ChatListState {
    var chats: [Chat] = []
    var chatDetail: ChatDetailState? = nil
    // var alertState: AlertState?
}

/*:
 ### Action
 Representação de todas as ações que o usuário ou o sistema podem realizar para modificar o estado
 */
enum ChatListAction {
    case onChatItemTapped(Chat)
}

/*:
 ### Store
 "Cérebro" da arquitetura. Responsável por receber Actions, executar Reducers e permitir acesso ao estado atual
 */
struct ChatListView: View {
    let store: Store<ChatListState, ChatListAction>
    
    var body: some View {
        List(store.state.chats) { chat in
            Button {
                store.send(.onChatItemTapped(chat))
            } label: {
                Text(chat.name)
            }
        }
    }
}

/*:
 ### Reducer
 Função que define como o estado deve mudar, dado o estado atual e uma Action
 */
func chatListReducer(_ state: inout ChatListState, _ action: ChatListAction) -> Void {
    switch action {
    case let .onChatItemTapped(chat):
        state.chatDetail = ChatDetailState(chat: chat)
    }
}

/*:
 view -> store -> reducer -> change state
 */

final class EvidenceLabTests: XCTestCase {
    @Observable
    class Store<State, Action> /*: ObservableObject*/ {
        private(set) var state: State
        private let reducer: (inout State, Action) -> Void
        
        init(initialState: State, reducer: @escaping (inout State, Action) -> Void) {
            self.state = initialState
            self.reducer = reducer
        }
        
        func send(_ action: Action) {
            self.reducer(&self.state, action)
        }
    }
    
    func testReduce() throws {
        let store = Store(
            initialState: ChatListState(),
            reducer: chatListReducer
        )
        XCTAssertEqual(store.state.chatDetail, nil)
        let chat = Chat.empty()
        store.send(.onChatItemTapped(chat))
        XCTAssertEqual(store.state.chatDetail, ChatDetailState(chat: chat))
    }
}

/*:
 ###: Exercício
 
 Construir um app inteiro com apenas um grande state chamado AppState e um grande
 reducer, appReducer que saiba resolver todas as actions possíveis na aplicação
 */
@ObservableState
struct AppState {
    var chatList: ChatListState
    var profileState: ProfileState
    var loginState: LoginState?
}

enum AppAction {
    case chatList(ChatListAction)
    case profile(ProfileAction)
    case login(LoginAction)
}

struct ChatListView_: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        List(store.state.chatList.chats) { chat in
            Button {
                store.send(.chatList(.onChatItemTapped(chat)))
            } label: {
                Text(chat.name)
            }
        }
    }
}

struct ProfileView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        Button {
            store.send(.profile(.action))
        } label: {
            Text(store.state.profileState.currentUser.name)
        }
    }
}

struct LoginView {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        Button {
            store.send(.login(.onUserLoggedIn(User())))
        } label: {
            Text(store.state.loginState?.currentUser.name ?? "")
        }
    }
}

func appReducer(_ state: inout AppState, _ action: AppAction) {
    switch action {
    case .chatList(.onChatItemTapped):
        break // ...
    case .profile(.action):
        break // ...
    case let .login(.onUserLoggedIn(user)):
        state.profileState.currentUser = user
    }
}

/*:
 ### High order Functions
 
 Funções que recebem funções como input e retornam funções como output
 */
func somaUm(_ a: Int) -> Int {
    a + 1
}

func multiplicaDois(_ a: Int) -> Int {
    a * 2
}

let operation = somaUm
let operation_ = multiplicaDois

func debugOperation<Input, Output>(
    _ operation: @escaping (Input) -> Output
) -> (Input) -> Output {
    return { input in
        print("---------")
        print("received \(input) (\(type(of: input)))")
        let output = operation(input)
        print("result: \(output) (\(type(of: output)))")
        print("---------")
        return output
    }
}

extension EvidenceLabTests {
    func testSomaFunc() throws {
        XCTAssertEqual(somaUm(1), 2)
    }
    
    func testDebugHighOrderFunc() throws {
        XCTAssertEqual(debugOperation(somaUm)(1), 2)
    }
}

/*:
 Outro exemplo: combine
 */
func mapOperation<Input, Output, MappedOutput>(
    _ operation: @escaping (Input) -> Output,
    transformOuput transform: @escaping (Output) -> MappedOutput
) -> (Input) -> MappedOutput {
    return { input in
        let result = operation(input)
        return transform(result)
    }
}

extension EvidenceLabTests {
    func testMapOperationHighOrderFunc() throws {
        let somaUmETransformaEmString = mapOperation(somaUm, transformOuput: { result in result.description })
        XCTAssertEqual(somaUmETransformaEmString(1), "2")
    }
}

/*:
 Outro exemplo: combine
 */
func combineOperations<Input, Result>(
    _ initialOperation: @escaping (Input) -> Result,
    _ operations: (Result) -> Result...
) -> (Input) -> Result {
    return { initialInput in
        var result = initialOperation(initialInput)
        for operation in operations {
            result = operation(result)
        }
        return result
    }
}

extension EvidenceLabTests {
    func testCombineSomaMultiplicacao() throws {
        let operation = combineOperations(somaUm, multiplicaDois)
        XCTAssertEqual(operation(1), 4)
    }
    
    func testCombineWithDebug() throws {
        let operation = combineOperations(
            debugOperation(somaUm),
            debugOperation(multiplicaDois)
        )
        XCTAssertEqual(operation(1), 4)
    }
    
    func testCombineWithMap() throws {
        let operation = combineOperations(
            mapOperation(somaUm, transformOuput: { $0.description }),
            { "Vini " + $0 }
        )
        XCTAssertEqual(operation(9), "Vini 10")
    }
    
    func testCombineWithMapAndDebug() throws {
        let operation = combineOperations(
            debugOperation(mapOperation(somaUm, transformOuput: { $0.description })),
            debugOperation({ "Vini " + $0 })
        )
        XCTAssertEqual(operation(9), "Vini 10")
    }
}

/*:
 ### High order Reducers
 
 Da mesma forma que "High order functions" são funções que recebem funções como input
 e retornam funções como output, um high order reducer é um reducer que
 recebe outro reducer como input e retorna um reducer como output:
 */
typealias Reducer<State, Action> = (inout State, Action) -> Void

func debug<State, Action>(_ reducer: @escaping Reducer<State, Action>) -> Reducer<State, Action> {
    { state, action in
        print("action received:")
        customDump(action)
        reducer(&state, action)
        print("state updated:")
        customDump(state)
    }
}

extension EvidenceLabTests {
    func testDebug() throws {
        var state = ChatListState()
        let reducer = debug(chatListReducer)
        reducer(&state, .onChatItemTapped(Chat.empty()))
    }
}

/*:
 Scope: transforma um reducer que sabe trabalhar em determinados State e Action
 em um reducer que sabe trabalhar em State e Actions do pai
 */
func scope<GlobalState, LocalState, GlobalAction, LocalAction>(
    state: @escaping (GlobalState) -> LocalState,
    action: @escaping (GlobalAction) -> LocalAction?,
    reducer: @escaping Reducer<LocalState, LocalAction>
) -> Reducer<GlobalState, GlobalAction> {
    return { globalState, globalAction in
        if let localAction = action(globalAction) {
            var localState = state(globalState)
            reducer(&localState, localAction)
        }
    }
}

let appReducer = scope(
    state: { (state: AppState) in
        state.chatList
    },
    action: { (action: AppAction) in
        if case let .chatList(chatListAction) = action {
            return chatListAction
        }
        return nil
    },
    reducer: chatListReducer
)

















struct ChatDetailState: Equatable {
    var chat: Chat
}

enum ChatDetailAction {
    
}

struct ProfileState {
    var currentUser: User
}

enum ProfileAction {
    case action
}

struct LoginState {
    var currentUser: User
}

enum LoginAction {
    case onUserLoggedIn(User)
}
