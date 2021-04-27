//
//  EventResponse.swift
//  CodeExercise
//
//  Created by Hart on 4/26/21.
//

import Foundation

struct EventsResponse: Codable {
    let events: [event]
}

struct event: Codable {
    let short_title: String
    let venue: venue
    let datetime_local:String
    let url: String
    let performers:[performers]
}

struct venue: Codable {
    let display_location: String
}

struct performers: Codable {
    let image:String
}
