<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, entities.Categorie" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Catégories</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="icon" href="/assets/favicon.ico">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7fc;
            color: #333;
        }
        .navbar {
            background-color: #00bcd4;
        }
        .navbar-brand {
            font-weight: bold;
            color: #fff;
        }
        .navbar .nav-link {
            color: #fff;
            font-weight: 500;
        }
        .navbar .nav-link:hover {
            color: #ffeb3b;
        }
        .container {
            margin-top: 50px;
        }
        .card {
            background: #ffffff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .form-control {
            border-radius: 8px;
            padding: 10px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .btn-primary {
            background-color: #00bcd4;
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            color: white;
            font-weight: bold;
        }
        .btn-primary:hover {
            background-color: #0097a7;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
        }
        table th, table td {
            text-align: center;
            padding: 12px;
        }
        table th {
            background-color: #00bcd4;
            color: white;
        }
        table td {
            background-color: #f4f7fc;
        }
        .btn-danger {
            background-color: #ff4d4d;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            color: white;
        }
        .btn-danger:hover {
            background-color: #e53935;
        }
        .btn-link {
            text-decoration: none;
            color: #ffeb3b;
        }
        .btn-link:hover {
            color: #ff7043;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg shadow-sm px-4">
    <a class="navbar-brand d-flex align-items-center" href="categories">
        Gestion des Catégories
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-between" id="navbarNav">
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link fw-semibold px-3" href="acceuil2">
                    <i class="fas fa-home"></i> Accueil
                </a>
            </li>
        </ul>
    </div>
</nav>

<div class="container">
    <div class="card">
        <h2 class="text-center mb-4">Ajouter une Catégorie</h2>
        <form action="addCategorie" method="post">
            <div class="form-group">
                <label for="nom">Nom de la Catégorie :</label>
                <input type="text" id="nom" name="nom" class="form-control" required placeholder="Entrez le nom de la catégorie">
            </div>
            <button type="submit" class="btn btn-primary w-100">Ajouter</button>
        </form>
    </div>

    <hr class="my-5">

    <h2 class="text-center mb-4">Liste des Catégories</h2>

    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Categorie> categories = (List<Categorie>) request.getAttribute("categories");
                if (categories != null && !categories.isEmpty()) {
                    for (Categorie cat : categories) {
            %>
                        <tr>
                            <td><%= cat.getId() %></td>
                            <td><%= cat.getNom() %></td>
                            <td>
                                <a href="deleteCategorie?id=<%= cat.getId() %>" class="btn btn-danger btn-link" onclick="return confirm('Voulez-vous vraiment supprimer cette catégorie ?');">
                                    Supprimer
                                </a>
                            </td>
                        </tr>
            <%
                    }
                } else {
            %>
                    <tr>
                        <td colspan="3" class="text-center">Aucune catégorie trouvée.</td>
                    </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
