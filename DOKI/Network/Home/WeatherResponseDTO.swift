//
//  WeatherResponseDTO.swift
//  DOKI
//
//  Created by 이세민 on 2/17/26.
//

struct WeatherResponseDTO: Codable {
    let temperature: Int
    let rainyMm: Int
    let region: String   
}
