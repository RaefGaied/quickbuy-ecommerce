<%@ page import="java.util.List"%>
<%@ page import="entities.Produit"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%@ page import="entities.User" %> 

<%
    HttpSession sessionUser = request.getSession(false);

    User utilisateur = null;
    String username = "Utilisateur";

    if (sessionUser != null) {
        utilisateur = (User) sessionUser.getAttribute("user");
        if (utilisateur != null) {
            username = utilisateur.getUsername(); 
        }
    }

    List<Produit> cart = (List<Produit>) session.getAttribute("cart");
    List<Integer> quantities = (List<Integer>) session.getAttribute("quantities"); 
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon Panier</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background-color: #f1f3f5;
        }

        .page-title {
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .card {
            border: none;
            border-radius: 15px;
            transition: all 0.3s ease;
        }

        .card:hover {
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

        .card-img-top {
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
            height: 200px;
            object-fit: contain;
            background-color: #f8f9fa;
        }

        .btn-primary {
            background-color: #007bff;
            border: none;
        }

        .btn-danger {
            background-color: #e74c3c;
        }

        .btn-success {
            background-color: #2ecc71;
        }

        .btn {
            transition: all 0.2s ease;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .card-title {
            font-weight: 600;
            font-size: 18px;
        }

        .card-text {
            font-size: 15px;
        }

        .form-control {
            font-size: 14px;
        }

        .total-box {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            font-size: 18px;
        }

        @media (max-width: 576px) {
            .page-title {
                font-size: 22px;
                padding: 15px;
            }

            .card-title {
                font-size: 16px;
            }

            .btn {
                font-size: 14px;
            }

            .total-box {
                font-size: 16px;
                padding: 15px;
            }
        }
    </style>
</head>
<body>

<div class="page-title">Votre Panier</div>

<h2 class="text-center mb-4">
    <i class="fas fa-shopping-cart me-2"></i> Panier de <%= username %>
    <% 
        int totalProduits = 0;
        if (quantities != null) {
            for (Integer q : quantities) {
                totalProduits += q;
            }
        }
    %>
    <span class="badge bg-secondary ms-2"><%= totalProduits %> article<%= totalProduits > 1 ? "s" : "" %></span>
</h2>

<div class="container mb-5">
    <% if (cart == null || cart.isEmpty()) { %>
        <div class="alert alert-warning text-center">Votre panier est vide.</div>
    <% } else { 
        double totalPrixGlobal = 0;
    %>
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <% for (int i = 0; i < cart.size(); i++) {
                Produit produit = cart.get(i);
                int quantite = (quantities != null && i < quantities.size()) ? quantities.get(i) : 1;
                double totalProduit = produit.getPrix() * quantite;
                totalPrixGlobal += totalProduit;
            %>
            <div class="col">
                <div class="card h-100 shadow-sm">
                    <img src="<%= request.getContextPath() %>/images/<%= produit.getImage() %>" class="card-img-top" alt="<%= produit.getNom() %>">
                    <div class="card-body">
                        <h5 class="card-title"><%= produit.getNom() %></h5>
                        <p class="card-text">Prix unitaire : <strong><%= produit.getPrix() %> €</strong></p>
                        <p class="card-text">Total : <strong><%= String.format("%.2f", totalProduit) %> €</strong></p>

                        <form action="CartServlet" method="post" class="d-flex flex-column gap-2">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="<%= produit.getId() %>">
                            <input type="number" name="quantite" value="<%= quantite %>" min="1" class="form-control">
                            <button type="submit" class="btn btn-primary">Mettre à jour</button>
                        </form>
                    </div>
                    <div class="card-footer bg-transparent text-center">
                        <a href="CartServlet?action=remove&id=<%= produit.getId() %>" class="btn btn-danger">Supprimer</a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>

        <!-- Totaux -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mt-5 gap-3">
            <div class="total-box">
                <p>Total des articles : <strong><%= totalProduits %></strong></p>
                <p>Prix total : <strong><%= String.format("%.2f", totalPrixGlobal) %> €</strong></p>
            </div>
            <div>
                <a href="CartServlet?action=clear" class="btn btn-danger">Vider le panier</a>
            </div>
        </div>
    <% } %>

    <!-- Bouton retour -->
    <div class="text-center mt-4">
        <a href="acceuil2.jsp" class="btn btn-success px-4 py-2">Continuer vos achats</a>
    </div>
</div>

</body>
</html>
