import SwiftUI
import FoundationModels

struct FormulaOneIntelligenceView: View {
    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()

            ScrollView {
                content
            }
        }
        .onAppear {
            Task {
                // TODO: Generate
                // await intelligence.generate()
            }
        }
        .navigationTitle("Formula One")
    }

    var content: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Championship Insights")
                }
                .font(.title3.weight(.bold))

                // TODO: Show content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Material.ultraThin)
            }
        }
        .padding()
    }

    var background: some View {
        Rectangle()
            .foregroundStyle(
                Design.glowyGradientBlend
            )
    }
}

#Preview {
    FormulaOneIntelligenceView()
        .colorScheme(.dark)
}

enum Design {
    static let glowyGradientBlend = LinearGradient(colors: [
        Color.red.mix(with: .bg, by: 0.5).opacity(0),
        Color.red.mix(with: .bg, by: 0.5).opacity(0.25),
        Color.red.mix(with: .bg, by: 0.5).opacity(0.5),
        Color.red.mix(with: .bg, by: 0.5)
    ], startPoint: .bottom, endPoint: .top)
}
