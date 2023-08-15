//
//  HomeViewController.swift
//  ToDoList
//
//  Created by Shqiperon Sadiku on 9.8.23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        // Do any additional setup after loading the view.
    }

    private func animateLabelFromTop() {
        titleLabel.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height)
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseInOut, animations: {
            self.titleLabel.transform = .identity
        }, completion: nil)
    }
    
    private func animateButtonFromBottom() {
        startButton.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseInOut, animations: {
            self.startButton.transform = .identity
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animate the appearance of the titleLabel and startButton with a fade-in animation
        UIView.animate(withDuration: 0.5) {
            self.titleLabel.alpha = 1
            self.startButton.alpha = 1
        }
    }
    
}
