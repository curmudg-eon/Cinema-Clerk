//
//  File.swift
//  
//
//  Created by Gabe Secula on 6/19/20.
//

import Foundation

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.lowercased().hasPrefix(prefix.lowercased()) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
