# Tile, Tap, Push!

####...is now on the App Store! Download it from the [App Store](https://itunes.apple.com/us/app/tile-tap-push!/id1016306913?ls=1&mt=8) today!

## Game Design

### Objective
Tap randomly generating patterns of white and black tiles as fast as possible than your opponent.

### Gameplay Mechanics
Players will have to tap the white tile on randomly generating rows of white and black tiles. Each correct tap on a white tile will move a line closer to the opponent. Conversely, every incorrect tap on a black tile will move the line back towards the player. In order to make the players concentrate a little bit more on accuracy, the reward for getting a tap correctly should be less than the penalty for tapping incorrectly.

In the single-player mode, the opponent will be played by the computer. The computer's "tap rate" will get significantly faster as the game progresses. The "tap rate" will increase in one of two ways: 1) when the current difficulty has been played for 15 seconds, or 2) when the player hits the top with the line. A point will be given for every computer "tap". In order to incentive players for hitting the top of the screen faster, a "speed bonus" will be given proportional to the difficulty of the level and the amount of points remaining in the level. The difficulty curve of single-player mode should be such that a new player can easily have enough time to make a couple of mistakes and still survive the first two difficulty levels, but get quickly steeper in order to let veteran players quickly get into a speed that best suits them. 

### Level Design
There are no levels; only a two-player and one-player game mode.

## Technical

### Scenes
* Main Menu
* Single Player
* Two Player
* Options Menu
* Credits

### Controls/Input
* Tap based controls
  * Tap on one tile
  * Tap on two tiles
  * Tap on white tiles
  * Tap on black tiles

### Classes/CCBs
* Scenes
  * Main Menu
  * Options Menu
  * Single Player
  * Two Player
  * Credits
* Nodes/Sprites
  * Particle Line
  * Tile Row
  * And a whole bunch of CCColorNodes

## MVP Milestones

### Day 1
* Finish MVP

### Days 2 - ??
* Add a bunch of unnecessarily complex features and animations without any planning whatsoever and cross our fingers that they work
* ???
* Profit!
