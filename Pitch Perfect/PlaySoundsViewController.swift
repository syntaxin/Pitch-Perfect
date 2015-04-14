//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Enrico Montana on 4/11/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class PlaySoundsViewController: UIViewController {
 
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode:AVAudioPlayerNode!
    var audioFile:AVAudioFile!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//Consolidated all effects to use AVAudioEngine only
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile (forReading: receivedAudio.filePathUrl, error:nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func playbackNormal(sender: UIButton) {
        //Alter speed and set rate to 0.5
        
        playbackManipulated("Speed", inputValue: 1.0)
    }
    
    
    @IBAction func playbackSlow(sender: UIButton) {
    //Alter speed and set rate to 0.5
        
        playbackManipulated("Speed", inputValue: 0.50)
    }

    @IBAction func playbackFast(sender: UIButton) {
    //Alter speed and set rate to 1.75

        playbackManipulated("Speed", inputValue: 1.75)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
    //Alter pitch and set to 1000
        
        playbackManipulated("Pitch", inputValue: 1000)
    }
    
    @IBAction func playDarthAudio(sender: UIButton) {
    //Alter pitch and set to -500
        
        playbackManipulated("Pitch", inputValue: -500)
    }
    
    @IBAction func playReverb(sender: UIButton) {
    //Alter reverb and set to 75
        
        playbackManipulated("Reverb", inputValue: 75)
    }
    
    @IBAction func playbackStop(sender: UIButton) {
    //Stop any playback in progress
        
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playbackManipulated (inputType: String, inputValue: float_t) {
    //This function will accept variables from the different buttons
    //This function uses a different effect and connects it to the engine based on user choice
    //The engine then plays the resulting output
        
    
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        
        if (inputType == "Speed"){
            
            var changeEffect = AVAudioUnitVarispeed()
            changeEffect.rate = inputValue
            
            audioEngine.attachNode (changeEffect)
            audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
            audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
            
        }
        
        if (inputType == "Pitch"){
            
            var changeEffect = AVAudioUnitTimePitch()
            changeEffect.pitch = inputValue
            
            audioEngine.attachNode (changeEffect)
            audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
            audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
            
        }
        
        if (inputType == "Reverb"){
            
            var changeEffect = AVAudioUnitReverb()
            changeEffect.wetDryMix = inputValue
            
            audioEngine.attachNode (changeEffect)
            audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
            audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
            
        }
        
    
    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    audioEngine.startAndReturnError(nil)
    audioPlayerNode.play()

    
    }
    

}