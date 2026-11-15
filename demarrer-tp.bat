@echo off
setlocal
cd /d "%~dp0"

 echo =====================================================
 echo   TP SPRING CLOUD - PREPARATION ET DEMARRAGE
 echo =====================================================
 echo.

where java >nul 2>nul
if errorlevel 1 (
  echo ERREUR : Java est introuvable. Configurez JAVA_HOME / PATH avec JDK 17+.
  pause
  exit /b 1
)
java -version
where mvn >nul 2>nul
if errorlevel 1 (
  echo ERREUR : Maven est introuvable. Installez Maven ou ajoutez son dossier bin au PATH.
  pause
  exit /b 1
)
echo.
echo Version Maven :
call mvn -version
 echo.
 echo [1/2] Compilation des quatre microservices...

call :build "eureka-server" || goto :error
call :build "service-client" || goto :error
call :build "service-voiture" || goto :error
call :build "gateway" || goto :error

 echo.
 echo [2/2] Demarrage dans l'ordre recommande...
start "EUREKA SERVER - 8761" cmd /k "cd /d ""%~dp0eureka-server"" && java -jar target\eureka-server-0.0.1-SNAPSHOT.jar"
echo Attente du demarrage Eureka...
timeout /t 15 /nobreak >nul

start "SERVICE-CLIENT - 8088" cmd /k "cd /d ""%~dp0service-client"" && java -jar target\service-client-0.0.1-SNAPSHOT.jar"
echo Attente du demarrage SERVICE-CLIENT...
timeout /t 15 /nobreak >nul

start "SERVICE-VOITURE - 8089" cmd /k "cd /d ""%~dp0service-voiture"" && java -jar target\service-voiture-0.0.1-SNAPSHOT.jar"
echo Attente du demarrage SERVICE-VOITURE...
timeout /t 15 /nobreak >nul

start "GATEWAY - 8888" cmd /k "cd /d ""%~dp0gateway"" && java -jar target\gateway-0.0.1-SNAPSHOT.jar"

echo.
echo Demarrage demande. Verifiez les quatre consoles avant les tests.
echo Eureka : http://localhost:8761
echo Gateway: http://localhost:8888
echo.
pause
exit /b 0

:build
echo.
echo ---- Compilation de %~1 ----
cd /d "%~dp0%~1"
call mvn -DskipTests package
if errorlevel 1 exit /b 1
cd /d "%~dp0"
exit /b 0

:error
echo.
echo ECHEC de compilation. Lisez le message Maven ci-dessus.
echo Verifiez JDK 17+, connexion Internet et dependances Maven.
pause
exit /b 1
