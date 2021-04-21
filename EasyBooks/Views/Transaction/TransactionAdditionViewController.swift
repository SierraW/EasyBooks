//
//  TransactionAdditionViewController.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-03-29.
//

import UIKit
import CoreData
import Speech
import AVFoundation

class TransactionAdditionViewController: UIViewController, CurrencyUnitViewControllerDataSource, BunnyManageViewControllerDataSource, TagViewControllerDataSource, UITextFieldDelegate, EventViewControllerDataSource, AVAudioRecorderDelegate {
    
    func checkExist(with name: String) -> Bool {
        return false
    }
    
    var bunny: EBBunny? {
        didSet {
            bunnyButton.setTitle(bunny?.name, for: .normal)
        }
    }
    
    var currencyUnit: EBCurrencyUnit? {
        didSet {
            unitButton.setTitle(currencyUnit?.prefix, for: .normal)
        }
    }
    
    var tag: EBTag? {
        didSet {
            tagButton.setTitle(tag?.name, for: .normal)
        }
    }
    
    var event: EBEvent? {
        didSet {
            eventButton.setTitle(event?.name, for: .normal)
            bunnyButton.isHidden = false
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var bunnyButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var unitButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    ///
    // Recored audio
    private var file: Int = 0
    private var audioSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    
    // Convert speech to text
    private let speechRecognizer = SFSpeechRecognizer(locale:
                Locale(identifier: "en-US"))!
    private var speechRecognitionRequest:
            SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var outputText: String?
    ///
    
    let alertController: AlertController? = CompleteAlertController()
    let amountTextFieldController = AmountTextFieldController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountTextField.textAlignment = .right
        amountTextField.addTarget(amountTextFieldController, action: #selector(amountTextFieldController.textFieldDidChange(_:)), for: .editingChanged)
        amountTextField.delegate = self

        addButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        bunnyButton.addTarget(self, action: #selector(presentBunnyManageVC), for: .touchUpInside)
        unitButton.addTarget(self, action: #selector(presentCurrencyUnitManageVC), for: .touchUpInside)
        tagButton.addTarget(self, action: #selector(presentTagManageVC), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(presentEventVC), for: .touchUpInside)
        bunnyButton.isHidden = true
        
        self.audioSessionPermission()
        self.requestTranscribePermissions()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc func handleSubmit() {
        if let warnings = checkFields() {
            var warningsMsg = "Please check the following fields: "
            for warning in warnings {
                warningsMsg.append("\(warning) ")
            }
            if let alertController = alertController {
                self.present(alertController.get(with: nil, instruction: "One or more fields empty.", handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }), animated: true, completion: nil)
            }
            return
        }
        let trans = NSEntityDescription.insertNewObject(forEntityName: "EBTransaction", into: context) as! EBTransaction
        trans.amount = amountTextFieldController.getAmount() as NSDecimalNumber?
        trans.des = descriptionTextField.text
        trans.bunny = bunny
        trans.unit = currencyUnit
        trans.tag = tag
        trans.event = event
        do {
            try context.save()
            if let alertController = alertController {
                self.present(alertController.get(with: nil, instruction: "Successfully added person", handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }), animated: true, completion: nil)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkFields() -> [String]? {
        return nil
    }
    
//    @objc func presentExampleVC() {
//        let vc = ViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//
////        vc.modalPresentationStyle = .fullScreen
////        present(vc, animated: true, completion: nil)
//    }
    
    @objc func presentEventVC() {
        let vc = EventViewController()
        vc.dataSource = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentBunnyManageVC() {
        let vc = BunnyManageViewController()
        vc.dataSource = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentCurrencyUnitManageVC() {
        let vc = CurrencyUnitViewController()
        vc.dataSource = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentTagManageVC() {
        let vc = TagViewController()
        vc.dataSource = self
        self.present(vc, animated: true, completion: nil)
    }
    
    ///
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
                switch authStatus {
                case .authorized:
                    print("Good to go!")
                case .denied:
                    print("Speech recognition authorization denied")
                case .restricted:
                        print("Not available on this device")
                default:
                    print("Transcription permission was declined.")
                
            }
        }
    }
    
    func audioSessionPermission(){
        audioSession = AVAudioSession.sharedInstance()
        
        do{
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch{
            print(error)
        }
        
        // Check permission
        AVAudioSession.sharedInstance().requestRecordPermission{ (hasPermission) in
            if hasPermission{
                let alertController = UIAlertController(title: "Press mic to speak", message: "Please record for description", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) {
                    UIAlertAction in
                    print("Recording....")
                }
                
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            }
        }
        
        // check any saved text file
        if let num: Int = UserDefaults.standard.object(forKey: "recording") as? Int{
            file = num
        }
    }
    
    @IBAction func recordBTN(sender: Any){
        if self.audioEngine.isRunning {
            self.audioEngine.stop()
            self.speechRecognitionRequest?.endAudio()
            self.speechRecognitionTask?.cancel()
            self.speechRecognitionTask = nil
        } else {
            self.speechRecorder()
        }
        self.audioRecording()
    }
    
    // get path to dir
    func getDir() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDir = path[0]
        
        return documentDir
    }
    
    func audioRecording(){
        
        if audioRecorder == nil {
            file = 1
            let filename = getDir().appendingPathComponent("\(file).m4a")
            let settings = [AVSampleRateKey: 12000,
                            AVNumberOfChannelsKey: 1,
                            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // recording started
            do {
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                print("Recording now")
            }
            catch {
                let alertController = UIAlertController(title: "Error", message: "Please try again", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            }
        } else{ // stop recording
            audioRecorder.stop()
            audioRecorder = nil
            
            // saving...
            UserDefaults.standard.set(file, forKey: "recording")
            let alertController = UIAlertController(title: "Message", message: "Recording saved", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                self.descriptionTextField.text = self.outputText
            })
            
            
            
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
            
        }
    }
    func speechRecorder(){
        // Stop task if running state
        if speechRecognitionTask != nil {
            speechRecognitionTask?.cancel()
            speechRecognitionTask = nil
        }
        
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let input = audioEngine.inputNode
        
        guard let speechRecognitionRequest = speechRecognitionRequest else {
            print("There was an error in recognition")
            fatalError("There was an error in recognition")
        }
        
        speechRecognitionRequest.shouldReportPartialResults = true
        
        speechRecognitionTask = speechRecognizer.recognitionTask(with: speechRecognitionRequest, resultHandler: {(result, error) in
            
            var textResult = false
            
            if result != nil {
                self.outputText = result?.bestTranscription.formattedString
                print(self.outputText!)
                textResult = (result?.isFinal)!
            }
            
            if error != nil || textResult {
                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil
                self.audioEngine.stop()
                input.removeTap(onBus: 0)
            }
        })
        
        let recordFormat = input.outputFormat(forBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: recordFormat) { (buffer, when) in
            self.speechRecognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch {
            print("Audio Engine error")
        }
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
