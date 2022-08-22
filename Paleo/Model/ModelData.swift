//
//  ModelData.swift
//  Paleo
//
//  Created by Joseph Zhu on 19/4/2022.
//

import Foundation

final class ModelData: ObservableObject {
    @Published var records: [Record] = []
    
    func getRecords() {
//        https://search.idigbio.org/v2/search/records/?rq=%7B%22kingdom%22%3A%22animalia%22%2C%22hasImage%22%3Atrue%2C%22geopoint%22%3A%7B%22type%22%3A%22exists%22%7D%2C%22mediarecords%22%3A%7B%22type%22%3A%22exists%22%7D%2C%22locality%22%3A%7B%22type%22%3A%22exists%22%7D%2C%22datecollected%22%3A%7B%22type%22%3A%22exists%22%7D%2C%22continent%22%3A%7B%22type%22%3A%22exists%22%7D%7D
//        https://search.idigbio.org/v2/search/records/?rq=%7B%22scientificname%22%3A+%22puma+concolor%22%7D&limit=5
//        https://search.idigbio.org/v2/view/records/1db58713-1c7f-4838-802d-be784e444c4a
//        https://jsonplaceholder.typicode.com/users
        guard let url = URL(string: "https://search.idigbio.org/v2/search/records/?rq=%7B%22kingdom%22%3A%22animalia%22%2C%22hasImage%22%3Atrue%2C%22geopoint%22%3A%7B%22type%22%3A%22exists%22%7D%2C%22mediarecords%22%3A%7B%22type%22%3A%22exists%22%7D%2C%22locality%22%3A%7B%22type%22%3A%22exists%22%7D%2C%22datecollected%22%3A%7B%22type%22%3A%22exists%22%7D%2C%22continent%22%3A%7B%22type%22%3A%22exists%22%7D%7D")
        else {
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse
            else {
                print("HTTPURLResponse error")
                return
            }
            
            if response.statusCode == 200 {
                guard let data = data
                else {
                    print("Response Error")
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode(RecordResponse.self, from: data)
                        self.records = decoded.items
                        
                        var count = 0
                        for record in self.records {
                            print("\(record.indexTerms.geopoint)")
                            count+=1
                            print(count)
                        }
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    
}

