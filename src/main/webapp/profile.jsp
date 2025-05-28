<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entities.User" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Profil Utilisateur</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Gestion Utilisateurs</a>
        <a class="btn btn-outline-light" href="acceuil2.jsp"><i class="fas fa-arrow-left"></i> Retour</a>
    </div>
</nav>

<div class="container mt-5">
<%
    User currentUser = (User) session.getAttribute("user");
    List<User> userList = (List<User>) request.getAttribute("userList");  // Correction ici

    if (currentUser != null && currentUser.getRole().toString().equals("ADMIN")) {
%>
    <h3 class="mb-4">Liste des Comptes Utilisateurs</h3>
    <table class="table table-hover table-bordered shadow-sm">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Nom d'utilisateur</th>
                <th>Email</th>
                <th>Rôle</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <% 
            if (userList != null) {
                for(User u : userList) { 
        %>
            <tr>
                <td><%= u.getId() %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getRole() %></td>
                <td>
                    <% if (u.isActive()) { %>
                        <span class="badge bg-success">Actif</span>
                    <% } else { %>
                        <span class="badge bg-secondary">Inactif</span>
                    <% } %>
                </td>
                <td>
                    <a href="UserServlet?action=toggleStatus&id=<%= u.getId() %>" class="btn btn-sm btn-warning me-2">
                        <i class="fas fa-sync-alt"></i> Activer/Désactiver
                    </a>
                    <a href="UserServlet?action=delete&id=<%= u.getId() %>" class="btn btn-sm btn-danger"
                       onclick="return confirm('Confirmer la suppression de ce compte ?');">
                        <i class="fas fa-trash-alt"></i> Supprimer
                    </a>
                </td>
            </tr>
        <% 
                } 
            } else { 
        %>
            <tr>
                <td colspan="6" class="text-center text-muted">Aucun utilisateur trouvé.</td>
            </tr>
        <% } %>
        </tbody>
    </table>
<%
    } else if (currentUser != null) {
%>
    <h3 class="mb-4">Mon Profil</h3>
    <div class="card shadow-sm">
        <div class="card-body">
            <h5 class="card-title"><i class="fas fa-user"></i> <%= currentUser.getUsername() %></h5>
            <p class="card-text"><strong>Email :</strong> <%= currentUser.getEmail() %></p>
            <p class="card-text"><strong>Rôle :</strong> <%= currentUser.getRole() %></p>
            <p class="card-text">
                <strong>Statut :</strong>
                <% if (currentUser.isActive()) { %>
                    <span class="badge bg-success">Actif</span>
                <% } else { %>
                    <span class="badge bg-secondary">Inactif</span>
                <% } %>
            </p>
        </div>
    </div>
<%
    } else {
%>
    <div class="alert alert-danger">Aucun utilisateur connecté !</div>
<%
    }
%>
</div>

</body>
</html>
