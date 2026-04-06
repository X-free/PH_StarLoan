//
//  OnboardingView.swift
//  StarLoan
//
//  Created by Albert on 2025/3/25.
//

import SwiftUI
import AppTrackingTransparency
import UIKit
import AdSupport
import FBSDKCoreKit

struct OnboardingView: View {
  @State private var currentPage = 0
  
  var roundok: ()-> Void
  @State private var countdown = 3
  
  @State private var timer: Timer? = nil

  
//  let images = ["ydy_jpg_01", "ydy_jpg_02", "ydy_jpg_03"]
//  let images = ["ydy_jpg_02", "ydy_jpg_03"]
  let images = ["ydy_jpg_02"]
  
  var body: some View {
    ZStack {
      Image(images[currentPage])
        .resizable()
        .scaledToFill()
      
      VStack {
        HStack {
          Spacer()
          
          Text("\(countdown) s")
            .padding(.horizontal, 10)
            .font(.system(size: 16))
            .foregroundColor(.white)
            .frame(height: 22)
            .background(Color.black.opacity(0.3))
            .cornerRadius(11)
            .padding(.trailing, 20)
        }
        .padding(.top, 44)
        Spacer()
        
        Text("Next")
          .font(.system(size: 16, weight: .heavy))
          .foregroundColor(.white)
          .frame(width: 125, height: 44)
          .background(Color(hex: "06101C"))
          .cornerRadius(22)
          .padding(.bottom, 160)
          .onTapGesture {
            timer?.invalidate()
            roundok()
            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
          }
      }
    }
    .ignoresSafeArea()
    .onAppear {
//      reportaod()
      startCountdown()
    }
  }
  
  private func startCountdown() {
    countdown = 3
    timer?.invalidate()
    
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      if countdown > 1 {
        countdown -= 1
      } else {
        timer.invalidate()
        
        roundok()
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
      }
    }
  }
  
  private func reportaod() {
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(1230)) {
      ATTrackingManager.requestTrackingAuthorization { status in
        DispatchQueue.main.async {
          let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
          
          let manager = SomeIdentifierManager()
          let idfv = manager.fetchIDFV() ?? ""
          
          Task {
            do {
              let response = try await RiskService.shared.market(feudally: String.generateUUID(), hold: idfv, house: ASIdentifierManager.shared().advertisingIdentifier.uuidString)
              let facebook = response.middle.facebook
              Settings.shared.appID = facebook.facebookAppID
              Settings.shared.clientToken = facebook.facebookClientToke
              Settings.shared.displayName = facebook.facebookDisplayName
              Settings.shared.appURLSchemeSuffix = facebook.cFBundleURLScheme
              ApplicationDelegate.shared.application(UIApplication.shared,didFinishLaunchingWithOptions: nil)
            } catch {
              
            }
          }
        }
      }
    }
  }
}

extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }
    
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue:  Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}
