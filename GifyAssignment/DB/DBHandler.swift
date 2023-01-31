//
//  DBHandler.swift
//  GifyAssignment
//
//  Created by macbook on 30/01/23.
//

import Foundation
import RealmSwift

// Can create interface to test DB as well
// Handle DB instantiations and operations
class DBHandler{
    // Observer property for updated DB instances
    @ObservedResults(GiphyDatumRealm.self) var favouritesGiphys
    var realm: Realm?
    
    // mapped favourite gifs from db
    var favouriteGiphyObjs: [GiphyDatum]{
        favouritesGiphys.map({GiphyDatum(data: $0)})
    }
    
    init(){
        initializeDB()
    }
    
    func initializeDB(){
        do{
            self.realm = try Realm()
        }
        catch let error{
            print("Error occured while starting DB : \(error.localizedDescription )")
        }
    }
    
    // remove a favourite from db
    func deleteFavourite(_ favourite: GiphyDatum?){
        guard let realm = realm, let realmObject = realm.objects(GiphyDatumRealm.self).filter({$0.id == favourite?.id ?? ""}).first else
        {
            return
        }

        do{
            try realm.write(){
                realm.delete(realmObject)
            }
        }
        catch let error{
            print("Error: \(error)")
        }
    }
    
    // add a gif to db
    func addFavourite(_ favourite: GiphyDatum?){
        guard let giphyObj = favourite, let realm = self.realm else { return }

        let realmObject: GiphyDatumRealm = GiphyDatumRealm(data: giphyObj)
        
        if !checkIfAlreadyFavourite(giphyData: realmObject){
            do{
                try realm.write(){
                    realm.add(realmObject)
                }
            }
            catch let error{
                print("Error: \(error)")
            }
        }
    }
    
    // clear all favourites from db
    func clearFavourites(){
        guard let realm else {
            return
        }
        
        do{
            try realm.write(){
                realm.delete(favouritesGiphys)
            }
        }
        catch let error{
            print("Error: \(error)")
        }
    }
    
    // check for duplicate favourit giphy instance in DB
    private func checkIfAlreadyFavourite(giphyData: GiphyDatumRealm) -> Bool{
        return favouritesGiphys.filter({$0.id ?? "" == giphyData.id ?? ""}).count > 0
    }
    
    // check if giphy instance is marked as favourite
    func isFavourite(giphyData: GiphyDatum?) -> Bool{
        return favouriteGiphyObjs.filter({$0.id ?? "" == giphyData?.id ?? ""}).count > 0
    }

}
