package dao;

import java.util.List;

import entities.User;

public interface IUserDAO {
    void saveUser(User user);
    User getUserByUsername(String username);
    User getUserByEmail(String email);
    User getUserById(int id); // ou long id, selon le type de votre ID
	List<User> getAllUsers();
	boolean userExists(String username);
	void updateUser(User user);
}