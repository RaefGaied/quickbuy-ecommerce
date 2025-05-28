<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="entities.Produit"%>
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>Ajouter ou modifier un produit</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
	crossorigin="anonymous"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="icon" href="/assets/favicon.ico">
<style>
body {
	background-color: #f0f4f8;
}

.card {
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	border-radius: 10px;
}

.btn-primary:hover {
	background-color: #0056b3;
}

.btn-danger:hover {
	background-color: #a71d2a;
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
</style>
</head>
<body>

	<nav class="navbar navbar-expand-lg bg-primary shadow-sm px-4">
		<a class="navbar-brand d-flex align-items-center text-white"
			href="acceuil"> <!--  <img src="/META-INF/ventes.png" alt="Logo" style="height: 45px; margin-right: 10px;">-->
			<span class="fw-bold">Gestion des Produits</span>
		</a>
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
			data-bs-target="#navbarNav">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse justify-content-between"
			id="navbarNav">
			<ul class="navbar-nav">
				<li class="nav-item"><a
					class="nav-link text-white fw-semibold px-3" href="acceuil"> <i
						class="fas fa-home"></i> Accueil
				</a></li>
			</ul>
		</div>
	</nav>


	<div
		class="container d-flex justify-content-center align-items-center mt-5">
		<div class="card p-4" style="width: 50%;">
			<h2 class="text-center text-primary">Ajout ou modification d'un
				produit</h2>
			<% Produit produit = (Produit) request.getAttribute("produit"); %>
			<form method="post" action="add">
				<% if (produit != null) { %>
				<input type="hidden" name="id" value="<%= produit.getId() %>">
				<% } %>
				<div class="mb-3">
					<label for="nom" class="form-label">Nom du produit</label> <input
						type="text" class="form-control" id="nom" name="nom"
						value="<%= (produit != null) ? produit.getNom() : "" %>" required>
				</div>
				<div class="mb-3">
					<label for="prix" class="form-label">Prix</label> <input
						type="number" step="0.01" class="form-control" id="prix"
						name="prix"
						value="<%= (produit != null) ? produit.getPrix() : "" %>" required>


				</div>
				<div class="mb-3">
					<label for="quantite" class="form-label">Quantité</label> <input
						type="number" class="form-control" id="quantite" name="quantite"
						value="<%= (produit != null) ? produit.getQuantite() : "" %>"
						required>

				</div>
				<div class="d-flex justify-content-between">
					<button type="submit" class="btn btn-primary px-4">
						<i class="fas fa-save"></i>
						<%= (produit != null) ? "Mettre à jour" : "Ajouter" %>
					</button>
					<a href="acceuil" class="btn btn-danger px-4"> <i
						class="fas fa-times"></i> Annuler
					</a>
				</div>
			</form>
		</div>
	</div>

</body>
</html>
