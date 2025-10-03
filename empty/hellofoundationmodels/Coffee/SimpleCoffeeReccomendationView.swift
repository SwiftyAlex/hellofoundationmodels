import SwiftUI
import FoundationModels

struct SimpleCoffeeReccomendationView: View {
    @State var prompt: String = ""

    var body: some View {
        List {
            TextField("How do you like your coffee?", text: $prompt)

            Button(action: {

            }, label: {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Generate")

                    Spacer()
                }
                .font(.headline.weight(.semibold))
            })
        }
        .navigationTitle("Coffee Reccomendation")
    }
}

#Preview {
    ContentView()
}
