//
//  LikeCollectionVC.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.

import UIKit

class LikeCollectionVC: RootBaseViewcontroller {
    @IBOutlet weak var likecount: UILabel!
    @IBOutlet weak var goldlike_img: UIImageView!
    @IBOutlet weak var collectionView:UICollectionView!
    
    var datasource:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        if(datasource.count > 0)
        {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        }
        else
        {
            collectionView.isHidden = true
        }
        likecount.text = "\(datasource.count) likes"
        if(datasource.count == 0 || datasource.count == 1)
        {
            likecount.text = "\(datasource.count) like"

        }
         // Do any additional setup after loading the view.
    }
  override func  viewDidLayoutSubviews()
    {
    Themes.sharedIntance.AddBorder(view: goldlike_img, borderColor: nil, borderWidth: nil, cornerradius: goldlike_img.frame.size.width/2)
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.collectionView.layoutIfNeeded()

            self.collectionView.reloadData()

        }
    }
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func DidclickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LikeCollectionVC:UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height: CGFloat = view.frame.size.height
    let width: CGFloat = view.frame.size.width
    // in case you you want the cell to be 40% of your controllers view
    return CGSize(width: width * 0.482, height: height * 0.49)
}
// MARK: - UICollectionViewDataSource protocol
// tell the collection view how many cells to make
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return datasource.count
}

// make a cell for each cell index path
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    // get a reference to our storyboard cell
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoldLikeCollectionViewCellID", for: indexPath as IndexPath) as! GoldLikeCollectionViewCell
    cell.ReloadContainer()
    return cell
}

// MARK: - UICollectionViewDelegate protocol

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // handle tap events
    print("You selected cell #\(indexPath.item)!")
}
}

