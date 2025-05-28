package servlets;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.GestionProduitJPA;
import entities.Produit;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private GestionProduitJPA produitDAO = new GestionProduitJPA();

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Produit> cart = (List<Produit>) session.getAttribute("cart");
        List<Integer> quantities = (List<Integer>) session.getAttribute("quantities");

        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        if (quantities == null) {
            quantities = new ArrayList<>();
            session.setAttribute("quantities", quantities);
        }

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            try {
                Produit produit = produitDAO.getProduct(id);
                if (produit != null) {
                    boolean produitExiste = false;
                    for (int i = 0; i < cart.size(); i++) {
                        if (cart.get(i).getId() == id) {
                            // produit déjà présent → incrémenter la quantité
                            int currentQty = quantities.get(i);
                            quantities.set(i, currentQty + 1);
                            produitExiste = true;
                            break;
                        }
                    }
                    if (!produitExiste) {
                        // nouveau produit → ajouter à la liste
                        cart.add(produit);
                        quantities.add(1);
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        else if ("remove".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            for (int i = 0; i < cart.size(); i++) {
                if (cart.get(i).getId() == id) {
                    cart.remove(i);
                    quantities.remove(i);
                    break;
                }
            }
        }
        else if ("clear".equals(action)) {
            cart.clear();
            quantities.clear();
        }

        response.sendRedirect("cart.jsp");
    }

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Produit> cart = (List<Produit>) session.getAttribute("cart");
        List<Integer> quantities = (List<Integer>) session.getAttribute("quantities");

        String action = request.getParameter("action");

        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            int newQuantite = Integer.parseInt(request.getParameter("quantite"));

            for (int i = 0; i < cart.size(); i++) {
                if (cart.get(i).getId() == id) {
                    quantities.set(i, newQuantite);
                    break;
                }
            }

            session.setAttribute("quantities", quantities);
        }

        response.sendRedirect("cart.jsp");
    }
}
