<!-- Created by Sébastien DAGUIN -->

# MyNews 2.0 — audit, premier lot et suite

Audit du 10 novembre 2026, base `main` à `6bf1f8f`.
Branche de travail : `feat/mynews-2-foundations`.
Référence : cahier des charges v1.0 « Monétiser Fullmoon efficacement » du 10 novembre 2026.

## État constaté

L'application associe deux circuits distincts : NewsAPI pour l'accueil/recherche/favoris et RSS pour les abonnements. SwiftUI et des gestionnaires observables sont déjà présents. Core Data conserve les favoris NewsAPI, les sources RSS et l'historique de recherche. Il n'existait aucun cache des articles RSS. Les tests existants utilisent XCTest et des réponses NewsAPI simulées, sans tests RSS. Une cible macOS existe mais n'est pas validée par ce lot.

Le projet compile en Swift 5 ; la cible iOS vise 18.0 et les tests 17.5. Firebase est configuré au démarrage et participe à l'authentification et aux services Analytics/Crashlytics. L'exigence « sans Firebase obligatoire » n'est donc pas satisfaite. Aucun choix de licence propre au projet n'est matérialisé par un fichier de licence.

## Lot 1 implémenté

- Réseau RSS injectable (`RSSFetching`, session Alamofire injectable), délai de 30 secondes, validation HTTP 2xx, validation des schémas HTTP(S) et résultat agrégé unique sur la file principale, y compris zéro source. Une source invalide ne supprime pas les résultats des autres.
- Parsing RSS et Atom de base : fragments de texte, CDATA, liens Atom alternatifs, descriptions imbriquées, dates RSS/ISO 8601. Rejet du XML mal formé et des documents dont la racine n'est pas celle d'un flux ; aucune résolution d'entité externe. Un flux valide vide reste un succès.
- Identité RSS fondée sur l'URL, déduplication des URL exactement identiques, tri des dates décroissant avec départage déterministe. Les titres identiques de deux URL distinctes sont conservés. Correction du calcul relatif des heures/jours.
- Gestionnaire RSS injectable : chargement maintenu jusqu'au résultat, exclusion des rafraîchissements simultanés, remplacement des données actualisées, conservation des articles des sources en échec et élagage des sources supprimées. Un changement des sources pendant une requête déclenche une nouvelle actualisation.
- Cache JSON atomique dans Application Support, limité à 1 000 articles sauvegardés. Titres, descriptions reçues, URL, dates et source sont relus au lancement, filtrés sur les abonnements courants. Les erreurs de lecture/écriture sont remontées. Il ne s'agit pas d'un téléchargement des pages web, images ou articles complets.
- Core Data : partage du modèle entre conteneurs (suppression des avertissements de modèles concurrents pendant les tests), vrai stockage en mémoire pour les tests ; restitution et mise à jour des statuts des sources ; suppression par identité d'URL depuis la liste affichée ; ordre de lecture stable. Égalité et hachage de `Link` utilisent la même identité. Les descriptions des favoris NewsAPI relisent maintenant `articleDescription`.
- Interface : erreurs RSS visibles, sources indisponibles visibles dans la gestion des abonnements, actualisation à la fermeture de la feuille des sources.
- Correction d'une erreur de compilation préexistante : `ArticleDetailLauncher` passait deux arguments inconnus à `NewsDetailView`. L'écran affiche l'article original. Ce composant n'a aucun appelant trouvé dans les sources ; son code de reformulation n'est pas une fonction Pro livrée.
- Suppression de l'impression de l'URL NewsAPI contenant la clé. La clé écrite en dur existante doit encore être révoquée/remplacée par son propriétaire et son approvisionnement revu. Aucun secret n'est reproduit dans ce document.

Le seul ajustement du fichier de projet inscrit le nouveau fichier de tests dans la cible existante. Aucune dépendance, aucun SDK, modèle Core Data ou réglage de compilation n'est migré.

## Architecture progressive

La séparation de ce lot est volontairement locale : modèle RSS et contrat de stockage dans `RSSItem.swift`, parsing/réseau dans `RSSFetcher.swift`, orchestration et état d'écran dans `FluxViewManager`. Les protocoles permettent les doubles de test sans singleton réseau ou stockage imposé au gestionnaire. Cela prépare le découplage, mais ce n'est pas encore une Clean Architecture complète ni un ensemble de packages indépendants.

Core Data est conservé pour ne pas risquer les données existantes. La migration SwiftData nécessite un scénario d'import, des fixtures d'anciennes bases, une politique de reprise en cas d'échec et des tests de non-perte avant remplacement. Swift 6 et la concurrence stricte devront suivre un audit de toutes les cibles et dépendances, sans hausse simultanée injustifiée des versions.

## Correspondance avec le cahier des charges

