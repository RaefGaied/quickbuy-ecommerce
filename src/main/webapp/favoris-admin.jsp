<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Gestion des Favoris</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/favorisadmin.css">
   <style>
    .product-img {
        width: 50px;
        height: 50px;
        object-fit: cover;
        border-radius: 8px;
    }
    
    .alert {
    animation: fadeIn 0.5s ease-in-out;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-10px); }
    to   { opacity: 1; transform: translateY(0); }
}
    
</style>

</head>
<body>
    <!-- Messages d'alerte -->
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show m-3">
            ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>
    
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show m-3">
            ${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <nav class="navbar navbar-expand-lg navbar-dark admin-badge mb-4 sticky-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="acceuil2">
                <i class="fas fa-chart-line me-2"></i>Tableau de bord des Favoris
            </a>
            <div class="d-flex">
                <a href="acceuil2" class="btn btn-outline-light me-2">
                    <i class="fas fa-arrow-left me-1"></i> Retour
                </a>
                <a href="LogoutServlet" class="btn btn-danger">
                    <i class="fas fa-sign-out-alt me-1"></i> Déconnexion
                </a>
            </div>
        </div>
    </nav>

    <div class="container mb-5">
        <!-- Section Statistiques Redesignée -->
        <div class="row mb-4">
            <!-- Carte Produits Favoris -->
            <div class="col-md-4">
                <div class="stat-card stat-card-1 h-100">
                    <div class="card-body">
                        <div class="stat-icon">
                            <i class="fas fa-heart"></i>
                        </div>
                        <div class="stat-content">
                            <h3 class="stat-value text-primary">${totalProduits}</h3>
                            <p class="stat-title">Produits Favoris</p>
                            
                            <div class="stat-progress-container">
                                <div class="stat-progress">
                                    <div class="stat-progress-bar bg-primary" 
                                         style="width: ${(totalProduits/maxProduits)*100}%"></div>
                                </div>
                                <span class="stat-count text-primary">
                                    ${totalProduits} / ${maxProduits}
                                </span>
                            </div>
                            
                            <small class="stat-change mt-2 d-block">
                                <i class="fas fa-arrow-up text-success"></i> 
                                <fmt:formatNumber value="${(totalProduits - previousProduits)/previousProduits * 100}" 
                                                maxFractionDigits="1"/>% vs mois dernier
                            </small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Carte Interactions -->
            <div class="col-md-4">
                <div class="stat-card stat-card-2 h-100">
                    <div class="card-body">
                        <div class="stat-icon">
                            <i class="fas fa-exchange-alt"></i>
                        </div>
                        <div class="stat-content">
                            <h3 class="stat-value text-success">${totalInteractions}</h3>
                            <p class="stat-title">Interactions</p>
                            
                            <div class="stat-progress-container">
                                <div class="stat-progress">
                                    <div class="stat-progress-bar bg-success" 
                                         style="width: ${(totalInteractions/maxInteractions)*100}%"></div>
                                </div>
                                <span class="stat-count text-success">
                                    ${totalInteractions} / ${maxInteractions}
                                </span>
                            </div>
                            
                            <small class="stat-change mt-2 d-block">
                                <i class="fas ${(totalInteractions - previousInteractions) >= 0 ? 'fa-arrow-up text-success' : 'fa-arrow-down text-danger'}"></i> 
                                <fmt:formatNumber value="${Math.abs(totalInteractions - previousInteractions)}" 
                                                maxFractionDigits="0"/> vs mois dernier
                            </small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Carte Utilisateurs Actifs -->
            <div class="col-md-4">
                <div class="stat-card stat-card-3 h-100">
                    <div class="card-body">
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-content">
                            <h3 class="stat-value text-info">${totalUsers}</h3>
                            <p class="stat-title">Utilisateurs Actifs</p>
                            
                            <div class="stat-progress-container">
                                <div class="stat-progress">
                                    <div class="stat-progress-bar bg-info" 
                                         style="width: ${(totalUsers/maxUsers)*100}%"></div>
                                </div>
                                <span class="stat-count text-info">
                                    ${totalUsers} / ${maxUsers}
                                </span>
                            </div>
                            
                            <small class="stat-change mt-2 d-block">
                                <i class="fas fa-user-plus text-success"></i> 
                                ${newUsers} nouveaux ce mois
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

<div class="container my-5">
    <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
        <!-- En-tête révisée pour meilleure visibilité -->
        <div class="card-header bg-primary text-white p-4">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center">
                <h2 class="h4 mb-3 mb-md-0 d-flex align-items-center text-white">
                    <i class="fas fa-trophy me-2"></i> Classement des Produits Favoris
                </h2>
                
                <!-- Boutons de tri avec meilleur contraste -->
                <div class="sort-options-container bg-white bg-opacity-10 p-2 rounded-3">
                    <div class="btn-group btn-group-sm" role="group" aria-label="Options de tri">
                        <button type="button" 
                                class="sort-btn btn btn-outline-light active" 
                                data-sort="favorites" 
                                aria-pressed="true">
                            <i class="fas fa-heart me-1"></i> <span class="fw-bold">Par Favoris</span>
                        </button>
                        <button type="button" 
                                class="sort-btn btn btn-outline-light" 
                                data-sort="price-high" 
                                aria-pressed="false">
                            <i class="fas fa-euro-sign me-1"></i> <span class="fw-bold">Prix élevé</span>
                        </button>
                        <button type="button" 
                                class="sort-btn btn btn-outline-light" 
                                data-sort="price-low" 
                                aria-pressed="false">
                            <i class="fas fa-euro-sign me-1"></i> <span class="fw-bold">Prix bas</span>
                        </button>
                        <button type="button" 
                                class="sort-btn btn btn-outline-light" 
                                data-sort="name" 
                                aria-pressed="false">
                            <i class="fas fa-sort-alpha-down me-1"></i> <span class="fw-bold">Par Nom</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Corps de la carte -->
        <div class="card-body p-4">
            <c:choose>
                <c:when test="${not empty topProduits}">
                    <div class="row g-4">
                        <c:forEach items="${topProduits}" var="entry" varStatus="loop">
                            <div class="col-md-6 col-lg-4">
                                <!-- Carte de produit -->
                                <article class="favorite-card border rounded-4 shadow-sm p-3 h-100 bg-white"
                                     data-favorites="${entry[1]}"
                                     data-price="${entry[0].prix}"
                                     data-name="${entry[0].nom}">
                                    <div class="d-flex gap-3">
                                        <!-- Image du produit -->
                                        <div class="position-relative" style="flex-shrink: 0;">
                                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-primary">
                                                #${loop.index + 1}
                                            </span>
                                            <c:choose>
                                                <c:when test="${not empty entry[0].image}">
                                                    <img src="${pageContext.request.contextPath}/images/${entry[0].image}"
                                                         alt="Image de ${entry[0].nom}"
                                                         class="img-fluid rounded"
                                                         style="width: 90px; height: 90px; object-fit: cover;"
                                                         loading="lazy">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="bg-light rounded d-flex align-items-center justify-content-center"
                                                         style="width: 90px; height: 90px;"
                                                         aria-hidden="true">
                                                        <i class="fas fa-box-open fa-2x text-muted"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Détails du produit -->
                                        <div class="flex-grow-1 d-flex flex-column justify-content-between">
                                            <div>
                                                <h3 class="h5 mb-1 product-title">${entry[0].nom}</h3>
                                                <div class="text-primary fw-bold fs-6" aria-label="Prix">
                                                    <fmt:formatNumber value="${entry[0].prix}" type="currency" currencyCode="EUR"/>
                                                </div>
                                            </div>

                                            <!-- Statistiques de favoris -->
                                            <div class="mt-2">
                                                <div class="d-flex justify-content-between align-items-center mb-1">
                                                    <span class="badge bg-danger bg-opacity-10 text-danger">
                                                        <i class="fas fa-heart me-1" aria-hidden="true"></i> 
                                                        <span>${entry[1]} favoris</span>
                                                    </span>
                                                    <span class="fw-bold text-muted small">
                                                        <fmt:formatNumber value="${(entry[1]/maxFavoris)*100}" maxFractionDigits="1"/>%
                                                    </span>
                                                </div>
                                                <div class="progress" style="height: 6px;" role="progressbar" 
                                                     aria-valuenow="${(entry[1]/maxFavoris)*100}" 
                                                     aria-valuemin="0" 
                                                     aria-valuemax="100">
                                                    <c:set var="percentage" value="${(entry[1]/maxFavoris)*100}" />
                                                    <div class="progress-bar bg-success"
                                                         style="width: ${percentage}%;">
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Actions -->
                                            <div class="d-flex justify-content-end gap-2 mt-3">
                                                <button class="btn btn-sm btn-outline-primary" aria-label="Voir les détails de ${entry[0].nom}">
                                                    <i class="fas fa-info-circle me-1" aria-hidden="true"></i> Détails
                                                </button>
                                                <button class="btn btn-sm btn-danger" aria-label="Ajouter ${entry[0].nom} aux favoris">
                                                    <i class="fas fa-heart me-1" aria-hidden="true"></i> Favori
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </article>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- État vide -->
                    <div class="empty-state text-center py-5" aria-live="polite">
                        <i class="far fa-heart fa-4x text-muted mb-3" aria-hidden="true"></i>
                        <h3 class="h4 text-muted">Aucun produit favori</h3>
                        <p class="text-muted">Les produits marqués comme favoris apparaîtront ici</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<div class="card">
            <div class="card-header bg-primary text-white">
                <h4><i class="fas fa-list me-2"></i>Détail des Favoris</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Produit</th>
                                <th class="text-center">Favoris</th>
                                <th>Utilisateurs</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${produitsFavoris}" var="produit" varStatus="status">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <c:choose>
                                                <c:when test="${not empty produit.image}">
                                                    <img src="${pageContext.request.contextPath}/images/${produit.image}" 
                                                         alt="${produit.nom}" 
                                                         class="product-img me-3">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="product-img me-3 bg-light d-flex align-items-center justify-content-center">
                                                        <i class="fas fa-box-open text-muted"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <div>
                                                <h6 class="mb-0">${produit.nom}</h6>
                                                <small class="text-muted">
                                                    <fmt:formatNumber value="${produit.prix}" type="currency" currencyCode="EUR"/> 
                                                    | Stock: ${produit.quantite}
                                                </small>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-primary rounded-pill px-3 py-2">
                                            ${produit.favoriteCount}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="user-list">
                                            <c:if test="${not empty usersParProduit[produit.id]}">
                                                <c:forEach items="${usersParProduit[produit.id]}" var="user" varStatus="userStatus" end="2">
                                                    <div class="user-item">
                                                        <span class="fw-bold">${user.username}</span>
                                                        <small class="text-muted">(${user.email})</small>
                                                    </div>
                                                </c:forEach>
                                                <c:if test="${fn:length(usersParProduit[produit.id]) > 3}">
                                                    <button class="btn btn-sm btn-outline-secondary mt-2" 
                                                            data-bs-toggle="collapse" 
                                                            data-bs-target="#users-${produit.id}">
                                                        + ${fn:length(usersParProduit[produit.id]) - 3} autres
                                                    </button>
                                                    <div class="collapse mt-2" id="users-${produit.id}">
                                                        <c:forEach begin="3" items="${usersParProduit[produit.id]}" var="user">
                                                            <div class="user-item">
                                                                <span class="fw-bold">${user.username}</span>
                                                                <small class="text-muted">(${user.email})</small>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </c:if>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <a href="FavorisServlet?action=${produit.isFavorite ? 'supprimer' : 'ajouter'}&idProduit=${produit.id}" 
                                           class="btn btn-sm ${produit.isFavorite ? 'btn-danger' : 'btn-outline-secondary'} btn-favorite"
                                           title="${produit.isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris'}"
                                           data-favorite-action>
                                           <i class="fas fa-heart${produit.isFavorite ? '' : '-broken'}"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    

    <!-- Footer -->
    <footer class="bg-dark text-white py-3 mt-5">
        <div class="container text-center">
            <p class="mb-0">&copy; <fmt:formatDate value="${now}" pattern="yyyy" /> Gestion des Favoris - Tous droits réservés</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    
    $(document).ready(function() {
        $('#clearHistoryBtn').click(function(e) {
            e.preventDefault();
            if(confirm("Êtes-vous sûr de vouloir effacer tout l'historique des actions ?")) {
                $(this).closest('form').submit();
            }
        });
    });

    $(document).ready(function() {
        // Gestion du bouton effacer l'historique
        $('#clearHistoryBtn').click(function(e) {
            if(confirm("Êtes-vous sûr de vouloir effacer tout l'historique des actions ?")) {
                $('form').submit();
            }
        });
    });
    
    

            // Vide le conteneur
            productContainer.innerHTML = '';
            // Réinsère les produits triés
            products.forEach(product => {
                productContainer.appendChild(product);
            });
        }
    });
    document.addEventListener('DOMContentLoaded', function() {
        // Animate progress bars on load
        const progressBars = document.querySelectorAll('.progress-bar');
        
        progressBars.forEach(bar => {
            const width = bar.style.width;
            bar.style.width = '0';
            
            setTimeout(() => {
                bar.style.width = width;
                bar.classList.add('progress-bar-animated');
                
                setTimeout(() => {
                    bar.classList.remove('progress-bar-animated');
                }, 1000);
            }, 100);
        });

        // Debug: Check maxFavoris and percentages
        console.log("Max favoris:", ${maxFavoris});
        <c:forEach items="${topProduits}" var="entry" varStatus="loop">
            console.log("Product #${loop.index + 1}:", "${entry[0].nom}", 
                      "Favorites:", ${entry[1]}, 
                      "Percentage:", ${(entry[1]/maxFavoris)*100});
        </c:forEach>
    });
    </script>
    
    <script src="${pageContext.request.contextPath}/static/js/favorisadminjs.js"></script>
</body>
</html>