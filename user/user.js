let isSidebarOpen = true; // Start open on desktop

function toggleDarkMode() {
    const html = document.documentElement;
    if (html.classList.contains('dark')) {
        html.classList.remove('dark');
        localStorage.setItem('theme', 'light');
    } else {
        html.classList.add('dark');
        localStorage.setItem('theme', 'dark');
    }
}

// Check for saved theme preference on load
if (localStorage.getItem('theme') === 'dark') {
    document.documentElement.classList.add('dark');
}

function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const backdrop = document.getElementById('sidebar-backdrop');
    isSidebarOpen = !isSidebarOpen;
    
    if (isSidebarOpen) {
        sidebar.classList.add('sidebar-open');
        sidebar.classList.remove('sidebar-collapsed');
        if (window.innerWidth < 768) backdrop.classList.remove('hidden');
    } else {
        sidebar.classList.remove('sidebar-open');
        sidebar.classList.add('sidebar-collapsed');
        backdrop.classList.add('hidden');
    }
}

function switchTab(tabId) {
    // Close sidebar automatically on mobile
    if (window.innerWidth < 768 && isSidebarOpen) {
        toggleSidebar();
    }

    document.querySelectorAll('.tab-pane').forEach(el => el.classList.add('hidden'));
    const target = document.getElementById(`tab-${tabId}`);
    if (target) target.classList.remove('hidden');
    
    const titles = {
        'dashboard': 'Dashboard',
        'profile': 'My Profile',
        'about': 'About Us',
        'contact': 'Contact Us'
    };
    document.getElementById('tab-title').innerText = titles[tabId] || 'Portal';

    document.querySelectorAll('.sidebar-link').forEach(btn => btn.classList.remove('active'));
    const sideBtn = document.getElementById(`btn-${tabId}`);
    if (sideBtn) sideBtn.classList.add('active');
}

function showSuccess(msg) {
    const t = document.getElementById('toast');
    t.innerText = msg;
    t.classList.remove('opacity-0');
    t.classList.add('opacity-100', 'translate-y-[-10px]');
    setTimeout(() => {
        t.classList.add('opacity-0');
        t.classList.remove('translate-y-[-10px]');
    }, 3000);
}

function logout() {
    showSuccess('Logging out...');
    setTimeout(() => location.reload(), 800);
}

// Initialize view based on screen size
window.addEventListener('resize', () => {
    if (window.innerWidth < 768 && isSidebarOpen) {
        toggleSidebar(); // Auto-close on resize to mobile
    }
});