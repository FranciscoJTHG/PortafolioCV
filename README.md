# Portafolio Personal

Proyecto personal que me permitió profundizar en el funcionamiento del framework Astro al realizar adecuaciones personalizadas a una plantilla. Está diseñado para mostrar mis habilidades, proyectos personales y sintesis curricular. Se puede ejecutar fácilmente por medio de Docker para entornos de desarrollo y producción.

## Características

*   **Portafolio de Proyectos**: Muestra de proyectos con descripciones detalladas y enlaces.
<!-- *   **Blog Personal**: Comparte tus conocimientos y experiencias a través de artículos de blog. -->
*   **Sección de CV/Currículum**: Presentar experiencia profesional y habilidades de manera clara.
<!-- *   **Tienda (Opcional)**: Integración para mostrar y vender productos digitales. -->
*   **Generación de PDF del CV**: Generación automática de una versión en PDF del CV. Para asegurar la compatibilidad en diferentes entornos (local y Docker), el proceso de construcción incluye la descarga de una versión de Chromium compatible con Puppeteer.
*   **Formulario de Contacto con Formspark**: Envíar mensajes directamente desde el sitio web utilizando la API de Formspark.
*   **Diseño Responsivo**: Diseño adaptado para verse bien en distintos dispositivo.
<!-- *   **Optimización SEO**: Construido con las mejores prácticas para motores de búsqueda. -->
*   **Rendimiento Rápido**: Aprovecha la arquitectura de islas de Astro para una carga rápida.
*   **Temas Personalizables**: Fácil cambio de temas gracias a DaisyUI.

## Pila Tecnológica

