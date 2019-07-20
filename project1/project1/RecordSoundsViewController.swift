//
//  RecordSoundsViewController.swift
//  project1
//
//  Created by vikas on 05/06/19.
//  Copyright © 2019 project1. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    func configureUI(isRecording: Bool){
        if (isRecording){
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text="Tap to Record"
        }
        else{
            recordingLabel.text="Recording in Progress"
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
   
    @IBAction func recordAudio(_ sender: Any) {
        
        self.configureUI(isRecording: false)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        self.configureUI(isRecording: true)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag
        {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordAudioURL
        }
    }
}

