package entities;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "favoris")
public class Favoris {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    // Lien vers l'utilisateur
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // Lien vers le produit
    @ManyToOne
    @JoinColumn(name = "produit_id", nullable = false)
    private Produit produit;

    public Favoris() {}

    public Favoris(User user, Produit produit) {
        this.user = user;
        this.produit = produit;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Produit getProduit() {
        return produit;
    }

    public void setProduit(Produit produit) {
        this.produit = produit;
    }

    @Override
    public String toString() {
        return "Favoris{" +
                "id=" + id +
                ", user=" + user.getUsername() +
                ", produit=" + produit.getNom() +
                '}';
    }
}
