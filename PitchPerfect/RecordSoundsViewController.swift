//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Tracy Adams on 9/12/23.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {


    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        
    }
    
    // MARK: Button Functionality and Delegate 
    
    @IBAction func recordAudio(_ sender: UIButton) {
        
        helper(flag: false)
        
        //recording code provided
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))

            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            //setting delegate here
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        
        helper(flag: true)

        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("recording was not successful")
        }
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
    }
    
    // MARK: Helper Functions
    
    //toggle UI
    func helper(flag: Bool){
        recordButton.isEnabled = flag
        stopRecordingButton.isEnabled = !flag
        if flag{
            recordLabel.text = "Tap to Record"
        }else{
            recordLabel.text =  "Recording in Progress"
        }
        
    }
}

