TP SPRING CLOUD - VERSION PREPAREE
=================================

Architecture et ports
---------------------
Eureka Server     : http://localhost:8761
SERVICE-CLIENT    : http://localhost:8088
SERVICE-VOITURE   : http://localhost:8089
Gateway           : http://localhost:8888

Configuration retenue
---------------------
- JDK 17 ou supérieur
- Spring Boot 4.0.9
- Spring Cloud 2025.1.4
- Eureka pour l'enregistrement et la découverte
- OpenFeign pour l'appel SERVICE-VOITURE -> SERVICE-CLIENT
- Spring Cloud Gateway WebFlux pour le routage
- H2 en mémoire pour chaque microservice

DEMARRAGE SUR WINDOWS
---------------------
1. Installer/configurer un JDK 17+ et vérifier dans CMD : java -version
2. Vérifier que l'ordinateur a accès à Internet au premier lancement Maven
   (Maven Wrapper télécharge Maven et les dépendances si elles ne sont pas en cache).
3. Double-cliquer sur demarrer-tp.bat.
4. Le script compile les quatre projets, puis démarre les applications dans
   l'ordre Eureka -> Client -> Voiture -> Gateway.
5. Attendre que les quatre consoles affichent le démarrage réussi.

DEMARRAGE MANUEL DANS INTELLIJ
------------------------------
Ouvrir chaque sous-dossier comme projet Maven, puis lancer les classes :
1. eureka-server/.../EurekaServerApplication.java
2. service-client/.../ServiceClientApplication.java
3. service-voiture/.../ServiceVoitureApplication.java
4. gateway/.../GatewayApplication.java

Laisser Eureka démarrer avant les deux microservices. Laisser SERVICE-CLIENT
être opérationnel avant SERVICE-VOITURE, car le CommandLineRunner de Voiture
utilise OpenFeign pour charger les clients 1 et 2.

VERIFICATIONS DIRECTES
----------------------
Eureka :
  http://localhost:8761
  SERVICE-CLIENT et SERVICE-VOITURE doivent être visibles dans la liste.

SERVICE-CLIENT :
  http://localhost:8088/clients
  http://localhost:8088/client/1
  http://localhost:8088/clients/1

SERVICE-VOITURE :
  http://localhost:8089/voitures
  http://localhost:8089/voitures/1
  http://localhost:8089/voitures/client/1

Gateway - routes explicites via Eureka / LoadBalancer :
  http://localhost:8888/clients
  http://localhost:8888/client/1
  http://localhost:8888/voitures
  http://localhost:8888/voitures/1
  http://localhost:8888/voitures/client/1

Gateway - routes dynamiques générées depuis Eureka :
  http://localhost:8888/SERVICE-CLIENT/clients
  http://localhost:8888/SERVICE-CLIENT/client/1
  http://localhost:8888/SERVICE-VOITURE/voitures
  http://localhost:8888/SERVICE-VOITURE/voitures/1
  http://localhost:8888/SERVICE-VOITURE/voitures/client/1

IMPORTANT
---------
Les bases H2 sont en mémoire : les données de test sont recréées au démarrage.
Ne lancer qu'une instance de chaque service sur les ports prévus (8761, 8088,
8089, 8888), sauf si vous configurez des ports différents.

Le projet utilise les routes Gateway par nom Eureka (lb://SERVICE-CLIENT et
lb://SERVICE-VOITURE). Les routes dynamiques sont également activées : le
préfixe SERVICE-CLIENT ou SERVICE-VOITURE est retiré avant le transfert.
