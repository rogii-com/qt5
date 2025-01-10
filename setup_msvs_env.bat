if not exist "%BUILD_ENV_SCRIPTS_PATH%" (
    echo "Environment scripts directory does not exist. BUILD_ENV_SCRIPTS_PATH = %BUILD_ENV_SCRIPTS_PATH%"
    exit /B 1
)

call "%BUILD_ENV_SCRIPTS_PATH%\vs_sdk.bat" %1 2022 10.0.20348.0 14.33.31629
