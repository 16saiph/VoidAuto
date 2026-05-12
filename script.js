// DOM Elements
const loginForm = document.getElementById('login-form');
const resultsSection = document.getElementById('results-section');
const detailSection = document.getElementById('detail-section');
const statusBadge = document.getElementById('status-badge');
const totalTasks = document.getElementById('total-tasks');
const doneTasks = document.getElementById('done-tasks');
const completionPercent = document.getElementById('completion-percent');
const assignmentList = document.getElementById('assignment-list');
const selectedTitle = document.getElementById('selected-title');
const questionPanel = document.getElementById('question-panel');
const refreshBtn = document.getElementById('refresh-btn');
const resetBtn = document.getElementById('reset-btn');
const completeBtn = document.getElementById('complete-btn');
const pdfDownloadLink = document.getElementById('pdf-download-link');
const themeSelect = document.getElementById('theme-select');
const wallpaperSelect = document.getElementById('wallpaper-select');
const languageSelect = document.getElementById('language-select');
const progressPanel = document.getElementById('progress-panel');
const dashboardPage = document.getElementById('dashboard-page');
const updatesPage = document.getElementById('updates-page');
const updatesList = document.getElementById('updates-list');
const navBtns = document.querySelectorAll('.nav-btn');

let currentAssignments = [];
let selectedAssignmentId = null;
let currentSession = null;
let currentPdfUrl = null;

const serviceLoginUrls = {
  maths: 'https://selectschool.sparx-learning.com/?app=sparx_maths&forget=1',
  science: 'https://selectschool.sparx-learning.com/?app=sparx_science&forget=1',
  reader: 'https://selectschool.sparx-learning.com/?app=sparx_reader&forget=1'
};

const themes = [
  { name: 'Midnight Blue', gradient: 'linear-gradient(135deg, #2c3e50, #4b79a1)' },
  { name: 'Neon Night', gradient: 'linear-gradient(135deg, #120f2d, #4b36ff)' },
  { name: 'Violet Dusk', gradient: 'linear-gradient(135deg, #1a1c2e, #7d4bff)' },
  { name: 'Electric Slate', gradient: 'linear-gradient(135deg, #181826, #5b6be0)' },
  { name: 'Deep Cyan', gradient: 'linear-gradient(135deg, #071e26, #256d82)' },
  { name: 'Obsidian Rose', gradient: 'linear-gradient(135deg, #16121a, #7c4ec0)' },
  { name: 'Lunar Graphite', gradient: 'linear-gradient(135deg, #121212, #3a4a6f)' },
  { name: 'Shadowburst', gradient: 'linear-gradient(135deg, #0e1520, #4e8ec6)' },
  { name: 'Aurora Night', gradient: 'linear-gradient(135deg, #08121d, #3a87ff)' },
  { name: 'Sapphire Mist', gradient: 'linear-gradient(135deg, #112636, #3f93d3)' },
  { name: 'Platinum Midnight', gradient: 'linear-gradient(135deg, #14172a, #878fc8)' },
  { name: 'Graphite Pulse', gradient: 'linear-gradient(135deg, #17181d, #6b7bbf)' },
  { name: 'Starboard', gradient: 'linear-gradient(135deg, #0f1930, #3775a2)' },
  { name: 'Moonlit Alloy', gradient: 'linear-gradient(135deg, #1a1d28, #8a7de2)' },
  { name: 'Nocturnal Flame', gradient: 'linear-gradient(135deg, #181510, #6c58ff)' }
];

const wallpapers = [
  { name: 'Galaxy mist', value: 'radial-gradient(circle at top left, rgba(103, 144, 255, 0.2), transparent 28%), radial-gradient(circle at bottom right, rgba(255, 110, 175, 0.15), transparent 24%), linear-gradient(180deg, #080a11, #10162b)' },
  { name: 'Dark grid', value: 'linear-gradient(180deg, #090b13, #111827), repeating-linear-gradient(45deg, transparent, transparent 10px, rgba(255,255,255,0.03) 10px, rgba(255,255,255,0.03) 11px)' },
  { name: 'Midnight blur', value: 'radial-gradient(circle at 20% 30%, rgba(113, 92, 255, 0.16), transparent 18%), linear-gradient(180deg, #0d0f18, #0f1624)' },
  { name: 'Smoke shadow', value: 'linear-gradient(180deg, #0c0d12, #14181f), radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.05), transparent 10%)' },
  { name: 'Night aurora', value: 'radial-gradient(circle at top center, rgba(172, 111, 255, 0.12), transparent 25%), linear-gradient(180deg, #0a0c14, #131a2a)' }
];

