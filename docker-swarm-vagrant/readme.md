# Docker Swarm  

Configuracion de Vagrant 3 nodos con Docker Swarm
 

## Instalacion
Clonar este repositorio 
cd docker-swarm-vagrant  
```

## Inicializar VMs  
Ejecutar `vagrant up`  
  - Esto configurara 3 maquinas virtuales **manager**,**worker-1**&**worker-2** todas provisionadas con docker. 
  desde la maquina manager ejecutar el comando 'docker service update --replicas 7 sweb'
  #aqui le estaremos indicando que replica 7 veces el servicio que creamos y los distribuya sobre el nodo creado. 


Para ssh en el nodo manager ejecuta el comando `vagrant ssh manager`  
Para ejecutar ssh en el nodo worker corre el comando `vagrant ssh worker-1` or `vagrant ssh worker-2`  

## Inicializacion Swarm manager
El archivo vagranfile ya contiene los scripts que provisionara automaticamente el cluster swarm 
El nodo manager iniciara el docker swarm mientras que los workers se uniran por medio de un token que se genero anteriormente.


-Con el comando docker node ls podemos ver la lista de nodos y roles de (worker/manager)  
-Se creo una red con el nombre locate para que cada contenedor pueda unirse.    
- Se creo un servicio para ejecutar contenedores desde la imagen especificada con los nodos conectados

 
##commands  
- `docker service ls`  
   Lists the services created
- `docker network ls`  
   Lists the networks created and available by default  
- `docker node ls`  
   Lists all the nodes in swarm
- `docker service ps <service-name>`  
   Lists all the containers running in all swarm nodes.
