package presentation;

import java.sql.SQLException;
import java.util.List;

import javax.swing.JOptionPane;

import dao.GestionProduit;
import dao.IGestionProduit;
import entities.Produit;

public class Test {

    public static void main(String[] args) {
        try {
            IGestionProduit gestion = new GestionProduit();

            Produit produitAjoute = new Produit(0, "Ordinateur", 1200.50, 10);
            gestion.addProduct(produitAjoute);
            System.out.println("Produit ajouté : " + produitAjoute);


            System.out.println("\nListe des produits après ajout :");
            List<Produit> liste = gestion.getAllProducts();
            liste.forEach(System.out::println);


            System.out.println("\nRecherche des produits contenant 'Ord' :");
            List<Produit> recherche = gestion.getAllProductsByMC("Ord");
            recherche.forEach(System.out::println);


            int idTest = liste.get(liste.size() - 1).getId();
            Produit produitRecupere = gestion.getProduct(idTest);
            System.out.println("\nProduit récupéré par ID : " + produitRecupere);


            if (produitRecupere != null) {
                produitRecupere.setPrix(999.99);
                produitRecupere.setQuantite(5);
                gestion.updateProduct(produitRecupere);
                System.out.println("\nProduit mis à jour : " + gestion.getProduct(idTest));
            }


            gestion.deleteProduct(idTest);
            System.out.println("\nProduit supprimé avec ID : " + idTest);


            System.out.println("\nListe des produits après suppression :");
            gestion.getAllProducts().forEach(System.out::println);

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erreur SQL : " + e.getMessage());
        }
    }
}
