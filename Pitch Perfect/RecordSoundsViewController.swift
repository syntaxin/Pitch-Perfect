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
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
   
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    

    override func viewWillAppear(animated: Bool) {
        pauseButton.hidden=true
        resumeButton.hidden=true
        stopButton.hidden=true
        recordingLabel.text="Tap to Record"
        microphoneButton.enabled=true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        //Simple UX Manipulations to prepare the user for their recording session
        microphoneButton.enabled = false
        stopButton.hidden = false
        recordingLabel.text = "Recording..."
        pauseButton.hidden = false
        
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
            recordingLabel.text = "Tap to Record"
            microphoneButton.enabled = true
            stopButton.hidden = true

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
        
        recordingLabel.text = "Tap to Record"
        microphoneButton.enabled = true
        stopButton.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func pauseRecordAudio(sender: UIButton) {
        //This function is to power the pause recording button for the user
        //It will also prepare the app to resume recording or stop
        
        recordingLabel.text = "Recording paused"
        pauseButton.hidden = true
        resumeButton.hidden = false
        audioRecorder.pause()

    
    }

    @IBAction func resumeRecordAudio(sender: UIButton) {
        //This function is to power the resume recording button for the user
        //It will also prepare the app to pause or stop
        
        recordingLabel.text = "Recording..."
        resumeButton.hidden = true
        pauseButton.hidden = false
        audioRecorder.record()
        
    }



}