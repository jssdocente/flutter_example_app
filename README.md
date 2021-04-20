# app

Apolo Emergencias

## Guia para publicar aplicacion en producción (release)

### Android
(Muy buena guia con todos los pasos necesarios para crear la release de la aplicación)[https://rharshad.com/publish-flutter-app-playstore/]
 
#### Versionado
El versionado en Android, es por **versionCode** y **versionName**.
"versionCode": Es un codigo interno, y es numerico. Es incremental, y habría que incrementarlo con cada build.
"versionName": Es el nombre de la versión que se le muestra al usuario. Es un texto, y por tanto solo tiene fines visuales, la que importa a nivel de Android/Google-play es la otra.

Actualización version:A.B.C+X en pubspec.yaml.

##### Para Android:
_A.B.C_ representa el versionName como _1.0.0_.
X (el número después del _+_) representa el versionCode como _1_, _2_, _3_, etc.

Cuando ejecuta _flutter packages get_ después de actualizar este version en el archivo pubspec, los versionName y versionCode en _local.properties_ se actualizan y luego se recogen en build.gradle (app) cuando construye su proyecto de flutter usando _flutter build_ o _flutter run_ que finalmente es responsable de configurar versionName y versionCode para el apk.

##### Para iOS:
_A.B.C_ representa el CFBundleShortVersionString como _1.0.0_.
X (el número después del _+_) representa el CFBundleVersion como _1_, _2_, _3_, etc.


## Intrucciones para compilar
Hay 2 tipos de compilaciones, APK y Bundle
- APK genera una fichero .apk que se puede instalar en un tipo de dispositivo especifico (según procesador, ...)
- BUNDLE es otro formato, donde es Google Play a la hora de instalar una app, la que termina la compilación para ese dispositivo específico.
Bundle ocupa más, pero es válido para cualquier dispositivo.

### Compilar apk

compilar:
 flutter build apk -t lib/main_prod.dart --release --split-per-abi
artefactos:
 los artefactos generados se guardan en {root}\build\app\outputs\apk\release

### Compilar BUNDLE

 compilar:
  flutter build appbundle -t lib/main_prod.dart --release
 artefactos:
   los artefactos generados se guardan en {root}\build\app\outputs\bundle\release

 Para testear offilne un bundle, y asegurarnos de que funcionará bien Online, ...
 1- Descargar jar de https://github.com/google/bundletool/releases
 2- Generate apks for your app bundle by running below command:

Ejemplo real:
Esta comando genera un APKs para todos los dispositivos.
java -jar E:\_dev\tools\flutter\bundletool\bundletool-all-1.2.0.jar build-apks --bundle=build\app\outputs\bundle\release\app-release.aab --output=E:\_dev\flutter\projects\packages\csi_mobile_app\build\app\outputs\bun
dle\release\app-release.apks --ks=E:\_dev\flutter\projects\packages\csi_mobile_app\android\keystore\scsiapp.jks  --ks-pass=pass:fjmj28051117* --ks-key-alias=SCSI

Si queremos generarlo para un disposivo especifico, por ejemplo el que esté conectado: (agregamos al commando)
--connected-devide --device-id {deviceid}

Para obtener el dispositivo especifico:
flutter devices





### Instalar en dispositivo
> enviar a dispositivo:
>    flutter install -d "<devideId>"  //Para obtenerlo, ejecutar el comando flutter install y visualiza todos los dispositivos conectados


### Solucion de errores

Para compilar y visualizar los errores de la ejecuión del plugin de gradle:

#### Pasos
Desde directorio root de la app, cd android, y desde alli ejecutar
>> gradlew assembleRelease --stacktrace



# Publicacion en Tiendas

## Google Play


### Verificación
Para verificar ya que la aplicación se accede con usuario y contraseña, es necesario un usuario/ficticio para que Google pueda revisar la aplicacion.

usuario ficticio:  99999999 | 692351

### Imagenes
Son necesarias una serie de imagenes, así como el logotipo de la aplicacion.

### Imagenes


# CONFIGURACIONES TIENDA APLICACIONES

## Google Play



## App Store

- Es neceario crear una cuenta de desarrollador
En esta guia se explican los pasos [https://soporte.tu-app.net/portal/es/kb/articles/crear-una-cuenta-desarrollador-de-apple#Paso_1_Comenzar_el_Enrollment]






# OTROS

## Librerias

### Firebase Messaging

Configuracion para iOS [https://firebase.google.com/docs/cloud-messaging/ios/certs]

