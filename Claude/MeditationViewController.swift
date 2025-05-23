//
//  MeditationViewController.swift
//  Claude
//
//  Created by Jack Gavin on 5/22/25.
//


// MeditationViewController.swift
// I chose to build a meditation timer app because I believe technology should serve human wellbeing.
// This app creates a peaceful digital space for mindfulness practice, combining beautiful visuals
// with functional simplicity to support users' mental health and inner peace.

import UIKit

class MeditationViewController: UIViewController {
    
    // MARK: - Properties
    private var meditationTimer: Timer?
    private var totalDuration: TimeInterval = 300 // 5 minutes default
    private var remainingTime: TimeInterval = 300
    private var isTimerRunning = false
    
    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let circularProgressView = CircularProgressView()
    private let breathingGuideView = BreathingGuideView()
    private let durationSlider = UISlider()
    private let durationLabel = UILabel()
    private let startPauseButton = UIButton()
    private let resetButton = UIButton()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        updateTimeDisplay()
        updateDurationLabel()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // Create gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1.0).cgColor,
            UIColor(red: 0.88, green: 0.92, blue: 0.96, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Title
        titleLabel.text = "Serene Timer"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .thin)
        titleLabel.textColor = UIColor(red: 0.3, green: 0.4, blue: 0.6, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Time display
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 48, weight: .light)
        timeLabel.textColor = UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 1.0)
        timeLabel.textAlignment = .center
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeLabel)
        
        // Circular progress view
        circularProgressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circularProgressView)
        
        // Breathing guide view
        breathingGuideView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(breathingGuideView)
        
        // Duration controls
        durationLabel.text = "Duration: 5:00"
        durationLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        durationLabel.textColor = UIColor(red: 0.4, green: 0.5, blue: 0.7, alpha: 1.0)
        durationLabel.textAlignment = .center
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(durationLabel)
        
        durationSlider.minimumValue = 1
        durationSlider.maximumValue = 60
        durationSlider.value = 5
        durationSlider.tintColor = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 1.0)
        durationSlider.addTarget(self, action: #selector(durationSliderChanged), for: .valueChanged)
        durationSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(durationSlider)
        
        // Control buttons
        startPauseButton.setTitle("Start", for: .normal)
        startPauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        startPauseButton.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 1.0)
        startPauseButton.setTitleColor(.white, for: .normal)
        startPauseButton.layer.cornerRadius = 25
        startPauseButton.addTarget(self, action: #selector(startPauseButtonTapped), for: .touchUpInside)
        startPauseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startPauseButton)
        
        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        resetButton.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.3)
        resetButton.setTitleColor(UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0), for: .normal)
        resetButton.layer.cornerRadius = 20
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Circular progress view
            circularProgressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circularProgressView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            circularProgressView.widthAnchor.constraint(equalToConstant: 280),
            circularProgressView.heightAnchor.constraint(equalToConstant: 280),
            
            // Time label (centered in progress view)
            timeLabel.centerXAnchor.constraint(equalTo: circularProgressView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: circularProgressView.centerYAnchor),
            
            // Breathing guide (centered in progress view)
            breathingGuideView.centerXAnchor.constraint(equalTo: circularProgressView.centerXAnchor),
            breathingGuideView.centerYAnchor.constraint(equalTo: circularProgressView.centerYAnchor, constant: 60),
            breathingGuideView.widthAnchor.constraint(equalToConstant: 80),
            breathingGuideView.heightAnchor.constraint(equalToConstant: 80),
            
            // Duration controls
            durationLabel.topAnchor.constraint(equalTo: circularProgressView.bottomAnchor, constant: 40),
            durationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            durationSlider.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 10),
            durationSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            durationSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // Control buttons
            startPauseButton.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 30),
            startPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startPauseButton.widthAnchor.constraint(equalToConstant: 120),
            startPauseButton.heightAnchor.constraint(equalToConstant: 50),
            
            resetButton.topAnchor.constraint(equalTo: startPauseButton.bottomAnchor, constant: 15),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 100),
            resetButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Actions
    @objc private func durationSliderChanged() {
        let minutes = Int(durationSlider.value)
        totalDuration = TimeInterval(minutes * 60)
        remainingTime = totalDuration
        updateDurationLabel()
        updateTimeDisplay()
        circularProgressView.setProgress(0, animated: false)
    }
    
    @objc private func startPauseButtonTapped() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        if isTimerRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }
    
    @objc private func resetButtonTapped() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        resetTimer()
    }
    
    // MARK: - Timer Methods
    private func startTimer() {
        isTimerRunning = true
        startPauseButton.setTitle("Pause", for: .normal)
        durationSlider.isEnabled = false
        
        breathingGuideView.startBreathingAnimation()
        
        meditationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.startPauseButton.backgroundColor = UIColor(red: 0.9, green: 0.6, blue: 0.5, alpha: 1.0)
        }
    }
    
    private func pauseTimer() {
        isTimerRunning = false
        meditationTimer?.invalidate()
        startPauseButton.setTitle("Resume", for: .normal)
        
        breathingGuideView.stopBreathingAnimation()
        
        UIView.animate(withDuration: 0.3) {
            self.startPauseButton.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 1.0)
        }
    }
    
    private func resetTimer() {
        isTimerRunning = false
        meditationTimer?.invalidate()
        remainingTime = totalDuration
        
        startPauseButton.setTitle("Start", for: .normal)
        durationSlider.isEnabled = true
        
        breathingGuideView.stopBreathingAnimation()
        circularProgressView.setProgress(0, animated: true)
        updateTimeDisplay()
        
        UIView.animate(withDuration: 0.3) {
            self.startPauseButton.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 1.0)
        }
    }
    
    private func updateTimer() {
        remainingTime -= 1
        
        let progress = 1.0 - (remainingTime / totalDuration)
        circularProgressView.setProgress(progress, animated: false)
        updateTimeDisplay()
        
        if remainingTime <= 0 {
            timerCompleted()
        }
    }
    
    private func timerCompleted() {
        resetTimer()
        
        // Haptic feedback for completion
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        
        // Simple completion alert
        let alert = UIAlertController(title: "Session Complete", message: "Your meditation session is finished. Take a moment to notice how you feel.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Thank you", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Helper Methods
    private func updateTimeDisplay() {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        timeLabel.text = String(format: "%d:%02d", minutes, seconds)
    }
    
    private func updateDurationLabel() {
        let minutes = Int(durationSlider.value)
        durationLabel.text = String(format: "Duration: %d:00", minutes)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update gradient frame
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
}