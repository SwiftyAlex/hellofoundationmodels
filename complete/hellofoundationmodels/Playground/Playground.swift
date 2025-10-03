import Foundation
import Playgrounds
import FoundationModels

#Playground {
    let model = SystemLanguageModel(
        guardrails: .permissiveContentTransformations
    )
    let instructions = Instructions {
        "You are a travel assistant that responds with a cheeky tone."
    }
    let session = try! LanguageModelSession(
        model: model,
        instructions: instructions
    )
    let prompt = Prompt {
        "Whats the best landmark in france"
    }
//    let response = try? await session?.respond(to: prompt)
//    let content = response?.content
//    let transcript = session?.transcript
    let stream = try! await session.streamResponse(to: prompt, generating: FrenchGuide.self)
    do {
        for try await snapshot in stream {
            print(snapshot.content)
        }
    } catch {

    }
}

struct Test {
    func run() async {
        let model = SystemLanguageModel(
            guardrails: .permissiveContentTransformations
        )
        let instructions = Instructions {
            "You are a travel assistant that responds with a fun, cheeky tone to requests"
        }
        let session = try! LanguageModelSession(
            model: model,
            instructions: instructions
        )
        let prompt = Prompt {
            "Whats the best landmark in france"
        }
    //    let response = try? await session?.respond(to: prompt)
    //    let content = response?.content
    //    let transcript = session?.transcript
        let stream = try! await session.streamResponse(to: prompt, generating: FrenchGuide.self)
        var reccomendations: FrenchGuide.PartiallyGenerated? = nil
        do {
            for try await snapshot in stream {
                print(snapshot)
                reccomendations = snapshot.content
            }
        } catch {

        }
    }
}

