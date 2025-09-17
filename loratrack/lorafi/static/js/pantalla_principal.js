document.addEventListener('DOMContentLoaded', () => {
    const navButton = document.querySelector('.nav_dis');
    const navPanel = document.querySelector('.nav_dis_content');
    const backButton = document.querySelector('.volver-btn');

    // Asegurarse de que los elementos existen antes de añadir listeners
    if (navButton && navPanel) {
        navButton.addEventListener('click', () => {
            navPanel.classList.toggle('hide');
            // Añadir o quitar las clases flex y flex-col según corresponda
            if (navPanel.classList.contains('hide')) {
                navPanel.classList.remove('flex', 'flex-col');
            } else {
                navPanel.classList.add('flex', 'flex-col');
            }
            navButton.classList.toggle('hide');
        });
    }

    if (backButton && navPanel) {
        backButton.addEventListener('click', () => {
            navPanel.classList.toggle('hide');
            // Añadir o quitar las clases flex y flex-col según corresponda
            if (navPanel.classList.contains('hide')) {
                navPanel.classList.remove('flex', 'flex-col');
            } else {
                navPanel.classList.add('flex', 'flex-col');
            }
            navButton.classList.toggle('hide');
        });
    }
});