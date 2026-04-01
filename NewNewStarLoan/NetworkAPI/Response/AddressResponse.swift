//
//  AddressResponse.swift
//  StarLoan
//
//  Created by Albert on 2025/4/15.
//


import Foundation

struct AddressResponse: Codable {
    let hundred: String
    let seats: String
    let middle: MiddleInfo
    
    struct MiddleInfo: Codable {
        let dog: [Level1Info]
    }
    
    struct Level1Info: Codable {
        let whirl: Int
        let bad: String
        let dog: [Level1Info]?
    }
    
    // 添加转换方法
    func toAddressData() -> AddressData {
        // 将 Level1Info 转换为 Region
        let regions = middle.dog.map { level1 -> Region in
            // 递归转换子级
            let provinces = level1.dog?.map { province -> Province in
                let cities = province.dog?.map { city -> City in
                    return City(whirl: city.whirl, bad: city.bad)
                }
                return Province(whirl: province.whirl, bad: province.bad, dog: cities)
            }
            return Region(whirl: level1.whirl, bad: level1.bad, dog: provinces)
        }
        
        return AddressData(
            hundred: hundred,
            seats: seats,
            middle: [:], // 这里可能需要根据实际需求转换 middle 字段
            dog: regions
        )
    }
}
