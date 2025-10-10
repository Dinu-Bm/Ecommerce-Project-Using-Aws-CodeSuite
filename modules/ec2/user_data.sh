#!/bin/bash
# --------------------------
# Update system packages
# --------------------------
apt-get update -y

# --------------------------
# Install Docker
# --------------------------
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

# --------------------------
# Install Docker Compose
# --------------------------
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# --------------------------
# Create application directory
# --------------------------
mkdir -p /opt/ecommerce-app
cd /opt/ecommerce-app

# --------------------------
# Dockerfile
# --------------------------
cat > Dockerfile << 'EOF'
FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev zip unzip git curl

RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd pdo pdo_mysql mysqli zip

RUN a2enmod rewrite

COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

EXPOSE 80
EOF

# --------------------------
# docker-compose.yml
# --------------------------
cat > docker-compose.yml << EOF
version: '3.8'

services:
  web:
    build: .
    ports:
      - "80:80"
    environment:
      DB_HOST: ${db_endpoint}
      DB_NAME: ${db_name}
      DB_USER: ${db_username}
      DB_PASS: ${db_password}
    restart: always
EOF

# --------------------------
# PHP Application
# --------------------------
cat > index.php << 'EOF'
<?php
$servername = getenv('DB_HOST');
$username   = getenv('DB_USER');
$password   = getenv('DB_PASS');
$dbname     = getenv('DB_NAME');

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Create products table if not exists
$sql = "CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

if ($conn->query($sql) === TRUE) {
    $insert_sql = "INSERT IGNORE INTO products (name, price, description) VALUES 
        ('Laptop', 999.99, 'High-performance laptop'),
        ('Smartphone', 699.99, 'Latest smartphone'),
        ('Headphones', 199.99, 'Noise-cancelling headphones'),
        ('Tablet', 499.99, 'Portable tablet')";
    $conn->query($insert_sql);
}

// Fetch products
$result = $conn->query("SELECT * FROM products");

echo "<!DOCTYPE html>
<html>
<head>
<title>E-Commerce Store</title>
<style>
body { font-family: Arial; margin: 20px; background: #f5f5f5; }
.container { max-width: 1000px; margin: auto; background: #fff; padding: 20px; border-radius: 10px; }
.header { background: #667eea; color: white; padding: 20px; text-align: center; border-radius: 10px; margin-bottom: 20px; }
.product-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
.product-card { border: 1px solid #ddd; padding: 15px; border-radius: 10px; text-align: center; transition: transform 0.3s, box-shadow 0.3s; }
.product-card:hover { transform: translateY(-5px); box-shadow: 0 5px 15px rgba(0,0,0,0.2); }
.product-name { font-weight: bold; margin-bottom: 5px; }
.product-price { color: #667eea; font-weight: bold; margin-bottom: 5px; }
</style>
</head>
<body>
<div class='container'>
<div class='header'><h1>🚀 Welcome to Our E-Commerce Store!</h1></div>
<div class='product-grid'>";
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        echo "<div class='product-card'><div class='product-name'>".$row['name']."</div><div class='product-price'>\$".$row['price']."</div><div class='product-description'>".$row['description']."</div></div>";
    }
} else {
    echo "<p>No products found</p>";
}
echo "</div></div></body></html>";
$conn->close();
?>
EOF

# --------------------------
# Build and run Docker container
# --------------------------
docker-compose up --build -d
