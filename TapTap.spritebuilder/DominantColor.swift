//
//  Purple.swift
//  TapTap
//
//  Created by Zachary Espiritu on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class DominantColor: CCNode {
    
    /**
    Called when the screen is tapped on the left side. "Moves" the DominantColor towards its target mark; a.k.a. the opponent's side of the screen.
    */
    func left() {
        scaleX += 0.02
    }
    
    /**
    Called when the screen is tapped on the right side. "Moves" the DominantColor away from its target mark; a.k.a. its own side of the screen.
    */
    func right() {
        scaleX -= 0.02
    }
    
}