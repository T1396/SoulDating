# SoulDating

"Entdecke, verbinde und verliebe dich in deiner Nähe!"

## Über die App

Soul Dating ist eine moderne iOS- Dating-App die darauf abzielt, Singles zusammenzuführen. Dafür verwendet die App Standorte des Users, um Ihnen potenzielle Matches in ihrem Umkreis vorzuschlagen.
Die App ist ideal für Personen, die daran interessiert sind, neue Menschen in der Umgebung kennenzulernen. SoulDating bietet eine einfache und nicht zu sehr von Werbung überladene Benutzeroberfläche.

## Design
<p>
  <img src="./img/swipe.png" width="200">
  <img src="./img/screenshot1.png" width="200">
  <img src="./img/screen6" width="200">
  <img src="./img/screen3" width="200"
</p>


## Features

- [x] Standortbasierte Nutzer-Vorschläge
- [x] Swiping - Mechanik: Swipe nach rechts für Like und nach links für Pass
- [x] Chat-Funktion: Kommuniziere direkt mit deinen Matches über eingebaute Nachrichtenfunktionen.
- [x] Anpassbare Benutzerpräferenzen: Ändere deine Vorlieben,  oder setze einen neuen Standort um Menschen aus einer anderen Umgebung kennenzulernen.
- [x] Like-Ansicht: Kontrolliere welche Nutzer dich geliked haben oder wen du geliked hast sowie Matches!
- [x] Chat-Bot: Lasse dir Flirtsprüche generieren um das Eis zu brechen! Oder führe komplette Konversationen und lass dir Tipps für Dating geben!

## Technischer Aufbau

#### Projektaufbau
##### Architektur: MVVM für eine Trennung von Logik und UI
##### Ordnerstruktur: 
- Models: Datenmodelle zur Speicherung in Firestore und Nutzung in der App.
- Views: UI-Komponenten sowie mit UIKomponenten verknüpfte Views
- ViewModels: Logik und Datenverarbeitung
- Utilities:: Enthält u.a. Manager für Firebase, RangeChecks, zusätzliche Json Dateien, Enums, Modifier und Extensions

#### Datenspeicherung
Firestore-Dokumente: Nutzerdaten, Präferenzen und Match/Chat Informationen werden sicher in Firestore gespeichert. Dies bietet eine leichte skalierbare Lösung für Echtzeit-Daten und Updates für z.bsp. die Chats.

#### API Calls
OpenAI Api zur Generierung von Anmachsprüchen, und als Assistenz um sich Tipps bezüglich z.bsp. Dating zu holen um mehr Erfolg zu haben.

#### 3rd-Party Frameworks

Firebase SDK: Für Benutzerauthentifizierung und Datenbankdienste.
Swift Open AI: https://github.com/SwiftBeta/SwiftOpenAI für Interaktion mit OpenAI Api

#### Attention
If you might want to test the app and access the chatgpt functionality u must replace the api-Key inside the "GptViewModel" class with your own OpenAI Api Key