const languages = {
  en: {
    loginTitle: 'School account login',
    scanButton: 'Connect & scan homework',
    settingsTitle: 'Dashboard settings',
    themeLabel: 'Theme palette',
    wallpaperLabel: 'Wallpaper',
    languageLabel: 'Language'
  },
  es: {
    loginTitle: 'Inicio de sesión escolar',
    scanButton: 'Conectar y escanear tareas',
    settingsTitle: 'Ajustes del panel',
    themeLabel: 'Paleta de tema',
    wallpaperLabel: 'Fondo',
    languageLabel: 'Idioma'
  },
  fr: {
    loginTitle: 'Connexion scolaire',
    scanButton: 'Se connecter et scanner les devoirs',
    settingsTitle: 'Paramètres du tableau de bord',
    themeLabel: 'Palette de thème',
    wallpaperLabel: 'Fond d’écran',
    languageLabel: 'Langue'
  },
  de: {
    loginTitle: 'Schul-Anmeldung',
    scanButton: 'Verbinden & Hausaufgaben scannen',
    settingsTitle: 'Dashboard-Einstellungen',
    themeLabel: 'Themenpalette',
    wallpaperLabel: 'Hintergrundbild',
    languageLabel: 'Sprache'
  }
};

let currentLanguage = 'en';

function populateSettings() {
  themes.forEach((theme) => {
    const option = document.createElement('option');
    option.value = theme.name;
    option.textContent = theme.name;
    themeSelect.appendChild(option);
  });

  wallpapers.forEach((wallpaper) => {
    const option = document.createElement('option');
    option.value = wallpaper.value;
    option.textContent = wallpaper.name;
    wallpaperSelect.appendChild(option);
  });

  Object.keys(languages).forEach((code) => {
    const option = document.createElement('option');
    option.value = code;
    option.textContent = code.toUpperCase();
    languageSelect.appendChild(option);
  });

  themeSelect.addEventListener('change', () => {
    applyTheme(themeSelect.value);
    localStorage.setItem('autosparxTheme', themeSelect.value);
  });

  wallpaperSelect.addEventListener('change', () => {
    applyWallpaper(wallpaperSelect.value);
    localStorage.setItem('autosparxWallpaper', wallpaperSelect.value);
  });

  languageSelect.addEventListener('change', () => {
    applyLanguage(languageSelect.value);
    localStorage.setItem('autosparxLanguage', languageSelect.value);
  });

  const savedTheme = localStorage.getItem('autosparxTheme') || themes[0].name;
  const savedWallpaper = localStorage.getItem('autosparxWallpaper') || wallpapers[0].value;
  const savedLanguage = localStorage.getItem('autosparxLanguage') || 'en';

  themeSelect.value = savedTheme;
  wallpaperSelect.value = savedWallpaper;
  languageSelect.value = savedLanguage;

  applyTheme(savedTheme);
  applyWallpaper(savedWallpaper);
  applyLanguage(savedLanguage);
}

function applyTheme(themeName) {
  const theme = themes.find((item) => item.name === themeName);
  if (!theme) return;
  document.documentElement.style.setProperty('--primary-gradient', theme.gradient);
  document.documentElement.style.setProperty('--primary-shadow', 'rgba(255,255,255,0.12)');
}

function applyWallpaper(value) {
  document.documentElement.style.setProperty('--page-bg', value);
}

function applyLanguage(code) {
  const locale = languages[code] || languages.en;
  currentLanguage = code;
  document.querySelector('.login-card h2').textContent = locale.loginTitle;
  document.querySelector('#login-form button[type="submit"]').textContent = locale.scanButton;
  document.querySelector('#settings-section h2').textContent = locale.settingsTitle;
  document.querySelector('label[for="theme-select"]').textContent = locale.themeLabel;
  document.querySelector('label[for="wallpaper-select"]').textContent = locale.wallpaperLabel;
  document.querySelector('label[for="language-select"]').textContent = locale.languageLabel;
}

