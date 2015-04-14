//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Enrico Montana on 4/10/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingStop: UILabel!
    @IBOutlet weak var recordingState: UILabel!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!

    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    

    override func viewWillAppear(animated: Bool) {
        notStartedStateUX()
        
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        //Simple UX Manipulations to prepare the user for their recording session
        
        currentlyRecordingStateUX()
        
        //This block will create the unique sound file that is recorded in the record action
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //Debug option to make sure this is working correctly
        //println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //Actually record the user and put the result into the file
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //This section will prepare the recorded object if successful
        //If the recording failed for whatever reason, we prepare the app to try for another recording
        
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        
        else {
        
            println("Recording was not successful")
            notStartedStateUX()

            }
        
        }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //This is to pass the recorded file to the next view controller
        
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        
        }
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        //This function is to power the stop recording button for the user
        //It will also prepare the app for another recording session
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        notStartedStateUX()
    }
    
    @IBAction func pauseRecordAudio(sender: UIButton) {
        //This function is to power the pause recording button for the user
        //It will also prepare the app to resume recording or stop
        currentlyPausedStateUX()
        audioRecorder.pause()
    }

    @IBAction func resumeRecordAudio(sender: UIButton) {
        //This function is to power the resume recording button for the user
        //It will also prepare the app to pause or stop
        
        currentlyRecordingStateUX()
        audioRecorder.record()
        
    }
    
//The below functions were addded to simplify
//the UX state management across
//multiple actions being taken by the user
//such as pre-start, paused, failed and re-start
    
    func notStartedStateUX () {
        pauseButton.hidden=true
        resumeButton.hidden=true
        stopButton.hidden=true
        microphoneButton.enabled=true
        recordingStop.hidden=true
        recordingState.hidden=true
        recordingLabel.text="Tap to Record"
        recordingLabel.textColor = UIColor.blueColor()
    }
    
    func currentlyRecordingStateUX () {
        microphoneButton.enabled = false
        stopButton.hidden = false
        pauseButton.hidden = false
        resumeButton.hidden = true
        recordingStop.hidden = false
        recordingState.hidden = false
        recordingLabel.text = "Recording..."
        recordingStop.text = "Tap to Stop"
        recordingState.text = "Pause"
        recordingLabel.textColor = UIColor.grayColor()
        recordingStop.textColor = UIColor.blueColor()
        recordingState.textColor = UIColor.blueColor()
        
    }
    
    func currentlyPausedStateUX () {
        
        pauseButton.hidden = true
        resumeButton.hidden = false
        recordingLabel.text = "Recording Paused"
        recordingState.text="Tap to Resume"

    }



}