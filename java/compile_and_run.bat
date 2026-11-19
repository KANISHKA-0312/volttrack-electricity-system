@echo off
echo ==============================================================
echo Compiling Electricity Consumption Management System (Java)...
echo ==============================================================
if not exist "bin" mkdir bin
javac -d bin src\com\ecm\model\*.java src\com\ecm\exception\*.java src\com\ecm\util\*.java src\com\ecm\dao\*.java src\com\ecm\service\*.java src\com\ecm\Main.java
if %errorlevel% neq 0 (
    echo [ERROR] Compilation failed!
    exit /b %errorlevel%
)
echo [SUCCESS] Compilation complete. Running Automated Verification Demo...
echo ==============================================================
java -cp bin com.ecm.Main --demo
pause
