<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="java.util.Objects" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entities.User" %> 

<%
    HttpSession sessionUser = request.getSession(false);
    User user = (sessionUser != null) ? (User) sessionUser.getAttribute("user") : null;
    String username = (user != null) ? user.getUsername() : null;
    String role = (sessionUser != null) ? (String) sessionUser.getAttribute("role") : null;
    Integer userId = (sessionUser != null && sessionUser.getAttribute("userId") != null) ? 
                     (Integer) sessionUser.getAttribute("userId") : null;

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String cacheBuster = "?v=" + System.currentTimeMillis();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Produits - <c:out value="${role eq 'admin' ? 'Admin' : 'Utilisateur'}"/></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="icon" href="${pageContext.request.contextPath}/images/ventes.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/acceuil.css">
    <script src="${pageContext.request.contextPath}/static/js/favorisadminjs.js"></script>
    <style>
     .welcome-container {
        border-left: 4px solid #0d6efd;
        transition: all 0.3s ease;
    }
    .welcome-container:hover {
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
    }
    #clock {
        font-family: 'Courier New', monospace;
        background: rgba(13, 110, 253, 0.1);
        padding: 5px 10px;
        border-radius: 4px;
    }
    </style>
</head>
<body class="${role eq 'admin' ? 'admin-view' : 'user-view'}">

   
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm mb-4 border-bottom">

        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="acceuil2">
                <i class="fas fa-box-open me-2"></i>Gestion des Produits
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarContent">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="acceuil2">
                            <i class="fas fa-home me-1"></i> Accueil
                        </a>
                    </li>
                    
                    <c:if test="${role eq 'admin'}">
                        <li class="nav-item">
                            <a class="nav-link" href="product-form2.jsp">
                                <i class="fas fa-plus-circle me-1"></i> Ajouter Produit
                            </a>
                        </li>
                         <li class="nav-item">
        <a class="nav-link fw-semibold px-3" href="categorie-form.jsp">
          <i class="fas fa-plus-circle"></i> Gerer Categorie
        </a>
      </li>
                        <li class="nav-item">
                            <a class="nav-link" href="FavorisServlet">
                                <i class="fas fa-chart-bar me-1"></i> Statistiques Favoris
                            </a>
                        </li>
                    </c:if>
                </ul>
                
                <form class="d-flex me-3" action="search" method="get">
                    <div class="input-group">
                        <input type="search" class="form-control" name="r" placeholder="Rechercher..." required>
                        <button class="btn btn-light" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
                
                <ul class="navbar-nav">
                    <li class="nav-item">
                       <c:if test="${role != 'admin'}">
                        <a class="nav-link" href="favoris-user.jsp">
                            <i class="fas fa-heart me-1"></i> Mes Favoris
                        </a>
                        </c:if>
                    </li>
                    <li class="nav-item">
                       <c:if test="${role != 'admin'}">
                        <a class="nav-link" href="cart.jsp">
                            <i class="fas fa-shopping-cart me-1"></i> Panier
                        </a>
                        </c:if>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i> <%= username %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="profile.jsp"><i class="fas fa-user me-2"></i>Profil</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="LogoutServlet"><i class="fas fa-sign-out-alt me-2"></i>Déconnexion</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container mt-3">
        <div class="alert alert-info d-flex justify-content-between align-items-center" role="alert">
            <div>
                <i class="fas fa-hand-sparkles me-2 fs-4"></i>
                Bienvenue, <strong><%= username %></strong> ! Ravi de vous revoir dans votre espace 
                <strong><%= ("admin".equals(role)) ? "administrateur" : "utilisateur" %></strong>.
            </div>
            <div class="text-end">
                <i class="fas fa-clock me-1"></i>
                <span id="clock" class="fw-bold"></span>
            </div>
        </div>
    </div>

    <c:if test="${not empty param.message}">
        <div class="alert alert-success alert-flash alert-dismissible fade show">
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            <i class="fas fa-check-circle me-2"></i> ${param.message}
        </div>
        <script>
            setTimeout(function() {
                document.querySelector('.alert-flash').remove();
            }, 3000);
        </script>
    </c:if>

    <!-- Main Content -->
    <div class="container container-main">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0">
                <i class="fas fa-boxes me-2"></i>Liste des Produits
                <small class="text-muted fs-6">(Vue ${role eq 'admin' ? 'Administrateur' : 'Utilisateur'})</small>
            </h2>
            
            <!--<c:if test="${role eq 'admin'}">
                <a href="product-form2.jsp" class="btn btn-primary">
                    <i class="fas fa-plus-circle me-2"></i>Ajouter un produit
                </a>
            </c:if>-->
        </div>

        <c:if test="${role != 'admin'}">
    <a href="cart.jsp" class="cart-btn mb-3 d-inline-flex align-items-center">
        <i class="fas fa-shopping-cart me-2"></i> Voir le Panier
    </a>
