#Configuración de Docker Compose para Drupal + MySQL y WordPress + MariaDB

#Descripción
Este entregable consistía en configurar y ejecutar dos entornos usando Docker Compose: 
	1. Drupal + MySQL accesible en el puerto 81
	2. WordPress + MariaBD accesible en el puerto 82

Ambos servicios están configurados con volumenes para persistir la información y conectados a la red 'redDocker' 

#Configuraciones realizadas

#Github
Como tenía que subir ambos docker-compose.yml al repositorio de Github realice unos pasos previos antes de realizar cada parte de la practica: 
	- Creamos una nueva rama llamada 'feature/docker-drupal-mysql' para la parte 1 
	- Creamos una nueva rama llamada 'feature/docker-wordpress-mariaBD' para la parte 2
	- Creamos una carpeta llamada 'Practica-Docker-Adrian dentro del repositorio para almacenar los archivos

#Drupal + MySQL: 
	- Se utilizó las imagenes oficiales de Drupal y MySQL 
	- Configuramos el contendor de Drupalm en el puerto 81 
	- Creamos un volumen para almacenar la base de datos de MySQL
	- Se conecto ambos servicios a la red 'redDocker'
	- Ejecutamso el docker-compose para levantar los contenedores con el siguiente comando: 
		docker-compose up -d
	- Una vez levantado los contenedores revisamos que funciona correctamente accediendo a http://localhost:81

#WordPress + MariaBD:
	- Utilizamos las imagenes oficiales de WordPress y MariaBD
	- Configuramos el contendor WordPress para que trabaje en el puerto 81
	- Creamos un valoumen para almancenar la base de datos en MariaBD
	- Conectamso ambos servicios a la red 'redDocker'
	- Ejecutamos el docker-compose para levantar los contenedores con el comando anteriormente mencionado
	- Una vez levantado los contenedores revisamos que funciona correctamente accediendo a http://localhost:82

Una vez realizado cada configuracion deberemos de enviar los cambios heechos al repositorio remoto y eliminar las ramas tanto en el
 repositorio local como en el repositorio remoto.

	


