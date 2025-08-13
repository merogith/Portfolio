<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ANSELEVG</title>
<link href="https://fonts.googleapis.com/css2?family=Chakra+Petch:wght@700&family=Roboto+Mono&display=swap" rel="stylesheet">
<style>
  body {
    margin: 0;
    font-family: 'Roboto Mono', monospace;
    background-color: #EAFD4F;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
  }
  .card {
    background: white;
    border: 1px solid black;
    border-radius: 16px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    max-width: 900px;
    width: 92vw;
    display: flex;
    flex-direction: column;
    padding: 24px;
  }
  header {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
  .tag, .square {
    border: 1px solid black;
    padding: 4px 8px;
    border-radius: 6px;
    font-size: 12px;
  }
  .square {
    padding: 4px;
    min-width: 28px;
    text-align: center;
  }
  .logo {
    font-family: 'Chakra Petch', sans-serif;
    font-size: 2.5rem;
    font-weight: 700;
    letter-spacing: -3px;
    text-transform: uppercase;
    cursor: pointer;
  }
  .logo span.italic {
    font-style: italic;
  }
  nav {
    display: flex;
    gap: 16px;
    margin-top: 8px;
    border-top: 1px solid black;
    padding-top: 8px;
    font-family: 'Chakra Petch', sans-serif;
    text-transform: uppercase;
  }
  nav a {
    color: rgba(0,0,0,0.6);
    text-decoration: none;
    transition: all 0.2s ease;
  }
  nav a:hover {
    text-decoration: underline;
    transform: scale(1.02);
  }
  nav a.active {
    color: black;
  }
  .content {
    margin-top: 24px;
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: flex-start;
    overflow-y: auto;
  }
  .content-inner {
    max-width: 720px;
  }
  .image {
    max-width: 100%;
    border: 1px solid black;
    border-radius: 8px;
    margin-top: 16px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
  }
  h2 {
    font-family: 'Chakra Petch', sans-serif;
    text-transform: uppercase;
    margin-top: 0;
  }
  ul {
    padding-left: 20px;
  }
  .grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
  }
  form {
    display: flex;
    flex-direction: column;
    gap: 12px;
  }
  input, textarea, button {
    padding: 8px;
    border: 1px solid black;
    border-radius: 6px;
    font-family: inherit;
  }
  button {
    background-color: #EAFD4F;
    font-weight: bold;
    cursor: pointer;
  }
  @media (max-width: 600px) {
    .logo { font-size: 1.8rem; }
    .card { padding: 16px; }
    .grid { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>

<div class="card">
  <header>
    <div class="tag">@ansel.archive</div>
    <div class="logo" onclick="loadPage('home')">ANSEL<span class="italic">E</span>VG</div>
    <div class="square">XYZ</div>
  </header>
  <nav>
    <a href="#" onclick="loadPage('work')">Work</a>
    <a href="#" onclick="loadPage('about')">About</a>
    <a href="#" onclick="loadPage('lab')">Lab</a>
    <a href="#" onclick="loadPage('contact')">Contact</a>
  </nav>
  <div class="content">
    <div class="content-inner" id="pageContent"></div>
  </div>
</div>

<script>
function loadPage(page) {
  const links = document.querySelectorAll('nav a');
  links.forEach(link => link.classList.remove('active'));
  const map = {work:0, about:1, lab:2, contact:3};
  if(page !== 'home'){ links[map[page]].classList.add('active'); }
  const content = document.getElementById('pageContent');

  if (page === 'home') {
    content.innerHTML = '';
  } 
 else if (page === 'work') {
  content.innerHTML = `
    <div>
      <h2>Work</h2>
      <p>Collection of my latest projects, visuals, and experiments.</p>
      <img src="https://i.imgur.com/cb7NnvQ.png" class="image">
      <img src="https://i.imgur.com/cb7NnvQ.png" class="image">
      <img src="https://i.imgur.com/cb7NnvQ.png" class="image">
      <img src="https://i.imgur.com/cb7NnvQ.png" class="image">
      <img src="https://i.imgur.com/cb7NnvQ.png" class="image">
      <img src="https://i.imgur.com/cb7NnvQ.png" class="image">
      <img src="https://i.imgur.com/cb7NnvQ.png" class="image">
      <img src="https://i.imgur.com/cb7NnvQ.png" class="image">
      <img src="https://i.imgur.com/cb7NnvQ.png" class="image">
      <img src="https://i.imgur.com/cb7NnvQ.png" class="image">
    </div>
  `;
}
  else if (page === 'about') {
    content.innerHTML = `
      <div>
        <h2>About Me</h2>
        <p>I am a multidisciplinary creative working across design, art, and technology. My focus is on creating visually compelling experiences that merge storytelling with innovation.</p>
        <div class="grid">
          <div>
            <h3>Background</h3>
            <ul>
              <li>BA in Visual Arts</li>
              <li>5+ years in creative direction</li>
            </ul>
          </div>
          <div>
            <h3>Skills</h3>
            <ul>
              <li>Branding</li>
              <li>UI/UX Design</li>
              <li>Art Direction</li>
            </ul>
          </div>
        </div>
      </div>
    `;
  } 
  else if (page === 'lab') {
    content.innerHTML = `
      <div>
        <h2>Approach</h2>
        <p>My creative lab is a space to test, break, and rebuild ideas. From rapid prototyping to long-term research, every project starts here.</p>
        <img src="https://picsum.photos/800/400?random=3" class="image">
      </div>
    `;
  } 
  else if (page === 'contact') {
    content.innerHTML = `
      <div>
        <h2>Connect</h2>
        <p>Reach out for collaborations, commissions, or just to say hi.</p>
        <form>
          <input type="text" placeholder="Your Name" required>
          <input type="email" placeholder="Your Email" required>
          <textarea rows="4" placeholder="Your Message"></textarea>
          <button type="submit">Send Message</button>
        </form>
        <p>Follow me on: 
          <a href="#" target="_blank">Instagram</a>, 
          <a href="#" target="_blank">Behance</a>
        </p>
      </div>
    `;
  }
}
loadPage('home');
</script>

</body>
</html>
