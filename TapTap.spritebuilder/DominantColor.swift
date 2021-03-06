//
//  Purple.swift
//  TapTap
//
//  Created by Zachary Espiritu on 6/30/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation

class DominantColor: CCNode {
    
    // MARK: Functions
    
    /**
    Called when the screen is tapped on the left side. "Moves" the `DominantColor` towards its target mark; a.k.a. the opponent's side of the screen.
    
    - parameter percentMove:  a percent in the form of a `Float` stating how much to move the `DominantColor` by
    */
    func left(percentMove: Float) {
        scaleX += percentMove
    }
    
    /**
    Called when the screen is tapped on the right side. "Moves" the `DominantColor` away from its target mark; a.k.a. its own side of the screen.
    
    - parameter percentMove:  a percent in the form of a `Float` stating how much to move the `DominantColor` by
    */
    func right(percentMove: Float) {
        scaleX -= percentMove
    }
    
}