#!/bin/sh

DB_PATH="/mnt/onboard/.kobo/KoboReader.sqlite"
OUT_HTML="/mnt/onboard/notes_viewer/index.html"

QUERY="SELECT replace(replace(ifnull(c.Title, 'Sin Título'), '\"', '&quot;'), char(10), ' '), replace(replace(ifnull(c.Attribution, 'Desconocido'), '\"', '&quot;'), char(10), ' '), replace(replace(ifnull(b.Text, ''), '\"', '&quot;'), char(10), '<br>'), replace(replace(ifnull(b.Annotation, ''), '\"', '&quot;'), char(10), '<br>'), ifnull(b.Color, 0), ifnull(b.DateCreated, '') FROM Bookmark b LEFT JOIN content c ON b.VolumeID = c.ContentID WHERE (b.Type = 'highlight' OR b.Type = 'note') AND (b.Text IS NOT NULL OR b.Annotation IS NOT NULL) ORDER BY b.DateCreated DESC;"

cat << 'EOF' > "$OUT_HTML"
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
<title>Mis Notas</title>
<style>
  :root {
    --bg: #ffffff;
    --text: #111111;
    --card-bg: #f9f9fa;
    --card-border: #dcdcdc;
    --header-bg: #ffffff;
    --header-border: #222222;
    --subtext: #555555;
    --note-bg: #ffffff;
    --note-border: #2b5b84;
    --btn-bg: #ffffff;
    --btn-border: #666666;
  }

  body.dark-mode {
    --bg: #121212;
    --text: #e0e0e0;
    --card-bg: #1e1e1e;
    --card-border: #333333;
    --header-bg: #181818;
    --header-border: #555555;
    --subtext: #aaaaaa;
    --note-bg: #222222;
    --note-border: #5a9bd5;
    --btn-bg: #222222;
    --btn-border: #777777;
  }

  * { box-sizing: border-box; }
  body {
    font-family: -apple-system, sans-serif, "Kobo Clara", "Avenir";
    margin: 0;
    padding: 12px;
    background: var(--bg);
    color: var(--text);
    user-select: none;
    -webkit-user-select: none;
  }

  header {
    background: var(--header-bg);
    padding: 10px 14px;
    margin: -12px -12px 12px -12px;
    border-bottom: 2px solid var(--header-border);
  }
  .header-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
  }
  h1 { margin: 0; font-size: 21px; font-weight: bold; }
  .header-actions {
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .action-btn {
    padding: 6px 10px;
    font-size: 13px;
    font-weight: bold;
    border: 1.5px solid var(--btn-border);
    border-radius: 6px;
    background: var(--btn-bg);
    color: var(--text);
    cursor: pointer;
  }

  .controls {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }
  #search {
    width: 100%;
    padding: 8px 12px;
    font-size: 15px;
    border: 1.5px solid var(--btn-border);
    border-radius: 6px;
    background: var(--bg);
    color: var(--text);
    outline: none;
  }
  .filters-row {
    display: flex;
    gap: 8px;
    align-items: center;
    flex-wrap: wrap;
  }
  #bookSelect {
    flex: 1;
    min-width: 140px;
    padding: 6px 10px;
    font-size: 14px;
    border: 1.5px solid var(--btn-border);
    border-radius: 6px;
    background: var(--bg);
    color: var(--text);
    outline: none;
  }
  .color-filters {
    display: flex;
    gap: 5px;
    align-items: center;
  }
  .color-btn {
    width: 24px;
    height: 24px;
    border-radius: 50%;
    border: 1.5px solid #888;
    cursor: pointer;
    box-sizing: border-box;
  }
  .color-btn.active {
    border: 2.5px solid var(--text);
    transform: scale(1.15);
  }
  .btn-all { background: var(--bg); border-color: var(--text); font-size: 10px; font-weight: bold; display: flex; align-items: center; justify-content: center; color: var(--text); }
  .btn-yellow { background: #fff3a8; border-color: #d4af37; }
  .btn-pink { background: #fed0e0; border-color: #e06d9b; }
  .btn-cyan { background: #cbebff; border-color: #4a90e2; }
  .btn-green { background: #d1f7c4; border-color: #48a868; }

  .card {
    border: 1px solid var(--card-border);
    border-radius: 8px;
    padding: 12px 14px;
    margin: 10px 0;
    background: var(--card-bg);
  }
  .book-title {
    font-weight: bold;
    font-size: 16.5px;
    color: var(--text);
  }
  .author {
    font-size: 13.5px;
    color: var(--subtext);
    margin-bottom: 6px;
  }
  .highlight {
    font-size: 16px;
    line-height: 1.5;
    padding: 8px 12px;
    border-radius: 5px;
    margin: 6px 0;
    color: #000000;
  }
  body.dark-mode .highlight {
    color: #111111;
  }
  .color-yellow { background-color: #fff3a8; border-left: 4px solid #d4af37; }
  .color-pink   { background-color: #fed0e0; border-left: 4px solid #e06d9b; }
  .color-cyan   { background-color: #cbebff; border-left: 4px solid #4a90e2; }
  .color-green  { background-color: #d1f7c4; border-left: 4px solid #48a868; }
  .color-default{ background-color: #eaeaea; border-left: 4px solid #888888; }

  .user-note {
    background: var(--note-bg);
    border: 1px solid var(--card-border);
    border-left: 4px solid var(--note-border);
    padding: 6px 10px;
    font-style: italic;
    margin-top: 6px;
    font-size: 15px;
    border-radius: 4px;
    color: var(--text);
  }
  .date {
    font-size: 11.5px;
    color: var(--subtext);
    margin-top: 6px;
    text-align: right;
  }

  .pagination-bar {
    position: sticky;
    bottom: 0;
    background: var(--header-bg);
    border-top: 2px solid var(--header-border);
    margin: 14px -12px -12px -12px;
    padding: 10px 14px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .nav-btn {
    padding: 8px 18px;
    font-size: 15px;
    font-weight: bold;
    border: 2px solid var(--btn-border);
    border-radius: 8px;
    background: var(--btn-bg);
    color: var(--text);
    cursor: pointer;
  }
  .nav-btn:disabled {
    opacity: 0.3;
    cursor: default;
  }
  #pageIndicator {
    font-size: 14px;
    font-weight: bold;
    color: var(--text);
  }

  #flashOverlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: black;
    z-index: 9999;
    display: none;
  }
</style>
</head>
<body>
  <div id="flashOverlay"></div>
  <header>
    <div class="header-top">
      <h1>Mis Notas</h1>
      <div class="header-actions">
        <button class="action-btn" onclick="limpiarPantalla()">Limpiar</button>
        <button class="action-btn" id="themeBtn" onclick="toggleTheme()">Modo Oscuro</button>
      </div>
    </div>
    <div class="controls">
      <input type="text" id="search" placeholder="Buscar texto, palabra o autor..." oninput="filtrar()">
      <div class="filters-row">
        <select id="bookSelect" onchange="filtrar()">
          <option value="">Todos los libros</option>
        </select>
        <div class="color-filters">
          <div class="color-btn btn-all active" onclick="filtrarColor('all', this)">All</div>
          <div class="color-btn btn-yellow" onclick="filtrarColor('color-yellow', this)"></div>
          <div class="color-btn btn-pink" onclick="filtrarColor('color-pink', this)"></div>
          <div class="color-btn btn-cyan" onclick="filtrarColor('color-cyan', this)"></div>
          <div class="color-btn btn-green" onclick="filtrarColor('color-green', this)"></div>
        </div>
      </div>
    </div>
  </header>
  <div id="contenedor">
EOF

sqlite3 "$DB_PATH" -separator "|" "$QUERY" | while IFS="|" read -r title author hl note color date; do
  case "$color" in
    1) color_class="color-yellow" ;;
    2) color_class="color-pink" ;;
    3) color_class="color-cyan" ;;
    4) color_class="color-green" ;;
    *) color_class="color-default" ;;
  esac

  echo "<div class='card' data-book='$title' data-color='$color_class' data-text='$title $author $hl $note'>" >> "$OUT_HTML"
  echo "  <div class='book-title'>$title</div>" >> "$OUT_HTML"
  echo "  <div class='author'>$author</div>" >> "$OUT_HTML"
  if [ -n "$hl" ]; then
    echo "  <div class='highlight $color_class'>$hl</div>" >> "$OUT_HTML"
  fi
  if [ -n "$note" ]; then
    echo "  <div class='user-note'><b>Nota:</b> $note</div>" >> "$OUT_HTML"
  fi
  echo "  <div class='date'>$date</div>" >> "$OUT_HTML"
  echo "</div>" >> "$OUT_HTML"
done

cat << 'EOF' >> "$OUT_HTML"
  </div>

  <div class="pagination-bar">
    <button class="nav-btn" id="prevBtn" onclick="cambiarPagina(-1)">← Anterior</button>
    <span id="pageIndicator">Página 1</span>
    <button class="nav-btn" id="nextBtn" onclick="cambiarPagina(1)">Siguiente →</button>
  </div>

  <script>
    const NOTAS_POR_PAGINA = 4;
    let paginaActual = 1;
    let notasFiltradas = [];
    let activeColor = 'all';

    if (localStorage.getItem('kobo_notes_theme') === 'dark') {
      document.body.classList.add('dark-mode');
      document.getElementById('themeBtn').textContent = 'Modo Claro';
    }

    function toggleTheme() {
      const isDark = document.body.classList.toggle('dark-mode');
      document.getElementById('themeBtn').textContent = isDark ? 'Modo Claro' : 'Modo Oscuro';
      localStorage.setItem('kobo_notes_theme', isDark ? 'dark' : 'light');
      limpiarPantalla();
    }

    function limpiarPantalla() {
      const overlay = document.getElementById('flashOverlay');
      overlay.style.display = 'block';
      setTimeout(() => {
        overlay.style.display = 'none';
      }, 70);
    }

    const books = new Set();
    document.querySelectorAll('.card').forEach(card => {
      const b = card.getAttribute('data-book');
      if (b) books.add(b);
    });
    const select = document.getElementById('bookSelect');
    Array.from(books).sort().forEach(b => {
      const opt = document.createElement('option');
      opt.value = b;
      opt.textContent = b;
      select.appendChild(opt);
    });

    function filtrarColor(color, btn) {
      activeColor = color;
      document.querySelectorAll('.color-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      filtrar();
    }

    function renderizarPagina() {
      const totalPaginas = Math.ceil(notasFiltradas.length / NOTAS_POR_PAGINA) || 1;
      if (paginaActual > totalPaginas) paginaActual = totalPaginas;
      if (paginaActual < 1) paginaActual = 1;

      const inicio = (paginaActual - 1) * NOTAS_POR_PAGINA;
      const fin = inicio + NOTAS_POR_PAGINA;

      document.querySelectorAll('.card').forEach(c => c.style.display = 'none');

      notasFiltradas.slice(inicio, fin).forEach(c => {
        c.style.display = 'block';
      });

      document.getElementById('pageIndicator').textContent = 
        notasFiltradas.length > 0 
          ? `Pág. ${paginaActual} de ${totalPaginas} (${notasFiltradas.length})`
          : '0 notas';

      document.getElementById('prevBtn').disabled = (paginaActual <= 1);
      document.getElementById('nextBtn').disabled = (paginaActual >= totalPaginas);

      window.scrollTo(0, 0);
    }

    function cambiarPagina(delta) {
      paginaActual += delta;
      renderizarPagina();
    }

    function filtrar() {
      const q = document.getElementById('search').value.toLowerCase();
      const selBook = document.getElementById('bookSelect').value;
      const allCards = Array.from(document.querySelectorAll('.card'));

      notasFiltradas = allCards.filter(card => {
        const text = (card.getAttribute('data-text') || '').toLowerCase();
        const book = card.getAttribute('data-book');
        const color = card.getAttribute('data-color');

        const matchesSearch = text.includes(q);
        const matchesBook = !selBook || book === selBook;
        const matchesColor = (activeColor === 'all') || (color === activeColor);

        return matchesSearch && matchesBook && matchesColor;
      });

      paginaActual = 1;
      renderizarPagina();
    }

    filtrar();
  </script>
</body>
</html>
EOF