//
//  ParticleLine.swift
//  TapTap
//
//  Created by Zachary Espiritu on 6/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class ParticleLine: CCNode {
    
    // MARK: Variables
    
    weak var redParticles: CCParticleSystem!
    weak var blueParticles: CCParticleSystem!
    
    // MARK: Functions
    
    /**
    Stops the generation of the particles from a `ParticleLine` object.
    
    For whatever reasons that I still don't really know about (and, quite frankly, don't care about right now), there's no need for a `startParticleGeneration()` function because it ends up restarting itself. This might be due to the Default Timeline in Spritebuilder automatically restarting when the `MainScene.ccb` is reloaded.
    */
    func stopParticleGeneration() {
        redParticles.stopSystem()
        blueParticles.stopSystem()
    }
    
}