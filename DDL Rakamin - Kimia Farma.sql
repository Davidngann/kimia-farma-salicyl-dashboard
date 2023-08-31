CREATE DATABASE kimia_farma_db;

use kimia_farma_db;

CREATE TABLE grup_dim(
    id_grup VARCHAR(10) PRIMARY KEY,
    nama_grup VARCHAR(255) NOT NULL
);

CREATE TABLE cabang_sales_dim(
    id_cabang_sales VARCHAR(10) PRIMARY KEY,
    kota_cabang_sales VARCHAR(255) NOT NULL
);

CREATE TABLE merek_dim(
    id_merek VARCHAR(10) PRIMARY KEY,
    nama_merek VARCHAR(255) NOT NULL
);

CREATE TABLE barang_dim(
    id_barang VARCHAR(10) PRIMARY KEY,
    nama_barang VARCHAR(255) NOT NULL,
    nama_tipe VARCHAR(50),
    id_merek VARCHAR(10),
    kemasan VARCHAR(50), 
    harga DECIMAL(15,2),
    FOREIGN KEY (id_merek) REFERENCES merek_dim(id_merek)
);

CREATE TABLE pelanggan_dim(
    id_pelanggan VARCHAR(50) PRIMARY KEY,
    level VARCHAR(50),
    nama_pelanggan VARCHAR(255) NOT NULL,
    id_cabang_sales VARCHAR(10),
    id_grup VARCHAR(10),
    FOREIGN KEY (id_cabang_sales) REFERENCES cabang_sales(id_cabang_sales),
    FOREIGN KEY (id_grup) REFERENCES grup(id_grup)
);

CREATE TABLE penjualan_fact(
    id_invoice VARCHAR(10) PRIMARY KEY,
    id_distributor VARCHAR(10),
    id_cabang_sales VARCHAR(10),
    tanggal DATE,
    id_pelanggan VARCHAR(50),
    id_barang VARCHAR(10),
    jumlah_barang INT,
    unit VARCHAR(10),
    harga_per_unit INT,
    mata_uang VARCHAR(3),
    id_merek VARCHAR(10),
    FOREIGN KEY (id_cabang_sales) REFERENCES cabang_sales_dim(id_cabang_sales),
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan_dim(id_pelanggan),
    FOREIGN KEY (id_barang) REFERENCES barang_dim(id_barang),
    FOREIGN KEY (id_merek) REFERENCES merek_dim(id_merek)
);

-- Aggregate table
CREATE TABLE penjualan_per_hari
    SELECT
        jual.tanggal as tanggal,
        jual.id_distributor AS distributor,
        brg.nama_barang as nama_barang,
        merek.nama_merek as merek,
        cbg.kota_cabang_sales as kota,
        count(jual.id_invoice) AS total_transaksi,
        SUM(jumlah_barang) as total_barang,
        SUM(jual.harga_per_unit * jual.jumlah_barang) as total_pendapatan
    FROM penjualan_fact jual
        JOIN barang_dim brg ON jual.id_barang = brg.id_barang
        JOIN cabang_sales_dim cbg ON jual.id_cabang_sales = cbg.id_cabang_sales
        JOIN merek_dim merek ON jual.id_merek = merek.id_merek
;
