//
//  Extensions.swift
//  Lector Noticias
//
//  Created by Dev1 on 18/12/2018.
//  Copyright © 2018 Dev1. All rights reserved.
//

import UIKit

extension DateFormatter {
   static let iso8601Full: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//.SSSZZZZZ"
      formatter.calendar = Calendar(identifier: .iso8601)
      formatter.timeZone = TimeZone(secondsFromGMT: 0)
      formatter.locale = Locale(identifier: "en_US_POSIX")
      return formatter
   }()
}

extension UIImage {
   func resizeImage(newWidth:CGFloat) -> UIImage? {
      let scale = newWidth / self.size.width
      let newHeight = self.size.height * scale
      let newSize = CGSize(width: newWidth, height: newHeight)
      UIGraphicsBeginImageContext(newSize)
      self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return newImage
   }
}
