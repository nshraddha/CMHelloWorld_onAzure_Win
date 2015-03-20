rd "\%ROLENAME%"

if defined DEPLOYROOT_PATH set DEPLOYROOT=%DEPLOYROOT_PATH%
if defined DEPLOYROOT (
	mklink /J "\%ROLENAME%" "%DEPLOYROOT%"
) else (
	mklink /J "\%ROLENAME%" "%ROLEROOT%\approot"
)

set DEPLOYROOT=\%ROLENAME%
set SERVER_APPS_LOCATION=%DEPLOYROOT%

set JAVA_HOME=%DEPLOYROOT%\zulu1.8.0_31-8.5.0.1-win64
set PATH=%JAVA_HOME%\bin;%PATH%
set CATALINA_HOME=%DEPLOYROOT%\apache-tomcat-8.0.20
set SERVER_APPS_LOCATION=%CATALINA_HOME%\webapps


cmd /c util\wash.cmd blob download "zulu1.8.0_31-8.5.0.1-win64.zip" "zulu1.8.0_31-8.5.0.1-win64.zip" eclipsedeploy portalvhds5b8stwn0jq1lf "OhiV6JXYpWkF5Ws7oZ4ayJHx4yctzB7Wbwkcj+Gi4e1U28WdcGOxPZMg51/vznsUYMwmvjIKovoDJNrFp2aLxA==" "http://core.windows.net"
if not exist "zulu1.8.0_31-8.5.0.1-win64.zip" (
	cmd /c util\wash.cmd file download "http://azure.azulsystems.com/zulu/zulu1.8.0_31-8.5.0.1-win64.zip?eclipse" "zulu1.8.0_31-8.5.0.1-win64.zip"
	if not exist "zulu1.8.0_31-8.5.0.1-win64.zip" exit 0
	cmd /c util\wash.cmd blob upload "zulu1.8.0_31-8.5.0.1-win64.zip" "zulu1.8.0_31-8.5.0.1-win64.zip" eclipsedeploy portalvhds5b8stwn0jq1lf "OhiV6JXYpWkF5Ws7oZ4ayJHx4yctzB7Wbwkcj+Gi4e1U28WdcGOxPZMg51/vznsUYMwmvjIKovoDJNrFp2aLxA==" "http://core.windows.net"
) else (
	echo
)
if not exist "zulu1.8.0_31-8.5.0.1-win64.zip" exit 0
cscript /NoLogo util\unzip.vbs "zulu1.8.0_31-8.5.0.1-win64.zip" "%DEPLOYROOT%"
del /Q /F "zulu1.8.0_31-8.5.0.1-win64.zip"
cmd /c util\wash.cmd blob download "apache-tomcat-8.0.20.zip" "apache-tomcat-8.0.20.zip" eclipsedeploy portalvhds5b8stwn0jq1lf "OhiV6JXYpWkF5Ws7oZ4ayJHx4yctzB7Wbwkcj+Gi4e1U28WdcGOxPZMg51/vznsUYMwmvjIKovoDJNrFp2aLxA==" "http://core.windows.net"
if not exist "apache-tomcat-8.0.20.zip" (
	cmd /c util\wash.cmd file download "https://azuredownloads.blob.core.windows.net/tomcat/apache-tomcat-8.0.20.zip" "apache-tomcat-8.0.20.zip"
	if not exist "apache-tomcat-8.0.20.zip" exit 0
	cmd /c util\wash.cmd blob upload "apache-tomcat-8.0.20.zip" "apache-tomcat-8.0.20.zip" eclipsedeploy portalvhds5b8stwn0jq1lf "OhiV6JXYpWkF5Ws7oZ4ayJHx4yctzB7Wbwkcj+Gi4e1U28WdcGOxPZMg51/vznsUYMwmvjIKovoDJNrFp2aLxA==" "http://core.windows.net"
) else (
	echo
)
if not exist "apache-tomcat-8.0.20.zip" exit 0
cscript /NoLogo util\unzip.vbs "apache-tomcat-8.0.20.zip" "%DEPLOYROOT%"
del /Q /F "apache-tomcat-8.0.20.zip"
cmd /c util\wash.cmd blob download "CMHelloWorld.war" "CMHelloWorld.war" eclipsedeploy portalvhds5b8stwn0jq1lf "OhiV6JXYpWkF5Ws7oZ4ayJHx4yctzB7Wbwkcj+Gi4e1U28WdcGOxPZMg51/vznsUYMwmvjIKovoDJNrFp2aLxA==" "http://core.windows.net"
if not exist "CMHelloWorld.war" exit 0
if not "%SERVER_APPS_LOCATION%" == "\%ROLENAME%" if exist "CMHelloWorld.war"\* (echo d | xcopy /y /e /q "CMHelloWorld.war" "%SERVER_APPS_LOCATION%\CMHelloWorld.war" 1>nul) else (echo f | xcopy /y /q "CMHelloWorld.war" "%SERVER_APPS_LOCATION%\CMHelloWorld.war" 1>nul)
start "Azure" /D"%CATALINA_HOME%\bin" startup.bat


:: *** This script will run whenever Azure starts this role instance.
:: *** This is where you can describe the deployment logic of your server, JRE and applications 
:: *** or specify advanced custom deployment steps
::     (Note though, that if you're using this in Eclipse, you may find it easier to configure the JDK,
::     the server and the server and the applications using the New Azure Deployment Project wizard 
::     or the Server Configuration property page for a selected role.)

echo Hello World!


@ECHO OFF
set ERRLEV=%ERRORLEVEL%
if %ERRLEV%==0 (set _MSG="Startup completed successfully.") else (set _MSG="*** Azure startup failed [%ERRLEV%]- exiting...")
choice /d y /t 5 /c Y /N /M %_MSG%
exit %ERRLEV%