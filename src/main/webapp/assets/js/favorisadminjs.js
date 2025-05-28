/**
 * Gestion des fonctionnalités JavaScript pour l'application de favoris
 */
document.addEventListener('DOMContentLoaded', function() {
    // Activer les tooltips Bootstrap
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl, {
            trigger: 'hover'
        });
    });

    // Fermer automatiquement les alertes après 5 secondes
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            new bootstrap.Alert(alert).close();
        });
    }, 5000);

    // Tri des produits favoris
    const sortButtons = document.querySelectorAll('.sort-btn');
    const cardsContainer = document.querySelector('.favorites-container') || document.querySelector('.row.g-4');

    if (sortButtons && cardsContainer) {
        sortButtons.forEach(button => {
            button.addEventListener('click', function () {
                // Gérer les classes actives
                sortButtons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');

                const sortBy = this.dataset.sort;
                const cards = Array.from(cardsContainer.children);

                cards.sort((a, b) => {
                    const aCard = a.querySelector('.favorite-card');
                    const bCard = b.querySelector('.favorite-card');

                    if (!aCard || !bCard) return 0;

                    switch (sortBy) {
                        case 'favorites':
                            return bCard.dataset.favorites - aCard.dataset.favorites;
                        case 'price-high':
                            return bCard.dataset.price - aCard.dataset.price;
                        case 'price-low':
                            return aCard.dataset.price - bCard.dataset.price;
                        case 'name':
                            return aCard.dataset.name.localeCompare(bCard.dataset.name);
                        default:
                            return 0;
                    }
                });

                cards.forEach(card => cardsContainer.appendChild(card));
            });
        });
    }

    // Effet hover sur les cartes de produits
    const cards = document.querySelectorAll('.favorite-card');
    cards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
            this.style.boxShadow = '0 8px 16px rgba(0, 0, 0, 0.15)';
            this.style.transition = 'all 0.3s ease';
        });
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '0 4px 12px rgba(0, 0, 0, 0.1)';
        });
    });

    // Animation des cartes statistiques
    const statCards = document.querySelectorAll('.stat-card');
    statCards.forEach((card, index) => {
        setTimeout(() => {
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 150);
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
    });
});

$(document).ready(function() {
    // Gestion du bouton favoris
    $('[data-favorite-action]').click(function(e) {
        e.preventDefault();

        const $btn = $(this);
        const $icon = $btn.find('i');
        const wasFavorite = $btn.hasClass('btn-danger');
        const url = $btn.attr('href');

        // Animation pendant la requête
        $icon.removeClass('fa-heart fa-heart-broken').addClass('fa-spinner fa-spin');
        $btn.prop('disabled', true);

        $.get(url, function(data) {
            $btn.toggleClass('btn-danger btn-outline-secondary');
            $icon.removeClass('fa-spinner fa-spin').addClass(wasFavorite ? 'fa-heart-broken' : 'fa-heart').addClass('heart-animation');

            setTimeout(() => $icon.removeClass('heart-animation'), 1000);

            const $countElement = $('.favorite-count');
            if ($countElement.length) {
                const currentCount = parseInt($countElement.text());
                $countElement.text(wasFavorite ? currentCount - 1 : currentCount + 1);
            }

            refreshHistory();
        }).fail(function() {
            showAlert('Une erreur est survenue', 'danger');
        }).always(function() {
            $btn.prop('disabled', false);
        });
    });

    // Bouton effacer l'historique
    $('#clearHistoryBtn').click(function(e) {
        e.preventDefault();

        if(confirm("Êtes-vous sûr de vouloir effacer tout l'historique des actions ?")) {
            $.post('FavorisServlet', { action: 'clearHistory' }, function() {
                showAlert('Historique effacé avec succès', 'success');
                refreshHistory();
            }).fail(function() {
                showAlert('Erreur lors de la suppression de l\'historique', 'danger');
            });
        }
    });

    // Auto-rafraîchissement de l'historique
    setInterval(refreshHistory, 30000);

    // Rafraîchir historique
    function refreshHistory() {
        $('#historiqueActions').load(location.href + ' #historiqueActions > *', function() {
            $('[title]').tooltip('dispose').tooltip({ trigger: 'hover' });
        });
    }

    // Affichage des alertes
    function showAlert(message, type) {
        const $alert = $(`
            <div class="alert alert-${type} alert-dismissible fade show position-fixed top-0 end-0 m-3 z-3">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `);
        $('body').append($alert);
        setTimeout(() => $alert.alert('close'), 3000);
    }
});
