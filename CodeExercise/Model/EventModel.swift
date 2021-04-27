//
//  EventModel.swift
//  CodeExercise
//
//  Created by Hart on 4/25/21.
//

import Foundation


struct EventModel {
    var title:String
    var location:String
    var time: Date
    var ticketUrl:String
    
    mutating func getEvent(of_index i:Int,eventsResponse:EventsResponse) {
        let event=eventsResponse.events[i]
        self.title=event.short_title;
        self.location=event.venue.display_location
//        self.time=event.datetime_local
        self.ticketUrl=event.url
    }
    
}
