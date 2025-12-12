-- ============================================================
--  Banco de Dados: wk_pedidos
--  Dump ajustado para execução automática em ambiente limpo
-- ============================================================

CREATE DATABASE IF NOT EXISTS wk_pedidos
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE wk_pedidos;

-- ------------------------------------------------------------
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
-- Host: localhost    Database: wk_pedidos
-- Server version 5.7.44-log
-- ------------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- ============================================================
-- TABELA: clientes
-- ============================================================

DROP TABLE IF EXISTS `clientes`;
CREATE TABLE `clientes` (
  `codigo` int(11) NOT NULL,
  `nome` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cidade` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `uf` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`codigo`),
  KEY `idx_clientes_nome` (`nome`),
  KEY `idx_clientes_cidade` (`cidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `clientes` VALUES
(1,'Ana Costa','São Paulo','SP'),
(2,'Marcos Silva','Campinas','SP'),
(3,'João Pedro','Rio de Janeiro','RJ'),
(4,'Clara Mendes','Belo Horizonte','MG'),
(5,'Carlos Souza','Curitiba','PR'),
(6,'Jéssica Almeida','Salvador','BA'),
(7,'Pedro Ribeiro','Fortaleza','CE'),
(8,'Bruna Lima','Goiânia','GO'),
(9,'Renato Rocha','Manaus','AM'),
(10,'Fabiana Torres','Recife','PE'),
(11,'Luiz Fernando','São Paulo','SP'),
(12,'Patrícia Gomes','Santos','SP'),
(13,'Gabriel Dias','Uberlândia','MG'),
(14,'Fernanda Luz','Belém','PA'),
(15,'Mateus Faria','Vitória','ES'),
(16,'Juliana Prado','Maceió','AL'),
(17,'Rafael Moreira','João Pessoa','PB'),
(18,'Bianca Freitas','São Luís','MA'),
(19,'Ricardo Martins','Porto Alegre','RS'),
(20,'Letícia Barros','Florianópolis','SC');

-- ============================================================
-- TABELA: produtos
-- ============================================================

DROP TABLE IF EXISTS `produtos`;
CREATE TABLE `produtos` (
  `codigo` int(11) NOT NULL,
  `descricao` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `preco_venda` decimal(10,2) NOT NULL,
  PRIMARY KEY (`codigo`),
  KEY `idx_produtos_descricao` (`descricao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `produtos` VALUES
(1,'Tinta branca 1L',29.90),
(2,'Tinta azul 1L',31.50),
(3,'Tinta preta 1L',32.00),
(4,'Tinta vermelha 1L',33.75),
(5,'Rolo de pintura 23cm',15.90),
(6,'Pincel 2"',8.50),
(7,'Bandeja para tinta',12.00),
(8,'Lixa fina',2.50),
(9,'Solvente 500ml',9.90),
(10,'Massa corrida 1kg',17.40),
(11,'Primer preparador 500ml',22.90),
(12,'Tinta premium branca 1L',39.90),
(13,'Tinta fosca preta 1L',34.90),
(14,'Tinta esmalte 1L',36.50),
(15,'Removedor 500ml',11.90),
(16,'Lixa grossa',3.00),
(17,'Espátula 8cm',6.50),
(18,'Fita crepe 18mm',4.90),
(19,'Fita crepe 50mm',8.90),
(20,'Rolo antirespingos',18.50);

-- ============================================================
-- TABELA: pedidos
-- ============================================================

DROP TABLE IF EXISTS `pedidos`;
CREATE TABLE `pedidos` (
  `numero_pedido` int(11) NOT NULL AUTO_INCREMENT,
  `data_emissao` datetime NOT NULL,
  `codigo_cliente` int(11) NOT NULL,
  `valor_total` decimal(12,2) NOT NULL,
  PRIMARY KEY (`numero_pedido`),
  KEY `idx_pedidos_data` (`data_emissao`),
  KEY `idx_pedidos_cliente` (`codigo_cliente`),
  CONSTRAINT `fk_pedidos_cliente`
    FOREIGN KEY (`codigo_cliente`) REFERENCES `clientes` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABELA: produtos_pedido
-- ============================================================

DROP TABLE IF EXISTS `produtos_pedido`;
CREATE TABLE `produtos_pedido` (
  `autoincrem` int(11) NOT NULL AUTO_INCREMENT,
  `numero_pedido` int(11) NOT NULL,
  `codigo_produto` int(11) NOT NULL,
  `quantidade` double NOT NULL,
  `vr_unitario` decimal(10,2) NOT NULL,
  `vr_total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`autoincrem`),
  KEY `fk_produtos_pedido_pedido` (`numero_pedido`),
  KEY `fk_produtos_pedido_produto` (`codigo_produto`),
  CONSTRAINT `fk_produtos_pedido_pedido`
    FOREIGN KEY (`numero_pedido`) REFERENCES `pedidos` (`numero_pedido`),
  CONSTRAINT `fk_produtos_pedido_produto`
    FOREIGN KEY (`codigo_produto`) REFERENCES `produtos` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- FINALIZAÇÃO
-- ============================================================

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
