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
    
    var eventName:String?
    var imageUrl:String?
    var time:Date?
    var location:String?
    var id:Int?
    var url:String?
    
    var isFavorite:Bool=false
    let defaults = UserDefaults.standard
    
    
    @IBAction func buyTicket(_ sender: Any) {
        let vc=SFSafariViewController(url: URL(string: url ?? "")!)
        present(vc, animated: true)
    }
    @IBAction func favoritePressed(_ sender: Any) {
        
        isFavorite = !isFavorite
        updateFavorite()
            
        
    }
    @IBAction func goBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    var favorites:[String:Bool]=[:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        if let d=defaults.object(forKey: K.favoriteSetName){
//                set=d as! Set<Int>
//        }
        
        defaults.dictionary(forKey: K.favoriteSetName)
        
        
        if let dic=defaults.dictionary(forKey: K.favoriteSetName) as? [String:Bool]{
            favorites=dic
        }
        
        isFavorite=favorites[String(id!)] ?? false
        
        updateFavorite()
        
        
        titleLabel.text=eventName
        imageView.load(urlString: imageUrl!)
        
        locationLabel.text=location
    
        let displayFormatter=DateFormatter()
        displayFormatter.dateFormat="EEEE, dd MMM yyyy \nhh:mm a"
        if time != nil{
            timeLabel.text="\(displayFormatter.string(from: time!))"
        }
    }
    
    
    func updateFavorite(){
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: K.img.favorite), for: .normal)
            favorites[String(id!)]=true
        }else{
            favoriteButton.setImage(UIImage(systemName:K.img.unfavorite ), for: .normal)
            favorites[String(id!)]=nil
        }
//        let test:Set=[1,0]
//        SearchViewControll().favorites=set
        UserDefaults.standard.set(favorites, forKey: K.favoriteSetName)
//        if !set.isEmpty{
//            UserDefaults.standard.set(set, forKey: K.favoriteSetName)
//        }
    }


}

