//
//  TravelAPI.swift
//  MurmanskTrips
//
//  Created by Maxim Kuznetsov on 21.11.2020.
//

import Alamofire

class TravelAPI {
    static let url = "https://murmansk.travel/api/trips"
    
    static func loadData(completion: @escaping (Result<Trips, AFError>) -> Void) {
        AF.request(url)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: Trips.self) { response in
                DispatchQueue.main.async {
                    completion(response.result)
                }
            }
    }
    
    static func downloadImage(from urlPath: String, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        
        guard let url = URL(string: urlPath) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(nil, error)
            } else if let data = data, let image = UIImage(data: data) {
                completion(image, nil)
            } else {
                completion(nil, CFNetworkErrors.cfErrorHTTPParseFailure as? Error)
            }
        }.resume()
    }
    
}
