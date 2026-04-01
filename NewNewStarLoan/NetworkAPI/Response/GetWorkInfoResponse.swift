//
//  GetWorkInfoResponse.swift
//  StarLoan
//
//  Created by Albert on 2025/4/16.
//
import Foundation

struct GetWorkInfoResponse: Codable {
  let seats: String
  let hundred: String
  
  let middle: MiddleInfo
  
  struct MiddleInfo: Codable {
    let stopped: [StoppedItem]
    
    struct StoppedItem: Codable {
      let dozen: Int
      let homayoun: String
      let lines: [LineItem]
      let frequented: Bool
      let mentioned: String
      let once: String
      let whirl: Int
      let hundred: String
      let mazreez: String
      let followerske: Int
      let neighbourhood: Int
      let studied: String
      let mountainside: String
      let actually: Int
      
      struct LineItem: Codable {
        let bad: String
        let mountainside: Int
      }
    }
  }
}
/**
 Moya_Logger: [2025/4/16, 17:01] Response Body: {
   "hundred" : "0",
   "seats" : "success",
   "middle" : {
     "K9zbL" : "AwvMxX@hotmail.com",
     "stopped" : [
       {
         "dozen" : 0,
         "homayoun" : "n",
         "lines" : [

         ],
         "frequented" : true,
         "mentioned" : "Please input company name",
         "once" : "",
         "whirl" : 19,
         "hundred" : "belted",
         "mazreez" : "nbaallstarl",
         "neighbourhood" : 0,
         "followerske" : 0,
         "studied" : "Company Name",
         "mountainside" : "",
         "actually" : 0
       },
       {
         "dozen" : 0,
         "homayoun" : "n",
         "lines" : [

         ],
         "frequented" : true,
         "mentioned" : "Please input company phone",
         "once" : "",
         "whirl" : 100,
         "hundred" : "company_phone_num",
         "mazreez" : "nbaallstarl",
         "neighbourhood" : 0,
         "followerske" : 1,
         "studied" : "Company Phone",
         "mountainside" : "",
         "actually" : 0
       },
       {
         "dozen" : 0,
         "homayoun" : "n",
         "lines" : [

         ],
         "frequented" : true,
         "mentioned" : "Please select company address",
         "once" : "",
         "whirl" : 20,
         "hundred" : "gravity",
         "mazreez" : "nbaallstarm",
         "neighbourhood" : 0,
         "followerske" : 0,
         "studied" : "Company Address",
         "mountainside" : "",
         "actually" : 0
       },
       {
         "dozen" : 0,
         "homayoun" : "n",
         "lines" : [

         ],
         "frequented" : true,
         "mentioned" : "Please input  job title",
         "once" : "",
         "whirl" : 101,
         "hundred" : "job_title",
         "mazreez" : "nbaallstarl",
         "neighbourhood" : 0,
         "followerske" : 0,
         "studied" : "Job Title",
         "mountainside" : "",
         "actually" : 0
       },
       {
         "dozen" : 0,
         "homayoun" : "n",
         "lines" : [
           {
             "bad" : "Less than 1 year",
             "mountainside" : 1
           },
           {
             "bad" : "1-3 years",
             "mountainside" : 2
           },
           {
             "bad" : "3-5years",
             "mountainside" : 3
           },
           {
             "bad" : "More than 5 years",
             "mountainside" : 4
           }
         ],
         "frequented" : true,
         "mentioned" : "Please select working experience",
         "once" : "",
         "whirl" : 55,
         "hundred" : "arrogance",
         "mazreez" : "nbaallstark",
         "neighbourhood" : 0,
         "followerske" : 0,
         "studied" : "Working Experience",
         "mountainside" : "",
         "actually" : 0
       }
     ],
     "uoZpADai" : 36073814
   }
 }
 
 */
