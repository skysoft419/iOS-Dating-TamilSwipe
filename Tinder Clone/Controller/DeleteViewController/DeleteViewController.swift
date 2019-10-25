//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
import UIKit


class DeleteViewController: RootBaseViewcontroller {
    
    @IBOutlet weak var pause_Btn: UIButton!
    
    override func viewDidLoad()
    
     {
        
      }
    
    override func didReceiveMemoryWarning() {
        
    }
    @IBAction func DidclickDelete(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
