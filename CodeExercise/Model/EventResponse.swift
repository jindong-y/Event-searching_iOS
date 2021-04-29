//
//  EventResponse.swift
//  CodeExercise
//
//  Created by Hart on 4/26/21.
//

import Foundation

struct EventsResponse: Codable {
    let events: [eventJson]
}

struct eventJson: Codable {
    let id:Int
    let short_title: String
    let venue: venueJson
    let datetime_local:String
    let url: String
    let performers:[performersJson]
}

struct venueJson: Codable {
    let display_location: String
}

struct performersJson: Codable {
    let image:String
}
