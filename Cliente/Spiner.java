import javax.swing.*;
import java.awt.*;

public class Spiner {
    public static void main(String[] args) {
        if (args.length > 0 && args[0].equals("input")) {
            int maximo = Integer.parseInt(args[1]);
            String mensaje = args.length > 2 ? args[2] : "Seleccione un valor:";

            mensaje = "<html>" + mensaje.replace("\n", "<br>") + "</html>";

            JLabel label = new JLabel(mensaje);
            SpinnerNumberModel model = new SpinnerNumberModel(1, 1, maximo, 1);
            JSpinner spinner = new JSpinner(model);

            JPanel panel = new JPanel(new BorderLayout(10, 10));
            panel.add(label, BorderLayout.NORTH);
            panel.add(spinner, BorderLayout.CENTER);

            int opcion = JOptionPane.showConfirmDialog(
                null,
                panel,
                "Seleccione un número",
                JOptionPane.OK_CANCEL_OPTION,
                JOptionPane.QUESTION_MESSAGE
            );

            if (opcion == JOptionPane.OK_OPTION) {
                System.out.println(spinner.getValue());
            } else {
                System.out.println("");
            }
        } else {
            JOptionPane.showMessageDialog(null, "Modo no válido");
        }
    }
}
