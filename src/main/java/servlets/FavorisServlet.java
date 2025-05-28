package servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.GestionFavorisJPA;
import dao.GestionProduitJPA;
import dao.UserDAO;
import entities.Produit;
import entities.User;

@WebServlet(name = "FavorisServlet", urlPatterns = {"/favoris", "/FavorisServlet"})
public class FavorisServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private transient GestionFavorisJPA gestionFavoris;
    private transient GestionProduitJPA gestionProduit;
    private transient UserDAO userDAO;

    // Constantes pour les attributs de session
    private static final String HISTORIQUE_ATTRIBUTE = "favorisHistory";
    private static final String MESSAGE_ATTRIBUTE = "message";
    private static final String ERROR_ATTRIBUTE = "error";

    @Override
    public void init() throws ServletException {
        gestionFavoris = new GestionFavorisJPA();
        gestionProduit = new GestionProduitJPA();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if (action != null) {
            handleFavoriteAction(request, response, user, action);
            return;
        }

        displayFavorites(request, response, user);
    }

    private void handleFavoriteAction(HttpServletRequest request, HttpServletResponse response,
                                    User user, String action) throws IOException {
        String idProduitStr = request.getParameter("idProduit");
        HttpSession session = request.getSession();

        try {
            validateParameters(idProduitStr, action);

            int idProduit = Integer.parseInt(idProduitStr);
            Produit produit = gestionProduit.getProduct(idProduit);
            validateProduct(produit);

            processFavoriteAction(user, produit, action, session);

        } catch (NumberFormatException e) {
            session.setAttribute(ERROR_ATTRIBUTE, "ID produit invalide");
        } catch (IllegalArgumentException e) {
            session.setAttribute(ERROR_ATTRIBUTE, e.getMessage());
        } catch (Exception e) {
            log("Erreur lors de la gestion des favoris", e);
            session.setAttribute(ERROR_ATTRIBUTE, "Erreur lors de la gestion des favoris: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/favoris");
    }

    private void validateParameters(String idProduitStr, String action) {
        if (idProduitStr == null || idProduitStr.isEmpty()) {
            throw new IllegalArgumentException("ID produit manquant");
        }
        if (!"ajouter".equals(action) && !"supprimer".equals(action)) {
            throw new IllegalArgumentException("Action non reconnue");
        }
    }

    private void validateProduct(Produit produit) {
        if (produit == null) {
            throw new IllegalArgumentException("Produit introuvable");
        }
    }

    private void processFavoriteAction(User user, Produit produit, String action, HttpSession session) {
        String message = null;
        
        if ("ajouter".equals(action)) {
            if (!gestionFavoris.estDejaFavori(user, produit)) {
                gestionFavoris.ajouterFavoris(user, produit);
                message = "Le produit a été ajouté à vos favoris";
                addToHistory(session, user, produit, "AJOUT");
            }
        } else {
            gestionFavoris.supprimerFavoris(user, produit);
            message = "Le produit a été retiré de vos favoris";
            addToHistory(session, user, produit, "SUPPRESSION");
        }

        if (message != null) {
            session.setAttribute(MESSAGE_ATTRIBUTE, message);
        }
    }

    private void displayFavorites(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String targetPage = "/favoris-user.jsp";

        try {
            if (isAdmin(user)) {
                setupAdminView(request, user);
                targetPage = "/favoris-admin.jsp";
            } else {
                setupUserView(request, user);
            }
        } catch (Exception e) {
            log("Erreur lors de la récupération des favoris", e);
            request.setAttribute(ERROR_ATTRIBUTE, "Erreur lors de la récupération des favoris: " + e.getMessage());
        }

        request.getRequestDispatcher(targetPage).forward(request, response);
    }

    private boolean isAdmin(User user) {
        return user.getRole() != null && "ADMIN".equalsIgnoreCase(user.getRole().toString());
    }

    private void setupAdminView(HttpServletRequest request, User user) throws Exception {
        List<Produit> tousFavoris = gestionFavoris.getAllFavorites();
        Map<Integer, List<User>> usersParProduit = gestionFavoris.getUsersByProducts();
        List<Object[]> topProduits = gestionFavoris.getProduitsLesPlusFavoris();

        int maxFavoris = calculateMaxFavorites(topProduits);

        request.setAttribute("produitsFavoris", tousFavoris);
        request.setAttribute("usersParProduit", usersParProduit);
        request.setAttribute("topProduits", topProduits);
        request.setAttribute("maxFavoris", maxFavoris);

        loadHistory(request);
    }

    private int calculateMaxFavorites(List<Object[]> topProduits) {
        int maxFavoris = 1;
        for (Object[] entry : topProduits) {
            int count = ((Number)entry[1]).intValue();
            if (count > maxFavoris) {
                maxFavoris = count;
            }
        }
        return maxFavoris;
    }

    private void loadHistory(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            List<Map<String, Object>> history = getHistory(session);
            if (history != null) {
                request.setAttribute("historiqueActions", history);
                log("[DEBUG] Historique chargé avec " + history.size() + " entrées");
            } else {
                log("[DEBUG] Historique est null");
            }
        } else {
            log("[DEBUG] Session est null");
        }
    }

    private void setupUserView(HttpServletRequest request, User user) throws Exception {
        List<Produit> favoris = gestionFavoris.getProduitsFavorisParUser(user);
        request.setAttribute("favoris", favoris);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if ("clearHistory".equals(request.getParameter("action"))) {
            session.removeAttribute(HISTORIQUE_ATTRIBUTE);
            session.setAttribute(MESSAGE_ATTRIBUTE, "L'historique a été effacé");
        }
        response.sendRedirect(request.getContextPath() + "/favoris");
    }

    @Override
    public void destroy() {
        try {
            if (gestionFavoris != null) {
                gestionFavoris.close();
            }
            if (gestionProduit != null) {
                gestionProduit.close();
            }
        } catch (Exception e) {
            getServletContext().log("Erreur lors de la fermeture des ressources", e);
        }
    }

    private void addToHistory(HttpSession session, User user, Produit produit, String actionType) {
        if (session == null) {
            log("[ERROR] Session est null dans addToHistory");
            return;
        }

        List<Map<String, Object>> history = getHistory(session);
        Map<String, Object> entry = createHistoryEntry(user, produit, actionType);

        manageHistorySize(history);
        history.add(0, entry);
        
        log("[DEBUG] Entrée ajoutée à l'historique: " + entry);
    }

    private Map<String, Object> createHistoryEntry(User user, Produit produit, String actionType) {
        Map<String, Object> entry = new HashMap<String, Object>();
        entry.put("produit", createDetachedProduit(produit));
        entry.put("user", createDetachedUser(user));
        entry.put("action", actionType);
        entry.put("date", new Date());
        return entry;
    }

    private Produit createDetachedProduit(Produit original) {
        Produit detached = new Produit();
        detached.setId(original.getId());
        detached.setNom(original.getNom());
        detached.setPrix(original.getPrix());
        detached.setImage(original.getImage());
        return detached;
    }

    private User createDetachedUser(User original) {
        User detached = new User();
        detached.setId(original.getId());
        detached.setUsername(original.getUsername());
        detached.setEmail(original.getEmail());
        detached.setRole(original.getRole());
        return detached;
    }

    private void manageHistorySize(List<Map<String, Object>> history) {
        if (history.size() >= 50) {
            history.remove(history.size() - 1);
        }
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> getHistory(HttpSession session) {
        List<Map<String, Object>> history = (List<Map<String, Object>>) session.getAttribute(HISTORIQUE_ATTRIBUTE);
        if (history == null) {
            history = new ArrayList<Map<String, Object>>();
            session.setAttribute(HISTORIQUE_ATTRIBUTE, history);
            log("[DEBUG] Nouvel historique créé");
        }
        return history;
    }
}