package dao;

import java.sql.SQLException;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.Query;

import entities.Categorie;
import entities.Produit;

public class GestionProduitJPA implements IGestionProduit {

    EntityManagerFactory emf = Persistence.createEntityManagerFactory("catalogue");

    @Override
    public void addProduct(Produit p) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction et = em.getTransaction();
        try {
            et.begin();
            if (p.getId() == 0) {
                em.persist(p);
            } else {
                em.merge(p);
            }
            et.commit();
        } catch (Exception e) {
            if (et.isActive()) {
                et.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Produit> getAllProducts() throws SQLException {
        return getAllProductsWithFavorites(0); // 0 = aucun utilisateur spécifié
    }

    @Override
	public List<Produit> getAllProductsWithFavorites(int userId) throws SQLException {
        EntityManager em = emf.createEntityManager();
        try {
            // Récupérer tous les produits
            Query q = em.createQuery("SELECT p FROM Produit p");
            List<Produit> produits = q.getResultList();

            // Pour chaque produit, calculer les infos favoris
            for (Produit p : produits) {
                // Compter le nombre total de favoris
                Query countQuery = em.createQuery(
                    "SELECT COUNT(f) FROM Favoris f WHERE f.produit.id = :produitId");
                countQuery.setParameter("produitId", p.getId());
                Long count = (Long) countQuery.getSingleResult();
                p.setFavoriteCount(count != null ? count.intValue() : 0);

                // Vérifier si l'utilisateur courant a ce produit en favori
                if (userId > 0) {
                    Query favQuery = em.createQuery(
                        "SELECT COUNT(f) FROM Favoris f WHERE f.produit.id = :produitId AND f.user.id = :userId");
                    favQuery.setParameter("produitId", p.getId());
                    favQuery.setParameter("userId", userId);
                    Long userFav = (Long) favQuery.getSingleResult();
                    p.setIsFavorite(userFav != null && userFav > 0);
                }
            }

            return produits;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Produit> getAllProductsByMC(String mc) throws SQLException {
        EntityManager em = emf.createEntityManager();
        try {
            Query q = em.createQuery("SELECT p FROM Produit p WHERE p.nom LIKE :x");
            q.setParameter("x", "%"+mc+"%");
            return q.getResultList();
        } finally {
            em.close();
        }
    }
    
    public void dissocierProduitsDeCategorie(Categorie categorie) {
        categorie.getProduits().forEach(p -> {
            p.setCategorie(null);
        });
    }


    @Override
    public Produit getProduct(int id) throws SQLException {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Produit.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public void deleteProduct(int id) throws SQLException {
        EntityManager em = emf.createEntityManager();
        EntityTransaction et = em.getTransaction();
        try {
            et.begin();
            Produit p = em.find(Produit.class, id);
            if (p != null) {
                em.remove(p);
            }
            et.commit();
        } catch (Exception e) {
            if (et.isActive()) {
                et.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public void updateProduct(Produit p) throws SQLException {
        EntityManager em = emf.createEntityManager();
        EntityTransaction et = em.getTransaction();
        try {
            et.begin();
            em.merge(p);
            et.commit();
        } catch (Exception e) {
            if (et.isActive()) {
                et.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

	 public void close() {
		 EntityManager em = emf.createEntityManager();
	        
        if (em != null && em.isOpen()) {
            em.close();
        }
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}