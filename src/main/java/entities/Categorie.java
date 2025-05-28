package entities;
import java.util.List;

import javax.persistence.*;



@Entity
public class Categorie {
	 @Id
	 @GeneratedValue(strategy = GenerationType.IDENTITY)
	 private int id;
	 private String nom;
	 @OneToMany(mappedBy = "categorie")
	 private List<Produit> produits;


	 public List<Produit> getProduits() {
	     return produits;
	 }

	 public void setProduits(List<Produit> produits) {
	     this.produits = produits;
	 }

	 
	 public Categorie() {
			
		}
	 
	public Categorie(int id, String nom, List<Produit> liste) {
		super();
		this.id = id;
		this.nom = nom;
		this.produits = liste;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getNom() {
		return nom;
	}

	public void setNom(String nom) {
		this.nom = nom;
	}

	public List<Produit> getListe() {
		return produits;
	}

	public void setListe(List<Produit> liste) {
		this.produits = liste;
	}

	@Override
	public String toString() {
		return "Categorie [id=" + id + ", nom=" + nom + ", liste=" + produits + "]";
	}
	
	
	 
	 
	 
	 
	

}
