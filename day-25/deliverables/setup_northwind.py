import sqlite3
import pandas as pd
import os
import csv

# Configuration
DB_NAME = "northwind.sqlite"
DATA_DIR = "data/dataset"

files = [
    "Categories.csv",
    "Customers.csv",
    "OrderDetails.csv",
    "Orders.csv",
    "Products.csv",
    "Shippers.csv",
    "Suppliers.csv",
]

print(f"Creating {DB_NAME}...")
conn = sqlite3.connect(DB_NAME)

for file in files:
    file_path = os.path.join(DATA_DIR, file)

    if os.path.exists(file_path):
        table_name = os.path.splitext(os.path.basename(file))[0].lower()

        try:
            # SPECIAL HANDLING FOR CUSTOMERS.CSV
            if "customer" in file.lower():
                print(f"   ⚠️ Applying flexible parser for {file}...")
                # Read with python engine, allow bad lines, and force 7 columns
                # If a row has 8 fields, the last one gets merged or dropped depending on config
                # Better approach: Read as list of lists and fix manually
                with open(file_path, "r", encoding="utf-8") as f:
                    reader = csv.reader(f)
                    rows = list(reader)

                # Header is row 0
                header = rows[0]
                data = []

                for i, row in enumerate(rows[1:]):
                    if len(row) > len(header):
                        # Merge extra fields into the 'Address' or 'CompanyName' column (usually index 4 or 1)
                        # Northwind schema: CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax
                        # If standard is 11 cols and we see 12, merge the extra into Address (index 4)
                        # But your error says "Expected 7, saw 8".
                        # Let's assume the extra comma is in the Address field.
                        # We will join the extra parts back into the field before the split happened.

                        # Simple fix: If row is too long, merge the excess into the 5th column (Address)
                        # Adjust index based on your actual CSV structure.
                        # Standard Northwind Customers has 11 columns. If yours has 7, it's a simplified version.
                        # Let's just merge all excess into the last column to be safe, or the one before last.

                        excess = len(row) - len(header)
                        # Merge excess into the column before the last (often Address/City boundary)
                        # Actually, safest is to merge into the field that likely contains the comma.
                        # Let's merge index 4 and 5 if 8 cols exist?
                        # Generic fix: Join the extra bits into the 5th column (index 4)
                        merge_idx = 4
                        row[merge_idx] = ", ".join(
                            row[merge_idx : merge_idx + excess + 1]
                        )
                        row = row[: merge_idx + 1] + row[merge_idx + excess + 1 :]

                    elif len(row) < len(header):
                        # Pad with empty strings if too short
                        row += [""] * (len(header) - len(row))

                    data.append(row)

                df = pd.DataFrame(data, columns=header)

            else:
                # Standard loading for other files
                df = pd.read_csv(file_path, encoding="utf-8")

            # Clean Column Names
            df.columns = [col.replace(" ", "") for col in df.columns]

            # Write to SQLite
            df.to_sql(table_name, conn, if_exists="replace", index=False)
            print(f"✅ Loaded {table_name} ({len(df)} rows)")

        except Exception as e:
            print(f"❌ Error loading {file}: {e}")
    else:
        print(f"❌ Missing file: {file_path}")

conn.close()
print(f"\nDatabase '{DB_NAME}' created successfully.")
