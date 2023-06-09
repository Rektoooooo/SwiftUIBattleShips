//
//  Game.swift
//  Battleship-SwiftUI
//
//  Created by Sebastian Kucera on 11/20/22.
//


import Foundation

/*
 the Fleet of ships in the game
 */
class Fleet {
    static let shipsInFleet:[(name: String, length: Int)] = [("PT Boat", 2),
                                                         ("Submarine", 3),
                                                         ("Destroyer", 3),
                                                         ("Battleship", 4),
                                                         ("Aircraft Carrier", 5)]
    var ships: [Ship]
    
    init() {
        ships = [Ship]()
    }
    
    /*
     return true if he fleet is destoryed
     */
    func isDestroyed() -> Bool {
        //if our fleet contains a ship that is NOT sunk then our fleet is not destoryed yet
        return !ships.contains(where:{!$0.isSunk()})
    }
    
    /*
     return the ship occupying the given Coordinate or nil if none found
     */
    func ship(at location: Coordinate) -> Ship? {
        return ships.first(where:{$0.occupies(location)})
    }
    
    /*
     deploy the fleet in random locations on the given ocean
     */
    func deploy(on ocean: Ocean) {
        ships.removeAll()
        for ship in Fleet.shipsInFleet {
            //get all the possible locations that the ship can fit in the ocean without intersecting
            //with a ship that is already deployed
            let fleetCoordinates = self.coordinates()
            let oceanCoordinates = ocean.locationsThatFit(length: ship.length)
            let possibleLocations = oceanCoordinates.filter {Set($0).intersection(fleetCoordinates).isEmpty}
            guard (possibleLocations.count > 0) else {
                assertionFailure("Cannot fit ship in ocean.!")
                return
            }
            
            //pick one of the locations at random and deploy the ship there
            let randomIndex = Int.random(in: 0..<possibleLocations.count)
            let shipCoordinates = possibleLocations[randomIndex]
            let deployedShip = Ship(ship.name, coordinates: shipCoordinates)
            ships.append(deployedShip)
        }
    }
    
    /*
     returns all the Coordinates of the deployed fleet in an array
     */
    private func coordinates() -> [Coordinate] {
        let coordinates = ships.map {$0.compartments.map {$0.location}}
        return Array(coordinates.joined())
    }
}
