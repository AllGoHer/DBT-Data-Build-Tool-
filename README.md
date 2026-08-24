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


![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()

![image]()
