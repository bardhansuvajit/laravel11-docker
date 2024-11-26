
#Docker Template for Laravel

#####Using PHP 8, PHP-FPM, Nginx and PCOV for testing

Server, runs as non root user for enhanced security. Health checks for DB is included.

To use, clone this repo first, then create your laravel project. If you already have your laravel project files created, then clonning wont work because your dir is not empty. in this case just clone files to a new directory, delete the .git file inside the new directory and copy all the fiels to your laravel project. I.e
````
mkdir laravel-docker-template
git clone https://github.com/emad-zaamout/laravel-docker-template laravel-docker-template
rm -rf laravel-docker-template/.git
cp -R laravel-docker-template/* your_laravel_project_dir
````


Inside your .env file, add the following values for your database
````
DB_CONNECTION=mysql
DB_HOST=database_mysql
DB_PORT=3306
DB_DATABASE=default
DB_USERNAME=laravel
DB_PASSWORD=secret
````
Or adjust the docker-compose.yml accordingly.

I also added an optional Makefile that contains commands to build and start containers. See Makefile or in your terminal write `make` to see list of commands. If you adjusted the container name inside the `docker-compose.yml` make sure to adjust the `CONTAINER_PHP=api` inside the Makefile.









Verify MySQL User Configuration
Log into the MySQL container and check the user permissions:

Access the MySQL container:
bash
Copy code
docker compose exec mysql bash
Log in to MySQL as the root user:
bash
Copy code
mysql -u root -p
Grant privileges to the suvajit user for the lara11_docker database:
sql
Copy code
GRANT ALL PRIVILEGES ON lara11_docker.* TO 'suvajit'@'%';
FLUSH PRIVILEGES;
Verify the user’s privileges:
sql
Copy code
SHOW GRANTS FOR 'suvajit'@'%';
3. Verify Database Existence
Ensure the lara11_docker database exists:

sql
Copy code
SHOW DATABASES;
If it doesn’t exist, create it:

sql
Copy code
CREATE DATABASE lara11_docker;
4. Restart the Containers
After making changes, restart the containers to apply the updated configurations:

bash
Copy code
docker compose down
docker compose up -d
5. Run Laravel Migrations
Enter the Laravel container and run migrations to set up the database schema:

bash
Copy code
docker compose exec app bash
php artisan migrate