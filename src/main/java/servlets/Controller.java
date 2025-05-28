package servlets;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import dao.GestionCategorieJPA;
import dao.GestionFavorisJPA;
import dao.GestionProduitJPA;
import dao.IGestionProduit;
import entities.Categorie;
import entities.Produit;

@WebServlet(urlPatterns = {"/", "/acceuil2", "/search", "/delete", "/edit", "/update", "/add"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50)
public class Controller extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IGestionProduit gestion;
    private GestionFavorisJPA gestionFavoris;
    private GestionCategorieJPA  gestionCategorie;

    public Controller() {
        super();
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        gestion = new GestionProduitJPA();
        gestionFavoris = new GestionFavorisJPA();
        gestionCategorie = new GestionCategorieJPA();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        try {
            if (path.equals("/")) {
                response.sendRedirect(request.getContextPath() + "/welcome.jsp");
            } else if (path.equals("/acceuil2")) {
                Integer userId = (Integer) request.getSession().getAttribute("userId");
                List<Produit> liste = gestion.getAllProductsWithFavorites(userId != null ? userId : 0);
                request.setAttribute("products", liste);
                request.getRequestDispatcher("acceuil2.jsp").forward(request, response);
            } else if (path.equals("/search")) {
                String mc = request.getParameter("r");
                if (mc != null && !mc.trim().isEmpty()) {
                    List<Produit> produits = gestion.getAllProductsByMC(mc);
                    Integer userId = (Integer) request.getSession().getAttribute("userId");
                    if (userId != null) {
                        for (Produit p : produits) {
                            int favCount = gestionFavoris.countFavoritesForProduct(p.getId());
                            boolean isFav = gestionFavoris.isProductFavoriteForUser(userId, p.getId());
                            p.setFavoriteCount(favCount);
                            p.setIsFavorite(isFav);
                        }
                    }
                    request.setAttribute("products", produits);
                }
                request.getRequestDispatcher("acceuil2.jsp").forward(request, response);
            } else if (path.equals("/delete")) {
                String id = request.getParameter("id");
                if (id != null && id.matches("\\d+")) {
                    gestion.deleteProduct(Integer.parseInt(id));
                }
                response.sendRedirect(request.getContextPath() + "/acceuil2");
            } else if (path.equals("/edit")) {
                String id = request.getParameter("id");
                if (id != null && id.matches("\\d+")) {
                    Produit produit = gestion.getProduct(Integer.parseInt(id));
                    if (produit != null) {
                        request.setAttribute("produit", produit);
                        request.setAttribute("categories", gestionCategorie.getAllCategories());
                        request.getRequestDispatcher("product-form2.jsp").forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/acceuil2");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/acceuil2");
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

        if (path.equals("/add")) {
            try {
				addProduct(request, response);
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        } else if (path.equals("/update")) {
            updateProduct(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        String nom = request.getParameter("nom");
        String prixStr = request.getParameter("prix");
        String quantiteStr = request.getParameter("quantite");
        String categorieIdStr = request.getParameter("categorie");

        if (nom != null && !nom.trim().isEmpty() &&
            prixStr.matches("\\d+(\\.\\d+)?") &&
            quantiteStr.matches("\\d+") &&
            categorieIdStr != null && categorieIdStr.matches("\\d+")) {

            double prix = Double.parseDouble(prixStr);
            int quantite = Integer.parseInt(quantiteStr);
            int categorieId = Integer.parseInt(categorieIdStr);

            Produit p = new Produit(0, nom, prix, quantite);

            Categorie c = gestionCategorie.getCategorieById(categorieId);
            p.setCategorie(c);

            handleImageUpload(request, p);

            try {
                gestion.addProduct(p);
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors de l'ajout du produit.");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/acceuil2");
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String nom = request.getParameter("nom");
        String prixStr = request.getParameter("prix");
        String quantiteStr = request.getParameter("quantite");
        String categorieIdStr = request.getParameter("categorie");

        if (idStr != null && idStr.matches("\\d+") &&
            nom != null && !nom.trim().isEmpty() &&
            prixStr.matches("\\d+(\\.\\d+)?") &&
            quantiteStr.matches("\\d+") &&
            categorieIdStr != null && categorieIdStr.matches("\\d+")) {

            try {
                int id = Integer.parseInt(idStr);
                double prix = Double.parseDouble(prixStr);
                int quantite = Integer.parseInt(quantiteStr);
                int categorieId = Integer.parseInt(categorieIdStr);

                Produit p = gestion.getProduct(id);
                if (p != null) {
                    p.setNom(nom);
                    p.setPrix(prix);
                    p.setQuantite(quantite);

                    Categorie c = gestionCategorie.getCategorieById(categorieId);
                    p.setCategorie(c);

                    handleImageUpload(request, p);
                    gestion.updateProduct(p);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors de la mise à jour du produit.");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/acceuil2");
    }

    private void handleImageUpload(HttpServletRequest request, Produit p)
            throws IOException, ServletException {
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String webappRoot = request.getServletContext().getRealPath("/");
            String uploadPath = webappRoot + "assets" + File.separator + "images";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String fileName = System.currentTimeMillis() + "_" + extractFileName(filePart);
            filePart.write(uploadPath + File.separator + fileName);
            p.setImage(fileName);

            String srcPath = request.getServletContext().getRealPath("/") + "../../src/main/webapp/assets/images/";
            File srcDir = new File(srcPath);
            if (srcDir.exists()) {
                Files.copy(
                    Paths.get(uploadPath + File.separator + fileName),
                    Paths.get(srcPath + fileName),
                    StandardCopyOption.REPLACE_EXISTING
                );
            }
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1).replace(" ", "_");
            }
        }
        return "unknown_" + System.currentTimeMillis();
    }
}
