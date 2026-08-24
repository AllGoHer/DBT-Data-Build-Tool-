# DBT-Data-Build-Tool-
_______________________________________________________________________________________________________________________________________________________________________________________________________________
### CAPA BRONCE

CODIGO:

SELECT * FROM dbt_dev.source.fact_sales

Luego, ejecutamos.

![image](https://github.com/user-attachments/assets/27d9e518-8bf7-4404-ac14-c09e525d5916)

![image](https://github.com/user-attachments/assets/08980059-13f7-4781-a2c5-4e7556360cdd)

En sources creamos el archivo source.yml

Código:

        version: 2
        sources:
          - name: source
            database: dbt_dev
            schema: source
            tables:

              - name: fact_sales

              - name: fact_returns

              - name: dim_date

              - name: dim_store

              - name: dim_product

              - name: dim_customer



![image](https://github.com/user-attachments/assets/e21980e2-eb13-4edd-acd0-7224acc6341a)

Ahora creamos el archivo bronce_returns.

Código:

        SELECT
            *
        FROM
            {{ source('source','fact_returns') }}


![image](https://github.com/user-attachments/assets/374a9b8a-ce77-4c68-b334-15cfa5289a4a)

![image](https://github.com/user-attachments/assets/17205a44-7b6d-4a30-b5e5-a9b462051771)

![image](https://github.com/user-attachments/assets/7342ad84-c1b0-4c2c-b52f-10bf6adbcd0e)

![image](https://github.com/user-attachments/assets/5c1046dc-7195-48f5-be27-78c3087b723a)

![image](https://github.com/user-attachments/assets/8af5fbe5-8b1a-44e9-87c6-bd476c961ee1)

Ahora, en el archivo dbt_project.yml cambiamos la siguiente parte.

Código:

        models:
          all_GoHer_project:
            # Config indicated by + and applies to all files under models/example/
            exemplo:
              +materialized: view


Por el código:

               models:
                 all_GoHer_project:
                   # Config indicated by + and applies to all files under models/example/
                   bronze:
                     +materialized: table

Guardamos el archivo y, en la terminal dentro del proyecto, ejecutamos el código con dbt run.

![image](https://github.com/user-attachments/assets/3da5e7db-4938-4ee5-bcbd-223478aebf50)

![image](https://github.com/user-attachments/assets/0954b68e-59b8-4605-ada0-336b11d64442)

Ahora vamos a limpiar la carpeta de destino con dbt clean

![image](https://github.com/user-attachments/assets/7a11f1eb-98ab-43f8-be85-93a28c323944)

Eliminará la carpeta target.

Ahora en la carpeta bronce crearé un archivo llamado properties.yml

Código:

        version: 2

        models:

          - name: bronze_date
            config:
              materialized: view

          - name: bronze_product
            config:
              materialized: view

Luego, en el archivo bronce_sales.sql lo editamos de la siguiente manera:

Código:
 
          {{ 
          config(
            materialized = 'view'
            )
          }}

         SELECT
             *
         FROM
             {{ source('source','fact_sales') }}


Y guardamos.

Ahora en la terminal ejecutamos dbt run

![image](https://github.com/user-attachments/assets/66aa9258-a5e9-4084-9d01-c04e3073053e)

Ahora, en la terminal veremos el estatus de git.

Código:

        Cd ..

Código:

        Git status

![image](https://github.com/user-attachments/assets/22ed6b68-e80e-4391-8236-b18b4752f616)

Código:

        Git add .

Código:
 
        git commit -m "bronze layer"

![image](https://github.com/user-attachments/assets/aa1cb814-5731-4fdf-8e00-f1d07e8c52c0)

Ahora, crearemos una rama de características.

Código:

        git switch -c feature_allan

luego, en el archivo dbt_project.yml se hará los siguientes cambios en la parte final, agregando la capa silver y gold.

Código:

        models:
          all_GoHer_project:
            # Config indicated by + and applies to all files under models/example/
            bronze:
              +materialized: table
              schema: bronze
            silver:
              +materialized: table
              schema: silver
            gold:
              +materialized: table
              schema: gold


![image](https://github.com/user-attachments/assets/a810ea83-226c-4d03-853a-36fb87b695f3)

Ahora, en macros creamos un archivo llamado generate_schema.sql

Código:

        {% macro generate_schema_name(custom_schema_name, mode) -%}

            {%- set default_schema = target.schema -%}
            {%- if custom_schema_name is none -%}

                {{ default_schema }}

            {%- else -%}

                {{ custom_schema_name | trim}}

            {%- endif -%}

         {%- endmacro %}

![image](https://github.com/user-attachments/assets/557dcc38-c723-49ca-8a86-d476c235aabe)

En la terminal entramos al proyecto.

Código:

        Cd all_GoHer_project

![image](https://github.com/user-attachments/assets/c2277a4d-bc28-450c-a4fc-a4203f28e9a3)

Bash:
  
Dbt run

![image](https://github.com/user-attachments/assets/c43eb1f0-b357-4b01-a42a-201f169d8f4b)

![image](https://github.com/user-attachments/assets/214220ab-09cf-40a0-9363-807c33994bc4)

Ahora, vamos a Databricks para verificar que se ha creado.

![image](https://github.com/user-attachments/assets/7a7a7cf7-e2f2-4675-9cd4-e84a38c5f3a4)

Luego, en el archivo properties.yml haremos las siguientes correcciones.

Código:

        version: 2

        models:

          - name: bronze_date
            config:
              materialized: view
              schema: bronze

          - name: bronze_product
            config:
              materialized: view

          - name: bronze_sales
            columns:
              - name: sales_id
                data_tests:
                  - unique
                  - not_null

  
          - name: bronze_store
            columns:
              - name: store_sk
                data_tests:
                  - unique
                  - not_null
              - name: store_name
                data_tests:
                  - accepted_values: 
                     arguments:
                        values: ['MegaMart Manhattan', 'MegaMart Brooklyn', 'MegaMart Austin', 'MegaMart San Jose', 'MegaMart Toronto']
          

![image](https://github.com/user-attachments/assets/2b3dc95b-9fc8-4eaf-8683-8c4c21c2caac)

________________________________________________________________________________________________________________________________________________________________________________________________________________

### PRUEBAS GENERICAS

Ahora, probaremos ejecutándolo.

Código:

        Dbt test


![image](https://github.com/user-attachments/assets/a57eca18-5fa0-403a-98a9-e054c524184a)

Ahora, hagamos otra prueba agregando Severity, para cambiaremos un poco el código del archivo properties.yml

Código:

        version: 2

        models:

          - name: bronze_date
            config:
              materialized: view
              schema: bronze

          - name: bronze_product
            config:
              materialized: view

         - name: bronze_sales
            columns:
              - name: sales_id
                data_tests:
                  - unique
                  - not_null

  
          - name: bronze_store
            columns:
              - name: store_sk
                data_tests:
                  - unique
                  - not_null
              - name: country
                data_tests:
                  - accepted_values: 
                      arguments:
                        values: ['USA', 'Canada', 'Mexico']
                      config:
                        severity: warn 



luego, ejecutamos la prueba.

Código:

        dbt test


![image](https://github.com/user-attachments/assets/4fd7cfcd-9031-483f-9896-9b518f91014b)

________________________________________________________________________________________________________________________________________________________________________________________________________________

### PRUEBAS SINGULARES

Vamos hacer una prueba para asegurarnos que en el archivo de ventas no haya un monto negativo a excepción de la columna de descuentos.

Para ello, nos dirigimos a la carpeta de test y creamos un archivo llamado non_negative_test.sql 


![image](https://github.com/user-attachments/assets/2f0188fc-8147-4bc6-892d-d95f942fd48e)

Nota: en las pruebas singulares las condicionales van en orden inverso, si devuelve algún resultado se tomará como un registro.

Código:

        SELECT 
            * 
        FROM
            {{  ref('bronze_sales') }}
        WHERE
            gross_amount < 0 AND net_amount < 0


![image](https://github.com/user-attachments/assets/2ca2b1e0-aa98-491d-9548-5f8cba822aca)

Como vemos, no hay ningún tipo de registro, quiere decir que se superó la prueba.

Ahora, se añadirá esta prueba, así es que, en la terminal se ejecutará nuevamente dbt test.


![image](https://github.com/user-attachments/assets/c0925005-7d70-4086-8192-c350c1c1820a)

Como podemos ver, ahora tenemos 6 data tests, uno más del anterior.

______________________________________________________________________________________________________________________________________________________________________________________________________________

### PRUEBA GENERICA PERSONALIZADA


![image](https://github.com/user-attachments/assets/75f3be7f-f61a-4d3f-9459-35ddb60b0ff1)

![image](https://github.com/user-attachments/assets/31640356-7f85-4ea2-b107-6d38eb88e6c5)

Primero crearemos una carpeta dentro de Tests llamada generic y, dentro de ella, crearemos el archivo generic_non_negative.sql

Código:

        {% test generic_non_negative(model, column_name) %}

        SELECT
            *
        FROM
            {{ model }}
        WHERE
            {{ column_name }} < 0

        {% endtest %}

![image](https://github.com/user-attachments/assets/d9a1fb50-d5aa-441e-b7c6-fe0a7a68dbb2)

Luego, vamos properties.yml y editamos el código en bronce_sales.

Código:

        version: 2

        models:

          - name: bronze_date
            config:
              materialized: view
              schema: bronze

          - name: bronze_product
            config:
              materialized: view

          - name: bronze_sales
            columns:
              - name: sales_id
                data_tests:
                  - unique
                  - not_null
              - name: gross_amount
                 data_tests:
                   - generic_non_negative
          
  
          - name: bronze_store
             columns:
              - name: store_sk
                data_tests:
                  - unique
                  - not_null
              - name: country
                data_tests:
                  - accepted_values: 
                      arguments:
                        values: ['USA', 'Canada', 'Mexico']
                      config:
                        severity: warn 

luego, ejecutamos la prueba.

Código:

        dbt test

![image](https://github.com/user-attachments/assets/da1aa6f9-86da-4d3c-adcf-7b9f10fe77d6)

________________________________________________________________________________________________________________________________________________________________________________________________________________

### DBT SEEDS


Ahora, en la carpeta de Seeds crearemos un archivo llamado lookup.csv con los siguientes datos.

Datos:

        customer_id, customer_name, customer_email
        1, Jhon Deer, Jhond@example.com
        2, Juan Ciervo, elvenado@example.com
        3, Bart Simpson, bartolomeo@example.com

Luego, para ejecutar ello necesitaríamos modificar el archivo dbt_project.yml para agregar el seeds al final del código.

Código:

        models:
          all_GoHer_project:
            # Config indicated by + and applies to all files under models/example/
            bronze:
              +materialized: table
              schema: bronze
            silver:
              +materialized: table
               schema: silver
             gold:
              +materialized: table
              schema: gold

        seeds: 
          all_GoHer_project:
            +schema: bronze

Luego, para verificar ejecutaremos el siguiente código.

Código:

        Dbt seed


![image](https://github.com/user-attachments/assets/e9958eb8-da58-4e7d-b351-eada679541f6)

Ahora, verificamos que en el archivo lookup se haya creado en Databricks.

![image](https://github.com/user-attachments/assets/e0268476-07b3-46e2-9583-09be3b998425)

Si queremos hacer consultas, nos vamos a nuestra carpeta de analisis, para ello, crearemos un archivo llamado explore.sql

Código:

        SELECT * FROM  {{ ref('lookup') }}

![image](https://github.com/user-attachments/assets/e4771b1a-f90e-4e85-ae3a-a8b60629599e)

Luego, salimos de la carpeta de proyecto y ejecutamos los siguientes comandos git.

Código:

        cd ..

código:

        git add .

código:

        git commit -m “sedes, test, etc”

![image](https://github.com/user-attachments/assets/458fe023-3901-42ce-908b-20d6ade53a8c)

________________________________________________________________________________________________________________________________________________________________________________________________________________

### JINJA & MACROS


![image](https://github.com/user-attachments/assets/90b6b8df-311d-4f57-9218-9d5d4763ec2f)

En la carpeta de analisis creamos un archivo llamado jinja-1.sql.

Código:

        {% set var_name = "All GoHer" %}

        {{ var_name }}

Al compilar da lo siguiente.

All GoHer

Luego, creamos el archivo jinja-2.sql.

Código:

        {% set inc_flag = 1 %}
        {% set last_load = 3 %}

        {% set cols_list = ["sales_id", "date_sk", "gross_amount"] %}

        SELECT 
    
            {% for i in cols_list %} 
                {{ i }},
                {% if not loop.last %}, {% endif %}
            {% endfor %}
    
        FROM
            {{ ref('bronze_sales') }}

        {% if inc_flag == 1 %}

            WHERE date_sk > {{ last_load }}

        {% endif %}


Y compilamos.

Luego creamos en la carpeta macro un archivo llamado multimacro.sql.

Código:

        {% macro multiply(col1,col2) %}

            {{ col1 }}*{{ col2 }} 

        {% endmacro %}

Ahora, creamos un nuevo archivo en analyses llamado query_macro.sql

Código:

        SELECT
            {{ multiply(10,50) }} as test_col 

_______________________________________________________________________________________________________________________________________________________________________________________________________________
### SILVER LAYER

En la carpeta silver, creamos un archivo llamado silver_salesinfo.sql.

Código:

        WITH sales AS
        (
            SELECT
                sales_id,
                product_sk
                customer_sk
                gross_amount,
                payment_method
            FROM
                {{ ref('bronze_sales') }}

        ),

        bronze_products AS
        (
            SELECT 
                product_sk,
                category
            FROM 
                {{ ref('bronze_product') }} 
        ),

         customer AS 
        (
            SELECT
                customer_sk,
        
        )

Ahora, volvemos al archivo bronce y entramos al archivo bronce_customer.sql y ejecutamos.

Veremos la siguiente información.

![image](https://github.com/user-attachments/assets/928aabe4-51b0-4a30-b852-198f37bd8fa2)

Ahora, hacemos una nueva consulta.

Código:

        WITH sales AS
        (
            SELECT
                sales_id,
                product_sk,
                customer_sk,
                {{ multiply('unit_price', 'quantity')}} as calculated_gross_amount,
                gross_amount,
                payment_method
            FROM
                {{ ref('bronze_sales') }}

        ),

        products AS
        (
            SELECT 
                product_sk,
                category
            FROM 
                {{ ref('bronze_product') }} 
        ),

        customer AS 
        (
            SELECT
                customer_sk,
                gender
               FROM
                {{ ref('bronze_customer') }}
        )

        SELECT
            sales.sales_id,
            sales.gross_amount,
            sales.payment_method,
            products.category,
            customer.gender
        FROM
            sales
        JOIN
            products ON sales.product_sk = products.product_sk
        JOIN
            customer ON sales.customer_sk = customer.customer_sk

![image](https://github.com/user-attachments/assets/f9dff8e7-1721-47ea-8e66-75e566b14ad8)

Hacemos una nueva consulta.

Código:

       WITH sales AS
       (
           SELECT
               sales_id,
               product_sk,
               customer_sk,
               {{ multiply('unit_price', 'quantity')}} as calculated_gross_amount,
               gross_amount,
               payment_method
           FROM
               {{ ref('bronze_sales') }}

       ),

       products AS
       (
           SELECT 
               product_sk,
               category
           FROM 
               {{ ref('bronze_product') }} 
       ),

       customer AS 
       (
           SELECT
               customer_sk,
               gender
           FROM
               {{ ref('bronze_customer') }}
       )

       joined_query AS (
       SELECT
           sales.sales_id,
           sales.gross_amount,
           sales.payment_method,
           products.category,
           customer.gender
       FROM
           sales
       JOIN
           products ON sales.product_sk = products.product_sk
       JOIN
           customer ON sales.customer_sk = customer.customer_sk
       )

       SELECT
           category,
           gender,
           sum(gross_amount) as total_sales
       FROM
           joined_query
       GROUP BY
           category,
           gender
       ORDER BY
            total_sales DESC


![image](https://github.com/user-attachments/assets/6152b324-32fb-4c46-aec3-5f2ea86b5f8f)

Nos dirigimos ahora a la terminal y, ejecutamos el siguiente código.

Código:

       dbt run --select "model/silver"

![image](https://github.com/user-attachments/assets/0d4ffa46-56ad-4b3e-b86c-53a47db4f19e)

![image](https://github.com/user-attachments/assets/db8fc564-b146-4357-a7d1-9cfa063b807c)

En Databricks entramos workspace DBT  y creamos un query

Código:

       CREATE TABLE items
       (
           id INT,
           name STRING,
           category STRING,
           updated TIMESTAMP

       );

       INSERT INTO items
       VALUES
       (1, 'item1', 'category1', current_timestamp()),
       (2, 'item2', 'category2', current_timestamp()),
       (3, 'item3', 'category3', current_timestamp());

![image](https://github.com/user-attachments/assets/3fce0fab-7ca8-450b-bf00-17b2aca4a3ac)

Ahora, en la carpeta snapshots crearemos un archivo llamado gold_items.yml

![image](https://github.com/user-attachments/assets/6a304654-7fb5-430a-8dfd-f2614f9f6f96)

Previo a ello, en la carpeta sources seleccionamos el archivo source y agregamos el name: ítems, para el proceso.

![image](https://github.com/user-attachments/assets/34ded69c-b87e-43ec-9bce-ef61469ba7a8)

Y también, en la carpeta models/gold creamos el archivo source_gold_items.sql

Código:

       WITH dedup_query AS
       (
           SELECT 
                *,
               ROW_NUMBER() OVER(PATITION BY id ORDER BY updateDate DESC) as deduplication_id
           FROM
               {{ ref('source', 'items') }}
       )
       SELECT
           id,name,category,updateDate
       FROM
           dedup_query
       WHERE
           deduplication_id = 1



como quedo pendiente, en el archivo sanpshots/gold_items.yml pasamos el siguiente código.

Código:

       snapshots:
           -name: gold_items
           relation: ref('source_gold_items')
            config:
               schema: gold
               database: dbt_dev
               unique_key: id
               strategy: timestamp
               update_at: updateDate
               dbt_valid_to_current: "to_date('9999-12-31')"


luego ejecutamos los siguientes códigos en la terminal.

Código:

       dbt snapshot


código:

      dbt build


![image](https://github.com/user-attachments/assets/4f207457-9bbd-479b-ac9f-facdd9041965)

Luego en Databricks hacemos la siguiente consulta.

Código:

       SELECT * FROM gold.items

![image](https://github.com/user-attachments/assets/cfad6f6b-1890-49cd-b7c5-d8200f09ced5)

![image](https://github.com/user-attachments/assets/52909303-6cb3-48c3-8c38-b35c56e75218)

Ahora, creamos un catálogo.

![image](https://github.com/user-attachments/assets/86ff9d07-3190-44d0-9a20-fab5f1c2269d)

Luego, creamos el esquema.

![image](https://github.com/user-attachments/assets/d9c7b802-1cfc-46bc-99b8-bcd3b02be446)

Creamos las siguientes tablas.

![image](https://github.com/user-attachments/assets/c338bff1-6402-4bfd-b994-19b5390ac852)

![image](https://github.com/user-attachments/assets/2fed9c91-922a-46e0-8ab1-eb1dbd1c1a3e)

![image](https://github.com/user-attachments/assets/bbeded8c-8776-40e3-b35c-cc4b12cd62c2)

![image](https://github.com/user-attachments/assets/72547b86-4a8d-4760-875f-843f29b80ce9)

![image](https://github.com/user-attachments/assets/b58b632f-c3e4-4bd7-b1f5-c691dbd115c3)

![image](https://github.com/user-attachments/assets/50d63f60-9ca9-4808-a616-c27bae62898b)

![image](https://github.com/user-attachments/assets/5421a774-b198-4809-b8b5-caf7d5955f9d)

![image](https://github.com/user-attachments/assets/30216a74-128b-4e80-a4e1-4eed3d09a17c)

![image](https://github.com/user-attachments/assets/bc2673ca-6047-484b-b1c9-eb3115ff08ec)

![image](https://github.com/user-attachments/assets/ea47ec24-311a-47e7-bf31-c099ab9f6c10)



