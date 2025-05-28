package servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.IUserDAO;
import dao.UserDAO;
import entities.Role;
import entities.User;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserDAO userDAO = new UserDAO(); // Utilisation de l'interface

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Vérifier si les mots de passe correspondent
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas !");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Vérifier si l'utilisateur ou l'email existe déjà
        if (userDAO.getUserByUsername(username) != null) {
            request.setAttribute("error", "Nom d'utilisateur déjà pris !");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (userDAO.getUserByEmail(email) != null) {
            request.setAttribute("error", "Email déjà utilisé !");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Créer un nouvel utilisateur
        User user = new User(username, email, password, Role.USER);
        userDAO.saveUser(user);

        // Redirection vers la page de connexion après inscription réussie
        response.sendRedirect("login.jsp");
    }

    @Override
    public void destroy() {
        UserDAO.close();
    }
}
