//
//  SliderCollectionView.swift
//  Tablviewcreator
//
//  Created by Vaigunda Anand M on 3/18/17.
//  Copyright © 2017 RoomBoys. All rights reserved.
//

import UIKit
import SDWebImage
protocol  SliderCollectionViewDelegate{
    func  IndexforPageControl(index:Int)
}

class SliderCollectionView: UICollectionView {
    enum SliderCategory {
        case header
        case list
        case mainSlider
        case planSlider
        case story
        case profile
        case _default
    }
    var Delegate:SliderCollectionViewDelegate?
     var Header_Data_Source:NSMutableArray = NSMutableArray()
    var List_data_source:NSMutableArray = NSMutableArray()
    var isGold = Bool()

    var Paging_Enabled:Bool=Bool()
    var Slidercat: SliderCategory = ._default

 
     override func awakeFromNib() {
        self.register(UINib(nibName:"SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SliderCollectionViewCellID")
        self.register(UINib(nibName:"ProfileSliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileSliderCollectionViewCellID")
        self.register(UINib(nibName:"PlanSliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlanSliderCollectionViewCellID")
        
        self.clipsToBounds = true
        self.dataSource=self
        self.delegate=self
        
 
    }
  
    func DidclickOrderBtn(sender:UIButton)
    {
        print("\(sender.tag)")
    }
    func ReloadSlider()
    {
        self.isPagingEnabled = Paging_Enabled;
          self.reloadData()
    }
    
  }
extension SliderCollectionView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
       
        return UIEdgeInsetsMake(0, 0, 0, 0)

        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(Slidercat == .header || Slidercat == .mainSlider || Slidercat == .story || Slidercat == .profile)
        {
        return self.Header_Data_Source.count
        }
       else if(Slidercat == .list)
        {
            return self.List_data_source.count
        }
        else if(Slidercat == .planSlider)
        {
            return self.List_data_source.count
        }
        else
        {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell=UICollectionViewCell()
        let row=indexPath.row
        if(Slidercat == .header || Slidercat == .mainSlider || Slidercat == .story || Slidercat == .profile)
        {
        // get a reference to our storyboard cell
         let Headercell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCellID", for: indexPath as IndexPath) as! SliderCollectionViewCell
        let objRecord:SliderRecord=Header_Data_Source[indexPath.row] as! SliderRecord
            if(Slidercat == .mainSlider)
            {
                Headercell.SetSliderdata(objRecord: objRecord)
            }else if Slidercat == .story{
                Headercell.setStoryData(objRecord: objRecord)
            }else if Slidercat == .profile{
                Headercell.profile=true
                print(Headercell.frame.height)
                Headercell.setProfileData(objRecord: objRecord)
            }
            else
            {
         Headercell.Setdata(objRecord: objRecord)
            }
      
            cell = Headercell
        }
        if(Slidercat == .list)
        {
            let ListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileSliderCollectionViewCellID", for: indexPath as IndexPath) as! ProfileSliderCollectionViewCell
            let objRecord:SliderRecord=List_data_source[indexPath.row] as! SliderRecord
            ListCell.indexpath = indexPath

            ListCell.Setdata(objRecord: objRecord)
            
            cell = ListCell

            
        }
        else if(Slidercat == .planSlider)
        {
            let ListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanSliderCollectionViewCellID", for: indexPath as IndexPath) as! PlanSliderCollectionViewCell
            let objRecord:SliderRecord=List_data_source[indexPath.row] as! SliderRecord
            ListCell.indexpath = indexPath
            
            ListCell.Setdata(objRecord: objRecord, isGold: isGold)
            
            cell = ListCell
            
            
        }
    
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = self.indexPathForItem(at: center) {
            self.Delegate?.IndexforPageControl(index: ip.row)
        }
    }
   

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if(Slidercat == .header || Slidercat == .mainSlider)
        {
            if Slidercat == .mainSlider {
                return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
            }
    return CGSize(width: collectionView.frame.size.width, height: self.frame.size.height)
        }
            
        else
        {
            return CGSize(width: self.frame.size.width, height: self.frame.size.height)

        }
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }

 

    

    
}
