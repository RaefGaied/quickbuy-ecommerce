<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>Gestion des Produits</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
body {
	font-family: 'Poppins', sans-serif;
	background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
	color: white;
	margin: 0;
	min-height: 100vh;
	display: flex;
	flex-direction: column;
}
.navbar {
	background: rgba(255, 255, 255, 0.05);
	backdrop-filter: blur(8px);
	box-shadow: 0 0 15px rgba(0, 255, 255, 0.1);
}
.navbar .navbar-brand {
	color: #00e6e6;
	font-weight: bold;
	text-transform: uppercase;
	font-size: 22px;
}
.navbar .nav-link {
	color: #ffffff !important;
	transition: 0.3s ease-in-out;
}
.navbar .nav-link:hover {
	color: #00ffff !important;
}
.form-wrapper {
	flex: 1;
	display: flex;
	justify-content: center;
	align-items: center;
	padding-top: 80px;
}
.card-glass {
	background: rgba(255, 255, 255, 0.1);
	border-radius: 20px;
	padding: 35px;
	backdrop-filter: blur(20px);
	box-shadow: 0 8px 32px rgba(0, 255, 255, 0.3);
	width: 100%;
	max-width: 550px;
	animation: fadeIn 1s ease;
}
.card-glass h2 {
	color: #00ffff;
	font-size: 26px;
	font-weight: 600;
	margin-bottom: 25px;
	text-align: center;
}
label {
	font-weight: 500;
	color: #ffffff;
}
input, textarea, select {
	background: rgba(255, 255, 255, 0.2);
	border: 1px solid rgba(255, 255, 255, 0.3);
	border-radius: 10px;
	padding: 10px;
	color: #fff;
	width: 100%;
}
input:focus, textarea:focus, select:focus {
	background: rgba(0, 255, 255, 0.1);
	border-color: #00ffff;
	box-shadow: 0 0 10px #00ffff;
}
.btn-neon {
	border: none;
	padding: 12px 25px;
	border-radius: 8px;
	font-weight: bold;
	text-transform: uppercase;
	color: white;
	background: linear-gradient(90deg, #00ffff, #00e6e6);
	box-shadow: 0 0 15px rgba(0, 255, 255, 0.6);
	transition: 0.3s;
}
.btn-neon:hover {
	background: linear-gradient(90deg, #00e6e6, #00ffff);
	box-shadow: 0 0 25px rgba(0, 255, 255, 0.9);
}
.btn-red {
	background: linear-gradient(90deg, #ff4d4d, #ff0000);
	box-shadow: 0 0 15px rgba(255, 0, 0, 0.6);
}
.btn-red:hover {
	box-shadow: 0 0 25px rgba(255, 0, 0, 0.9);
}
img.preview-img {
	max-height: 200px;
	border-radius: 10px;
	margin-bottom: 20px;
	box-shadow: 0 0 10px rgba(255, 255, 255, 0.3);
}
@keyframes fadeIn {
	from { opacity: 0; transform: translateY(20px); }
	to { opacity: 1; transform: translateY(0); }
}
</style>
</head>

<body>

<nav class="navbar navbar-expand-lg fixed-top px-4">
	<div class="container-fluid">
		<a class="navbar-brand" href="acceuil2">
			<i class="fas fa-box"></i> Gestion des Produits
		</a>
		<div class="collapse navbar-collapse justify-content-end">
			<ul class="navbar-nav">
				<li class="nav-item">
					<a class="nav-link" href="acceuil2">
						<i class="fas fa-home"></i> Accueil
					</a>
				</li>
			</ul>
		</div>
	</div>
</nav>

<div class="form-wrapper">
	<div class="card-glass">
		<h2>Ajout / Modification d'un Produit</h2>

		<form method="post" action="${empty produit ? 'add' : 'update'}" enctype="multipart/form-data">
			<c:if test="${not empty produit}">
				<input type="hidden" name="id" value="${produit.id}">
			</c:if>

			<div class="mb-3">
				<label for="nom" class="form-label">Nom du produit</label>
				<input type="text" class="form-control" id="nom" name="nom" value="${produit.nom}" required>
			</div>

			<div class="mb-3">
				<label for="prix" class="form-label">Prix (€)</label>
				<input type="number" step="0.01" min="0" class="form-control" id="prix" name="prix" value="${produit.prix}" required>
			</div>

			<div class="mb-3">
				<label for="quantite" class="form-label">Quantité</label>
				<input type="number" min="0" class="form-control" id="quantite" name="quantite" value="${produit.quantite}" required>
			</div>

			<div class="mb-3">
				<label for="categorie" class="form-label">Catégorie</label>
				<select class="form-control" id="categorie" name="categorie" required>
					<option value="" disabled selected>Sélectionner une catégorie</option>
					<c:forEach var="categorie" items="${categories}">
						<option value="${categorie.id}" ${produit.categorie != null && produit.categorie.id == categorie.id ? 'selected' : ''}>
							${categorie.nom}
						</option>
					</c:forEach>
				</select>
			</div>

			<div class="mb-3">
				<label for="image" class="form-label">Image du produit</label>
				<input type="file" class="form-control" id="image" name="image" accept="image/*">
			</div>

			<c:if test="${not empty produit.image}">
				<div class="text-center">
					<img src="images/${produit.image}" alt="Image du produit" class="preview-img img-fluid" />
				</div>
			</c:if>

			<div class="d-flex justify-content-between mt-4">
				<button type="submit" class="btn-neon">
					<i class="bi bi-save"></i>
					${empty produit ? 'Ajouter' : 'Mettre à jour'}
				</button>
				<a href="acceuil2" class="btn-neon btn-red">
					<i class="bi bi-x-circle"></i> Annuler
				</a>
			</div>
		</form>

	</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