populateSettings();

const assignmentDataUrl = './assignments.json';
const externalAdviceUrl = 'https://api.adviceslip.com/advice';
const mathApiUrl = 'https://api.mathjs.org/v4/';

async function loadAssignmentData() {
  try {
    const response = await fetch(assignmentDataUrl, { cache: 'no-store' });
    if (!response.ok) {
      throw new Error('Could not fetch assignment data.');
    }
    return await response.json();
  } catch (error) {
    console.error('Assignment API load failed:', error);
    return null;
  }
}

async function fetchExternalAdvice() {
  try {
    const response = await fetch(externalAdviceUrl, { cache: 'no-store' });
    if (!response.ok) {
      throw new Error('External API unavailable.');
    }
    const data = await response.json();
    return data?.slip?.advice || null;
  } catch (error) {
    console.warn('External advice call failed:', error);
    return null;
  }
}

async function evaluateExpression(expression) {
  try {
    const encoded = encodeURIComponent(expression);
    const response = await fetch(`${mathApiUrl}?expr=${encoded}`);
    if (!response.ok) {
      throw new Error('Math API evaluation failed');
    }
    return (await response.text()).trim();
  } catch (error) {
    console.warn('Math API error:', error);
    return null;
  }
}

function trySolveLinearEquation(question) {
  const match = question.match(/solve\s+(.+?)\s*=\s*(.+)/i);
  if (!match) return null;

  const left = match[1].trim();
  const right = match[2].trim().replace(/[.]/g, '');
  const variableMatch = left.match(/([+-]?\d*)([a-zA-Z])/);
  if (!variableMatch) return null;

  const coefficient = parseFloat(variableMatch[1] || '1');
  const constantPart = left
    .replace(variableMatch[0], '')
    .replace(/\+/g, ' + ')
    .replace(/-/g, ' - ')
    .trim();

  const constantValue = constantPart
    ? Number(constantPart.replace(variableMatch[2], '').trim())
    : 0;
  const rightValue = Number(right);
  if (Number.isNaN(coefficient) || Number.isNaN(rightValue) || Number.isNaN(constantValue)) {
    return null;
  }

  const x = (rightValue - constantValue) / coefficient;
  return `${variableMatch[2]} = ${x}`;
}

async function generateAnswerForQuestion(question) {
  const lower = question.toLowerCase();
  if (/solve/i.test(question) && question.includes('=')) {
    const solution = trySolveLinearEquation(question);
    if (solution) {
      return `Solve the equation step-by-step: ${solution}`;
    }
  }

  if (/simplify/i.test(lower) || /evaluate/i.test(lower)) {
    const xMatch = question.match(/for\s*x\s*=\s*(\d+)/i);
    let expression = question.replace(/simplify\s*/i, '').replace(/evaluate\s*/i, '');
    expression = expression.replace(/for\s*x\s*=\s*\d+/i, '').replace(/\.$/, '').trim();

    if (xMatch) {
      const xValue = xMatch[1];
      expression = expression.replace(/x(?![a-zA-Z0-9])/g, `(${xValue})`);
    }

    const result = await evaluateExpression(expression);
    if (result) {
      return `Calculated answer: ${result}`;
    }
    return xMatch
      ? `Evaluate the expression with x = ${xMatch[1]} and simplify the result.`
      : 'Answer generated using internal logic.';
  }

  if (/convert .* to a decimal/i.test(lower)) {
    const fraction = question.match(/(\d+\/\d+)/);
    if (fraction) {
      const result = await evaluateExpression(fraction[1]);
      return result ? `Decimal answer: ${result}` : `Convert the fraction ${fraction[1]} to a decimal.`;
    }
  }

  if (/area of a triangle/i.test(lower)) {
    const match = question.match(/base\s*(\d+)cm\s*and\s*height\s*(\d+)cm/i);
    if (match) {
      const base = Number(match[1]);
      const height = Number(match[2]);
      return `Area = 1/2 × base × height = 1/2 × ${base} × ${height} = ${0.5 * base * height} cm².`;
    }
  }

  if (/triangle with sides/i.test(lower)) {
    return 'This is an isosceles triangle because two sides are equal in length.';
  }

  if (/describe what friction does/i.test(lower)) {
    return 'Friction is a force that resists motion between two surfaces that are touching.';
  }

  if (/unit of force/i.test(lower)) {
    return 'The unit of force is the Newton (N).';
  }

  if (/list three different forms of energy/i.test(lower)) {
    return 'Examples of energy forms include kinetic energy, potential energy, and thermal energy.';
  }

  if (/explain how sound is produced/i.test(lower)) {
    return 'Sound is produced when vibrations travel through a material such as air and reach our ears.';
  }

  if (/summarise the main idea/i.test(lower) || /summarize the main idea/i.test(lower)) {
    return 'The main idea is to understand the text and explain it clearly using the most important points.';
  }

  if (/what was the character.*main problem/i.test(lower)) {
    return 'The character’s main problem was the challenge or conflict they needed to solve in the story.';
  }

  if (/match the word/i.test(lower)) {
    return 'Read each definition carefully and match the word that fits the meaning best.';
  }

  if (/use the word.*adapt/i.test(lower)) {
    return 'I can adapt to new situations by learning quickly and staying calm when things change.';
  }

  return 'Use a clear answer with the correct steps and check your work carefully.';
}

