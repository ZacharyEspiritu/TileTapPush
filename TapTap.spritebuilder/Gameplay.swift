//
//  Gameplay.swift
//  TapTap
//
//  Created by Zachary Espiritu on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

enum Side {
    case Blue, Red
}
enum Winner {
    case Blue, Red, None
}
enum GameState {
    case Initial, Playing, GameOver
}

class Gameplay: CCNode {
    
    // MARK: Constants
    
    let moveAmount: CGFloat = 0.03      // How much does the line move on a correct tap?
    let wrongTapPenalty: CGFloat = 0.04 // How much does the line move on an incorrect tap?
    
    let numberOfTileRows: Int = 4       // How many tile rows do we generate for each array?
    
    let xDelay = 0.15                   // How long does the incorrect X mark appear in milliseconds?
    
    let audio = OALSimpleAudio.sharedInstance() // OALSimpleAudio instance used for handling sounds.

    
    // MARK: Variables
    
    var countdown: String = "0" {
        didSet { // Called during the `countdownBeforeGameBegins()` sequence. Every time the countdown variable changes, it changes the label output of the `redCountdownLabel` and the `blueCountdownLabel`.
            redCountdownLabel.string = String("\(countdown)")
            blueCountdownLabel.string = String("\(countdown)")
        }
    }
    weak var redCountdownLabel: CCLabelTTF!  // Countdown labels used at the beginning
    weak var blueCountdownLabel: CCLabelTTF! // of each game.
    
    weak var redWarningGradient: CCNode!     // Refers to the CCGradientNodes that appear
    weak var blueWarningGradient: CCNode!    // when a player is about to lose.
    
    weak var dominantColor: DominantColor!   // The color that is the one that is actually moving. Defaults to Blue.
    weak var particleLine: ParticleLine!     // The particle line that hides the color fade between the two sides.
    
    weak var world: CCNode!                  // Used for animation handling in Gameplay.ccb.
    
    weak var topTitleHolderNode, bottomTitleHolderNode: CCNode! // Used to animate title CCLabelTTF nodes attached to these holder nodes.
    
    // Variables used to handle the infinite generation of tileRows. Two sets exist to handle both players' sets individually.
    weak var blueTileRowNode: CCNode!
    var blueTileRows: [TileRow] = []
    var blueIndex: Int = 0
    weak var redTileRowNode: CCNode!
    var redTileRows: [TileRow] = []
    var redIndex: Int = 0
    
    // Variables used to handle the each of the red X's that appears when you tap on an incorrect box.
    weak var blueX1, blueX2, blueX3, blueX4: CCSprite!
    weak var redX1, redX2, redX3, redX4: CCSprite!
    
    var currentWinner: Winner = .None // Used to determine which menu transition animation should be played, because it depends on which side on the last game.
    
    var warningSound = false // Used in the "locking" mechanism for the warningSound. See `checkForWarningSound()` below.
    
    var gameState: GameState = .Initial // Used to check if the game is in a state where the players are allowed to make moves. Prevents players from discovering a bug where you can continue playing the game even after the game has ended and is in the Main Menu.
    
    
    // MARK: Reset Functions
    
    /**
    Called whenever the `Gameplay.ccb` file loads.
    */
    func didLoadFromCCB() {
        
        self.animationManager.runAnimationsForSequenceNamed("Gameplay")
        
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
        
        audio.preloadEffect("siren.mp3")
        audio.preloadEffect("tap.wav")
        audio.preloadEffect("scratch.wav")
        audio.preloadEffect("buzz.wav")
        audio.playBg("gameplayBG.mp3")
        
        gameState = .Playing // Change the gameState to Playing to allow players to begin making moves.
        countdownBeforeGameBegins()

    }
    
    
    // MARK: Primed Game State Functions
    
    /**
    Launches a 3-second countdown before the game begins.
    
    `TileRows` are left visible during this countdown on purpose to give a few seconds to the players so they can get acquainted with the starting generation of tiles before the game truly starts.
    */
    func countdownBeforeGameBegins() {
        redCountdownLabel.visible = true
        blueCountdownLabel.visible = true
        
        self.countdown = "READY?"
        delay(1.2) {
            self.countdown = "3"
            self.delay(1) {
                self.countdown = "2"
                self.delay(1) {
                    self.countdown = "1"
                    self.delay(1) {
                        // Enable user interaction on "GO!".
                        self.countdown = "GO!"
                        self.userInteractionEnabled = true
                        self.multipleTouchEnabled = true
                        self.delay(0.4) {
                            // Remove the "GO!" after a slight pause. No need to wait another full second since the players will already know what to do.
                            self.redCountdownLabel.visible = false
                            self.blueCountdownLabel.visible = false
                            return
                        }
                    }
                }
            }
        }
    }
    
    /**
    When called, delays the running of code included in the `closure` parameter.
    */
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    // MARK: In-Game Functions
    
