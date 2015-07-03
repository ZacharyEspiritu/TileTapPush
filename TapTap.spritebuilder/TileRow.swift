//
//  TileRow.swift
//  TapTap
//
//  Created by Zachary Espiritu on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

enum BoxNumber {
    case Top, Midtop, Midbottom, Bottom
}

class TileRow: CCNode {
    
    // MARK: Variables
    
    // Connecting our boxes to make everything more boxy. Fun fact: everything's in a layout box, so it's a box in a box. Boxception ftw.
    weak var box1: CCNodeColor!
    weak var box2: CCNodeColor!
    weak var box3: CCNodeColor!
    weak var box4: CCNodeColor!
    
    var enumBox: BoxNumber = .Top /* .Top acts as the default box. We have to put something in for each of our variables otherwise we would have to implement an override init() function somewhere in here, and who really wants to do that? I also don't want to run the risk of implementing a .None enumeration just in case something goes wrong and it becomes impossible to make a move in-game. */ {
        didSet {
            
            let whiteColor = CCColor(red: 1, green: 1, blue: 1)
            let blackColor = CCColor(red: 0, green: 0, blue: 0)
            
            box1.color = blackColor
            box2.color = blackColor
            box3.color = blackColor
            box4.color = blackColor
            
            if enumBox == .Top {
                box4.color = whiteColor
            }
            else if enumBox == .Midtop {
                box3.color = whiteColor
                
            }
            else if enumBox == .Midbottom {
                box2.color = whiteColor
            }
            else if enumBox == .Bottom {
                box1.color = whiteColor
            }
        }
    }
    
    // MARK: Procedural Generation Functions
    
    /**
    Generates a random `TileRow`.
    
    It randomly generates a number and uses the result to decide which of the four boxes in a `TileRow` to color in. By using the `didSet` property of the `enumBox` variable, we don't need to set the colors here because they will be set automatically every time the `enumBox` variable of a `TileRow` changes.
    */
    func generateRandomTileRow() {
        
        // Generate a random number and based on that number, decide which of the four tiles to color.
        var rand = CCRANDOM_0_1()
        if rand < 0.25 {
            enumBox = .Bottom
        }
        else if rand < 0.50 {
            enumBox = .Midbottom
        }
        else if rand < 0.75 {
            enumBox = .Midtop
        }
        else {
            enumBox = .Top
        }
        
    }
    
}