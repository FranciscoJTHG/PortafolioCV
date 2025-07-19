# ---- Etapa 1: Build ----
# Usa una imagen de Node.js que incluye pnpm
FROM node:20-slim as build

# Instala pnpm
RUN npm install -g pnpm

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de manifiesto del proyecto
COPY package.json pnpm-lock.yaml ./

# Instala las dependencias
RUN pnpm install --frozen-lockfile

# Copia el resto del código fuente
COPY . .

# Instala las dependencias necesarias para Chromium
RUN apt-get update && apt-get install -y     chromium     fontconfig     fonts-ipafont-gothic     fonts-wqy-zenhei     fonts-thai-tlwg     fonts-kacst     --no-install-recommends &&     rm -rf /var/lib/apt/lists/*

# Construye la aplicación Astro para producción
RUN pnpm build

# Genera el archivo PDF del CV
RUN pnpm generatePdf

# ---- Etapa 2: Production ----
# Usa una imagen de Nginx ligera
FROM nginx:1.27-alpine

# Copia la configuración de Nginx personalizada
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia los archivos estáticos construidos desde la etapa anterior
COPY --from=build /app/dist /usr/share/nginx/html

# Copia la carpeta public (incluyendo el CV en PDF)
COPY --from=build /app/public /usr/share/nginx/html/public

# Expone el puerto 80
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
