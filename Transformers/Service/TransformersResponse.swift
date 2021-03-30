//
//  TransformersResponse.swift
//  Transformers
//
//  Created by Alek Spitzer on 3/28/21.
//

import Foundation

struct TransformersResponse: Codable {
    let transformers:[Transformer]?
    
    enum CodingKeys: String, CodingKey {
        case transformers
    }
}
