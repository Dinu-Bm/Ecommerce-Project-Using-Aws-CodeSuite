#!/bin/bash
# Update system packages
apt-get update -y

# Install Docker
apt-get install -y docker.io

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create application directory
mkdir -p /opt/ecommerce-app

# Create Dockerfile
cat > /opt/ecommerce-app/Dockerfile << 'EOF'
FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd pdo pdo_mysql mysqli zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy application files
COPY . /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

EXPOSE 80
EOF

# Create docker-compose.yml
cat > /opt/ecommerce-app/docker-compose.yml << EOF
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

# Create a simple PHP application
mkdir -p /opt/ecommerce-app

cat > /opt/ecommerce-app/index.php << 'EOF'
<?php
\$servername = getenv('DB_HOST');
\$username = getenv('DB_USER');
\$password = getenv('DB_PASS');
\$dbname = getenv('DB_NAME');

// Create connection
\$conn = new mysqli(\$servername, \$username, \$password, \$dbname);

// Check connection
if (\$conn->connect_error) {
    die("Connection failed: " . \$conn->connect_error);
}

// Create products table if not exists
\$sql = "CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

if (\$conn->query(\$sql) === TRUE) {
    // Insert sample products if table was created
    \$insert_sql = "INSERT IGNORE INTO products (name, price, description) VALUES 
        ('Laptop', 999.99, 'High-performance laptop'),
        ('Smartphone', 699.99, 'Latest smartphone'),
        ('Headphones', 199.99, 'Noise-cancelling headphones'),
        ('Tablet', 499.99, 'Portable tablet')";
    \$conn->query(\$insert_sql);
}

// Get products
\$result = \$conn->query("SELECT * FROM products");

echo "<!DOCTYPE html>
<html>
<head>
    <title>E-Commerce Store</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .product-card {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .product-name {
            font-size: 1.2em;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        .product-price {
            color: #667eea;
            font-size: 1.1em;
            font-weight: bold;
        }
        .server-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            text-align: center;
            font-family: monospace;
        }
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h1>🚀 Welcome to Our E-Commerce Store!</h1>
            <p>Built with Docker, AWS & Terraform</p>
        </div>
        
        <div class='server-info'>
            <strong>Environment:</strong> ${environment} | 
            <strong>Server:</strong> " . gethostname() . " | 
            <strong>Containerized:</strong> Docker
        </div>

        <h2>🛍️ Our Products</h2>
        
        <div class='product-grid'>";

if (\$result->num_rows > 0) {
    while(\$row = \$result->fetch_assoc()) {
        echo "<div class='product-card'>
                <div class='product-name'>" . \$row["name"] . "</div>
                <div class='product-price'>$" . \$row["price"] . "</div>
                <div class='product-description'>" . \$row["description"] . "</div>
              </div>";
    }
} else {
    echo "<p>No products found</p>";
}

echo "    </div>
    </div>
</body>
</html>";

\$conn->close();
?>
EOF

# Build and run Docker container
cd /opt/ecommerce-app
docker-compose up --build -d