*   [Astro](https://astro.build) - Framework web para construir sitios rápidos y modernos.
*   [TailwindCSS](https://tailwindcss.com/) - Framework CSS utilitario para un diseño rápido y personalizado.
*   [DaisyUI](https://daisyui.com/) - Librería de componentes de TailwindCSS para una interfaz de usuario elegante.
*   [Node.js](https://nodejs.org/) - Entorno de ejecución para JavaScript.
*   [pnpm](https://pnpm.io/) - Gestor de paquetes rápido y eficiente.
*   [Docker](https://www.docker.com/) - Plataforma para desarrollar, enviar y ejecutar aplicaciones en contenedores.
*   [Nginx](https://www.nginx.com/) - Servidor web ligero y de alto rendimiento (para producción).

## Ejecución del Proyecto con Docker

Este proyecto está configurado para ser ejecutado fácilmente usando Docker y Docker Compose.

### Requisitos

*   [Docker Desktop](https://www.docker.com/products/docker-desktop/) (o Docker Engine y Docker Compose instalados en tu sistema).

### 1. Entorno de Desarrollo

Para iniciar el proyecto en modo de desarrollo con recarga en caliente y mapeo de volúmenes:

1.  **Clona el repositorio** (si aún no lo has hecho):
    ```bash
    git clone https://github.com/manuelernestog/astrofy.git
    cd astrofy
    ```

2.  **Inicia los servicios de desarrollo**: 
    ```bash
    docker-compose -f docker-compose.dev.yml up --build
    ```
    Esto construirá la imagen `portfolio-dev` (si es necesario) e iniciará el servidor de desarrollo de Astro. El código fuente local se montará en el contenedor, permitiendo cambios en tiempo real.

3.  **Accede a la aplicación**: Abre tu navegador y ve a `http://localhost:4321`.

### 2. Entorno de Producción

Para construir y ejecutar el proyecto en un entorno de producción, utilizando Nginx para servir los archivos estáticos:

1.  **Construye e inicia los servicios de producción**: 
    ```bash
    docker-compose -f docker-compose.yml up --build -d
    ```
    Esto construirá la imagen `portfolio_prod`, generará el sitio estático y el PDF del CV, y luego servirá la aplicación usando Nginx en segundo plano.

2.  **Accede a la aplicación**: Abre tu navegador y ve a `http://localhost:80`.

### Comandos Útiles de Docker Compose

*   **Detener los servicios**: 
    ```bash
    docker-compose -f docker-compose.dev.yml down
    # o para producción
    docker-compose -f docker-compose.yml down
    ```
*   **Reconstruir imágenes (si hay cambios en Dockerfile)**:
    ```bash
    docker-compose -f docker-compose.dev.yml build
    # o para producción
    docker-compose -f docker-compose.yml build
    ```
*   **Ver logs de los contenedores**: 
    ```bash
    docker-compose -f docker-compose.dev.yml logs -f
    # o para producción
    docker-compose -f docker-compose.yml logs -f
    ```

## Estructura del Proyecto

```
├── src/
│   ├── components/         # Componentes reutilizables de Astro
│   ├── content/            # Colecciones de contenido (blog, proyectos, tienda)
│   ├── layouts/            # Diseños de página base
│   ├── lib/                # Utilidades y funciones de ayuda
│   ├── pages/              # Páginas de Astro (rutas)
│   ├── scripts/            # Scripts para tareas como la generación de PDF
│   ├── styles/             # Estilos globales
│   ├── types/              # Definiciones de tipos de TypeScript
│   └── config.ts           # Configuración global del sitio
├── public/                 # Archivos estáticos (imágenes, CV en PDF)
├── docker-compose.dev.yml  # Configuración de Docker Compose para desarrollo
├── docker-compose.yml      # Configuración de Docker Compose para producción
├── Dockerfile              # Dockerfile para la imagen de producción
├── Dockerfile.dev          # Dockerfile para la imagen de desarrollo
├── nginx.conf              # Configuración de Nginx para producción
├── package.json            # Dependencias y scripts del proyecto
├── pnpm-lock.yaml          # Archivo de bloqueo de pnpm
├── tailwind.config.cjs     # Configuración de TailwindCSS
└── tsconfig.json           # Configuración de TypeScript
```

## Configuración del Sitio

Puedes modificar la configuración global del sitio en el archivo `/src/config.ts`:

*   **SITE\_TITLE**: Título predeterminado de las páginas.
*   **SITE\_DESCRIPTION**: Descripción predeterminada de las páginas.
*   **GENERATE\_SLUG\_FROM\_TITLE**: Genera slugs de publicaciones de blog basados en el título. Establece a `false` para usar el enrutamiento basado en archivos de Astro.
*   **TRANSITION\_API**: Habilita o deshabilita la API de transiciones de vista.

<!-- ## Gestión de Contenido -->

<!-- Este proyecto utiliza [colecciones de contenido de Astro](https://docs.astro.build/en/guides/content-collections/) para organizar el blog, los proyectos y los elementos de la tienda. Se encuentran en la carpeta `/src/content/`. -->

<!-- ### Publicaciones del Blog -->

<!-- Agrega tus publicaciones de blog en formato Markdown (`.md`) en la carpeta `/src/content/blog/`. -->

<!-- **Ejemplo de Formato de Publicación**:

```markdown
---
title: "Título de la Publicación"
description: "Descripción de tu publicación"
pubDate: "Sep 10 2022"
heroImage: "/ruta/a/tu/imagen.webp"
---
``` -->

### Proyectos

Agrega tus entradas de proyecto en formato Markdown (`.md`) en la carpeta `/src/content/projects/`.

**Ejemplo de Formato de Proyecto**:

```markdown
---
title: "Título del Proyecto"
description: "Descripción de tu proyecto"
pubDate: "Oct 20 2023"
img: "/ruta/a/tu/imagen-proyecto.webp"
url: "https://tu-url-proyecto.com"
tags: ["Desarrollo Web", "Astro", "TailwindCSS"]
---
```

<!-- ### Artículos de la Tienda

Agrega tus artículos de la tienda en formato Markdown (`.md`) en la carpeta `/src/content/store/`.

**Ejemplo de Formato de Artículo**:

```markdown
---
title: "Artículo de Ejemplo 1"
description: "Descripción del artículo"
heroImage: "/ruta/a/tu/imagen-articulo.webp"
details: true # mostrar u ocultar botón de detalles
custom_link_label: "Etiqueta de botón de enlace personalizado"
custom_link: "Enlace de botón personalizado"
pubDate: "Sep 15 2022"
pricing: "$15"
oldPricing: "$25.5"
badge: "Destacado"
checkoutUrl: "https://url-de-pago.com/"
---
``` -->

## Despliegue

Puedes desplegar tu sitio en cualquier servicio de alojamiento estático (Vercel, Netlify, GitHub Pages, etc.). Consulta la [documentación oficial de despliegue de Astro](https://docs.astro.build/en/guides/deploy/) para configuraciones específicas de la plataforma.

<!-- > **⚠️ PRECAUCIÓN** </br>
> La paginación del blog en esta plantilla utiliza parámetros de ruta dinámicos, que actualmente son incompatibles con las configuraciones de despliegue SSR (Server-Side Rendering). Por favor, utiliza las opciones de despliegue estático predeterminadas para tus despliegues. -->

<!-- ## Contribución

¡Las sugerencias y las solicitudes de extracción son bienvenidas! No dudes en abrir una discusión o un problema para una nueva solicitud de función o un error. -->

<!-- Una de las mejores maneras de contribuir es elegir un [informe de error o sugerencia de función](https://github.com/manuelernestog/astrofy/issues) marcado como `accepted` y empezar a trabajar en él. -->

<!-- Ten cuidado al trabajar en problemas _no_ marcados como `accepted`. El hecho de que alguien haya creado un problema no significa que aceptaremos una solicitud de extracción para él. -->

## Licencia

Astrofy está bajo la licencia MIT — consulta el archivo [LICENSE](https://github.com/manuelernestog/astrofy/blob/main/LICENSE) para más detalles.

Visualización de la plantilla origina: https://astrofy-template.netlify.app/

<!-- ## Contribuidores

<a href="https://github.com/manuelernestog/astrofy/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=manuelernestog/astrofy" />
</a>

Hecho con [contrib.rocks](https://contrib.rocks)... -->
