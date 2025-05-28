package dao;

import java.sql.SQLException;
import java.util.List;

import javax.persistence.*;

import entities.Categorie;
import entities.Produit;

public class GestionCategorieJPA implements IGestionCategorie {

    EntityManagerFactory emf = Persistence.createEntityManagerFactory("catalogue");
    EntityManager em = emf.createEntityManager();
    private GestionProduitJPA produitDao = new GestionProduitJPA();

    @Override
    public void addCategorie(Categorie c) throws SQLException {
        EntityTransaction et = em.getTransaction();
        et.begin();
        em.persist(c);
        et.commit();
    }

    @Override
    public List<Categorie> getAllCategories() {
        EntityManager em = emf.createEntityManager();
        List<Categorie> categories = null;
        try {
            categories = em.createQuery("SELECT c FROM Categorie c", Categorie.class).getResultList();
        } finally {
            em.close();  
        }
        return categories;
    }
    
    


    @Override
    public Categorie getCategorieById(int id) throws SQLException {
        return em.find(Categorie.class, id);
    }
    
    @Override
    public void deleteCategorie(int id) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Categorie c = em.find(Categorie.class, id);
            if (c != null) {
                produitDao.dissocierProduitsDeCategorie(c);
                em.remove(c);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw new RuntimeException("Error deleting category", e);
        } finally {
            if (em != null) em.close();
        }
    }

    
    




    @Override
    public void updateCategorie(Categorie c) throws SQLException {
        EntityTransaction et = em.getTransaction();
        et.begin();
        em.merge(c);
        et.commit();
    }
}