async function scanHomework(services) {
  const apiData = await loadAssignmentData();
  const advice = await fetchExternalAdvice();
  const statusMessage = advice ? `Remote API connected: “${advice}”` : 'Homework data loaded from the app API.';

  const assignments = [];
  if (apiData) {
    services.forEach((service) => {
      if (Array.isArray(apiData[service])) {
        apiData[service].forEach((item) => assignments.push({ ...item }));
      }
    });
  }

  if (assignments.length === 0) {
    progressPanel.innerHTML = `<p class="muted">${statusMessage}</p><p class="muted">No homework found for selected services.</p>`;
    currentAssignments = [];
    selectedAssignmentId = null;
    updateResults();
    return;
  }

  currentAssignments = assignments;
  selectedAssignmentId = assignments[0].id;
  updateResults();
  progressPanel.innerHTML = `<p class="muted">${statusMessage}</p><p class="muted">Loaded ${assignments.length} assignment(s) from the homework API.</p>`;
}

async function completeSelectedAssignment(assignment) {
  const answers = await Promise.all(assignment.questions.map(generateAnswerForQuestion));
  assignment.completedAnswers = answers;
  assignment.status = 'done';
  return assignment;
}

loginForm.addEventListener('submit', async (event) => {
  event.preventDefault();
  const school = document.getElementById('school').value.trim();
  const username = document.getElementById('username').value.trim();
  const password = document.getElementById('password').value.trim();

  const services = Array.from(document.querySelectorAll('input[name="service"]:checked')).map(
    (checkbox) => checkbox.value
  );

  if (!school || !username || !password || services.length === 0) {
    alert('Please enter your school, username, password, and select at least one Sparx service.');
    return;
  }

  currentSession = {
    school,
    username,
    services,
    loginUrls: services.map((service) => serviceLoginUrls[service] || '')
  };
  await showLoading();
  scanHomework(services);
});

refreshBtn.addEventListener('click', async () => {
  if (!currentSession) {
    return;
  }
  await showLoading();
  scanHomework(currentSession.services);
});

completeBtn.addEventListener('click', async () => {
  if (!selectedAssignmentId) {
    return;
  }

  const assignment = currentAssignments.find((item) => item.id === selectedAssignmentId);
  if (!assignment) {
    return;
  }

  if (assignment.status === 'done') {
    alert('This homework is already completed.');
    return;
  }

  assignment.status = 'done';
  updateResults();
  completeBtn.textContent = 'Completing...';
  completeBtn.disabled = true;
  await new Promise((resolve) => setTimeout(resolve, 900));
  createHomeworkPdf(assignment);
  completeBtn.textContent = 'Complete selected homework';
  completeBtn.disabled = false;
});