</c:if>
        
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Image</th>
                        <th>Nom</th>
                        <th>Prix</th>
                        <th>Quantité</th>
                        <th>Catégorie</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty products}">
                            <tr>
                                <td colspan="6" class="text-center alert alert-warning">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    Aucun produit disponible
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${products}" var="p">
                                <tr class="product-row">
                                    <td class="text-center">${p.id}</td>
                                    <td class="text-center">
                                        <div class="position-relative" style="width: 80px; margin: 0 auto;">
                                            <c:choose>
                                                <c:when test="${not empty p.image}">
                                                    <img src="${pageContext.request.contextPath}/images/${p.image}${cacheBuster}"
                                                         alt="Image de ${p.nom}"
                                                         style="max-width: 80px; max-height: 80px; border-radius: 8px; object-fit: cover;">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="product-img bg-light d-flex align-items-center justify-content-center img-thumbnail" 
                                                         style="width: 80px; height: 80px;">
                                                        <i class="fas fa-box-open text-muted"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="stock-badge badge 
                                                  ${p.quantite > 10 ? 'bg-success' : 
                                                   p.quantite > 0 ? 'bg-warning text-dark' : 'bg-danger'}">
                                                ${p.quantite > 0 ? p.quantite : '0'}
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <h6 class="product-name mb-0">${p.nom}</h6>
                                        <small class="favorite-count">
                                           <c:if test="${role != 'admin'}">
                                            <i class="fas fa-heart text-danger"></i> ${p.favoriteCount} favoris
                                            </c:if>
                                        </small>
                                    </td>
                                    <td class="text-center product-price">${p.prix}€</td>
                                    <td class="text-center">
                                        <span class="${p.quantite > 10 ? 'in-stock' : 
                                                   p.quantite > 0 ? 'low-stock' : 'out-of-stock'}">
                                            ${p.quantite}
                                        </span>
                                    </td>
                                     <td>${p.categorie.nom}</td>
                                    <td class="action-btns">
                                        <div class="d-flex justify-content-center gap-2">

                                      
                                            <c:if test="${role ne 'admin'}">
                                                <a href="CartServlet?action=add&id=${p.id}"
                                                   class="btn btn-success btn-sm"
                                                   title="Ajouter au panier"
                                                   ${p.quantite <= 0 ? 'disabled' : ''}>
                                                    <i class="fas fa-shopping-cart"></i>
                                                </a>
                                                <a href="FavorisServlet?action=${p.isFavorite ? 'supprimer' : 'ajouter'}&idProduit=${p.id}&idUser=${userId}&redirect=acceuil2.jsp"
                                                   class="btn btn-sm ${p.isFavorite ? 'btn-danger' : 'btn-outline-danger'}"
                                                   title="${p.isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris'}">
                                                    <i class="fas fa-heart"></i>
                                                </a>
                                            </c:if>

                                          
                                            <c:if test="${role eq 'admin'}">
                                                <a href="edit?id=${p.id}" 
                                                   class="btn btn-warning btn-sm"
                                                   title="Modifier">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="delete?id=${p.id}" 
                                                   class="btn btn-danger btn-sm"
                                                   title="Supprimer"
                                                   onclick="return confirm('Voulez-vous vraiment supprimer ce produit ?');">
                                                    <i class="fas fa-trash-alt"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

 
    <footer class="bg-dark text-white py-3 mt-4">
        <div class="container text-center">
            <p class="mb-0">
                &copy; <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy"/> 
                Gestion des Produits - Tous droits réservés
            </p>
        </div>
    </footer>
    
    

    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
        
        
        document.querySelectorAll('.favorite-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                if (!this.classList.contains('disabled')) {
                    const icon = this.querySelector('i');
                    icon.classList.remove('fa-heart');
                    icon.classList.add('fa-spinner', 'fa-spin');
                    this.classList.add('disabled');
                }
            });
        });

      
        function updateClock() {
            const now = new Date();
            const time = now.toLocaleTimeString('fr-FR', { 
                hour: '2-digit', 
                minute: '2-digit', 
                second: '2-digit',
                hour12: false 
            });
            document.getElementById('clock').textContent = time;
        }

        setInterval(updateClock, 1000);
        updateClock(); // Initialisation immédiate
    });
    </script>
</body>
</html>