| Exigence | État après ce lot | Travail restant |
| --- | --- | --- |
| F-001 Sources RSS | Ajout/retrait existants fiabilisés | Validation UI de suppression ; gestion des URL équivalentes |
| F-002 Articles par date/source | Tri RSS corrigé, source conservée | Filtres par source et classement unifiés |
| F-003 Recherche | NewsAPI existante | Recherche locale dans le cache RSS |
| F-004 Favoris | NewsAPI existants, description corrigée | Favoris RSS persistants et identité URL unifiée |
| F-005 Navigateur intégré | Présent | Tests UI et cas de liens non valides |
| F-006 Thèmes | Réglages existants | Vérification de leur application sur chaque écran |
| F-007 Lu/non lu | Non implémenté pour RSS | Modèle local et actions accessibles |
| F-008 OPML | Non implémenté | Import/export, erreurs et doublons |
| F-009 Catégories | Non implémenté | Stockage et classement des sources |
| F-010 Déduplication | URL RSS exactement identique | URL canoniques et regroupement intersources |
| F-011 Hors ligne | Cache des métadonnées et descriptions RSS | Vue locale de lecture ; pas de page Safari hors ligne |
| P-001 à P-008 Pro | Non implémentées | Briefings, résumés cités, veille, recherche sémantique, Q/R, dossiers, exports et alertes |
| SwiftData / CloudKit | Non implémentés | Migration sans perte puis synchronisation facultative |
| NoctisResearch / MLX | Non intégrés | Vérification licences/API, package indépendant, service d'intelligence facultatif |
| StoreKit 2 | Non implémenté | Produits, transactions vérifiées, droits, restauration, Sandbox |
| FR/EN et accessibilité | Non validés globalement | Localisation, VoiceOver, Dynamic Type, contraste et parcours UI |

## Validation

Vérification finale : **41 tests exécutés, 0 échec**, dont **13 nouveaux tests RSS/persistance**, sur simulateur iPhone 17 Pro (iOS 26.5), avec Xcode 27.3. Compilation de l'application et de la cible de tests réussie ; `git diff --check` sans erreur. La dernière exécution ne contient plus les avertissements Core Data de modèles multiples.

Couverture ajoutée : RSS/Atom, CDATA et texte imbriqué, dates et identité, XML invalide, HTTP 503 et réseau absent, zéro source, échec partiel/total, callback unique, suppression par URL et statuts persistés dans un conteneur en mémoire, description des favoris, cache rouvert/corrompu/limité à 1 000 entrées, erreur d'écriture remontée, rafraîchissement concurrent ignoré, flux vide, conservation hors ligne et changement des sources pendant une requête. Les tests de ce lot utilisent des réponses HTTP simulées (URLProtocol), une base Core Data en mémoire et des fichiers temporaires ; ils ne valident aucun serveur RSS tiers réel, achat ou service IA.

Commande reproductible depuis le dépôt :

```sh
xcodebuild -project MyNews.xcodeproj -scheme MyNews \
  -destination 'platform=iOS Simulator,id=AE3B1BD7-0E1C-42AC-AA31-4AD5D94CE72E' \
  -derivedDataPath ../DerivedData -disableAutomaticPackageResolution \
  test CODE_SIGNING_ALLOWED=NO IPHONEOS_DEPLOYMENT_TARGET=18.0
```

Remplacer l'identifiant du simulateur par un appareil disponible. L'option de minimum iOS aligne temporairement les tests sur l'application ; sans elle, la configuration existante des tests 17.5 ne peut pas importer l'application 18.0. La résolution initiale des dépendances nécessite un accès réseau.

## Prochains lots, dans l'ordre

1. Terminer le socle : récupération des erreurs Core Data au démarrage (le `fatalError` existant reste), erreurs de fetch aujourd'hui masquées dans les repositories historiques, gestion transactionnelle des échecs d'écriture et tests de réouverture d'une vraie base sur disque. Harmoniser ensuite la configuration des tests avec le minimum de l'application.
2. Unifier les articles RSS/NewsAPI derrière des contrats de dépôt sans refonte générale : favoris RSS, lu/non lu, recherche locale, suppression accessible et parcours UI hors ligne. Tester l'application sur appareil, y compris démarrage sans réseau et cache corrompu.
3. Définir et tester la migration SwiftData, puis adopter Swift 6 progressivement. Isoler/rendre facultatifs Firebase et l'authentification pour la lecture RSS. Révoquer la clé NewsAPI exposée ; décider de conserver ou supprimer ce service.
4. Catégories, OPML et lecture locale des descriptions ; vérifier les droits source par source avant toute extension de cache, résumé ou export. Mesurer la taille et les performances : le cache est limité en nombre, mais ni le corps HTTP, ni la taille de chaque description ne sont encore bornés. Annulation des téléchargements, reprise/backoff et validateurs ETag restent à ajouter.
5. Seulement après ces validations : NoctisResearch et `ArticleIntelligenceService` facultatif, tests de citations et absence d'IA ; ensuite StoreKit 2 et droits vérifiés/restaurables, puis bêta TestFlight.

Limites du parser : ce n'est pas une implémentation exhaustive RSS/Atom ; liens relatifs, `xml:base`, contenus XML complexes et formats de dates inhabituels restent à traiter. Les erreurs et détails HTTP sont actuellement regroupés en statut indisponible. L'ancien cache est conservé sans durée d'expiration tant qu'une source échoue ; prévoir un réglage d'effacement et une politique de rétention. Pas de validation UI, macOS, SwiftLint, Swift Testing, CloudKit, modèle local ou StoreKit dans ce lot.

