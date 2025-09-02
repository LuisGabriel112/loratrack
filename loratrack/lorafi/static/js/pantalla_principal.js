document.addEventListener('DOMContentLoaded', () => {
    const navButton = document.querySelector('.nav_dis');
    const navPanel = document.querySelector('.nav_dis_content');
    const backButton = document.querySelector('.volver-btn');

    // Asegurarse de que los elementos existen antes de añadir listeners
    if (navButton && navPanel) {
        navButton.addEventListener('click', () => {
            navPanel.classList.toggle('hide');
            navButton.classList.toggle('hide');
        });
    }

    if (backButton && navPanel) {
        backButton.addEventListener('click', () => {
            navPanel.classList.toggle('hide');
            navButton.classList.toggle('hide');
        });
    }
});