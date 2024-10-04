<?php
// Datenbankverbindung herstellen
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "cardealership";

// Verbindung erstellen
$conn = new mysqli($servername, $username, $password, $dbname);

// Verbindung prüfen
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Funktion zum Leeren aller Tabellen
function truncateTables($conn) {
    $conn->query("SET FOREIGN_KEY_CHECKS = 0");

    $tables = [];
    $result = $conn->query("SHOW TABLES");
    while ($row = $result->fetch_array()) {
        $tables[] = $row[0];
    }

    foreach ($tables as $table) {
        $sql = "TRUNCATE TABLE $table";
        if ($conn->query($sql) === TRUE) {
            echo "Table $table truncated successfully.<br>";
        } else {
            echo "Error truncating table $table: " . $conn->error . "<br>";
        }
    }

    $conn->query("SET FOREIGN_KEY_CHECKS = 1");
}

// Funktion zum Entfernen doppelter Einträge
function removeDuplicates($conn, $table, $columns) {
    $unique_columns = implode(', ', $columns);

    $temp_table_name = 'temp_' . $table;
    $create_temp_table_sql = "CREATE TEMPORARY TABLE $temp_table_name AS 
        SELECT * FROM $table 
        ORDER BY " . implode(', ', $columns);
    $conn->query($create_temp_table_sql);

    $delete_duplicates_sql = "DELETE FROM $table 
        WHERE (" . $unique_columns . ") IN (
            SELECT " . $unique_columns . " 
            FROM $temp_table_name 
            GROUP BY " . $unique_columns . " 
            HAVING COUNT(*) > 1
        ) AND row_number > 1";
    $conn->query($delete_duplicates_sql);

    $conn->query("DROP TEMPORARY TABLE $temp_table_name");
}

// Funktion zum Hinzufügen neuer Daten
function populateTables($conn) {
    // Brands
    $check_brands = "SELECT COUNT(*) as count FROM Brands";
    $result = $conn->query($check_brands);
    $row = $result->fetch_assoc();

    if ($row['count'] == 0) {
        $sql = "INSERT INTO Brands (name) VALUES 
                ('BMW'), 
                ('Audi'), 
                ('Mercedes'), 
                ('Volkswagen')";
        $conn->query($sql);
    }

    // CarModels
    $brands_ids = [];
    $result = $conn->query("SELECT brand_id FROM Brands");
    while ($row = $result->fetch_assoc()) {
        $brands_ids[] = $row['brand_id'];
    }

    $model_names = ["X1", "X3", "Q5", "A4", "C-Class", "E-Class", "Golf", "Passat"];
    for ($i = 0; $i < 15; $i++) {
        $model_name = $model_names[array_rand($model_names)];
        $brand_id = $brands_ids[array_rand($brands_ids)];
        $year = rand(2010, 2023);
        $sql = "INSERT INTO CarModels (model_name, brand_id, year) VALUES ('$model_name', $brand_id, $year)";
        $conn->query($sql);
    }

    // Customers
    $customer_names = ["Max Mustermann", "Erika Mustermann", "John Doe", "Jane Doe", "Alice Smith", "Bob Johnson"];
    for ($i = 0; $i < 15; $i++) {
        $name = $customer_names[array_rand($customer_names)];
        $email = strtolower(str_replace(" ", ".", $name)) . "@example.com";
        $phone = "123-456-789" . rand(0, 9);
        $address = "Street " . rand(1, 100);
        $sql = "INSERT INTO Customers (name, email, phone, address) VALUES ('$name', '$email', '$phone', '$address')";
        $conn->query($sql);
    }

    // Sales
    $model_ids = [];
    $result = $conn->query("SELECT model_id FROM CarModels");
    while ($row = $result->fetch_assoc()) {
        $model_ids[] = $row['model_id'];
    }

    for ($i = 0; $i < 15; $i++) {
        $customer_id = rand(1, 15);
        $model_id = $model_ids[array_rand($model_ids)];
        $sale_date = date('Y-m-d', strtotime('2010-01-01 + ' . rand(0, 365*13) . ' days'));
        $sale_price = rand(20000, 50000);
        $sql = "INSERT INTO Sales (customer_id, model_id, sale_date, sale_price) VALUES ($customer_id, $model_id, '$sale_date', $sale_price)";
        $conn->query($sql);
    }

    // Workshops
    $workshop_names = ["Auto Werkstatt Müller", "KFZ Schmidt", "Garage Meier", "Werkstatt Becker"];
    for ($i = 0; $i < 15; $i++) {
        $name = $workshop_names[array_rand($workshop_names)];
        $address = "Werkstattstrasse " . rand(1, 100);
        $phone = "987-654-321" . rand(0, 9);
        $email = strtolower(str_replace(" ", ".", $name)) . "@werkstatt.com";
        $sql = "INSERT INTO Workshops (name, address, phone, email) VALUES ('$name', '$address', '$phone', '$email')";
        $conn->query($sql);
    }

    // MaintenanceLogs
    $workshop_ids = [];
    $result = $conn->query("SELECT workshop_id FROM Workshops");
    while ($row = $result->fetch_assoc()) {
        $workshop_ids[] = $row['workshop_id'];
    }

    for ($i = 0; $i < 15; $i++) {
        $model_id = $model_ids[array_rand($model_ids)];
        $workshop_id = $workshop_ids[array_rand($workshop_ids)];
        $maintenance_date = date('Y-m-d', strtotime('2010-01-01 + ' . rand(0, 365*13) . ' days'));
        $details = "Wartung durchgeführt für Modell " . $model_id;
        $sql = "INSERT INTO MaintenanceLogs (model_id, workshop_id, maintenance_date, details) VALUES ($model_id, $workshop_id, '$maintenance_date', '$details')";
        $conn->query($sql);
    }

    // Accessories
    $accessory_names = ["Sitzbezüge", "Kofferraummatte", "Wachsspray", "Scheibenreiniger", "Parkhilfe", "Navigation", "Winterreifen", "Sommerreifen"];
    for ($i = 0; $i < 15; $i++) {
        $accessory_name = $accessory_names[array_rand($accessory_names)];
        $price = rand(100, 1000);
        $model_id = $model_ids[array_rand($model_ids)];
        $sql = "INSERT INTO Accessories (accessory_name, price, model_id) VALUES ('$accessory_name', $price, $model_id)";
        $conn->query($sql);
    }
}

