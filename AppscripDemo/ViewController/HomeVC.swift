//
//  HomeVC.swift
//  AppscripDemo
//
//  Created by Jigar on 19/11/20.
//

import UIKit

struct foodinfo {
    var title : String?
    var bannerImages : [String]
    var fooddata : FoodData?
}



class HomeVC: UIViewController {

    var bannerImages = [String]()
    var arrFoodData = [FoodData]()
    var sectionData = [foodinfo]()

    @IBOutlet var tblView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Get Food Data From Json
        arrFoodData = getStaticJsonFoodData()
        
        let bannerInfo = foodinfo(title: "", bannerImages: ["1","2","3","4"], fooddata: nil)
        sectionData.append(bannerInfo)
        for i in 0..<arrFoodData.count{
            let foodInfo = foodinfo(title: "", bannerImages: [], fooddata: arrFoodData[i])
            sectionData.append(foodInfo)

        }
        
        let headerNib = UINib.init(nibName: "HeaderView", bundle: Bundle.main)
        tblView.register(headerNib, forHeaderFooterViewReuseIdentifier: "HeaderView")

        
        tblView.reloadData()
    }
    
}

extension HomeVC{

    func getStaticJsonFoodData() -> [FoodData]{
        guard let url = Bundle.main.url(forResource: "Food", withExtension: "json") else { return [] }
        guard let data = try? Data(contentsOf: url) else { return [] }
        guard let jsonData = try? JSONDecoder().decode(FoodResult.self, from: data) else { return [] }
        if let foodData = jsonData.data , foodData.count > 0 {
            return foodData
        }
        return []
    }
}

// MARK:- Extension: UITableViewDataSource

extension HomeVC : UITableViewDataSource , UITableViewDelegate {
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
           
            return sectionData[section].fooddata?.is_Expand ?? true ? sectionData[section].fooddata?.sub_category?.count ?? 0 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return cellForBanner(tableView, indexPath,objectdata: sectionData[indexPath.section].bannerImages)

        }else{
            return cellForFoodCategory(tableView, indexPath,objectdata: (sectionData[indexPath.section].fooddata?.sub_category)!)

        }
    }
    
    
    func cellForBanner( _ tableView : UITableView, _ indexPath : IndexPath,objectdata:[String]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblBannerCell") as! tblBannerCell
        cell.arrBannerImage = objectdata
        return cell
    }

    func cellForFoodCategory( _ tableView : UITableView, _ indexPath : IndexPath,objectdata:[FoodSubCategoryData]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblCustomCell") as! tblCustomCell
        let objectData = objectdata[indexPath.row]
        cell.lblFoodCategoryName.text = objectData.sub_category_name ?? ""
        cell.imgFoodCategory.image = UIImage(named: "\(objectData.sub_category_imagename ?? "")")

        cell.imgFoodCategory.alpha = objectData.is_checked ?? true ? 0.4 : 1.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextvc = storyBoard.instantiateViewController(withIdentifier: "HomeDetailsVC") as! HomeDetailsVC
        nextvc.delegate = self
        nextvc.indexPath = indexPath
        nextvc.subcategorydata = self.sectionData[indexPath.section].fooddata?.sub_category?[indexPath.row]
        self.present(nextvc, animated:true, completion:nil)

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
        
        headerView.lblHeaderTitle.text = sectionData[section].fooddata?.food_category_name ?? ""
        headerView.btnClick.tag = section
        headerView.btnClick.addTarget(self, action: #selector(btnClickExpand(_:)), for: .touchUpInside)
        headerView.imgArrow.image = UIImage(named: "\(sectionData[section].fooddata?.is_Expand ?? true ? "downarrow" : "leftarrow")")

        return headerView
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 150 : 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 50
    }
    
    @objc func btnClickExpand(_ sender: UIButton){
        
        self.sectionData[sender.tag].fooddata?.is_Expand?.toggle()
        self.tblView.reloadData()
    }
    
}
extension HomeVC : HomeDetailsVCDelegate{
    func selectedSubCatgory(selSubCategory: FoodSubCategoryData, indexPath: IndexPath) {
        self.sectionData[indexPath.section].fooddata?.sub_category?[indexPath.row].is_checked = selSubCategory.is_checked
        self.tblView.reloadRows(at: [indexPath], with: .none)
    }
    
}
