// ─── LIVE SENSOR POLLING ───────────────────────────────────────────
function startLivePolling(contextPath) {
    updateSensor(contextPath);
    setInterval(() => updateSensor(contextPath), 5000);
}

function updateSensor(contextPath) {
    fetch(contextPath + '/api/sensor')
        .then(r => r.json())
        .then(data => {
            setValue('tempVal',   data.temperature, '°C');
            setValue('presVal',   data.pressure,    'bar');
            setValue('flowVal',   data.flowRate,     'L/min');
            setValue('levelVal',  data.level,        '%');
            setGauge('tempGauge',  data.temperature, 0, 100);
            setGauge('presGauge',  data.pressure,    0, 12);
            setGauge('flowGauge',  data.flowRate,    0, 60);
            setGauge('levelGauge', data.level,       0, 100);
            updateTimestamp();
            checkThresholds(data);
        })
        .catch(() => console.log('Sensor API not available'));
}

function setValue(id, val, unit) {
    const el = document.getElementById(id);
    if (el) el.textContent = parseFloat(val).toFixed(2) + (unit ? ' ' + unit : '');
}

function setGauge(id, val, min, max) {
    const el = document.getElementById(id);
    if (!el) return;
    const pct = Math.min(100, Math.max(0, ((val - min) / (max - min)) * 100));
    el.style.width = pct + '%';
    el.className = 'gauge-fill';
    if (pct > 85) el.classList.add('danger');
    else if (pct > 70) el.classList.add('warn');
}

function updateTimestamp() {
    const el = document.getElementById('lastUpdated');
    if (el) el.textContent = 'Last updated: ' + new Date().toLocaleTimeString();
}

function checkThresholds(data) {
    // Visual warning if temperature > 80
    const tempCard = document.getElementById('tempCard');
    if (tempCard) {
        if (data.temperature > 80) tempCard.style.borderColor = '#ef4444';
        else tempCard.style.borderColor = '';
    }
}

// ─── CHART HELPERS ────────────────────────────────────────────────
function buildTrendChart(canvasId, labels, datasets) {
    const ctx = document.getElementById(canvasId);
    if (!ctx) return;
    return new Chart(ctx, {
        type: 'line',
        data: { labels, datasets },
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { position: 'top', labels: { usePointStyle: true, pointStyleWidth: 8, font: { size: 11 } } } },
            scales: {
                x: { grid: { display: false }, ticks: { maxTicksLimit: 8, font: { size: 11 } } },
                y: { grid: { color: '#f1f5f9' }, ticks: { font: { size: 11 } } }
            },
            elements: { point: { radius: 0 }, line: { tension: 0.4, borderWidth: 2 } }
        }
    });
}

// ─── MODAL HELPERS ────────────────────────────────────────────────
function openModal(id) {
    const m = document.getElementById(id);
    if (m) { m.style.display = 'flex'; }
}
function closeModal(id) {
    const m = document.getElementById(id);
    if (m) { m.style.display = 'none'; }
}
document.addEventListener('keydown', e => {
    if (e.key === 'Escape') {
        document.querySelectorAll('.modal').forEach(m => m.style.display = 'none');
    }
});

// ─── SIDEBAR MOBILE TOGGLE ─────────────────────────────────────────
function toggleSidebar() {
    document.querySelector('.sidebar').classList.toggle('open');
}

// ─── AUTO-DISMISS ALERTS ──────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
    const alerts = document.querySelectorAll('.alert[data-auto-dismiss]');
    alerts.forEach(a => setTimeout(() => a.remove(), 4000));
});