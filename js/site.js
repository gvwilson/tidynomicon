// Pull all H2's into div.headings.
const makeTableOfContents = () => {
  const container = document.querySelectorAll('#headings')[0]
  const headings = Array.from(document.querySelectorAll('h2'))
  const items = headings
        .map((h) => '<li><a href="#' + h.id + '">' + h.innerHTML + '</a></li>')
        .join('\n')
  container.innerHTML = '<h3>Contents</h3><ul>\n' + items + '</ul>'
}

// Stripe all tables.
const stripeTables = () => {
  const tables = document.querySelectorAll('table')
  Array.from(tables).forEach(t => {
    t.classList.add('table', 'table-striped')
  })
}

// Perform all transformations.
const transformPage = () => {
  makeTableOfContents()
  stripeTables()
}

// Run page transformations once page is loaded.
document.addEventListener("DOMContentLoaded", (event) => {
  transformPage()
})
