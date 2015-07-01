//
//  MainScene.swift
//  TapTap
//
//  Created by Zachary Espiritu on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

enum Side {
    case Blue, Red
}

class MainScene: CCNode {
    
    let moveAmount: CGFloat = 0.03
    
    let wrongTapPenalty: CGFloat = 0.04
    let numberOfTileRows: Int = 4
    
    var countdown: String = "0" {
        didSet {
            redCountdownLabel.string = String("\(countdown)")
            blueCountdownLabel.string = String("\(countdown)")
        }
    }
    
    weak var redCountdownLabel: CCLabelTTF!
    weak var blueCountdownLabel: CCLabelTTF!
    
    weak var dominantColor: DominantColor!
    weak var particleLine: ParticleLine!
    
    weak var world: CCNode!
    
    weak var blueTileRowNode: CCNode!
    var blueTileRows: [TileRow] = []
    var blueIndex: Int = 0
    weak var redTileRowNode: CCNode!
    var redTileRows: [TileRow] = []
    var redIndex: Int = 0
    
    func didLoadFromCCB() {
        
        for index in 0..<numberOfTileRows {
            
            // Duplicate the tileRow. We have to do this since we can't add the same piece as a child to two different nodes.
            var blueTileRow = CCBReader.load("TileRow") as! TileRow
            var redTileRow = CCBReader.load("TileRow") as! TileRow
            
            var rowWidth = blueTileRow.contentSizeInPoints.width * CGFloat(index)
            
            blueTileRow.position = CGPoint(x: rowWidth, y: 0)
            redTileRow.position = CGPoint(x: rowWidth, y: 0)
            
            // Generate a random tile row for the redTileRow and the blueTileRow.
            blueTileRow.generateRandomTileRow()
            redTileRow.generateRandomTileRow()
            
            // Add the tileRow as a child of its respective TileRowNode. This allows us to position it relative to the TileRowNode.
            blueTileRowNode.addChild(blueTileRow)
            redTileRowNode.addChild(redTileRow)
            
            // Append the tileRow to the end of its respective TileRow array.
            blueTileRows.append(blueTileRow)
            redTileRows.append(redTileRow)
        }
        
        countdownBeforeGameBegins()

    }
    
