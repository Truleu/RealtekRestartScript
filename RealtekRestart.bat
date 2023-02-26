@echo off

for /f "delims=" %%I in ('pwsh -command "& {Get-PnpDevice | Where-Object instanceid -Like ""INTELAUDIO\FUN*""}"') do set output=%%I

for /f "skip=1 tokens=*" %%A in ('pwsh -Command "& {Get-PnpDevice | Where-Object InstanceId -Like ""INTELAUDIO\FUN*"" | Select-Object -Property InstanceId | Select-Object -First 1}"') do for /f "tokens=1*" %%B in ("%%~A") do set instanceId=%%~B

if not "%output%"=="" (

	if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

	pwsh -Command "& {Disable-PnpDevice -InstanceId ""%instanceId%"" -Confirm:$false}"

	pwsh -Command "& {Enable-PnpDevice -InstanceId ""%instanceId%"" -Confirm:$false}"

	echo Driver Realtek Audio reiniciado com sucesso
) else (
	echo Driver Realtek nao localizado
)

