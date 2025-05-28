package servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UserDAO;
import entities.User;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ProfileServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (!user.isActive()) {
            session.invalidate();
            request.setAttribute("error", "Votre compte est désactivé.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (user.getRole().name().equals("ADMIN")) {
            // Si c'est un admin, récupérer tous les utilisateurs
            UserDAO dao = new UserDAO();
            List<User> userList = dao.getAllUsers();
            request.setAttribute("userList", userList);
        } else {
            // Sinon afficher son profil personnel
            request.setAttribute("user", user);
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