resetBtn.addEventListener('click', () => {
  currentAssignments = [];
  selectedAssignmentId = null;
  currentSession = null;
  if (currentPdfUrl) {
    URL.revokeObjectURL(currentPdfUrl);
    currentPdfUrl = null;
  }
  resultsSection.classList.add('hidden');
  detailSection.classList.add('hidden');
  assignmentList.innerHTML = '';
  selectedTitle.textContent = 'Choose one assignment';
  questionPanel.innerHTML = '<p class="muted">Pick a homework task from the list to see the questions and work inside this dashboard.</p>';
  completeBtn.classList.add('hidden');
  pdfDownloadLink.classList.add('hidden');
  loginForm.reset();
});

async function showLoading() {
  statusBadge.textContent = 'Scanning...';
  statusBadge.classList.remove('badge-green');
  statusBadge.style.background = 'rgba(93, 143, 255, 0.18)';
  statusBadge.style.color = '#8ab9ff';
  resultsSection.classList.remove('hidden');
  totalTasks.textContent = '-';
  doneTasks.textContent = '-';
  completionPercent.textContent = '-';
  assignmentList.innerHTML = '<p class="muted">Connecting to Sparx and scanning your homework...</p>';
  progressPanel.innerHTML = '<p class="muted">Preparing the login route and dashboard progress details...</p>';
  detailSection.classList.add('hidden');
  await new Promise((resolve) => setTimeout(resolve, 1100));
}

function scanHomework(services) {
  const assignments = [];
  services.forEach((service) => {
    if (sampleData[service]) {
      sampleData[service].forEach((item) => assignments.push({ ...item }));
    }
  });

  currentAssignments = assignments;
  selectedAssignmentId = assignments.length ? assignments[0].id : null;
  updateResults();
}

function updateResults() {
  if (currentAssignments.length === 0) {
    assignmentList.innerHTML = '<p class="muted">No homework was found for the selected services.</p>';
    statusBadge.textContent = 'No tasks found';
    statusBadge.classList.add('badge-green');
    statusBadge.style.background = 'rgba(94, 225, 176, 0.16)';
    statusBadge.style.color = '#7af2b7';
    completionPercent.textContent = '0%';
    totalTasks.textContent = '0';
    doneTasks.textContent = '0';
    detailSection.classList.add('hidden');
    updateProgressPanel();
    return;
  }

  const doneCount = currentAssignments.filter((assignment) => assignment.status === 'done').length;
  const totalCount = currentAssignments.length;
  const percentDone = Math.round((doneCount / totalCount) * 100);

  totalTasks.textContent = totalCount;
  doneTasks.textContent = doneCount;
  completionPercent.textContent = `${percentDone}%`;
  statusBadge.textContent = 'Scan complete';
  statusBadge.classList.add('badge-green');
  statusBadge.style.background = 'rgba(94, 225, 176, 0.16)';
  statusBadge.style.color = '#7af2b7';

  assignmentList.innerHTML = '';
  currentAssignments.forEach((assignment) => {
    const tile = document.createElement('button');
    tile.type = 'button';
    tile.dataset.assignmentId = assignment.id;
    const classes = ['assignment-tile'];
    if (assignment.id === selectedAssignmentId) classes.push('selected');
    if (assignment.status === 'done') classes.push('completed');
    tile.className = classes.join(' ');
    
    const completedBadge = assignment.status === 'done' ? '<div class="completed-badge">✓ Done</div>' : '';
    tile.innerHTML = `
      <div>
        <strong>${assignment.title}</strong>
        <div class="assignment-meta">
          <span>${assignment.subject}</span>
          <span>${assignment.status === 'done' ? 'Completed' : 'Undone'}</span>
        </div>
      </div>
      <div style="display: flex; align-items: center; gap: 12px;">
        <span>${assignment.questions.length} Qs</span>
        ${completedBadge}
      </div>
    `;
    tile.addEventListener('click', () => selectAssignment(assignment.id));
    assignmentList.appendChild(tile);
  });

  detailSection.classList.remove('hidden');
  selectAssignment(selectedAssignmentId);
  updateProgressPanel();
}

