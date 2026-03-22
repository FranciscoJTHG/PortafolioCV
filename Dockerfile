# ---- Etapa 1: Build ----
FROM node:20-slim AS build

LABEL maintainer="Francisco J. Thielen G." \
      description="Portfolio CV - Astro static site" \
      version="3.0.0"

ENV NODE_ENV=production

# Instala dependencias del sistema necesarias para Puppeteer Chromium
# Se hace antes de COPY para aprovechar el cache de Docker
RUN apt-get update && apt-get install -y \
    fontconfig \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libnss3 \
    libxss1 \
    libasound2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libcairo2 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxext6 \
    libxi6 \
    libxrender1 \
    libxtst6 \
    libglib2.0-0 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Instala pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copia manifiestos de dependencias (capa cacheada — cambia raramente)
COPY package.json pnpm-lock.yaml ./

# Instala dependencias
RUN pnpm install --frozen-lockfile

# Descarga el binario de Chromium para Puppeteer
RUN npx puppeteer browsers install chrome

# Copia el código fuente (capa que cambia con frecuencia — va al final)
COPY . .

# Construye la aplicación Astro para producción
RUN pnpm build

# Genera el archivo PDF del CV
RUN pnpm generatePdf

# ---- Etapa 2: Production ----
FROM nginx:1.27-alpine

LABEL maintainer="Francisco J. Thielen G." \
      description="Portfolio CV - Nginx static server"

# Instalar curl para health checks
RUN apk add --no-cache curl

# Copia la configuración de Nginx personalizada
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia los artefactos estáticos desde la etapa de build
COPY --from=build /app/dist /usr/share/nginx/html
COPY --from=build /app/public /usr/share/nginx/html/public

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:80 || exit 1

CMD ["nginx", "-g", "daemon off;"]
