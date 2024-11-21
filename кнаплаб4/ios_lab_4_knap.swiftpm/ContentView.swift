import SwiftUI

struct ContentView: View {
    @State private var pokemonNameOrID: String = ""
    @State private var pokemon: Pokemon?
    @State private var errorMessage: String?
    @State private var showingInstructions = false
    
    private let pokemonService = PokemonService()

    var body: some View {
        ZStack {
            Image("a")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer() // Відступ зверху
                
                // Поле для введення
                TextField("Введіть ім'я покемона", text: $pokemonNameOrID)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .frame(maxWidth: 300) // Фіксуємо ширину
                
                // Кнопка
                Button(action: {
                    fetchPokemon()
                }) {
                    Text("Отримати дані")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 200) // Фіксуємо ширину кнопки
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                // Відображення результатів
                if let pokemon = pokemon {
                    ScrollView { // Прокручуваний список здібностей
                        VStack(spacing: 10) {
                            ForEach(pokemon.abilities, id: \.slot) { ability in
                                VStack(alignment: .leading) {
                                    Text("Ability: \(ability.ability.name)")
                                    Text("Hidden: \(ability.is_hidden ? "Yes" : "No")")
                                    Text("Slot: \(ability.slot)")
                                }
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .frame(maxWidth: 300) // Фіксуємо ширину елементів
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                } else {
                    Text("Введіть ім'я покемона і натисніть 'Отримати дані'")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                }
                
                // Кнопка інструкцій
                Button("Інструкція") {
                    showingInstructions = true
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: 200)
                .background(Color.green)
                .cornerRadius(10)
                .sheet(isPresented: $showingInstructions) {
                    InstructionView()
                }
                
                Spacer() // Відступ знизу
            }
            .padding()
        }
    }
    
    private func fetchPokemon() {
        errorMessage = nil
        pokemon = nil
        pokemonService.fetchPokemonData(pokemonNameOrID: pokemonNameOrID.lowercased()) { result in
            DispatchQueue.main.async {
                if let result = result {
                    self.pokemon = result
                } else {
                    self.errorMessage = "Не вдалося отримати дані. Перевірте ім’я чи ідентифікатор і повторіть спробу."
                }
            }
        }
    }
}

struct InstructionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Інструкція")
                .font(.title)
                .padding(.bottom, 20)
            
            Text("Ability")
                .font(.headline)
            Text("Здібність покемона, яка надає йому унікальні властивості.")
            
            Text("Hidden")
                .font(.headline)
            Text("Показує, чи є здібність прихованою. Якщо 'Yes', це особлива здібність, рідкісна для цього покемона.")
            
            Text("Slot")
                .font(.headline)
            Text("Порядковий номер здібності у списку покемона.")
            
            Spacer()
        }
        .padding()
    }
}
