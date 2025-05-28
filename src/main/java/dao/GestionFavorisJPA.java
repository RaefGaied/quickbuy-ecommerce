package dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.Query;
import entities.Favoris;
import entities.Produit;
import entities.User;

public class GestionFavorisJPA implements IGestionFavoris, AutoCloseable {
    private EntityManagerFactory emf;
    private EntityManager em;

    public GestionFavorisJPA() {
        this.emf = Persistence.createEntityManagerFactory("catalogue");
        this.em = emf.createEntityManager();
    }

    @Override
    public void ajouterFavoris(User user, Produit produit) {
        EntityTransaction et = em.getTransaction();
        try {
            et.begin();
            if (!estDejaFavori(user, produit)) {
                Favoris f = new Favoris(user, produit);
                em.persist(f);
            }
            et.commit();
        } catch (Exception e) {
            if (et.isActive()) {
                et.rollback();
            }
            throw new RuntimeException("Erreur lors de l'ajout aux favoris", e);
        }
    }

    @Override
    public void supprimerFavoris(User user, Produit produit) {
        EntityTransaction et = em.getTransaction();
        try {
            et.begin();
            Query q = em.createQuery(
                "DELETE FROM Favoris f WHERE f.user = :user AND f.produit = :produit");
            q.setParameter("user", user);
            q.setParameter("produit", produit);
            q.executeUpdate();
            et.commit();
        } catch (Exception e) {
            if (et.isActive()) {
                et.rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression des favoris", e);
        }
    }

    @Override
    public boolean estDejaFavori(User user, Produit produit) {
        Query q = em.createQuery(
            "SELECT COUNT(f) FROM Favoris f WHERE f.user = :user AND f.produit = :produit");
        q.setParameter("user", user);
        q.setParameter("produit", produit);
        Long count = (Long) q.getSingleResult();
        return count > 0;
    }

    @Override
    public List<Produit> getProduitsFavorisParUser(User user) throws SQLException {
        Query q = em.createQuery(
            "SELECT f.produit FROM Favoris f WHERE f.user = :user");
        q.setParameter("user", user);
        return q.getResultList();
    }

    @Override
    public List<Object[]> getProduitsLesPlusFavoris() throws SQLException {
        Query q = em.createQuery(
            "SELECT f.produit, COUNT(f) AS nb FROM Favoris f GROUP BY f.produit ORDER BY nb DESC");
        q.setMaxResults(10); // Limite aux 10 premiers résultats
        return q.getResultList();
    }

    @Override
    public List<User> getUsersByFavoriProduit(int produitId) {
        Query q = em.createQuery(
            "SELECT f.user FROM Favoris f WHERE f.produit.id = :id");
        q.setParameter("id", produitId);
        return q.getResultList();
    }

    @Override
    public int countFavoritesForProduct(int productId) {
        Query q = em.createQuery(
            "SELECT COUNT(f) FROM Favoris f WHERE f.produit.id = :productId");
        q.setParameter("productId", productId);
        return ((Long) q.getSingleResult()).intValue();
    }

    @Override
    public boolean isProductFavoriteForUser(int userId, int productId) {
        Query q = em.createQuery(
            "SELECT COUNT(f) FROM Favoris f WHERE f.user.id = :userId AND f.produit.id = :productId");
        q.setParameter("userId", userId);
        q.setParameter("productId", productId);
        return ((Long) q.getSingleResult()) > 0;
    }

    @Override
    public List<Produit> getAllFavorites() throws SQLException {
        Query q = em.createQuery(
            "SELECT DISTINCT f.produit FROM Favoris f");
        return q.getResultList();
    }

    @Override
    public Map<Integer, List<User>> getUsersByProducts() {
        List<Object[]> results = em.createQuery(
            "SELECT f.produit.id, f.user FROM Favoris f", Object[].class)
            .getResultList();

        Map<Integer, List<User>> map = new HashMap<Integer, List<User>>();
        for (Object[] result : results) {
            Integer produitId = (Integer) result[0];
            User user = (User) result[1];

            if (!map.containsKey(produitId)) {
                map.put(produitId, new ArrayList<User>());
            }
            map.get(produitId).add(user);
        }
        return map;
    }

    @Override
    public void close() {
        if (em != null && em.isOpen()) {
            em.close();
        }
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}