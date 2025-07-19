/// <reference path="../.astro/types.d.ts" />
/// <reference types="astro/client" />

// Declaración de tipos para archivos estáticos
declare module "*.svg" {
    const content: string;
    export default content;
}

declare module "*.png" {
    const content: string;
    export default content;
}

// Tipos para variables de entorno
interface ImportMetaEnv {
    readonly PUBLIC_API_URL: string;
    // Añade más variables según necesites
}