var buttons = document.getElementsByClassName("bibtex-button")
for (var i = 0; i < buttons.length; i++) {
buttons[i].addEventListener('click', function(e) {
var bibtex = this.parentElement.nextElementSibling;
var others = document.getElementsByClassName("bibtex-entry")
if (bibtex.classList.contains("shown")) {
  var open = false;
} else {
  var open = true;
}
for (var i = 0; i < others.length; i++) {
  others[i].classList.remove("shown")
}
if (open) {
bibtex.classList.add("shown")
}

});
}


var copy = document.getElementsByClassName("bibtex-copy")
for (var i = 0; i < copy.length; i++) {
  copy[i].addEventListener('click',function (e) {
  var bibtex_content = this.previousElementSibling.innerHTML.replace(/<br>/g,"");
  console.log(bibtex_content)
  navigator.clipboard.writeText(bibtex_content).then(
  () => {
    this.value = "Copied!"
    setTimeout(() => {
  this.value = "Copy to clipboard";
}, "1000");
  },
  () => {
    /* clipboard write failed */
  },
);
});
}