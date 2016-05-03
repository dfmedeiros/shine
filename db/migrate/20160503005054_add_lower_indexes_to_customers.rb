class AddLowerIndexesToCustomers < ActiveRecord::Migration
  def up
    execute %{
      CREATE INDEX
        customers_lower_last_name
      ON
        customers (LOWER(last_name) VARCHAR_PATTERN_OPS)
    }

    execute %{
      CREATE INDEX
        customers_lower_first_name
      ON
        customers (LOWER(first_name) VARCHAR_PATTERN_OPS)
    }

    execute %{
      CREATE INDEX
        customers_lower_email
      ON
        customers (LOWER(email))
    }
  end

  def down
    remove_index :customers, name: "customers_lower_last_name"
    remove_index :customers, name: "customers_lower_first_name"
    remove_index :customers, name: "customers_lower_email"
  end
end
