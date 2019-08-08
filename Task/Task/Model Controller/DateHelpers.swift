//
//  DateHelpers.swift
//  Task
//
//  Created by Michael Moore on 8/7/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import Foundation

extension Date {
    func stringValue() -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter.string(from: self)
    }
}
