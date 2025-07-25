import fs from 'fs/promises';
import path from 'path';
import puppeteer from 'puppeteer';
import { PDFDocument } from 'pdf-lib';

const CV_DIR = path.join(process.cwd(), 'public', 'cv');
const HTML_PATH = path.join(process.cwd(), 'dist', 'cv-template', 'index.html');
const PDF_PATH = path.join(CV_DIR, 'Francisco_Thielen_CV.pdf');

/**
 * Agrega metadatos a un buffer de PDF.
 * @param pdfBuffer El buffer del PDF original.
 * @returns Un buffer del PDF con los metadatos añadidos.
 */
async function addMetadata(pdfBuffer: Buffer): Promise<Uint8Array> {
  const pdfDoc = await PDFDocument.load(pdfBuffer.buffer as ArrayBuffer);
  pdfDoc.setTitle('CV Francisco Thielen - Ing. de Software');
  pdfDoc.setAuthor('Francisco J. Thielen G.');
  pdfDoc.setSubject('Curriculum Vitae');
  pdfDoc.setKeywords(['javascript', 'react', 'astro', 'typescript', 'Java', 'Spring', 'Node.js']);
  pdfDoc.setCreator('Portfolio CV Generator');
  pdfDoc.setProducer('Generated with pdf-lib and Puppeteer');
  return pdfDoc.save();
}

/**
 * Genera el archivo PDF a partir del HTML de CV construido.
 */
const generatePDF = async () => {
  console.log('Iniciando generación de PDF...');

  let browser;

  try {
    // Asegurarse de que el directorio de salida exista
    await fs.mkdir(CV_DIR, { recursive: true });

    console.log('Lanzando navegador (Puppeteer)...');
    browser = await puppeteer.launch({
      headless: true,
      args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage'],
    });

    const page = await browser.newPage();

    console.log(`Cargando HTML desde: ${HTML_PATH}`);
    const htmlContent = await fs.readFile(HTML_PATH, 'utf8');

    await page.setContent(htmlContent, {
      waitUntil: 'networkidle0',
    });

    await page.emulateMediaType('print');

    console.log('Generando buffer de PDF...');
    const pdfBuffer = await page.pdf({
      format: 'A4',
      printBackground: true,
      margin: {
        top: '1mm',
        right: '1mm',
        bottom: '1mm',
        left: '1mm',
      },
      preferCSSPageSize: true,
    });

    console.log('Agregando metadatos al PDF...');
    const finalPdfBuffer = await addMetadata(pdfBuffer);

    console.log(`Guardando PDF en: ${PDF_PATH}`);
    await fs.writeFile(PDF_PATH, finalPdfBuffer);

    console.log('✅ PDF generado exitosamente.');

  } catch (error) {
    console.error('❌ Error al generar el PDF:', error);
    process.exit(1);
  } finally {
    if (browser) {
      console.log('Cerrando navegador...');
      await browser.close();
    }
  }
};

// Ejecutar la función
generatePDF();
