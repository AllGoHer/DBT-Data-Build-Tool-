# Data Build Tool

CAPA BRONCE
CODIGO:
SELECT * FROM dbt_dev.source.fact_sales

Luego, ejecutamos.
 
 
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


 
Ahora creamos el archivo bronce_returns.
Código:
SELECT
    *
FROM
    {{ source('source','fact_returns') }}


 

 

 
 
 
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

 

 
Ahora vamos a limpiar la carpeta de destino con dbt clean
 
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
 

Ahora, en la terminal veremos el estatus de git.
Código:
Cd ..

Código:
Git status
 

Código:
Git add .

Código:
git commit -m "bronze layer"

 
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

 

En la terminal entramos al proyecto.
Código:
Cd all_GoHer_project

 
Bash:
  
Dbt run

 
 
Ahora, vamos a Databricks para verificar que se ha creado.
 

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
          
 
PRUEBAS GENERICAS
Ahora, probaremos ejecutándolo.
Código:
Dbt test

 
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

 
PRUEBAS SINGULARES
Vamos hacer una prueba para asegurarnos que en el archivo de ventas no haya un monto negativo a excepción de la columna de descuentos.
Para ello, nos dirigimos a la carpeta de test y creamos un archivo llamado non_negative_test.sql 

 

Nota: en las pruebas singulares las condicionales van en orden inverso, si devuelve algún resultado se tomará como un registro.

Código:
SELECT 
    * 
FROM
    {{  ref('bronze_sales') }}
WHERE
    gross_amount < 0 AND net_amount < 0

 

Como vemos, no hay ningún tipo de registro, quiere decir que se superó la prueba.
Ahora, se añadirá esta prueba, así es que, en la terminal se ejecutará nuevamente dbt test.
 

Como podemos ver, ahora tenemos 6 data tests, uno más del anterior.

PRUEBA GENERICA PERSONALIZADA

 
 
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
 
DBT SEEDS
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

 
Ahora, verificamos que en el archivo lookup se haya creado en Databricks.
 
Si queremos hacer consultas, nos vamos a nuestra carpeta de analisis, para ello, crearemos un archivo llamado explore.sql
Código:
SELECT * FROM  {{ ref('lookup') }}

 
Luego, salimos de la carpeta de proyecto y ejecutamos los siguientes comandos git.
Código:

cd ..

código:

git add .

código:

git commit -m “sedes, test, etc”

 
 
JINJA & MACROS
 
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

SILVER LAYER
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

 
Nos dirigimos ahora a la terminal y, ejecutamos el siguiente código.
Código:
dbt run --select "model/silver"
 
 
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
       
       
Ahora, en la carpeta snapshots crearemos un archivo llamado gold_items.yml
 
Previo a ello, en la carpeta sources seleccionamos el archivo source y agregamos el name: ítems, para el proceso.
 
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
 

Luego en Databricks hacemos la siguiente consulta.
Código:
SELECT * FROM gold.items


 
 


Ahora, creamos un catálogo.
 
Luego, creamos el esquema.
 
Creamos las siguientes tablas.
 

 


 

 

 

 
 


 

 

	
