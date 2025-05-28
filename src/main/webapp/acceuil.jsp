<%@page import="entities.Produit"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>Liste des Produits</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="icon" href="/assets/favicon.ico">
<style>
body {
	background-color: #f0f4f8;
}

.product-header {
	color: #2e7d32;
	font-weight: bold;
	font-size: 2rem;
}

.table th {
	background-color: #2c3e50;
	color: #ecf0f1;
}

.navbar .navbar-brand img {
	height: 40px;
	margin-right: 8px;
}

.search-bar .form-control {
	width: 180px;
	height: 32px;
	font-size: 14px;
}

.search-bar .btn {
	height: 32px;
	font-size: 14px;
	padding: 4px 10px;
}

.navbar {
	background: linear-gradient(90deg, #1F1F1F, #2C2C2C);
}

.navbar .navbar-brand, .navbar-nav .nav-link {
	color: white !important;
}

.navbar-nav .nav-link:hover {
	background-color: #333 !important;
	color: #f1c40f !important;
}

.navbar-nav .nav-item .nav-link i {
	margin-right: 5px;
}

.navbar .navbar-brand {
	font-size: 1.3rem;
	font-weight: bold;
}

.search-bar .form-control {
	background-color: #333;
	border: 1px solid #555;
	color: white;
}

.search-bar .form-control::placeholder {
	color: #bbb;
}

.search-bar .btn {
	background-color: #f1c40f;
	border-color: #f1c40f;
}

.search-bar .btn:hover {
	background-color: #e6b800;
	border-color: #e6b800;
}
</style>


</head>
<body>

	<nav class="navbar navbar-expand-lg bg-primary shadow-sm px-4">

		<a class="navbar-brand d-flex align-items-center" href="acceuil">
			<!--  <img src="<%= request.getContextPath() %>/images/ventes.png" alt="Logo" style="height: 45px; margin-right: 10px;">-->


			<span class="fw-bold text-primary">Gestion des Produits</span>
		</a>
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
			data-bs-target="#navbarNav">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse justify-content-between"
			id="navbarNav">
			<ul class="navbar-nav">
				<li class="nav-item"><a
					class="nav-link text-dark fw-semibold px-3" href="acceuil"> <i
						class="fas fa-home"></i> Accueil
				</a></li>
				<li class="nav-item"><a
					class="nav-link text-dark fw-semibold px-3" href="product-form.jsp">
						<i class="fas fa-plus-circle"></i> Ajouter Produit
				</a></li>
			</ul>

			<form class="d-flex search-bar" action="search" method="get">
				<input class="form-control rounded-pill me-2" type="search" name="r"
					placeholder="Rechercher un produit" required>
				<button
					class="btn btn-primary rounded-circle d-flex align-items-center justify-content-center"
					type="submit" style="width: 38px; height: 38px;">
					<i class="fas fa-search"></i>
				</button>
			</form>
		</div>
	</nav>



	<div class="container mt-5">
		<h2 class="product-header text-center mb-4">Liste des Produits</h2>

		<% 
      List<Produit> liste = (List<Produit>) request.getAttribute("products"); 
      if (liste == null || liste.isEmpty()) { 
    %>
		<div class="alert alert-warning text-center">Aucun produit
			trouvé.</div>
		<% } else { %>
		<div class="table-responsive">
			<table class="table table-bordered table-hover">
				<thead class="table-dark">
					<tr>
						<th>ID</th>
						<th>Nom</th>
						<th>Prix</th>
						<th>Quantité</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					<% for (Produit p : liste) { %>
					<tr>
						<td><%= p.getId() %></td>
						<td><%= p.getNom() %></td>
						<td><%= p.getPrix() %> €</td>
						<td><%= p.getQuantite() %></td>
						<td><a href="edit?id=<%= p.getId() %>"
							class="btn btn-sm btn-warning"> <i class="fas fa-edit"></i>
								Modifier
						</a> <a href="delete?id=<%= p.getId() %>"
							class="btn btn-sm btn-danger"
							onclick="return confirm('Voulez-vous vraiment supprimer ce produit ?');">
								<i class="fas fa-trash"></i> Supprimer
						</a></td>
					</tr>
					<% } %>
				</tbody>
			</table>
		</div>
		<% } %>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
