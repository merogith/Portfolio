const printButton = document.querySelector("#print-cv");
printButton.hidden = false;
printButton.addEventListener("click", () => window.print());
