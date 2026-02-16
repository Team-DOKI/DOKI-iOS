//
//  PresignedUrlRequestDTO.swift
//  DOKI
//
//  Created by 이세민 on 2/16/26.
//

struct PresignedUrlRequestDTO: Encodable {
    let domain: String
    let contentType: String
}
