@echo off
echo === Kompilacja ===
javac -encoding UTF-8 -d out src\*.java

if %errorlevel% neq 0 (
    echo Blad kompilacji
    pause
    exit /b
)

echo.
echo === Test POLISH ===
java -cp out Test kmp tests-POLISH.txt cases-POLISH.txt

echo.
echo === Test GREEK ===
java -cp out Test kmp tests-GREEK.txt cases-GREEK.txt

echo.
echo === Test EMOJI ===
java -cp out Test kmp tests-EMOJI.txt cases-EMOJI.txt

echo.
echo Done
pause