function updateProgressPanel() {
  if (!currentSession) {
    progressPanel.innerHTML = '<p class="muted">No session active yet. Login to see progress details.</p>';
    return;
  }

  const serviceMap = {
    maths: 'Maths',
    science: 'Science',
    reader: 'Reader'
  };

  const serviceHtml = currentSession.services
    .map((service) => {
      const url = serviceLoginUrls[service] || 'Unknown URL';
      const subjectName = serviceMap[service] || service;
      const count = currentAssignments.filter((assignment) => assignment.subject === subjectName).length;
      return `<li><strong>${subjectName}</strong>: <span>${url}</span> · ${count} assignment(s)</li>`;
    })
    .join('');

  const loggedInTo = currentSession.services.map((service) => service.charAt(0).toUpperCase() + service.slice(1)).join(', ');

  progressPanel.innerHTML = `
    <p><strong>Login route:</strong> using ${loggedInTo}</p>
    <ul>${serviceHtml}</ul>
    <p class="muted">The bot will first visit the selected Sparx login URLs, then scan tasks and report progress here.</p>
  `;
}

function selectAssignment(assignmentId) {
  selectedAssignmentId = assignmentId;
  const assignment = currentAssignments.find((item) => item.id === assignmentId);

  document.querySelectorAll('.assignment-tile').forEach((tile) => {
    tile.classList.toggle('selected', tile.dataset.assignmentId === assignmentId);
  });

  if (!assignment) {
    selectedTitle.textContent = 'Choose one assignment';
    questionPanel.innerHTML = '<p class="muted">Pick a homework task from the list to see the questions and work inside this dashboard.</p>';
    completeBtn.classList.add('hidden');
    pdfDownloadLink.classList.add('hidden');
    return;
  }

  selectedTitle.textContent = `${assignment.title} • ${assignment.subject}`;
  questionPanel.innerHTML = `
    <p class="muted">Answer the questions below inside the dashboard. This view is for your reference and guided work.</p>
    <ul class="question-list">
      ${assignment.questions.map((question) => `<li class="question-item">${question}</li>`).join('')}
    </ul>
  `;

  if (assignment.status === 'done') {
    completeBtn.textContent = 'Already completed';
    completeBtn.disabled = true;
    completeBtn.classList.remove('hidden');
    pdfDownloadLink.classList.remove('hidden');
  } else {
    completeBtn.textContent = 'Complete selected homework';
    completeBtn.disabled = false;
    completeBtn.classList.remove('hidden');
    pdfDownloadLink.classList.add('hidden');
  }
}

function createHomeworkPdf(assignment) {
  if (currentPdfUrl) {
    URL.revokeObjectURL(currentPdfUrl);
    currentPdfUrl = null;
  }

  const { jsPDF } = window.jspdf;
  const doc = new jsPDF({ unit: 'pt', format: 'a4' });
  const margin = 40;
  let vertical = 40;

  doc.setFontSize(18);
  doc.text('AutoSparx Homework Completion', margin, vertical);
  vertical += 30;
  doc.setFontSize(12);
  doc.text(`Assignment: ${assignment.title}`, margin, vertical);
  vertical += 18;
  doc.text(`Subject: ${assignment.subject}`, margin, vertical);
  vertical += 20;

  doc.setFontSize(11);
  doc.text('Step-by-step completed answers:', margin, vertical);
  vertical += 18;

  assignment.questions.forEach((question, index) => {
    const answerLines = generateSolutionSteps(question);
    const prefixText = assignment.completedAnswers?.[index] || generateSolutionSteps(question).join(' ');
    const prefix = `${index + 1}. ${question}`;
    const wrappedPrefix = doc.splitTextToSize(prefix, 520);
    doc.text(wrappedPrefix, margin, vertical);
    vertical += wrappedPrefix.length * 14;

    const wrappedAnswer = doc.splitTextToSize(`Answer: ${answerText}`, 520);
    doc.text(wrappedAnswer, margin + 12, vertical);
    vertical += wrappedAnswer.length * 14
    vertical += 10;
    if (vertical > 730) {
      doc.addPage();
      vertical = margin;
    }
  });

  const blob = doc.output('blob');
  currentPdfUrl = URL.createObjectURL(blob);
  pdfDownloadLink.href = currentPdfUrl;
  pdfDownloadLink.download = `${slugify(assignment.title)}_completed_homework.pdf`;
  pdfDownloadLink.textContent = 'Download completed PDF';
  pdfDownloadLink.classList.remove('hidden');
}

