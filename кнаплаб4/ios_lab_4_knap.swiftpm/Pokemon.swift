import Foundation

struct Ability: Decodable {
    let name: String
    let url: String
}

struct PokemonAbility: Decodable {
    let ability: Ability
    let is_hidden: Bool
    let slot: Int
}
    
struct Pokemon: Decodable {
    let abilities: [PokemonAbility]
}
