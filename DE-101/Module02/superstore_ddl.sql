-- ************************************** dim_calendar

CREATE TABLE demipt3.mknn_store_dim_calendar
(
 order_date date NOT NULL,
 ship_date  date NOT NULL,
 year       int NOT NULL,
 quarter    varchar(5) NOT NULL,
 month      int NOT NULL,
 week       int NOT NULL,
 week_day   int NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( order_date, ship_date )
);

-- ************************************** dim_geography

CREATE TABLE demipt3.mknn_store_dim_geography
(
 geo_id      int NOT NULL,
 country     varchar(20) NOT NULL,
 city        varchar(20) NOT NULL,
 "state"       varchar(20) NOT NULL,
 region      varchar(20) NOT NULL,
 postal_code int NOT NULL,
 CONSTRAINT PK_2 PRIMARY KEY ( geo_id )
);

-- ************************************** dim_product

CREATE TABLE demipt3.mknn_store_dim_product
(
 product_id   varchar(20) NOT NULL,
 category     varchar(20) NOT NULL,
 sub_category varchar(20) NOT NULL,
 segment      varchar(20) NOT NULL,
 product_name varchar(150) NOT NULL,
 CONSTRAINT PK_3 PRIMARY KEY ( product_id )
);

CREATE TABLE demipt3.mknn_store_dim_shipping
(
 ship_id   int NOT NULL,
 ship_mode varchar(15) NOT NULL,
 CONSTRAINT PK_4 PRIMARY KEY ( ship_id )
);

-- ************************************** fact_sales

CREATE TABLE demipt3.mknn_store_fact_sales
(
 row_id     int NOT NULL,
 order_id   varchar(20) NOT NULL,
 ship_id    int NOT NULL,
 order_date date NOT NULL,
 geo_id     int NOT NULL,
 ship_date  date NOT NULL,
 product_id varchar(20) NOT NULL,
 sales      decimal(9,6) NOT NULL,
 quantity   int NOT NULL,
 discount   decimal(2,2) NOT NULL,
 profit     decimal(9,6) NOT NULL,
 CONSTRAINT PK_5 PRIMARY KEY ( row_id ),
 CONSTRAINT FK_1 FOREIGN KEY ( product_id ) REFERENCES demipt3.mknn_store_dim_product ( product_id ),
 CONSTRAINT FK_2 FOREIGN KEY ( geo_id ) REFERENCES demipt3.mknn_store_dim_geography ( geo_id ),
 CONSTRAINT FK_3 FOREIGN KEY ( order_date, ship_date ) REFERENCES demipt3.mknn_store_dim_calendar ( order_date, ship_date ),
 CONSTRAINT FK_4 FOREIGN KEY ( ship_id ) REFERENCES demipt3.mknn_store_dim_shipping ( ship_id )
);

CREATE INDEX FK_1 ON demipt3.mknn_store_fact_sales
(
 product_id
);

CREATE INDEX FK_2 ON demipt3.mknn_store_fact_sales
(
 geo_id
);

CREATE INDEX FK_3 ON demipt3.mknn_store_fact_sales
(
 order_date,
 ship_date
);

CREATE INDEX FK_4 ON demipt3.mknn_store_fact_sales
(
 ship_id
);