import Foundation

final public class NetworkManager {
    static public let shared = NetworkManager()
    
    public init() {}
    
    public func fetchDecodableData<T: Decodable>(from url: URL, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
           let session = URLSession(configuration: .default)
           session.dataTask(with: url) { data, response, error in
               DispatchQueue.main.async {
                   if let error = error {
                       completion(.failure(error))
                       return
                   }
                   
                   guard let data = data else {
                    completion(.failure(error as! Error))
                       return
                   }
                   
                   do {
                       let decodedData = try JSONDecoder().decode(T.self, from: data)
                       completion(.success(decodedData))
                   } catch {
                       completion(.failure(error))
                   }
               }
           }.resume()
       }
   }
