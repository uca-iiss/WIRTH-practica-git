#Configuracion de Docker Compose para los dos ejercicios de la practica de Docker

#Descripción Este entregable consiste en la configuración y ejecución de dos enternos usando Docker Compose, el primero con Drupas y MySQL desde el puerto 81, y el segundo accesible en el puerto 82 con WordPress y MariaDb. Configurados con volúmenes para persistir la información y el segundo conectado a la red 'redDocker'.

#Primer ejercicio Drupas + MySQL: se utiliza las imágenes oficiales de Drupal y MySQL, configuramos el contendor de Drupal en el puerto 81 y creamos un volumen para almacenar la base de datos de MySQL. Ejecutamos el docker-compose para levantar los contenedores con el siguiente comando: docker-compose up -d. Una vez levantado los contenedores accedemos a a http://localhost:81 para comprobar que funciona correctamente.

#WordPress + MariaBD: utilizamos las imágenes oficiales de WordPress y MariaBD más recientes, configuramos el contendor WordPress para que trabaje en el puerto 82 y creamos un volumen para almacenar la base de datos en MariaBD y conectamos ambos servicios a la red 'redDocker'. Ejecutamos el docker-compose para levantar los contenedores con el comando anteriormente mencionado. Una vez levantado los contenedores accedemos a a http://localhost:82 para comprobar que funciona correctamente.

Una vez realizada la práctica lo subimos creando una rama para cada ejercicio y realizando un merge a la rama principal de GitHub.