package servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import dao.UserDAO;
import entities.Role;
import entities.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Input validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=2");
            return;
        }

        HttpSession session = request.getSession();

        try {
            // Handle admin login
            if ("admin".equals(username) && "admin".equals(password)) {
                // Créer un objet User pour admin (ici, on ne va pas chercher en base)
                User adminUser = new User("admin", "admin@example.com", "admin", Role.ADMIN);
                session.setAttribute("user", adminUser);
                session.setAttribute("role", "admin");
                session.setAttribute("userId", adminUser.getId());
                response.sendRedirect("acceuil2.jsp");
                return;
            }

            // Handle regular user login
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserByUsername(username);

            if (user != null && verifyPassword(password, user, userDAO)) {
                // Stocke l'objet User complet dans la session
                session.setAttribute("user", user);
                session.setAttribute("role", user.getRole() != null ? user.getRole().toString() : "user");
                session.setAttribute("userId", user.getId());

                response.sendRedirect("acceuil2.jsp");
            } else {
                response.sendRedirect("login.jsp?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=3");
        }
    }

    private boolean verifyPassword(String inputPassword, User user, UserDAO userDAO) {
        String storedHash = user.getPassword();

        // Case 1: Password is BCrypt hashed
        if (storedHash.startsWith("$2a$")) {
            return BCrypt.checkpw(inputPassword, storedHash);
        }

        // Case 2: Password is in plaintext (legacy)
        if (inputPassword.equals(storedHash)) {
            // Upgrade to BCrypt
            String newHash = BCrypt.hashpw(inputPassword, BCrypt.gensalt());
            user.setPassword(newHash);
            userDAO.updateUser(user);
            return true;
        }

        return false;
    }
}
