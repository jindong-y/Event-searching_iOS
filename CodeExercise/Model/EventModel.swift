//
//  EventModel.swift
//  CodeExercise
//
//  Created by Hart on 4/25/21.
//

import Foundation

//MARK: A model for event array
struct EventsModel {
    var events:[event]
    
    //initialize using eventJson
    init(events_response: [eventJson]) {
        events=events_response.map({ (eventJson) -> event in
            let dateString = eventJson.datetime_local
            let dateFormatter=DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") //Avoid issues with the device's local settings
            dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss"
            let date=dateFormatter.date(from: dateString)
            return event(title: eventJson.short_title, location: eventJson.venue.display_location, time: date!, ticketUrl: eventJson.url, id: eventJson.id,imageUrl: eventJson.performers[0].image)
        })
    }
    
}

struct event {
    let title:String
    let location:String
    let time: Date
    let ticketUrl:String
    let id:Int
    let imageUrl:String
}
