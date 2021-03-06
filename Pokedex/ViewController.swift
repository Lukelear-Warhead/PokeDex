//
//  ViewController.swift
//  Pokedex
//
//  Created by Luke Regan on 2/1/16.
//  Copyright © 2016 Luke Regan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
	
	@IBOutlet weak var collection: UICollectionView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	var pokemon = [Pokemon]()
	var filteredPokemon = [Pokemon]()
	var inSearchMode = false
	var musicPlayer: AVAudioPlayer!
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		collection.delegate = self
		collection.dataSource = self
		searchBar.delegate = self
		
		searchBar.returnKeyType = .Done
		
		parsePokemonCSV()
		//initAudio()
		
	}
	
	@IBAction func musicButtonPressed(sender: UIButton) {
		if musicPlayer.playing {
			musicPlayer.stop()
			sender.alpha = 0.2
		} else {
			musicPlayer.play()
			sender.alpha = 1
		}
	}
	
	func initAudio() {
		let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
		do {
			musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
			musicPlayer.prepareToPlay()
			musicPlayer.numberOfLoops = -1
			musicPlayer.play()
		} catch let err as NSError {
			print(err.debugDescription)
		}
	}
	
	func parsePokemonCSV() {
		let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
		do {
			let csv = try CSV(contentsOfURL: path)
			let rows = csv.rows
			for row in rows {
				let pokeId = Int(row["id"]!)!
				let name = row["identifier"]!
				let poke = Pokemon(name: name, pokedexId: pokeId)
				pokemon.append(poke)
			}
		} catch let err as NSError {
			print(err.debugDescription)
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "PokemonDetailVC" {
			if let detailVC = segue.destinationViewController as? PokemonDetailVC,
			let poke = sender as? Pokemon {
				detailVC.pokemon = poke
			}
		}
	}


}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text == nil || searchBar.text == "" {
			inSearchMode = false
			view.endEditing(true)
			collection.reloadData()
		} else {
			inSearchMode = true
			let lower = searchBar.text!.lowercaseString
			filteredPokemon = pokemon.filter({ $0.name.rangeOfString(lower) != nil })
			collection.reloadData()
		}
		
	}
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		view.endEditing(true)
	}
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
		let poke: Pokemon!
		
		if inSearchMode {
			poke = filteredPokemon[indexPath.row]
		} else {
			poke = pokemon[indexPath.row]
		}
		performSegueWithIdentifier("PokemonDetailVC", sender: poke)
	}
	
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
			let poke: Pokemon!
			
			if inSearchMode {
				poke = filteredPokemon[indexPath.row]
			} else {
				poke = pokemon[indexPath.row]
			}
			cell.configureCell(poke)
			
			return cell
		} else {
			return UICollectionViewCell()
		}
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		if inSearchMode {
			return filteredPokemon.count
		} else {
			return pokemon.count
		}
		
	}
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSize(width: 100, height: 100)
	}
}

