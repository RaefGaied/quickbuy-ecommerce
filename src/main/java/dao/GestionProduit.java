package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import entities.Categorie;
import entities.Produit;

public class GestionProduit implements IGestionProduit {

	private Connection connection;

	public GestionProduit() throws SQLException
	{
		connection=SingletonConnection.getInstance();
	}

	@Override
	public void addProduct(Produit p) throws SQLException {
		PreparedStatement ps = connection.prepareStatement("insert into produit (nom, prix, quantite) values (?, ?, ?)");
			ps.setString(1, p.getNom());
			ps.setDouble(2, p.getPrix());
			ps.setInt(3, p.getQuantite());
			ps.executeUpdate();
	}

	@Override
	public List<Produit> getAllProducts() throws SQLException   {
		List<Produit> produits = new ArrayList<>();
        PreparedStatement st = connection.prepareStatement("select * from produit");
        ResultSet rs = st.executeQuery();
            while (rs.next()) {
                produits.add(new Produit(rs.getInt(1), rs.getString(2), rs.getDouble(3), rs.getInt(4)));}


        return produits;
	}

	@Override
	public List<Produit> getAllProductsByMC(String mc) throws SQLException  {
		   List<Produit> produits = new ArrayList<>();
	        PreparedStatement ps = connection.prepareStatement("select * from produit where nom like ?");
	            ps.setString(1, "%" + mc + "%");
	            ResultSet rs = ps.executeQuery();
	            while (rs.next()) {
	                    produits.add(new Produit(rs.getInt("id"), rs.getString("nom"), rs.getDouble("prix"), rs.getInt("quantite")));
	        }
	        return produits;
	}

	@Override
	public Produit getProduct(int id) throws SQLException  {

        PreparedStatement ps = connection.prepareStatement("select * from produit where id = ?") ;
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                    return new Produit(rs.getInt("id"), rs.getString("nom"), rs.getDouble("prix"), rs.getInt("quantite"));
                }


        return null;
	}

	@Override
	public void deleteProduct(int id) throws SQLException  {

	       PreparedStatement ps = connection.prepareStatement("delete from produit where id = ?");
	            ps.setInt(1, id);
	            ps.executeUpdate();


	}

	@Override
	public void updateProduct(Produit p) throws SQLException {

        PreparedStatement ps = connection.prepareStatement( "update produit set nom = ?, prix = ?, quantite = ? WHERE id = ?");
            ps.setString(1, p.getNom());
            ps.setDouble(2, p.getPrix());
            ps.setInt(3, p.getQuantite());
            ps.setInt(4, p.getId());
            ps.executeUpdate();


	}

	@Override
	public List<Produit> getAllProductsWithFavorites(int userId) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void dissocierProduitsDeCategorie(Categorie categorie) {
		// TODO Auto-generated method stub
		
	}

}
