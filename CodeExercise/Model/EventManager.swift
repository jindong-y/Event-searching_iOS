//
//  EventManager.swift
//  CodeExercise
//
//  Created by Hart on 4/25/21.
//

import Foundation

protocol EventManagerDelegete {
    func didUpdate(eventManager: EventManager, events:[event])
    func didUpdate(_ events:[event])
    func didFailUpdate(error: Error)
}



struct EventManager {
    let baseUrl = K.eventBaseURL
    var query:String?
    var page: Int?
    
//    var response: EventsResponse?
    
    var delegate: EventManagerDelegete?
    
    
    func fetchEvents(query:String,page:Int) -> Void {
        sendRequest(urlString: "\(baseUrl)&q=\(query)&page=\(page)")
    }
    
    
    func sendRequest(urlString: String)  {
        if let url = URL(string: urlString){
            //create urlSession
            let session = URLSession(configuration: .default)
            //creat a task
            let task=session.dataTask(with: url, completionHandler: handler(data:response:error:))
            task.resume()
        }
        
    }
    
    func handler(data:Data?, response:URLResponse?, error:Error?) -> Void {
        if error != nil{
            print(error!)
            return;
        }
        if let safeData=data{
            if let response = parseJSON(data: safeData){
                delegate?.didUpdate( response.events)
            }
        }
        
        
    }
    
    func parseJSON(data: Data)-> EventsResponse?  {
        let decoder=JSONDecoder()
        do{
            let decodedData = try decoder.decode(EventsResponse.self, from: data)
            return decodedData
        }catch{
            print(error)
            delegate?.didFailUpdate(error: error)
            return nil
        }
        
    }
}