## Licences et droits — vérification du 10 novembre 2026

Les fichiers de licence racine des 17 dépendances verrouillées dans `Package.resolved` ont été examinés dans les copies résolues par Xcode. Cela constitue un inventaire du code distribué par ces dépôts, pas une autorisation globale pour les contenus, les marques ou tous les binaires embarqués.

| Dépendance | Version | Licence racine vérifiée |
| --- | --- | --- |
| abseil-cpp-binary | 1.2024011602.0 | [Apache-2.0](https://github.com/google/abseil-cpp-binary/blob/194a6706acbd25e4ef639bcaddea16e8758a3e27/LICENSE) |
| alamofire | 5.10.0 | [MIT](https://github.com/Alamofire/Alamofire/blob/ea6a94b7dddffd0ca4d0f29252d95310b84dec84/LICENSE) |
| app-check | 10.19.2 | [Apache-2.0](https://github.com/google/app-check/blob/3b62f154d00019ae29a71e9738800bb6f18b236d/LICENSE) |
| appauth-ios | 1.7.5 | [Apache-2.0](https://github.com/openid/AppAuth-iOS/blob/c89ed571ae140f8eb1142735e6e23d7bb8c34cb2/LICENSE) |
| firebase-ios-sdk | 10.29.0 | [Apache-2.0](https://github.com/firebase/firebase-ios-sdk/blob/eca84fd638116dd6adb633b5a3f31cc7befcbb7d/LICENSE) |
| googleappmeasurement | 10.28.0 | [Apache-2.0](https://github.com/google/GoogleAppMeasurement/blob/fe727587518729046fc1465625b9afd80b5ab361/LICENSE) |
| googledatatransport | 9.4.0 | [Apache-2.0](https://github.com/google/GoogleDataTransport/blob/a637d318ae7ae246b02d7305121275bc75ed5565/LICENSE) |
| googlesignin-ios | 7.1.0 | [Apache-2.0](https://github.com/google/GoogleSignIn-iOS/blob/a7965d134c5d3567026c523e0a8a583f73b62b0d/LICENSE) |
| googleutilities | 7.13.3 | [Apache-2.0](https://github.com/google/GoogleUtilities/blob/57a1d307f42df690fdef2637f3e5b776da02aad6/LICENSE) |
| grpc-binary | 1.62.2 | [Apache-2.0](https://github.com/google/grpc-binary/blob/e9fad491d0673bdda7063a0341fb6b47a30c5359/LICENSE) |
| gtm-session-fetcher | 3.5.0 | [Apache-2.0](https://github.com/google/gtm-session-fetcher/blob/a2ab612cb980066ee56d90d60d8462992c07f24b/LICENSE) |
| gtmappauth | 4.1.1 | [Apache-2.0](https://github.com/google/GTMAppAuth/blob/5d7d66f647400952b1758b230e019b07c0b4b22a/LICENSE) |
| interop-ios-for-google-sdks | 100.0.0 | [Apache-2.0](https://github.com/google/interop-ios-for-google-sdks/blob/2d12673670417654f08f5f90fdd62926dc3a2648/LICENSE) |
| leveldb | 1.22.5 | [BSD-3-Clause](https://github.com/firebase/leveldb/blob/a0bc79961d7be727d258d33d5a6b2f1023270ba1/LICENSE) |
| nanopb | 2.30910.0 | [zlib](https://github.com/firebase/nanopb/blob/b7e1104502eca3a213b46303391ca4d3bc8ddec1/LICENSE.txt) |
| promises | 2.4.0 | [Apache-2.0](https://github.com/google/promises/blob/540318ecedd63d883069ae7f1ed811a2df00b6ac/LICENSE) |
| swift-protobuf | 1.28.2 | [Apache-2.0](https://github.com/apple/swift-protobuf/blob/ebc7251dd5b37f627c93698e4374084d98409633/LICENSE.txt) |

Les notices de copyright/licence et les éventuels fichiers NOTICE devront être conservés et accompagnés d'un écran ou document d'attributions adapté avant distribution. Les artefacts binaires Google/grpc/abseil et leur contenu tiers devront faire l'objet d'une vérification de distribution complète ; leurs dépôts enveloppes ne suffisent pas à clôturer cette vérification. La licence de MyNews reste à choisir explicitement, sans déduire une autorisation de réutilisation du seul caractère public du dépôt.

Les conditions [NewsAPI](https://newsapi.org/terms), consultées le 10 novembre 2026, limitent le plan Developer au développement/test et maintiennent les droits des titulaires sur les contenus tiers. Le plan réel du compte n'a pas été vérifié. Les droits de cache/résumé/export des éditeurs RSS et la provenance/licence des images/icônes de l'application restent à vérifier. Aucune licence, marque, contenu de NoctisResearch ou modèle MLX n'est ajouté ou réputé autorisé par ce lot.
