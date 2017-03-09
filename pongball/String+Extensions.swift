import Foundation

extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
    
    var gadgetName: String {
        if (self.slice(from: "i", to: "de")) != nil {
            if "\(self.slice(from: "i", to: "de")!)" == "Phone " {
                var componentes = self.components(separatedBy: " de ")
                return componentes[1]
            }
        } else if (self.slice(from: "'", to: "ne")) != nil {
            if "\(self.slice(from: "'", to: "ne")!)" == "s iPho" {
                var componentes = self.components(separatedBy: "'s ")
                return componentes[0]
            }
        }
        return self
    }
}
