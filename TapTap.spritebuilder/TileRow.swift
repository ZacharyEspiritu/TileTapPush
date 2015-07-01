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
    
    // Connecting our boxes to make everything more boxy. Fun fact: everything's in a layout box, so it's a box in a box. Boxception ftw.
    weak var box1: CCNodeColor!
    weak var box2: CCNodeColor!
    weak var box3: CCNodeColor!
    weak var box4: CCNodeColor!
    
    var enumBox: BoxNumber = .Top // Default box. We have to put something in for each of our variables otherwise we would have to implement an override init() function somewhere in here, and who really wants to do that? I also don't want to run the risk of implementing a .None enumeration just in case something goes wrong and it becomes impossible to make a move in-game.
    
    /**
    Generates a random TileRow.
    
    It randomly generates a number and uses the result to decide which of the four boxes in a TileRow to color in. The other three boxes are set to the default color. Each TileRow has an enumBox used for later checking functions, which is set here corresponding to the randomly selected tile.
    */
    func generateRandomTileRow() {
        
        let whiteColor = CCColor(red: 1, green: 1, blue: 1)
        let blackColor = CCColor(red: 0, green: 0, blue: 0)
        
        // Generate a random number and based on that number, decide which of the four tiles to color.
        var rand = CCRANDOM_0_1()
        if rand < 0.25 {
            box1.color = whiteColor // White
            box2.color = blackColor // Black
            box3.color = blackColor // Black
            box4.color = blackColor // Black
            
            enumBox = .Bottom
        }
        else if rand < 0.50 {
            box1.color = blackColor // Black
            box2.color = whiteColor // White
            box3.color = blackColor // Black
            box4.color = blackColor // Black
            
            enumBox = .Midbottom
        }
        else if rand < 0.75 {
            box1.color = blackColor // Black
            box2.color = blackColor // Black
            box3.color = whiteColor // White
            box4.color = blackColor // Black
            
            enumBox = .Midtop
        }
        else {
            box1.color = blackColor // Black
            box2.color = blackColor // Black
            box3.color = blackColor // Black
            box4.color = whiteColor // White
            
            enumBox = .Top
        }
        
    }
    
}