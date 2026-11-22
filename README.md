# Kobo Notes Viewer 📖✨

Un visor interactivo y ligero de notas y subrayados diseñado para lectores de tinta electrónica **Kobo** (optimizado para pantallas a color como **Kobo Libra Colour** y **Clara Colour** con E-Ink Kaleido 3, y compatible con modelos monocromáticos).

Permite consultar todas las anotaciones y citas recopiladas a lo largo de tus libros desde una pestaña o menú dedicado, sin depender de servicios externos en la nube ni de aplicaciones pesadas.

---

## ✨ Características

- 🎨 **Soporte de Color Real:** Visualiza los subrayados en su color original (amarillo, rosa, celeste, verde).
- 📄 **Paginación Fija (Anti-Ghosting):** Elimina el rastro de tinta al navegar por páginas individuales en lugar de arrastrar scroll continuo.
- 🌓 **Modo Oscuro / Modo Claro:** Interruptor rápido para alternar estilos de alto contraste según la iluminación ambiental.
- 🔍 **Buscador Instantáneo:** Filtra notas por texto, palabras clave o autor en tiempo real.
- 📚 **Selector por Libro:** Menú desplegable para ver las notas de un título específico.
- 🧹 **Refresco Rápido:** Botón de destello manual para limpiar residuos de tinta electrónica cuando lo necesites.
- ⚡ **100% Offline y Nativo:** Lee directamente de la base de datos interna SQLite del dispositivo (`KoboReader.sqlite`).

---

## 🚀 Requisitos

Necesitas un lanzador de acciones para Kobo instalado en tu lector:

- **Para Kobo OS 5.x / 6.x (Qt 6):** [Nickelite](https://github.com/open-source-arena/Nickelite)
- **Para Kobo OS 4.x (Qt 5):** [NickelMenu](https://github.com/pgaskin/NickelMenu)

---

## 📦 Instalación

1. Conecta tu Kobo a la computadora por USB.
2. Copia la carpeta `notes_viewer` en la raíz del almacenamiento del Kobo:
   ```text
   KOBOeReader/notes_viewer/
   ```
3. Configura el acceso directo según tu versión de firmware:

### A) Si usas Nickelite (Kobo OS 5.x / 6.x - recomendado para Libra Colour)
Copia el archivo `config_templates/tab.ini` en:
```text
KOBOeReader/.adds/nickelite/tab.ini
```
*(Al tocar la pestaña inferior en la pantalla de inicio, se abrirá directamente el visor de notas).*

### B) Si usas NickelMenu (Kobo OS 4.x)
Copia o agrega las líneas de `config_templates/nickelmenu_config` dentro de tu archivo de configuración:
```text
KOBOeReader/.adds/nm/config
```

4. Expulsa el Kobo con seguridad y desconecta el cable.

---

## 📝 Licencia

Distribuido bajo la Licencia MIT. Consulta el archivo `LICENSE` para más información.
