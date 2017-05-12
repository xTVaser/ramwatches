import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * Created by Tyler on 5/11/2017.
 */
public class AddressToLua {

    public static void main(String[] args) throws Exception {

        String[] lines = new String(Files.readAllBytes(Paths.get("Addresses"))).split("\n");

        for (int i = 0; i < lines.length; i++) {

            String[] tokens = lines[i].split("\t");
            System.out.println("checkpoints[\"" + Integer.parseInt(tokens[1].trim(), 16) + "\"] = \"" + tokens[0] + "\"");
        }
    }
}
