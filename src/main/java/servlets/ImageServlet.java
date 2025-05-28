package servlets;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {
    
    private static final String IMAGE_DIR = "C:/Users/raefg/eclipse-workspace/gestioncatalogue-Maven2/src/main/webapp/assets/images/";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String requestedName = request.getPathInfo().substring(1);
        System.out.println("Requête reçue pour: " + requestedName);
        
        if(requestedName == null || requestedName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 1. Protection contre Path Traversal
        requestedName = requestedName.replaceAll("\\.\\.", "").replaceAll("/", "");
        
        // 2. Convertir le nom demandé vers le nom physique
        String physicalName = requestedName
            .replaceAll("^\\d+_", "") // Supprime le timestamp
            .replace("_", " ");        // Convertit les underscores en espaces
        
        File imageFile = new File(IMAGE_DIR + physicalName);
        System.out.println("Chemin physique: " + imageFile.getAbsolutePath());
        
        // 3. Vérification existence
        if(!imageFile.exists() || imageFile.isDirectory()) {
            System.err.println("ERREUR: Fichier introuvable - " + physicalName);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // 4. Envoi de l'image
        try {
            String mimeType = Files.probeContentType(imageFile.toPath());
            response.setContentType(mimeType != null ? mimeType : "application/octet-stream");
            response.setHeader("Cache-Control", "public, max-age=86400");
            Files.copy(imageFile.toPath(), response.getOutputStream());
            System.out.println("Image envoyée: " + physicalName);
        } catch (IOException e) {
            System.err.println("ERREUR d'envoi: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}