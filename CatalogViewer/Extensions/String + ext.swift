//
//  String + ext.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import Foundation

extension String {
   static func random(of n: Int) -> String {
      let digits = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
      return String(Array(0..<n).map { _ in digits.randomElement()! })
   }
}
