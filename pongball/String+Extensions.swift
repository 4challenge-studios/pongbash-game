//
//  String+Extensions.swift
//  pongball
//
//  Created by Matheus Martins on 3/9/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation

extension String {
    var gadgetName: String {
        if (self.slice(from: "i", to: "de")) != nil {
            if "\(self.slice(from: "i", to: "de")!)" == "Phone " {
                var componentes = self.components(separatedBy: " de ")
                return componentes[1]
            }
        } else if (self.slice(from: "’", to: "ne")) != nil {
            if "\(self.slice(from: "’", to: "ne")!)" == "s iPho" {
                var componentes = self.components(separatedBy: "’s ")
                return componentes[0]
            }
        }
        return self
    }
}
