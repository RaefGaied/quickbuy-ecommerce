package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.GestionProduit;
import dao.IGestionProduit;
import entities.Produit;

/**
 * Servlet implementation class FirstServlet
 */
@WebServlet("/index.php")
public class FirstServlet extends HttpServlet  {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public FirstServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

     IGestionProduit gestion;
	/**
	 * @see Servlet#init(ServletConfig)
	 */
	@Override
	public void init(ServletConfig config) throws ServletException {
		try {
			gestion = new GestionProduit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			List<Produit> liste = gestion.getAllProducts ();
			PrintWriter out = response.getWriter();
			out.println("<html><head><title>Liste des Produits</title></head><body>");
            out.println("<h2>Liste des Produits</h2>");
            out.println("<table border='1'><tr><th>ID</th><th>Nom</th><th>Prix</th><th>Quantité</th></tr>");

            for (Produit p : liste) {
                out.println("<tr><td>" + p.getId() + "</td><td>" + p.getNom() + "</td><td>" +
                            p.getPrix() + "</td><td>" + p.getQuantite() + "</td></tr>");
            }

            out.println("</table>");
            out.println("</body></html>");
		} catch (SQLException e) {

			e.printStackTrace();
		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
