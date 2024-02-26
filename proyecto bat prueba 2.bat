@echo off
title Registro e Inicio de Sesion

:inicio
cls
echo Buenas jefe que le pongo 
echo.

:menu_principal
echo ///Menu Principal:///
echo === 1. Registrarse ===
echo === 2. Iniciar Sesion ===
echo === 3. Salir ===
set /p opcion="Seleccione una opcion: "

if "%opcion%"=="1" goto registro
if "%opcion%"=="2" goto inicio_sesion
if "%opcion%"=="3" goto salir
goto inicio

:registro
cls
echo Registro de Usuario
echo.
set /p usuario="Ingrese nombre de usuario: "
set /p pass="Ingrese contraseña: "
set /p pass_confirm="Confirme contraseña: "
if "%pass%" neq "%pass_confirm%" (
    echo Las contraseñas no coinciden. Inténtelo de nuevo.
    pause
    goto registro
)
echo %usuario%:%pass% >> usuarios.txt
echo Registro exitoso.
pause
goto inicio

:inicio_sesion
cls
echo Inicio de Sesión
echo.
set /p usuario="Ingrese nombre de usuario: "
set /p pass="Ingrese contraseña: "
findstr /i "^%usuario%:%pass%" usuarios.txt > nul
if errorlevel 1 (
    echo Nombre de usuario o contraseña incorrectos.
    pause
    goto inicio_sesion
)
echo Inicio de sesion exitoso. ¡Bienvenido, %usuario%!
pause
goto opciones_sesion

:opciones_sesion
cls
echo Opciones de sesión:
echo 1. Modificar contraseña
echo 2. Eliminar usuario
echo 3. Cerrar sesión
set /p opcion="Seleccione una opción: "

if "%opcion%"=="1" goto modificar_contrasena
if "%opcion%"=="2" goto eliminar_usuario
if "%opcion%"=="3" goto inicio
goto opciones_sesion

:modificar_contrasena
cls
echo Modificar Contraseña
echo.
set /p nueva_pass="Ingrese nueva contraseña: "
set /p nueva_pass_confirm="Confirme nueva contraseña: "
if "%nueva_pass%" neq "%nueva_pass_confirm%" (
    echo Las contraseñas no coinciden. Intentelo de nuevo.
    pause
    goto modificar_contrasena
)
set "usuario_antiguo=%usuario%"
set "contrasena_antigua=%pass%"
set /p usuario="Ingrese nombre de usuario: "
set /p pass="Ingrese contraseña antigua: "
findstr /i "^%usuario_antiguo%:%contrasena_antigua%" usuarios.txt > nul
if errorlevel 1 (
    echo Usuario o contraseña incorrectos.
    pause
    goto opciones_sesion
)
rem Elimina la línea antigua
type usuarios.txt | findstr /v /i "^%usuario_antiguo%:%contrasena_antigua%" > usuarios_temp.txt
rem Añade la nueva línea
echo %usuario%:%nueva_pass% >> usuarios_temp.txt
move /y usuarios_temp.txt usuarios.txt > nul
echo Contraseña modificada exitosamente.
pause
goto opciones_sesion

:eliminar_usuario

cls
Set /p respuesta=¿Esta seguro de que desea borrar el usuario? (S/N):
if "%respuesta%"=="S" (
findstr /v %nombre%;%contrasena% usuarios.txt > usuarios_temp.txt
move /y usuarios_temp.txt usuarios.txt > nul
echo El usuario "%nombre%" ha sido eliminado correctamente.
pause
goto menu_principal
) else if "%respuesta%"=="N" (
echo Perfecto, no borramos el usuario. Le devolvemos a las opciones de su usuario.
pause
goto menu_sesion
) else (
echo No se ha detectado el caracter. "Recuerde escribir la confirmacion en mayusculas"
pause
goto eliminar_usuario
)

