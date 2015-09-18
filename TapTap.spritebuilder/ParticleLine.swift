//
//  ParticleLine.swift
//  TapTap
//
//  Created by Zachary Espiritu on 6/30/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation

class ParticleLine: CCNode {
    
    // MARK: Constants
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // See `OptionsMenu.swift` for information on these constants.
    let leftSideColorChoice = "leftSideColorChoice"
    let rightSideColorChoice = "rightSideColorChoice"
    
    
    // MARK: Variables
    
    weak var backgroundParticles: CCParticleSystem!
    weak var dominantParticles: CCParticleSystem!
    weak var gradientNode: CCNodeGradient!
    
    
    // MARK: Functions
    
    /**
    Called whenever `ParticleLine.ccb` is loaded. Its main purpose is to update the main menu screen with the color choices a user may have selected in the options menu.
    */
    func didLoadFromCCB() {
        getColorChoicesFromMemory()
    }
    
    /**
    Stops the generation of the particles from a `ParticleLine` object.
    
    For whatever reasons that I still don't really know about (and, quite frankly, don't care about right now), there's no need for a `startParticleGeneration()` function because it ends up restarting itself. This might be due to the Default Timeline in Spritebuilder automatically restarting when the `MainScene.ccb` is reloaded.
    */
    func stopParticleGeneration() {
        backgroundParticles.stopSystem()
        dominantParticles.stopSystem()
    }
    
    
    // MARK: Memory Functions
    
    func getColorChoicesFromMemory() {
        
        // Color presets.
        let turquoiseColor = CCColor(red: 26/255, green: 188/255, blue: 156/255)
        let grayColor = CCColor(red: 52/255, green: 73/255, blue: 94/255)
        let orangeColor = CCColor(red: 230/255, green: 126/255, blue: 34/255)
        let redColor = CCColor(red: 255/255, green: 102/255, blue: 102/255)
        let silverColor = CCColor(red: 189/255, green: 195/255, blue: 199/255)
        let yellowColor = CCColor(red: 241/255, green: 196/255, blue: 15/255)
        let purpleColor = CCColor(red: 155/255, green: 89/255, blue: 182/255)
        let blueColor = CCColor(red: 0/255, green: 0/255, blue: 255/255)
        let greenColor = CCColor(red: 39/255, green: 174/255, blue: 96/255)
        
        // Restore previously set color choices.
        let leftColorChoiceInt = defaults.integerForKey(leftSideColorChoice)
        if leftColorChoiceInt == 1 { // Turquoise
            dominantParticles.startColor = turquoiseColor
            dominantParticles.endColor = turquoiseColor
            gradientNode.startColor = turquoiseColor
        }
        else if leftColorChoiceInt == 2 { // Gray
            dominantParticles.startColor = grayColor
            dominantParticles.endColor = grayColor
            gradientNode.startColor = grayColor
        }
        else if leftColorChoiceInt == 3 { // Orange
            dominantParticles.startColor = orangeColor
            dominantParticles.endColor = orangeColor
            gradientNode.startColor = orangeColor
        }
        else if leftColorChoiceInt == 4 { // Red
            dominantParticles.startColor = redColor
            dominantParticles.endColor = redColor
            gradientNode.startColor = redColor
        }
        else if leftColorChoiceInt == 5 { // Silver
            dominantParticles.startColor = silverColor
            dominantParticles.endColor = silverColor
            gradientNode.startColor = silverColor
        }
        else if leftColorChoiceInt == 6 { // Yellow
            dominantParticles.startColor = yellowColor
            dominantParticles.endColor = yellowColor
            gradientNode.startColor = yellowColor
        }
        else if leftColorChoiceInt == 7 { // Purple
            dominantParticles.startColor = purpleColor
            dominantParticles.endColor = purpleColor
            gradientNode.startColor = purpleColor
        }
        else if leftColorChoiceInt == 8 { // Blue
            dominantParticles.startColor = blueColor
            dominantParticles.endColor = blueColor
            gradientNode.startColor = blueColor
        }
        else if leftColorChoiceInt == 9 { // Green
            dominantParticles.startColor = greenColor
            dominantParticles.endColor = greenColor
            gradientNode.startColor = greenColor
        }
        
        let rightColorChoiceInt = defaults.integerForKey(rightSideColorChoice)
        if rightColorChoiceInt == 1 { // Turquoise
            backgroundParticles.startColor = turquoiseColor
            backgroundParticles.endColor = turquoiseColor
            gradientNode.endColor = turquoiseColor
        }
        else if rightColorChoiceInt == 2 { // Gray
            backgroundParticles.startColor = grayColor
            backgroundParticles.endColor = grayColor
            gradientNode.endColor = grayColor
        }
        else if rightColorChoiceInt == 3 { // Orange
            backgroundParticles.startColor = orangeColor
            backgroundParticles.endColor = orangeColor
            gradientNode.endColor = orangeColor
        }
        else if rightColorChoiceInt == 4 { // Red
            backgroundParticles.startColor = redColor
            backgroundParticles.endColor = redColor
            gradientNode.endColor = redColor
        }
        else if rightColorChoiceInt == 5 { // Silver
            backgroundParticles.startColor = silverColor
            backgroundParticles.endColor = silverColor
            gradientNode.endColor = silverColor
        }
        else if rightColorChoiceInt == 6 { // Yellow
            backgroundParticles.startColor = yellowColor
            backgroundParticles.endColor = yellowColor
            gradientNode.endColor = yellowColor
        }
        else if rightColorChoiceInt == 7 { // Purple
            backgroundParticles.startColor = purpleColor
            backgroundParticles.endColor = purpleColor
            gradientNode.endColor = purpleColor
        }
        else if rightColorChoiceInt == 8 { // Blue
            backgroundParticles.startColor = blueColor
            backgroundParticles.endColor = blueColor
            gradientNode.endColor = blueColor
        }
        else if rightColorChoiceInt == 9 { // Green
            backgroundParticles.startColor = greenColor
            backgroundParticles.endColor = greenColor
            gradientNode.endColor = greenColor
        }
        
    }
    
}