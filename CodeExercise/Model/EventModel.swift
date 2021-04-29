//
//  EventModel.swift
//  CodeExercise
//
//  Created by Hart on 4/25/21.
//

import Foundation


struct EventsModel {
    var events:[event]
//    var favorites:[Int]
    
    
    
    init(events_response: [eventJson]) {
        events=events_response.map({ (eventJson) -> event in
            let dateString = eventJson.datetime_local
            let dateFormatter=DateFormatter()
            dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss"
            let date=dateFormatter.date(from: dateString)
            return event(title: eventJson.short_title, location: eventJson.venue.display_location, time: date!, ticketUrl: eventJson.url, id: eventJson.id,imageUrl: eventJson.performers[0].image)
        })
    }
//    mutating func getEvent(of_index i:Int,eventsResponse:EventsResponse) {
//        let event=eventsResponse.events[i]
//        self.title=event.short_title;
//        self.location=event.venue.display_location
////        self.time=event.datetime_local
//        self.ticketUrl=event.url
//    }
    
}

struct event {
    let title:String
    let location:String
    let time: Date
    let ticketUrl:String
    let id:Int
    let imageUrl:String
}
