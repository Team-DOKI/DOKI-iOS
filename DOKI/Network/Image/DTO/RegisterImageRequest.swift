//
//  RegisterImageRequest.swift
//  DOKI
//
//  Created by 이세민 on 2/16/26.
//

struct RegisterImageRequest: Codable {
    let imageUrl: String
    let contentType: String
    let width: Int
    let height: Int
    let domain: String
}
