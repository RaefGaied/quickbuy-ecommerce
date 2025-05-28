package dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import entities.Produit;
import entities.User;

public interface IGestionFavoris {

    void ajouterFavoris(User user, Produit produit);

    void supprimerFavoris(User user, Produit produit);

    boolean estDejaFavori(User user, Produit produit);

    int countFavoritesForProduct(int productId);
    boolean isProductFavoriteForUser(int userId, int productId);

    List<Produit> getProduitsFavorisParUser(User user) throws SQLException;

    List<Object[]> getProduitsLesPlusFavoris() throws SQLException; 
    List<User> getUsersByFavoriProduit(int produitId);

	List<Produit> getAllFavorites() throws SQLException;

	Map<Integer, List<User>> getUsersByProducts();

	void close();

}
