//
//  Result.swift
//  teamvoy
//
//  Created by Alessandro Marconi on 13/11/2019.
//  Copyright © 2019 OleksandrZheliezniak. All rights reserved.
//

import UIKit

class Result: Decodable{

    var sunrise: String?
    var sunset: String?
    var solar_noon: String?
    var day_length: String?
    var civil_twilight_begin: String?
    var civil_twilight_end: String?
    var nautical_twilight_begin: String?
    var nautical_twilight_end: String?
    var astronomical_twilight_begin: String?
    var astronomical_twilight_end: String?
    
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case results
        case status
    }
    
        enum ResultsCodingKeys: String, CodingKey {
        case sunrise = "sunrise"
        case sunset = "sunset"
        case solar_noon = "solar_noon"
        case day_length = "day_length"
        case civil_twilight_begin = "civil_twilight_begin"
        case civil_twilight_end = "civil_twilight_end"
        case nautical_twilight_begin = "nautical_twilight_begin"
        case nautical_twilight_end = "nautical_twilight_end"
        case astronomical_twilight_begin = "astronomical_twilight_begin"
        case astronomical_twilight_end = "astronomical_twilight_end"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.status = try? container.decode(String.self, forKey: .status)

        // Nested ratings
        let resultsContainer = try container.nestedContainer(keyedBy: ResultsCodingKeys.self, forKey: .results)
        self.sunrise = try resultsContainer.decode(String.self, forKey: .sunrise)
        self.sunset = try resultsContainer.decode(String.self, forKey: .sunset)
        self.solar_noon = try resultsContainer.decode(String.self, forKey: .solar_noon)
        self.day_length = try resultsContainer.decode(String.self, forKey: .day_length)
        self.civil_twilight_begin = try resultsContainer.decode(String.self, forKey: .civil_twilight_begin)
        self.civil_twilight_end = try resultsContainer.decode(String.self, forKey: .civil_twilight_end)
        self.nautical_twilight_begin = try resultsContainer.decode(String.self, forKey: .nautical_twilight_begin)
        self.nautical_twilight_end = try resultsContainer.decode(String.self, forKey: .nautical_twilight_end)
        self.astronomical_twilight_begin = try resultsContainer.decode(String.self, forKey: .astronomical_twilight_begin)
        self.astronomical_twilight_end = try resultsContainer.decode(String.self, forKey: .astronomical_twilight_end)
    }
}
