Despliegue de una aplicación real utilizando Terraform
Creando un sitio con Wordpress a través de la nube de DigitalOcean. Se provisionará dos droplets, una VPC para comunicación interna y un balanceador de carga. El repositorio que se utilizo para este proyecto fue GitHub - galvarado/terraform-ansible-DO-deploy-wordpress: Deploy Wordpress to Digital Ocean using terraform and ansible

Requisitos para replicar este proyecto:
	Instalar Terraform v1.2.1
	Tener una cuenta creada con Digital Ocean, para instalar dicha infraestructura
	Instalar y configurar doctl
	Code Visual

Pasos para replicar este código:
1.	Clonar este repositorio
Git clone
2.	Generar token con Digital Ocean, https://cloud.digitalocean.com/account/api/tokens	
do_token = "" Ingresar el token generado”


3.	Modificar el archivo de variables terraform.tfvars. Cambiando las siguientes variables
3.1 do_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
3.2 ssh_key_private1 = "Este key se genera desde la computadora host si es con Windows a través de Putty y con Linux con el comando “ssh-keygen” https://docs.digitalocean.com/products/droplets/how-to/add-ssh-keys/create-with-openssh/	 y se debe de colocar la ruta donde esta almacenada. En mi caso fue “~/.ssh/id_rsa” que es la ruta por default donde se almacenan las llaves en Linux. 
3.3 droplet_ssh_key_id1 = "Este id se genera a través del comando "doctl compute ssh-key list" https://docs.digitalocean.com/reference/doctl/how-to/install/

Las demás variables no son necesarias cambiarlas para realizar el deployment, ya que si se cambia se debe de cambiar en el otro archivo examen-terraform.tf, por esa razón solo se recomienda cambiar las variables mencionadas anteriormente para ejecutar el deployment, estas son necesarias para realizar la conexión de nuestra computadora a DigitalOcean

4.	Cargar el key public ssh a la cuenta de DigitalOcean, esta llave ya se genero anteriormente en los pasos anteriores, solo debemos de copiar la llave publica a nuestra cuenta de Digital Ocean. How to Upload SSH Public Keys to a DigitalOcean Account :: DigitalOcean Documentation


Aplicación que se va a instalar
### Wordpress configuration (optional)
Estos son los datos por defecto para la configuración de la base de datos MYSQL
wp_mysql_db: 
wordpress wp_mysql_user: 
wordpress wp_mysql_password: randompassword

Esto son los datos por defecto para el sitio de Wordpress
wp_site_title: New blog 
wp_site_user: superadmin 
wp_site_password: strongpasshere 
wp_site_email: some_email@example.com

##Depoyment Terraform
Para ejecutar el deployment se deben correr estos comandos
terraform plan (si no muestra ningún error ejecutar el siguiente comando)
terraform apply

Para eliminar la infraestructura que se creo anteriormente se ejecuta el siguiente comando
Terraform destroy