    func countdownBeforeGameBegins() {
        redCountdownLabel.visible = true
        blueCountdownLabel.visible = true
        
        self.countdown = "3"
        self.delay(1.0) {
            self.countdown = "2"
            self.delay(1.0) {
                self.countdown = "1"
                self.delay(1.0) {
                    self.countdown = "GO!"
                    self.userInteractionEnabled = true
                    self.multipleTouchEnabled = true
                    self.delay(0.4) {
                        self.redCountdownLabel.visible = false
                        self.blueCountdownLabel.visible = false
                        return
                    }
                }
            }
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        var taplocation = touch.locationInNode(world)
        
        var xTouch = taplocation.x
        var screenHalf = CCDirector.sharedDirector().viewSize().width / 2
        
        if xTouch < screenHalf { // A tap on the blue side.
            checkIfRightTap(side: .Blue, location: taplocation)
            
        }
        else { // A tap on the red side.
            checkIfRightTap(side: .Red, location: taplocation)
        }
        
        checkIfWin()
        
    }
    
    func checkIfRightTap(#side: Side, location: CGPoint) {
        
        if side == .Blue { // Blue player tapped.
            
            var tileRow = blueTileRows[blueIndex]
            var rowBox: BoxNumber = tileRow.enumBox

            var yTouch = location.y
            var screenQuartersVertical = CCDirector.sharedDirector().viewSize().height / 4
            
            // Compare the tap location against the enumBox of the selected tileRow to see if it was tapped in the right spot.
            if yTouch > 0 && yTouch < screenQuartersVertical && rowBox == .Bottom || yTouch > screenQuartersVertical && yTouch < (screenQuartersVertical * 2) && rowBox == .Midbottom || yTouch > (screenQuartersVertical * 2) && yTouch < (screenQuartersVertical * 3) && rowBox == .Midtop || yTouch > (screenQuartersVertical * 3) && yTouch < (screenQuartersVertical * 4) && rowBox == .Top {
                
                // Move the tile row to the top of the tileRow stack.
                var xDiff = tileRow.contentSize.width * CGFloat(numberOfTileRows)
                tileRow.position = ccpAdd(tileRow.position, CGPoint(x: xDiff, y: 0))
                
                // Change the drawing order.
                tileRow.zOrder = tileRow.zOrder + 1
                
                // Randomly select a new tile to be colored.
                tileRow.generateRandomTileRow()
                
                // Animate the tile falling downwards.
                var moveTileRowOver = CCActionMoveBy(duration: 0.05, position: CGPoint(x: -tileRow.contentSize.width, y: 0))
                blueTileRowNode.runAction(moveTileRowOver)
                
                // Cycle through the numbers 1 - numberOfTileRows in the blueIndex.
                blueIndex = (blueIndex + 1) % numberOfTileRows
                
                // Move the particleLine to stay with the dominantColor edge.
                particleLine.position.x += moveAmount
                
                // Move the dominantColor towards its goal.
                dominantColor.left(Float(moveAmount))
            }
            else { // If the player tapped on the wrong square, move the dominantColor away from its goal.
                dominantColor.right(Float(wrongTapPenalty))
                
                // Move the particleLine to stay with the dominantColor edge.
                particleLine.position.x -= wrongTapPenalty
            }
            
        }
        else if side == .Red {
            var tileRow = redTileRows[redIndex]
            var rowBox: BoxNumber = tileRow.enumBox
            
            var yTouch = location.y
            var screenQuartersVertical = CCDirector.sharedDirector().viewSize().height / 4
            
            // Compare the tap location against the enumBox of the selected tileRow to see if it was tapped in the right spot.
            if yTouch > 0 && yTouch < screenQuartersVertical && rowBox == .Top || yTouch > screenQuartersVertical && yTouch < (screenQuartersVertical * 2) && rowBox == .Midtop || yTouch > (screenQuartersVertical * 2) && yTouch < (screenQuartersVertical * 3) && rowBox == .Midbottom || yTouch > (screenQuartersVertical * 3) && yTouch < (screenQuartersVertical * 4) && rowBox == .Bottom {
                
                // Move the tile row to the top of the tileRow stack.
                var xDiff = tileRow.contentSize.width * CGFloat(numberOfTileRows)
                tileRow.position = ccpAdd(tileRow.position, CGPoint(x: xDiff, y: 0))
                
                // Change the drawing order.
                tileRow.zOrder = tileRow.zOrder + 1
                
                // Randomly select a new tile to be colored.
                tileRow.generateRandomTileRow()
                
                // Animate the tile falling downwards.
                var moveTileRowOver = CCActionMoveBy(duration: 0.05, position: CGPoint(x: -tileRow.contentSize.width, y: 0))
                redTileRowNode.runAction(moveTileRowOver)
                
                // Cycle through the numbers 1 - numberOfTileRows in the blueIndex.
                redIndex = (redIndex + 1) % numberOfTileRows
                
                // Move the particleLine to stay with the dominantColor edge.
                particleLine.position.x -= moveAmount
                
                // Since this is the red player, move the dominantColor away its goal.
                dominantColor.right(Float(moveAmount))
            }
            else { // Since this is the red player, when the player taps on the wrong square, move the dominantColor towards its goal.
                dominantColor.left(Float(wrongTapPenalty))
                
                // Move the particleLine to stay with the dominantColor edge.
                particleLine.position.x += wrongTapPenalty
            }
        }
    }
    
    func checkIfWin() {
        var scale = dominantColor.scaleX
        
        if scale <= 0 {
            redWins()
        }
        else if scale >= 1 {
            blueWins()
        }
    }

    func redWins() {
        println("Red wins")
        self.userInteractionEnabled = false
        
        fadeOutTileRows()
        
        world.animationManager.runAnimationsForSequenceNamed("RedWins")
        particleLine.stopParticleGeneration()
        
        
    }
    
    func blueWins() {
        println("Blue wins")
        self.userInteractionEnabled = false
        
        fadeOutTileRows()
        
        world.animationManager.runAnimationsForSequenceNamed("BlueWins")
        particleLine.stopParticleGeneration()
    }
    
    func playAgain() {
        var mainScene = CCBReader.load("MainScene") as! MainScene
        mainScene.animationManager.runAnimationsForSequenceNamed("Default Timeline")
        
        var scene = CCScene()
        scene.addChild(mainScene)
                
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func fadeOutTileRows() {
        blueTileRowNode.cascadeOpacityEnabled = true
        blueTileRowNode.runAction(CCActionFadeOut(duration: 0.3))
        
        redTileRowNode.cascadeOpacityEnabled = true
        redTileRowNode.runAction(CCActionFadeOut(duration: 0.3))
    }
    
    func mainMenu() {
        
    }
    
}