    /**
    Called whenever a tap on the screen occurs.
    
    It checks to see which side of the screen the tap occured, and passes that information along to the `checkIfRightTap()` function for further processing.
    
    In addition, it calls the `checkIfWin()` function to determine if the tap action caused the game to land in a win state. If `checkIfWin()` returns false, it calls the `checkForWarning()` function to determine if the tap action caused the game to land in a state where it should display a `warningGradient` to one of the players.
    */
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        if gameState == .Playing { // Check to see if the `gameState` is currently Playing. Used to prevent people from continuing to make moves while the game is in the menu phase.
            var taplocation = touch.locationInNode(world)
            
            var xTouch = taplocation.x
            var screenHalf = CCDirector.sharedDirector().viewSize().width / 2
            
            if xTouch < screenHalf { // A tap on the blue side.
                checkIfRightTap(side: .Blue, location: taplocation)
                
            }
            else { // A tap on the red side.
                checkIfRightTap(side: .Red, location: taplocation)
            }
            
            // Check to see if the tap caused a win. If not, check to see if the tap caused the game to enter a warning state for one of the players.
            if !checkIfWin() {
                checkForWarning()
            }
        }
        
    }
    
    
    // MARK: Checking Functions
    
    /**
    Called whenever a tap occurs by `touchBegan()`. 
    
    Checks to see if the tap caused the game to land in a state where it should display a `warningGradient` to one of the players. Also, checks to see if the tap caused the game to do the reverse - if the tap caused the game to leave one of the two possible warning states.
    */
    func checkForWarning() {
        
        var scale = dominantColor.scaleX
        
        if scale <= 0.22 || scale >= 0.78 {
            if scale <= 0.22 {
                blueWarningGradient.visible = true
            }
            else if scale >= 0.78 {
                redWarningGradient.visible = true
            }
            
            // "Locking" mechanism to prevent the `siren.mp3` being repeatedly played on every tap that would result in a "Warning" state.
            if !warningSound {
                warningSound = true
                checkForWarningSound()
            }
        }
        else {
            blueWarningGradient.visible = false
            redWarningGradient.visible = false
            
            audio.stopAllEffects()
            
            warningSound = false // "Unlocks" the locking mechanism detailed above.
        }
        
    }
    
    /**
    Checks to see if a warning sound should be played.
    */
    func checkForWarningSound() {
        if warningSound {
            audio.playEffect("siren.mp3", volume: 0.08, pitch: 1.0, pan: 0.0, loop: true)
        }
    }
    
    /**
    Checks if a tap landed in the correct box on a `TileRow`.

    Called whenever a tap occurs by `touchBegan()`, which passes the `Side` and the `CGPoint` of the tap location to the function.
    
    :param: side      The `Side` on which the tap occured.
    :param: location  The `CGPoint` at which the tap occured.
    */
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
                
                audio.playEffect("tap.wav")
            }
            else {
                
                // If the player tapped on the wrong square, move the dominantColor away from its goal.
                dominantColor.right(Float(wrongTapPenalty))
                
                // Move the particleLine to stay with the dominantColor edge.
                particleLine.position.x -= wrongTapPenalty
                
                // Have the color of the incorrectly tapped box flash red.
                let redColor = CCColor(red: 1, green: 0, blue: 0)
                let blackColor = CCColor(red: 0, green: 0, blue: 0)
                
                if yTouch > 0 && yTouch < screenQuartersVertical { // Incorrect tap on Bottom box (box1).
                    blueX1.visible = true
                    blueX1.runAction(CCActionFadeOut(duration: xDelay))
                }
                else if yTouch > screenQuartersVertical && yTouch < (screenQuartersVertical * 2) { // Incorrect tap on Midbottom box (box2).
                    blueX2.visible = true
                    blueX2.runAction(CCActionFadeOut(duration: xDelay))
                }
                else if yTouch > (screenQuartersVertical * 2) && yTouch < (screenQuartersVertical * 3) { // Incorrect tap on Midtop box (box3).
                    blueX3.visible = true
                    blueX3.runAction(CCActionFadeOut(duration: xDelay))
                }
                else if yTouch > (screenQuartersVertical * 3) && yTouch < (screenQuartersVertical * 4) { // Incorrect tap on Top box (box4).
                    blueX4.visible = true
                    blueX4.runAction(CCActionFadeOut(duration: xDelay))
                }
                
                audio.playEffect("buzz.wav")
            }
            
        }
        else if side == .Red { // Red side tapped.
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
                
                audio.playEffect("tap.wav")
            }
            else { // Since this is the red player, when the player taps on the wrong square, move the dominantColor towards its goal.
                dominantColor.left(Float(wrongTapPenalty))
                
                // Move the particleLine to stay with the dominantColor edge.
                particleLine.position.x += wrongTapPenalty
                
                // Have the color of the incorrectly tapped box flash red.
                let redColor = CCColor(red: 1, green: 0, blue: 0)
                let blackColor = CCColor(red: 0, green: 0, blue: 0)
                
                if yTouch > 0 && yTouch < screenQuartersVertical { // Incorrect tap on Bottom box (box4).
                    redX4.visible = true
                    redX4.runAction(CCActionFadeOut(duration: xDelay))
                }
                else if yTouch > screenQuartersVertical && yTouch < (screenQuartersVertical * 2) { // Incorrect tap on Midbottom box (box3).
                    redX3.visible = true
                    redX3.runAction(CCActionFadeOut(duration: xDelay))
                }
                else if yTouch > (screenQuartersVertical * 2) && yTouch < (screenQuartersVertical * 3) { // Incorrect tap on Midtop box (box2).
                    redX2.visible = true
                    redX2.runAction(CCActionFadeOut(duration: xDelay))
                }
                else if yTouch > (screenQuartersVertical * 3) && yTouch < (screenQuartersVertical * 4) { // Incorrect tap on Top box (box1).
                    redX1.visible = true
                    redX1.runAction(CCActionFadeOut(duration: xDelay))
                }
                
                audio.playEffect("buzz.wav")
            }
        }
    }
    
    /**
    Checks at every tap if a Win state has occured as a result of the tap.
    
    Returns a Boolean variable for outside functions to determine if a win occured.
    
    :returns:  Returns `true` if a win occured as a result of the tap. Returns `false` in all other cases.
    */
    func checkIfWin() -> Bool {
        var scale = dominantColor.scaleX
        
        if scale <= -0.01 || scale >= 1.01 {
            
            if scale <= -0.01 {
                redWins()
            }
            else if scale >= 1.01 {
                blueWins()
            }
            
            // Stop all music and play some end-game tunes.
            audio.stopAllEffects()
            audio.playEffect("scratch.wav")
            audio.playBg("outsideBG.wav")
            
            // Change the `gameState` to GameOver to prevent people from continuing to play the game on the now-invisible TileRows.
            gameState = .GameOver
            
            return true
        }
        
        return false
    }
    
    
    // MARK: End-Game Functions

    /**
    To be run whenever a state occurs where red wins.
    
    Triggers end-game animation sequences.
    */
    func redWins() {
        self.userInteractionEnabled = false
        
        fadeOutTileRows()
        
        world.animationManager.runAnimationsForSequenceNamed("RedWins")
        particleLine.stopParticleGeneration()
        
        blueWarningGradient.visible = false
        
        currentWinner = .Red
    }
    
    /**
    To be run whenever a state occurs where blue wins.
    
    Triggers end-game animation sequences.
    */
    func blueWins() {
        println("Blue wins")
        self.userInteractionEnabled = false
        
        fadeOutTileRows()
        
        world.animationManager.runAnimationsForSequenceNamed("BlueWins")
        particleLine.stopParticleGeneration()
        
        redWarningGradient.visible = false
        
        currentWinner = .Blue
    }
    
    /**
    Runs an animation sequence on the `TileRowNodes` to fade them out of view.
    
    `cascadeOpacityEnabled = true` is used to apply the opacity effect to the `tileRows` that are children of the nodes.
    */
    func fadeOutTileRows() {
        blueTileRowNode.cascadeOpacityEnabled = true
        blueTileRowNode.runAction(CCActionFadeOut(duration: 0.3))
        
        redTileRowNode.cascadeOpacityEnabled = true
        redTileRowNode.runAction(CCActionFadeOut(duration: 0.3))
    }
    
    
    // MARK: Button Functions
    
    /**
    Resets the Gameplay to its original state and restarts the game.
    */
    func playAgain() {
        var gameplayScene = CCBReader.load("Gameplay") as! Gameplay
        gameplayScene.animationManager.runAnimationsForSequenceNamed("Gameplay")
        
        var scene = CCScene()
        scene.addChild(gameplayScene)
                
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    /**
    Brings the game back to the mainMenu with some animation for polish.
    */
    func mainMenu() {
        
        if currentWinner == .Blue {
            world.animationManager.runAnimationsForSequenceNamed("BlueTransitionToMenu")
        }
        else if currentWinner == .Red {
            world.animationManager.runAnimationsForSequenceNamed("RedTransitionToMenu")
        }
        
        currentWinner == .None
        userInteractionEnabled = false
        
        delay(1.2) { // We need to stick a delay in here because we need to wait for the `TransitionToMenu` sequence to end before playing the `MainMenu` sequence.
            
            self.world.animationManager.runAnimationsForSequenceNamed("MainMenu")
            
            self.topTitleHolderNode.visible = true
            self.bottomTitleHolderNode.visible = true
            
            self.topTitleHolderNode.cascadeOpacityEnabled = true
            self.bottomTitleHolderNode.cascadeOpacityEnabled = true
            
            var fadeInAction = CCActionFadeIn(duration: 1)
            self.topTitleHolderNode.runAction(fadeInAction)
            self.bottomTitleHolderNode.runAction(fadeInAction)
            
            self.userInteractionEnabled = true
        }
        
        

    }
    
    /**
    Plays the game.
    */
    func play() {
        playAgain()
    }
    
    func options() {
        var optionsMenuScene = CCBReader.load("OptionsMenu") as! OptionsMenu
        optionsMenuScene.animationManager.runAnimationsForSequenceNamed("Default Timeline")

        var scene = CCScene()
        scene.addChild(optionsMenuScene)
        
        var transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
}