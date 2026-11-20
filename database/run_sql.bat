@echo off
echo =========================================================================
echo Executing DBMS SQL Queries and Displaying Tables (Scenario 14)...
echo Student: Kanishka K - Reg No: 732925ITR044 - Class: 25IT3A
echo =========================================================================
cd /d "%~dp0"
if exist "..\.venv\Scripts\python.exe" (
    "..\.venv\Scripts\python.exe" run_sql.py
) else (
    python run_sql.py
)
pause
