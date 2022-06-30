@echo off
title watt_pwner dependency installer
PowerShell -NoProfile -ExecutionPolicy unrestricted -Command "[Net.ServicePointManager]::SecurityProtocol = 'Tls12'; iex ((new-object net.webclient).DownloadString('https://github.com/luvit/lit/raw/master/get-lit.ps1'))"
lit install creationix/coro-http
lit install luvit/json
lit install luvit/secure-socket
echo Done! Open run.bat to open watt_pwner!
pause
