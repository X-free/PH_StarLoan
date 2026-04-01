//
//  OnboardingView.swift
//  StarLoan
//
//  Created by Albert on 2025/3/25.
//

import SwiftUI

struct OnboardingView: View {
  @Binding var isPresented: Bool
  @State private var currentPage = 0
  
  let images = ["ydy_jpg_01", "ydy_jpg_02", "ydy_jpg_03"]
  
  var body: some View {
      if #available(iOS 14.0, *) {
          ZStack {
              Image(images[currentPage])
                  .resizable()
                  .scaledToFill()
              
              VStack {
                  Spacer()
                  
                  Button(action: {
                      if currentPage < images.count - 1 {
                          withAnimation {
                              currentPage += 1
                          }
                      } else {
                          withAnimation {
                              isPresented = false
                              UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                          }
                      }
                  }) {
                      Text("Next")
                          .font(.system(size: 16, weight: .heavy))
                          .foregroundColor(.white)
                          .frame(width: 125, height: 44)
                          .background(Color(hex: "06101C"))
                          .cornerRadius(22)
                  }
                  .padding(.bottom, 160)
              }
          }
          .ignoresSafeArea()
      } else {
          // Fallback on earlier versions
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
