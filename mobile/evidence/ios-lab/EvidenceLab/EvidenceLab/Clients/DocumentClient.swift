import Combine
import Foundation

protocol DocumentClient<D> {
    associatedtype D: Identifiable, Codable
    func get(_ id: D.ID) -> AnyPublisher<D, Never>
    func getAll() -> AnyPublisher<[D], Never>
    func create(_ document: D) -> AnyPublisher<D, Never>
    func update(_ document: D) -> AnyPublisher<Void, Never>
}

extension DocumentClient {
    func eraseToAnyClient() -> AnyDocumentClient<D> {
        AnyDocumentClient(self)
    }
}

extension DocumentClient {
    static func file(_ root: String) -> AnyDocumentClient<Chat> {
        FileDocumentClient<Chat>(root: root).eraseToAnyClient()
    }
    
    static func memory(_ root: String) -> AnyDocumentClient<Chat> {
        MemoryDocumentClient<Chat>(root: root).eraseToAnyClient()
    }
}

struct AnyDocumentClient<D>: DocumentClient where D: Identifiable, D: Codable {
    private let _get: (D.ID) -> AnyPublisher<D, Never>
    private let _getAll: () -> AnyPublisher<[D], Never>
    private let _create: (D) -> AnyPublisher<D, Never>
    private let _update: (D) -> AnyPublisher<Void, Never>
    
    init<Client: DocumentClient<D>>(_ source: Client) {
        self._get = { source.get($0) }
        self._getAll = { source.getAll() }
        self._create = { source.create($0) }
        self._update = { source.update($0) }
    }
    
    func get(_ id: D.ID) -> AnyPublisher<D, Never> {
        _get(id)
    }
    
    func getAll() -> AnyPublisher<[D], Never> {
        _getAll()
    }
    
    func create(_ document: D) -> AnyPublisher<D, Never> {
        _create(document)
    }
    
    func update(_ document: D) -> AnyPublisher<Void, Never> {
        _update(document)
    }
}

class MemoryDocumentClient<D>: DocumentClient where D: Identifiable, D: Codable {
    private let root: String
    private var storage: [D.ID: D] = [:]
    
    init(root: String) {
        self.root = root
    }
    
    func get(_ id: D.ID) -> AnyPublisher<D, Never> {
        Just(storage[id]!).eraseToAnyPublisher()
    }
    
    func getAll() -> AnyPublisher<[D], Never> {
        Just(storage.values.compactMap { $0 }).eraseToAnyPublisher()
    }
    
    func create(_ document: D) -> AnyPublisher<D, Never> {
        storage[document.id] = document
        return Just(document).eraseToAnyPublisher()
    }
    
    func update(_ document: D) -> AnyPublisher<Void, Never> {
        storage[document.id] = document
        return Just(()).eraseToAnyPublisher()
    }
    
    
}

struct FileDocumentClient<D>: DocumentClient where D: Identifiable, D: Codable {
    private let root: String
    
    init(root: String) {
        self.root = root
    }
    
    func get(_ id: D.ID) -> AnyPublisher<D, Never> {
        let url = URL.documentsDirectory.appending(path: "\(root)/\(id).json")
        
        do {
            let data = try Data(contentsOf: url)
            let document = try JSONDecoder().decode(D.self, from: data)
            return Just(document).eraseToAnyPublisher()
        } catch {
            fatalError("error trying to get data with id: \(id)")
        }
    }
    
    func getAll() -> AnyPublisher<[D], Never> {
        let filemanager = FileManager.default
        let directory = URL.documentsDirectory.appending(path: root)
        
        do {
            let files = try filemanager
                .contentsOfDirectory(atPath: directory.path(percentEncoded: true))
                .filter { !$0.starts(with: ".") }
            
            var documents = [D]()
            for file in files {
                let url = directory.appending(path: file)
                let data = try Data(contentsOf: url)
                let document = try JSONDecoder().decode(D.self, from: data)
                documents.append(document)
            }
            return Just(documents).eraseToAnyPublisher()
        } catch {
            return Just([]).eraseToAnyPublisher()
        }
    }
    
    func create(_ document: D) -> AnyPublisher<D, Never> {
        let filemanager = FileManager.default
        let directory = URL.documentsDirectory.appending(path: root)
        let url = directory.appending(path: "\(document.id).json")
        
        do {
            try filemanager.createDirectory(at: directory, withIntermediateDirectories: true)
            let data = try JSONEncoder().encode(document)
            try data.write(to: url)
            return Just(document).eraseToAnyPublisher()
        } catch {
            return Just(document).eraseToAnyPublisher()
        }
    }
    
    func update(_ document: D) -> AnyPublisher<Void, Never> {
        let url = URL.documentsDirectory.appending(path: "\(root)/\(document.id).json")
        do {
            let updatedData = try JSONEncoder().encode(document)
            try updatedData.write(to: url)
        } catch {
            return Just(()).eraseToAnyPublisher()
        }
        return Just(()).eraseToAnyPublisher()
    }
}
