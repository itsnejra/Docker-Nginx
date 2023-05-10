# Koristite sliku temeljenu na Node.js-u
FROM node:latest

# Postavljanje radnog direktorija za Node.js aplikaciju
WORKDIR /usr/src/app

# Kopiranje package.json i package-lock.json u radni direktorij
COPY package*.json ./

# Instalacija ovisnosti aplikacije
RUN npm install

# Kopiranje ostatka aplikacije u radni direktorij
COPY . .

# Izgradnja aplikacije
RUN npm run build

# Koristite sliku temeljenu na Nginx-u
FROM nginx:latest

# Kopiranje konfiguracijske datoteke Nginx-a u sliku
COPY nginx.conf /etc/nginx/nginx.conf

# Kopiranje izgrađene aplikacije iz prethodne faze u direktorij koji Nginx koristi za posluživanje
COPY --from=0 /usr/src/app/build /usr/share/nginx/html

# Postavite izloženi port kontejnera
EXPOSE 80

# Pokretanje Nginx-a u prvom planu prilikom pokretanja kontejnera
CMD ["nginx", "-g", "daemon off;"]
