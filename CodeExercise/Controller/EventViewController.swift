//
//  ViewController.swift
//  CodeExercise
//
//  Created by Hart on 4/21/21.
//

import UIKit
import SafariServices
class EventViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var eventName:String?
    var imageUrl:String?
    var time:Date?
    var location:String?
    var id:Int?
    var url:String?
    
    var isFavorite:Bool=false
    let defaults = UserDefaults.standard
    var favorites:[String:Bool]=[:]
    
    
    @IBAction func buyTicket(_ sender: Any) {
        NSLog("Buy ticket")
        let vc=SFSafariViewController(url: URL(string: url ?? "")!)
        present(vc, animated: true)
    }
    @IBAction func favoritePressed(_ sender: Any) {
        NSLog("Favorited status changes")
        isFavorite = !isFavorite
        updateFavorite()
        
        
    }
    @IBAction func goBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *){
        }else{
            backButton.setImage(#imageLiteral(resourceName: "chevron_left"), for: .normal)
        }
        //Load favorites
        if let dic=defaults.dictionary(forKey: K.favoriteSetName) as? [String:Bool]{
            favorites=dic
        }
        
        //initial isFavorite
        isFavorite=favorites[String(id!)] ?? false
        updateFavorite()
        
        //set outlets
        titleLabel.text=eventName
        imageView.load(urlString: imageUrl!)
        locationLabel.text=location
        let displayFormatter=DateFormatter()
        displayFormatter.dateFormat="EEEE, dd MMM yyyy \nhh:mm a"
        if time != nil{
            timeLabel.text="\(displayFormatter.string(from: time!))"
        }
    }
    
    //update favorite status of button and store in the dictionary
    func updateFavorite(){
        NSLog("Update Favorite")
        if isFavorite {
            if #available(iOS 13.0, *) {
                favoriteButton.setImage(UIImage(systemName: K.img.favorite), for: .normal)
            } else {
                // Fallback on earlier versions
                favoriteButton.setImage(#imageLiteral(resourceName: "Heart Fill"), for: .normal)
            }
            favorites[String(id!)]=true
        }else{
            if #available(iOS 13.0, *) {
                favoriteButton.setImage(UIImage(systemName:K.img.unfavorite ), for: .normal)
            } else {
                // Fallback on earlier versions
                favoriteButton.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
            }
            favorites[String(id!)]=nil
        }
        //update favorites in user defaults
        UserDefaults.standard.set(favorites, forKey: K.favoriteSetName)
        NSLog("Update Favorite in user defaults")
    }
    
    
}