// Funktion zum Hinzufügen eines neuen Eintrags
function addEntry($conn, $table, $data) {
    // Überprüfen, ob die Tabelle existiert
    $result = $conn->query("SHOW COLUMNS FROM $table");
    $columns = [];
    while ($row = $result->fetch_assoc()) {
        $columns[] = $row['Field'];
    }

    // Überprüfen, ob alle Datenfelder gültig sind
    $data_columns = array_keys($data);
    foreach ($data_columns as $column) {
        if (!in_array($column, $columns)) {
            echo "Unbekannte Spalte: $column<br>";
            return;
        }
    }

    // Erstellen der SQL-Anweisung
    $columns_list = implode(", ", $data_columns);
    $values_list = implode("', '", array_map([$conn, 'real_escape_string'], array_values($data)));
    $sql = "INSERT INTO $table ($columns_list) VALUES ('$values_list')";

    if ($conn->query($sql) === TRUE) {
        echo "Neuer Eintrag in $table erfolgreich hinzugefügt.<br>";
    } else {
        echo "Fehler: " . $sql . "<br>" . $conn->error . "<br>";
    }
}

// Funktion zum Löschen eines Eintrags
function deleteEntry($conn, $table, $id_column, $id_value) {
    $sql = "DELETE FROM $table WHERE $id_column = $id_value";

    if ($conn->query($sql) === TRUE) {
        echo "Eintrag in $table mit $id_column = $id_value erfolgreich gelöscht.<br>";
    } else {
        echo "Fehler: " . $sql . "<br>" . $conn->error . "<br>";
    }
}

// Datenverarbeitung
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $action = $_POST['action'] ?? '';

    switch ($action) {
        case 'truncate':
            truncateTables($conn);
            break;
        case 'remove_duplicates':
            $table = $_POST['table'];
            $columns = explode(',', $_POST['columns']);
            removeDuplicates($conn, $table, $columns);
            break;
        case 'populate':
            populateTables($conn);
            break;
        case 'add_entry':
            $table = $_POST['table'];
            $data = [];
            foreach ($_POST as $key => $value) {
                if (strpos($key, 'data_') === 0) {
                    $column = substr($key, 5);
                    $data[$column] = $value;
                }
            }
            addEntry($conn, $table, $data);
            break;
        case 'delete_entry':
            $table = $_POST['table'];
            $id_column = $_POST['id_column'];
            $id_value = $_POST['id_value'];
            deleteEntry($conn, $table, $id_column, $id_value);
            break;
    }
}

