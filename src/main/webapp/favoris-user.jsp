<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Mes Favoris</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4CAF50;
            --secondary-color: #8BC34A;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
        }
        
        body {
            background-color: var(--light-color);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .user-header {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .favorite-card {
            transition: all 0.3s ease;
            border: none;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            cursor: pointer;
        }
        
        .favorite-card:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        
        .card-img-top {
            height: 180px;
            object-fit: cover;
        }
        
        .badge-price {
            font-size: 1rem;
            padding: 0.5rem 1rem;
        }
        
        /* Animation pour le bouton retirer */
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .btn-remove:hover {
            animation: pulse 0.5s ease;
        }
        
        @media (max-width: 768px) {
            .favorite-card {
                margin-bottom: 1rem;
            }
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

    <nav class="navbar navbar-expand-lg navbar-dark user-header mb-4 sticky-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="acceuil2">
                <i class="fas fa-heart me-2"></i>Mes Favoris
            </a>
            <div class="d-flex">
                <a href="acceuil2" class="btn btn-outline-light me-2">
                    <i class="fas fa-arrow-left me-1"></i> Retour
                </a>
                <a href="LogoutServlet" class="btn btn-light">
                    <i class="fas fa-sign-out-alt me-1"></i> Déconnexion
                </a>
            </div>
        </div>
    </nav>

    <div class="container mb-5">
        <c:choose>
            <c:when test="${empty favoris}">
                <div class="alert alert-info text-center">
                    <i class="fas fa-info-circle fa-2x mb-3"></i>
                    <h4>Votre liste de favoris est vide</h4>
                    <p>Commencez par ajouter des produits à vos favoris</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                    <c:forEach items="${favoris}" var="produit">
                        <div class="col">
                            <div class="card favorite-card h-100">
                                <c:choose>
                                    <c:when test="${not empty produit.image}">
                                        <img src="${pageContext.request.contextPath}/images/${produit.image}" 
                                             class="card-img-top" 
                                             alt="${produit.nom}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="card-img-top bg-light d-flex align-items-center justify-content-center" 
                                             style="height: 180px;">
                                            <i class="fas fa-box-open fa-3x text-muted"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-body">
                                    <h5 class="card-title">${produit.nom}</h5>
                                    <p class="card-text">
                                        <span class="badge bg-success badge-price">
                                            <fmt:formatNumber value="${produit.prix}" type="currency"/>
                                        </span>
                                        <span class="badge bg-secondary ms-2">
                                            Stock: ${produit.quantite}
                                        </span>
                                    </p>
                                </div>
                                <div class="card-footer bg-white border-0">
                                    <a href="FavorisServlet?action=supprimer&idProduit=${produit.id}" 
                                       class="btn btn-danger btn-sm btn-remove w-100"
                                       title="Retirer des favoris">
                                       <i class="fas fa-trash-alt me-1"></i> Retirer
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-white py-3 mt-5">
        <div class="container text-center">
            <p class="mb-0">&copy; <fmt:formatDate value="${now}" pattern="yyyy" /> Gestion des Favoris</p>
        </div>
    </footer>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        // Activer les tooltips
        document.addEventListener('DOMContentLoaded', function() {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
            tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl, {
                    trigger: 'hover'
                });
            });
            
            // Fermer automatiquement les alertes après 5 secondes
            setTimeout(function() {
                var alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    new bootstrap.Alert(alert).close();
                });
            }, 5000);
        });
    </script>
</body>
</html>