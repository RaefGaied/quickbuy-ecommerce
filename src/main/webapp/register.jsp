<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>Inscription</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
<style>
    body {
        margin: 0;
        padding: 0;
        font-family: 'Roboto', sans-serif;
        height: 100vh;
        background: linear-gradient(120deg, #0f2027, #203a43, #2c5364);
        display: flex;
        justify-content: center;
        align-items: center;
        color: white;
    }

    .register-card {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 20px;
        padding: 40px;
        width: 100%;
        max-width: 450px;
        backdrop-filter: blur(15px);
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
    }

    .register-card h2 {
        text-align: center;
        margin-bottom: 30px;
        font-weight: 700;
        color: white;
    }

    .form-control {
        background: rgba(255, 255, 255, 0.1);
        border: none;
        color: white;
        border-radius: 12px;
        padding-left: 40px;
    }

    .form-control:focus {
        background: rgba(255, 255, 255, 0.15);
        box-shadow: 0 0 12px rgba(0, 191, 255, 0.7);
        color: white;
    }

    .input-group {
        position: relative;
    }

    .input-group i {
        position: absolute;
        top: 50%;
        left: 15px;
        transform: translateY(-50%);
        color: rgba(255, 255, 255, 0.7);
        font-size: 16px;
    }

    .btn-register {
        background: linear-gradient(90deg, #00c6ff, #0072ff);
        border: none;
        color: white;
        font-weight: 600;
        border-radius: 12px;
        transition: all 0.3s ease;
    }

    .btn-register:hover {
        background: linear-gradient(90deg, #0072ff, #00c6ff);
        box-shadow: 0 0 15px rgba(0, 191, 255, 0.8);
    }

    .already-account {
        margin-top: 15px;
        text-align: center;
        color: rgba(255, 255, 255, 0.8);
    }

    .already-account a {
        color: #00c6ff;
        text-decoration: none;
        font-weight: 500;
    }

    .already-account a:hover {
        text-decoration: underline;
    }

    .alert {
        background-color: rgba(255, 0, 0, 0.2);
        border: none;
        color: #ff4d4d;
        border-radius: 10px;
        padding: 10px;
        text-align: center;
        font-size: 0.9rem;
    }
</style>
</head>
<body>

<div class="register-card">
    <h2><i class="fas fa-user-plus me-2"></i>Créer un Compte</h2>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert">
        <i class="fas fa-exclamation-triangle me-1"></i> <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form action="RegisterServlet" method="post">
        <div class="mb-3 input-group">
            <i class="fas fa-user"></i>
            <input type="text" class="form-control" id="username" name="username" placeholder="Nom d'utilisateur" required>
        </div>

        <div class="mb-3 input-group">
            <i class="fas fa-envelope"></i>
            <input type="email" class="form-control" id="email" name="email" placeholder="Email" required>
        </div>

        <div class="mb-3 input-group">
            <i class="fas fa-lock"></i>
            <input type="password" class="form-control" id="password" name="password" placeholder="Mot de passe" required>
        </div>

        <div class="mb-3 input-group">
            <i class="fas fa-lock"></i>
            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirmer le mot de passe" required>
        </div>

        <button type="submit" class="btn btn-register w-100 mt-3">
            <i class="fas fa-user-check me-2"></i>S'inscrire
        </button>
    </form>

    <p class="already-account">
        Déjà un compte ? <a href="login.jsp"><i class="fas fa-sign-in-alt me-1"></i> Se connecter</a>
    </p>
</div>

</body>
</html>
