package servlets;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.GestionCategorieJPA;
import dao.IGestionCategorie;
import entities.Categorie;

@WebServlet(urlPatterns = {"/categories", "/searchCategorie", "/deleteCategorie", "/editCategorie", "/updateCategorie", "/addCategorie"})
public class CategorieController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IGestionCategorie gestion;

    public CategorieController() {
        super();
    }

    public void init(ServletConfig config) throws ServletException {
        gestion = new GestionCategorieJPA();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        try {
            if (path.equals("/categories")) {
                List<Categorie> liste = gestion.getAllCategories();
                request.setAttribute("categories", liste);
                request.getRequestDispatcher("categorie-form.jsp").forward(request, response);
            } 
            else if (path.equals("/searchCategorie")) {
                String mc = request.getParameter("r");
                if (mc != null && !mc.trim().isEmpty()) {
                    List<Categorie> categories = gestion.getAllCategories(); 
                    request.setAttribute("categories", categories);
                }
                request.getRequestDispatcher("categorie-form.jsp").forward(request, response);
            } 
            else if (path.equals("/deleteCategorie")) {
                String id = request.getParameter("id");
                if (id != null && id.matches("\\d+")) {
                    gestion.deleteCategorie(Integer.parseInt(id));
                }
                response.sendRedirect(request.getContextPath() + "/categories");
            } 
            else if (path.equals("/editCategorie")) {
                String id = request.getParameter("id");
                if (id != null && id.matches("\\d+")) {
                    Categorie categorie = gestion.getCategorieById(Integer.parseInt(id));
                    if (categorie != null) {
                        request.setAttribute("categorie", categorie);
                        request.getRequestDispatcher("categorie-form.jsp").forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/categories");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/categories");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors du traitement de la requête.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if (path.equals("/addCategorie")) {
            addCategorie(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void addCategorie(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nom = request.getParameter("nom");
        String idStr = request.getParameter("id");

        if (nom != null && !nom.trim().isEmpty()) {
            Categorie c = new Categorie();
            c.setNom(nom);

            try {
                if (idStr != null && idStr.matches("\\d+") && Integer.parseInt(idStr) != 0) {
                    c.setId(Integer.parseInt(idStr));
                    gestion.updateCategorie(c);
                } else {
                    gestion.addCategorie(c);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors de l'ajout de la catégorie.");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/categories");
    }
}
