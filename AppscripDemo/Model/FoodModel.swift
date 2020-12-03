//
//  FoodModel.swift
//  AppscripDemo
//
//  Created by Jigar on 19/11/20.
//

import UIKit

struct FoodResult : Decodable {
    let result : Int?
    let data : [FoodData]?
}
struct FoodData : Decodable {
    let food_category_id : Int?
    let food_category_name : String?
    let food_category_imagename : String?
    var is_Expand  : Bool?
    var sub_category : [FoodSubCategoryData]?

}
struct FoodSubCategoryData : Decodable {
    
    let sub_category_id : Int?
    let sub_category_name : String?
    let sub_category_imagename : String?
    let description : String?
    var is_checked  : Bool?
}
