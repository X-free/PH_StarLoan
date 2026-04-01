//
//  HomePageResponse.swift
//  StarLoan
//
//  Created by Albert on 2025/4/1.
//

import Foundation

struct HomePageResponse: Codable {
  let hundred: String
  let seats: String
  let middle: HomePageMiddleContent
}

struct HomePageMiddleContent: Codable {
  let twins: String
  let slap: Int
  let counted: HomePageCountedContent
  let showAbout: Int
  let seven: HomePageSevenContent
  let trek: Int
  let carsick: HomePageCarsickContent
  let window: HomePageWindowContent?
  let reaching: String
  let lap: String
  let karima: HomePageKarimaContent?
  
  enum CodingKeys: String, CodingKey {
    case twins, slap, counted, seven, trek, carsick, window, reaching, lap, karima
    case showAbout = "show_about"
  }
}

struct HomePageCountedContent: Codable {
  let tail: [ProductInfo]
  let mountainside: String
  
  var cardType: HomePageCardType? {
      return HomePageCardType(rawValue: mountainside)
  }
}

struct HomePageCarsickContent: Codable {
  let tail: [BannerInfo]
  let mountainside: String
  
  var cardType: HomePageCardType? {
      return HomePageCardType(rawValue: mountainside)
  }
}

struct HomePageWindowContent: Codable {
  let tail: [RepaymentInfo]
  let mountainside: String
  
  var cardType: HomePageCardType? {
      return HomePageCardType(rawValue: mountainside)
  }
}

struct HomePageKarimaContent: Codable {
    let tail: [KarimaProductInfo]
    let mountainside: String
    
    var cardType: HomePageCardType? {
        return HomePageCardType(rawValue: mountainside)
    }
}
struct KarimaProductInfo: Codable {
    let bgColor: Int
    let van: String                // phpstarloanios
    let nearly: String            // Loan terms
    let steep: String             // Borrowed 1 times
    let cratered: String          // Star Loan
    let fresh: String             // Interest Rate
    let stomach: [String]         // 空数组
    let vomiting: String          // Apply
    let drop: String              // Loan Amount
    let hairpin: String           // yellow
    let fine: String              // 121days
    let fazila: String            // 30,000
    let car: String               // 空字符串
    let lurched: Int              // 1
    let shrieking: String         // 121
    let winding: String           // Limit increase
    let trade: String             // 空字符串
    let todayClicked: Int         // 0
    let todayApplyNum: Int        // 100
    let isCopyPhone: String       // "0"
    let accountable: String       // 30,000
    let advisor: Int              // 1
    let loudly: String            // Low Interest Rates
    let same: [String]            // ["Low Interest Rates", "17 years old can be borrowed"]
    let lots: Int                 // 2
    let held: String              // Max Loan Up To
    let afghans: String           // ≥ 0.05%/days
    let whirl: Int                // 1
    let watched: String           // 空字符串
    let buttonExplain: String     // 空字符串
    
    enum CodingKeys: String, CodingKey {
        case bgColor, van, nearly, steep, cratered, fresh, stomach, vomiting
        case drop, hairpin, fine, fazila, car, lurched, shrieking, winding
        case trade, todayClicked, todayApplyNum, isCopyPhone, accountable
        case advisor, loudly, same, lots, held, afghans, whirl, watched
        case buttonExplain
    }
}


struct ProductInfo: Codable {
  let termInfoImg: String
  let fine: String
  let cratered: String
  let stuck: String
  let watched: String
  let car: String
  let accountable: String
  let whirl: Int
  let held: String
  let sickness: String
  let vomiting: String
  let fresh: String
  let loanRateUnit: String
  let loanRateImg: String
}

struct HomePageSevenContent: Codable {
  let dizzy: String
  let sandwiched: String
}

struct BannerInfo: Codable {
  let trade: String
  let studied: String
  let sat: String
  let present: String
  let feud: Int
  let productUrl: String?
  
  enum CodingKeys: String, CodingKey {
    case trade, studied, sat, present, feud
    case productUrl = "product_url"
  }
}

struct RepaymentInfo: Codable {
  let drive: String
  let trade: String
  let seats: String
  let repayAmount: String
  let repayBtnText: String
  let seven: String
  let studied: String
  
  enum CodingKeys: String, CodingKey {
    case drive, trade, seats, seven, studied
    case repayAmount = "repay_amount"
    case repayBtnText = "repay_btn_text"
  }
}

enum HomePageCardType: String {
  case banner = "nbaallstara"
  case largeCard = "nbaallstarb"
  case smallCard = "nbaallstarc"
  case repay = "nbaallstard"
  case productList = "nbaallstare"
  
  var displayName: String {
    switch self {
    case .banner:
      return "BANNER"
    case .largeCard:
      return "LARGE_CARD"
    case .smallCard:
      return "SMALL_CARD"
    case .repay:
      return "REPAY"
    case .productList:
      return "PRODUCT_LIST"
    }
  }
}


