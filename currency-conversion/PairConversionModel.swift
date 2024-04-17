//
//  PairConversionModel.swift
//  currency-conversion
//
//  Created by Rafael Badaró on 16/04/24.
//

import Foundation

struct PairConversionModel: Codable  {
    let result: String?
    let documentation: String?
    let termsOfUse: String?
    let timeLastUpdateUnix: Int?
    let timeLastUpdateUTC: String?
    let timeNextUpdateUnix: Int?
    let timeNextUpdateUTC: String?
    let baseCode: String?
    let targetCode: String?
    let conversionRate: Double?
    let conversionResult: Double?
}
