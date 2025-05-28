package dao;

import java.sql.SQLException;
import java.util.List;

import entities.Categorie;
import entities.Produit;

public interface IGestionProduit {
	public void addProduct(Produit p) throws SQLException;
	public List<Produit> getAllProducts() throws SQLException;
	public List<Produit> getAllProductsByMC(String mc) throws SQLException;
	public Produit getProduct(int id) throws SQLException;
	public void deleteProduct(int id) throws SQLException;
	public void updateProduct(Produit p) throws SQLException ;
	List<Produit> getAllProductsWithFavorites(int userId) throws SQLException;
	void dissocierProduitsDeCategorie(Categorie categorie);

}
