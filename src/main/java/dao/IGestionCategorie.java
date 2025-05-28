package dao;

import java.sql.SQLException;
import java.util.List;

import entities.Categorie;

public interface IGestionCategorie {
    public void addCategorie(Categorie c) throws SQLException;
    public List<Categorie> getAllCategories() throws SQLException;
    public Categorie getCategorieById(int id) throws SQLException;
    public void deleteCategorie(int id) throws SQLException;
    public void updateCategorie(Categorie c) throws SQLException;
}
