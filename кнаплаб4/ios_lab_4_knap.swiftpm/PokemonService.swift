import Foundation


class PokemonService {
    // Параметр completion використовується для передачі даних назад у вигляді об'єкта Pokemon або nil у випадку помилки
    func fetchPokemonData(pokemonNameOrID: String, completion: @escaping (Pokemon?) -> Void) {
        
        
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemonNameOrID)"
        
        guard let url = URL(string: urlString) else { return }// конвертація п
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Перевіряємо, чи сталася помилка
            if let error = error {
                print("Помилка отримання даних: \(error)")
                completion(nil)
                return
            }

            // Перевіряємо, чи є отримані дані
            guard let data = data else {
                print("Немає даних")
                completion(nil)  // Якщо даних нема то передаємо ніл і виходимо
                return
            }
            do {
                // Декодуємо дані з JSON у модель Pokemon за допомогою JSONDecoder
                let decoder = JSONDecoder()
                let pokemon = try decoder.decode(Pokemon.self, from: data)
                completion(pokemon)  // Якщо декодування успішне, передаємо об'єкт Pokemon через completion
            } catch {
                // Виводимо повідомлення про помилку, якщо декодування не вдалося
                print("Помилка декодування даних: \(error)")
                completion(nil)  // Якщо помилка то передаємо ніл
            }
        }.resume()  // Запускаємо запит
    }
}
