//
//  HomeDetailsVC.swift
//  AppscripDemo
//
//  Created by Jigar on 20/11/20.
//

import UIKit

protocol HomeDetailsVCDelegate {
    func selectedSubCatgory(selSubCategory:FoodSubCategoryData,indexPath:IndexPath)
}

class HomeDetailsVC: UIViewController {

    @IBOutlet var imgSubCategory: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var btnClick: UIButton!
    var delegate: HomeDetailsVCDelegate? = nil
    var subcategorydata : FoodSubCategoryData? = nil
    var indexPath : IndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblName.text = subcategorydata?.sub_category_name ?? ""
        self.lblDesc.text = subcategorydata?.description ?? ""
        self.imgSubCategory.image = UIImage(named: "\(subcategorydata?.sub_category_imagename ?? "")")
        if subcategorydata?.is_checked ?? true {
            self.btnClick.layer.borderWidth = 1
            self.btnClick.layer.borderColor = UIColor.red.cgColor
        }
    }
    

    @IBAction func btnTapped(_ sender: UIButton) {
        subcategorydata?.is_checked?.toggle()
        if delegate != nil{
            self.delegate?.selectedSubCatgory(selSubCategory: subcategorydata!, indexPath: indexPath!)
            self.dismiss(animated: true, completion: nil)
        }
    }

}
