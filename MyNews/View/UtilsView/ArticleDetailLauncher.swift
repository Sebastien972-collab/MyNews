import SwiftUI
#if canImport(FoundationModels)
import FoundationModels
#endif

private struct ArticleRewrite {
    let title: String
    let content: String
}

private enum ArticleAIRewriter {
    static func rewrite(article: Article) async -> ArticleRewrite? {
        #if canImport(FoundationModels)
        guard #available(iOS 26.0, macOS 26.0, *) else {
            return nil
        }

        let model = SystemLanguageModel.default
        guard model.supportsLocale() else {
            return nil
        }

        guard case .available = model.availability else {
            return nil
        }

        do {
            let session = LanguageModelSession(instructions: """
            Tu es un assistant de redaction de news.
            Tu dois reformuler le titre et le contenu avec un style clair, concis et fidele aux faits.
            Ne cree aucune information. Garde la langue francaise.
            """)

            let response = try await session.respond(
                to: """
                Reformule l'article ci-dessous.
                - Titre: une phrase courte et percutante.
                - Contenu: entre 4 et 8 phrases, lisible, sans inventer.

                Titre original:
                \(article.title)

                Contenu original:
                \(article.content)
                """,
                generating: RewrittenArticle.self
            )

            return ArticleRewrite(
                title: response.content.title.trimmingCharacters(in: .whitespacesAndNewlines),
                content: response.content.content.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        } catch {
            return nil
        }
        #else
        return nil
        #endif
    }
}

struct ArticleDetailLauncher<Label: View>: View {
    let article: Article
    @ViewBuilder let label: () -> Label

    @State private var isPreparing = false
    @State private var shouldNavigate = false
    @State private var rewrittenTitle: String?
    @State private var rewrittenContent: String?

    var body: some View {
        ZStack {
            Button {
                Task { await prepareThenOpen() }
            } label: {
                label()
                    .overlay(alignment: .center) {
                        if isPreparing {
                            ProgressView()
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
            }
            .buttonStyle(.plain)
            .disabled(isPreparing)

            NavigationLink(isActive: $shouldNavigate) {
                NewsDetailView(
                    article: article,
                    rewrittenTitle: rewrittenTitle,
                    rewrittenContent: rewrittenContent
                )
            } label: {
                EmptyView()
            }
            .hidden()
        }
    }

    private func prepareThenOpen() async {
        guard !isPreparing else {
            return
        }

        await MainActor.run {
            isPreparing = true
        }

        let rewrite = await ArticleAIRewriter.rewrite(article: article)

        await MainActor.run {
            rewrittenTitle = rewrite?.title
            rewrittenContent = rewrite?.content
            isPreparing = false
            shouldNavigate = true
        }
    }
}

#if canImport(FoundationModels)
@available(iOS 26.0, macOS 26.0, *)
@Generable
private struct RewrittenArticle {
    var title: String
    var content: String
}
#endif
