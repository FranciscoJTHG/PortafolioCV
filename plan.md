# Plan de Despliegue a Producción

Este documento detalla las tareas necesarias para analizar, preparar y desplegar el portafolio Astro en un entorno de producción. La estrategia se basa en el uso de **Docker** y **Nginx** como se define en los archivos de configuración del proyecto.

---

## Fase 1: Análisis y Preparación

El objetivo de esta fase es asegurar que la configuración existente sea óptima para producción.

- [ ] **Revisar `Dockerfile` de Producción:**
    -   Verificar que se esté utilizando una imagen base de Node.js ligera (ej. `node:18-alpine`).
    -   Asegurar que el `Dockerfile` implemente una **construcción multi-etapa (multi-stage build)**. La primera etapa debe construir el proyecto Astro (`pnpm build`), y la segunda etapa debe copiar únicamente los archivos estáticos generados (el directorio `dist/`) a una imagen ligera de Nginx (ej. `nginx:alpine`).
    -   Confirmar que se copian los archivos de configuración de Nginx (`nginx.conf`) correctamente.

- [ ] **Revisar `nginx.conf`:**
    -   Asegurar que la configuración de Nginx esté optimizada para servir archivos estáticos.
    -   Implementar cabeceras de cacheo (`Cache-Control`) para los assets (`.js`, `.css`, `.webp`, etc.) para mejorar el rendimiento.
    -   Añadir cabeceras de seguridad (HSTS, X-Frame-Options, etc.) para mayor protección.
    -   Configurar una página de error 404 personalizada para que apunte a la página `404.astro` generada.

- [ ] **Revisar `docker-compose.yml`:**
    -   Verificar que el `docker-compose.yml` (el de producción, no el `.dev`) esté configurado correctamente.
    -   Asegurar que el servicio se reinicie automáticamente en caso de fallo (`restart: always`).
    -   Confirmar que los puertos estén mapeados correctamente (ej. `80:80` y/o `443:443`).

- [ ] **Validar Variables de Entorno:**
    -   Revisar `src/config.ts` y otros archivos para identificar si se usan variables de entorno.
    -   Asegurarse de que el método para pasar secretos o configuraciones de producción al contenedor sea seguro y no se expongan en el `Dockerfile`.

- [ ] **Optimización de Assets:**
    -   Verificar que todas las imágenes (`.webp`, `.png`) estén comprimidas y optimizadas para la web.
    -   Revisar el tamaño del PDF del CV (`Francisco_Thielen_CV.pdf`) y optimizarlo si es posible sin perder calidad.

---

## Fase 2: Construcción y Pruebas Locales

Simular el entorno de producción de forma local para validar que todo funciona como se espera.

- [ ] **Limpiar dependencias:**
    -   Ejecutar `pnpm install` para asegurar que todas las dependencias del `pnpm-lock.yaml` estén correctamente instaladas.

- [ ] **Construir la aplicación Astro:**
    -   Ejecutar el comando de build de producción: `pnpm build`.
    -   Verificar que el directorio `dist/` se genere sin errores.

- [ ] **Construir la imagen de Docker de producción:**
    -   Utilizar el compose de producción: `docker-compose build`.

- [ ] **Levantar el contenedor y verificar:**
    -   Ejecutar `docker-compose up`.
    -   Acceder a `http://localhost` en el navegador y realizar una verificación completa:
        -   Navegar por todas las páginas.
        -   Verificar que los estilos se cargan correctamente.
        -   Probar la descarga del CV.
        -   Revisar la consola del navegador en busca de errores.
        -   Comprobar que la API de RSS (`/rss.xml`) funcione.

---

## Fase 3: Despliegue en Servidor

Pasos para desplegar la aplicación en el servidor de producción (ej. una VM en la nube).

- [ ] **Preparación del Servidor:**
    -   Asegurarse de que el servidor tenga **Docker** y **Docker Compose** instalados.

- [ ] **Transferencia de Archivos:**
    -   Clonar el repositorio en el servidor (`git clone`). Es la práctica recomendada.
    -   Asegurarse de que el branch principal (`main` o `master`) esté actualizado.

- [ ] **Construcción en Producción:**
    -   Dentro del directorio del proyecto en el servidor, ejecutar `docker-compose build` para construir la imagen de producción.

- [ ] **Lanzamiento de la Aplicación:**
    -   Ejecutar `docker-compose up -d` para iniciar el contenedor en modo detached.

- [ ] **Configuración de DNS:**
    -   Apuntar el registro A o CNAME de tu dominio al a la IP del servidor de producción.

- [ ] **(Recomendado) Configurar HTTPS con Let's Encrypt:**
    -   Modificar el `docker-compose.yml` para integrar **Certbot** y generar un certificado SSL/TLS.
    -   Actualizar `nginx.conf` para que escuche en el puerto 443, utilice los certificados generados y redirija todo el tráfico HTTP a HTTPS.

---

## Fase 4: Tareas Post-Despliegue y Mantenimiento

- [ ] **Monitoreo:**
    -   Revisar los logs del contenedor para detectar cualquier error inicial: `docker-compose logs -f`.

- [ ] **Plan de Actualización:**
    -   Definir el proceso para futuras actualizaciones:
        1.  `git pull` en el servidor.
        2.  `docker-compose build` para reconstruir la imagen con los cambios.
        3.  `docker-compose up -d` para reiniciar el contenedor con la nueva versión.

- [ ] **(Mejora Futura) Implementar CI/CD:**
    -   Configurar un pipeline de CI/CD (ej. con GitHub Actions) para automatizar todo el proceso de despliegue cada vez que se haga un `push` a la rama principal.
