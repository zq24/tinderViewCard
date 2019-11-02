//
//  MainPageViewController.swift
//  TinderViewCard
//
//  Created by Zhaoming Qin on 11/1/19.
//  Copyright © 2019 Zhaoming. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var jobTypeTextField: UITextField!
    @IBOutlet weak var jobLocationTextField: UITextField!
    @IBOutlet weak var card: CardView!
    @IBOutlet weak var cardTwo: CardView!
    var divisor: CGFloat!
    
    var img: [UIImageView] = [UIImageView(image: UIImage(named: "ThumbsDown")), UIImageView(image: UIImage(named: "ThumbsUp"))]
    
    var Jobs: [Job] = []
    var url = URLHead(description: nil, location: nil)
    
    var cards: [CardView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        divisor = (view.frame.width / 2) / 0.61
        // Do any additional setup after loading the view.
        getData(is_init: true)
        while Jobs.count == 0 {}
        
        //for i in 0..<Jobs.count {
            
        //}
        card.jobDescriptionTextView.text = Jobs[0].description
        cardTwo.jobDescriptionTextView.text = Jobs[1].description
    }
    
    // Only within this card view
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        print("card tag: " + "\(card.tag)")
        
        // In mathematics, translation refers to moving an object without changing it in any other way.
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor).scaledBy(x: scale, y: scale)
        
        var index: Int = 0
        img[0].tag = 0
        img[1].tag = 1
        
        // check to see if the card was dragged to right or left
        if xFromCenter > 0 {
            index = 1
            card.addSubview(self.img[index])
            self.img[index].tintColor = .green
            self.img[0 - index + 1].alpha = 0
//            self.img[0 - index + 1].removeFromSuperview()
        } else {
            index = 0
            card.addSubview(self.img[index])
            self.img[index].tintColor = .red
            self.img[0 - index + 1].alpha = 0
        }
        
        
        // thumbImageView.alpha = abs(xFromCenter / view.center.x)
        img[index].alpha = abs(xFromCenter / view.center.x)
        
        // Only move back to the center when stop touching the screen
        if sender.state == UIGestureRecognizer.State.ended {
            
            // check whether if the card has being dragged to the point where it can automatically go off the screen.
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }
                return
            } else if card.center.x > (view.frame.width - 75) {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }
                return
            }
            
            UIView.animate(withDuration: 0.2) {
                card.center = self.view.center
                // self.thumbImageView.alpha = 0
                self.img[index].alpha = 0
                self.img[0 - index + 1].alpha = 0
                card.transform = .identity
            }
        }
        
        print(card.subviews.count)
    }
    
    func getData(is_init: Bool) {
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
            
        var str_url = self.url.head
            
    //        str_url += "lat=\(curLocation!.coordinate.latitude)&long=\(curLocation!.coordinate.longitude)"
            
        if is_init {
            str_url += "lat=37.3229978&long=-122.0321823"
        }
        else {
            if self.url.description != nil {
                str_url += "description=\(self.url.description!)&"
            }
            if self.url.location != nil {
                str_url += "description=\(self.url.location!)"
            }
        }
        print(str_url)
        
        let url_to_send = URL(string: str_url)!
        
        let task = mySession.dataTask(with: url_to_send) { data, response, error in

            guard error == nil else {
                print("error: \(error!)")
                return
            }
                       
            guard let content = data else {
                print("no data!")
                return
            }
                    
            let decoder = JSONDecoder()
            do {
                self.Jobs = try decoder.decode([Job].self, from: content)
                DispatchQueue.main.async {
                    self.card.jobDescriptionTextView.text = self.Jobs[0].description
                    self.cardTwo.jobDescriptionTextView.text = self.Jobs[1].description
                }
                print(self.Jobs[0].how_to_apply)
                print("Got all the data into allTodos!")
            }
            catch {
                print("JSON Decode error")
            }
        }
        task.resume()
    }
    var times = 0;
    @IBAction func search(_ sender: Any) {
        times += 1
        if jobTypeTextField == nil && jobLocationTextField == nil {
            // give an alert
        }
        url.description = jobTypeTextField.text!
        url.location = jobLocationTextField.text!
        getData(is_init: false)
        // refresh view
        while self.Jobs.count == 0 {}
        
        print("this is No.\(times) call for update")
        // update cards
        //DispatchQueue.main.async { [weak self] in
        //    self?.card.jobDescriptionTextView.text = self?.Jobs[0].description
        //    self?.cardTwo.jobDescriptionTextView.text = self?.Jobs[1].description
        //    self?.card.layoutSubviews()
//            self?.card.setNeedsLayout()
//            self?.card.layoutIfNeeded()
//            self?.card.setNeedsLayout()
//            self?.cardTwo.layoutIfNeeded()
        //}
    }
}
