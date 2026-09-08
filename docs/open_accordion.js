console.log('Voici un test')

// Check if URL of browser window has hash tag
if (location.hash) {
  console.log('Hash trouvé')
  // Get URL hash tag
  const hash = window.location.hash;
  console.log(hash)
  // Select checkbox with ID of hashtag
  const checkbox = document.querySelector(hash);
  console.log(checkbox)
  // Check if checkbox exists
  if(checkbox) {
    // Set selected checkbox as checked
    checkbox.checked = true;
    console.log('Fait')
  }
}

console.log(document.querySelectorAll('*[id]'))