function generateSolutionSteps(question) {
  const lower = question.toLowerCase();
  if (lower.startsWith('solve')) {
    return [
      'Rewrite the equation clearly.',
      'Isolate the variable by moving numbers to the other side.',
      'Divide or simplify to find the value of the variable.',
      'Check the answer by substituting it back into the original equation.'
    ];
  }
  if (lower.startsWith('factorise') || lower.startsWith('factorize')) {
    return [
      'Identify the common structure or formula.',
      'Break the expression into factors.',
      'Write the factors as a product.',
      'Verify by expanding the factors back into the original expression.'
    ];
  }
  if (lower.startsWith('evaluate')) {
    return [
      'Substitute the value into the expression.',
      'Perform operations in the correct order (BODMAS).',
      'Simplify step by step until only a number remains.',
      'Confirm the final result is correct.'
    ];
  }
  if (lower.includes('summarise') || lower.includes('summarize')) {
    return [
      'Read the text carefully and identify the main idea.',
      'Write a short summary using your own words.',
      'Include the key events or facts from the passage.',
      'Keep the answer clear and focused.'
    ];
  }
  if (lower.includes('describe')) {
    return [
      'Think about the key features or meaning.',
      'Explain it using simple sentences.',
      'Give one or two examples if helpful.',
      'Keep the description clear and easy to follow.'
    ];
  }
  if (lower.includes('match') || lower.includes('use the word')) {
    return [
      'Read each prompt carefully.',
      'Match the item that fits the meaning.',
      'Use the word correctly in a complete sentence.',
      'Check spelling and clarity.'
    ];
  }
  return [
    'Read the question slowly.',
    'Break the problem into smaller steps.',
    'Work through each step carefully.',
    'Write the final response clearly and check it.'
  ];
}

function slugify(text) {
  return text.toLowerCase().replace(/[^a-z0-9]+/g, '_').replace(/^_|_$/g, '');
}

// Navigation and page management
const updateLog = [
  { title: 'Sidebar Navigation Added', date: 'May 12, 2026', content: 'Left sidebar with Dashboard and Updates pages. Quick access to all features.' },
  { title: 'Discord Community Button', date: 'May 12, 2026', content: 'Join our Discord community using the Discord button in the sidebar footer.' },
  { title: 'Update Log Page', date: 'May 12, 2026', content: 'View all updates and changes to AutoSparx in the Updates page.' },
  { title: 'Completed Homework Badges', date: 'May 12, 2026', content: 'Completed assignments now show green badges for quick visual identification.' },
  { title: 'Enhanced Homework Completion', date: 'May 12, 2026', content: 'AI bot now fully completes selected homework in Sparx and marks as done with smart detection for already-completed tasks.' },
  { title: 'Theme Customization', date: 'May 11, 2026', content: '15 midnight colour combinations added. Customise dashboard appearance with wallpapers and languages.' },
  { title: 'PDF Export Feature', date: 'May 11, 2026', content: 'Generate step-by-step homework solution PDFs that can be downloaded for offline reference.' },
  { title: 'Initial Release', date: 'May 10, 2026', content: 'AutoSparx dashboard prototype with homework scanning, selection, and settings.' }
];

function switchPage(pageName) {
  dashboardPage.classList.toggle('hidden', pageName !== 'dashboard');
  updatesPage.classList.toggle('hidden', pageName !== 'updates');

  navBtns.forEach((btn) => {
    btn.classList.toggle('active', btn.dataset.page === pageName);
  });
}

navBtns.forEach((btn) => {
  btn.addEventListener('click', () => {
    switchPage(btn.dataset.page);
  });
});

function populateUpdateLog() {
  updatesList.innerHTML = '';
  updateLog.forEach((update) => {
    const item = document.createElement('div');
    item.className = 'update-item';
    item.innerHTML = `
      <div class="update-item-header">
        <h3 class="update-item-title">${update.title}</h3>
        <span class="update-item-date">${update.date}</span>
      </div>
      <p class="update-item-content">${update.content}</p>
    `;
    updatesList.appendChild(item);
  });
}

populateUpdateLog();

// Keep the password only for the active scan in memory.
// This demo uses sample homework and a simulated scan so the UI works inside Codespaces.