// HTML für die Anzeige der Tabellen
function displayTable($conn, $table_name) {
    $result = $conn->query("SELECT * FROM $table_name");

    if ($result->num_rows > 0) {
        echo "<h2>$table_name</h2>";
        echo "<table>";
        echo "<thead><tr>";

        // Kopfzeilen anzeigen
        $fields = $result->fetch_fields();
        foreach ($fields as $field_info) {
            echo "<th>" . htmlspecialchars($field_info->name) . "</th>";
        }
        echo "<th>Aktionen</th>";
        echo "</tr></thead><tbody>";

        // Tabellenzeilen anzeigen
        while ($row = $result->fetch_assoc()) {
            echo "<tr>";
            foreach ($row as $value) {
                echo "<td>" . htmlspecialchars($value) . "</td>";
            }
            // Löschen-Button hinzufügen
            $id_column = array_key_first($row);
            $id_value = $row[$id_column];
            echo "<td><form method='post' style='display:inline;'>
                <input type='hidden' name='action' value='delete_entry'>
                <input type='hidden' name='table' value='$table_name'>
                <input type='hidden' name='id_column' value='$id_column'>
                <input type='hidden' name='id_value' value='$id_value'>
                <button type='submit'>Löschen</button>
            </form></td>";
            echo "</tr>";
        }
        echo "</tbody></table>";
    } else {
        echo "Keine Daten in der Tabelle: $table_name.<br>";
    }
}

// HTML-Formular für Operationen
?>

<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title>AutoKatalog Verwaltung</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
        form {
            margin-bottom: 20px;
        }
        select, input[type="text"] {
            margin-right: 10px;
        }
        button {
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <h1>AutoKatalog Verwaltung</h1>
    
    <!-- Operationen -->
    <form method="post">
        <button name="action" value="truncate">Alle Tabellen leeren</button>
        <button name="action" value="remove_duplicates">Doppelte Einträge entfernen</button>
        <button name="action" value="populate">Beispieldaten hinzufügen</button>
    </form>

    <!-- Neuen Eintrag hinzufügen -->
    <h2>Neuen Eintrag hinzufügen</h2>
    <form method="post">
        <label for="table">Tabelle wählen:</label>
        <select name="table" id="table">
            <option value="Brands">Brands</option>
            <option value="CarModels">CarModels</option>
            <option value="Customers">Customers</option>
            <option value="Sales">Sales</option>
            <option value="Workshops">Workshops</option>
            <option value="MaintenanceLogs">MaintenanceLogs</option>
            <option value="Accessories">Accessories</option>
        </select>

        <!-- Dynamische Felder für Tabelle auswählen -->
        <div id="entry_form">
            <!-- Hier werden die Felder für die ausgewählte Tabelle hinzugefügt -->
        </div>

        <button name="action" value="add_entry">Eintrag hinzufügen</button>
    </form>

    <!-- Tabellen anzeigen -->
    <?php
    $tables = ['Brands', 'CarModels', 'Customers', 'Sales', 'Workshops', 'MaintenanceLogs', 'Accessories'];
    foreach ($tables as $table) {
        displayTable($conn, $table);
    }
    ?>

    <script>
        // Dynamisches Formular zur Eingabe der Daten
        document.getElementById('table').addEventListener('change', function() {
            var table = this.value;
            var entry_form = document.getElementById('entry_form');
            entry_form.innerHTML = ''; // Formular zurücksetzen

            var fields = {
                'Brands': ['name'],
                'CarModels': ['model_name', 'brand_id', 'year'],
                'Customers': ['name', 'email', 'phone', 'address'],
                'Sales': ['customer_id', 'model_id', 'sale_date', 'sale_price'],
                'Workshops': ['name', 'address', 'phone', 'email'],
                'MaintenanceLogs': ['model_id', 'workshop_id', 'maintenance_date', 'details'],
                'Accessories': ['accessory_name', 'price', 'model_id']
            };

            fields[table].forEach(function(field) {
                var label = document.createElement('label');
                label.innerHTML = field.replace(/_/g, ' ').toUpperCase() + ':';
                var input = document.createElement('input');
                input.type = 'text';
                input.name = 'data_' + field;
                input.id = field;
                entry_form.appendChild(label);
                entry_form.appendChild(input);
                entry_form.appendChild(document.createElement('br'));
            });
        });
    </script>
</body>
</html>

<?php
// Verbindung schließen
$conn->close();
?>
