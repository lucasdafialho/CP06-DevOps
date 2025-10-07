-- =============================================
-- Script DDL - Sistema de Biblioteca
-- Database: BibliotecaDB
-- =============================================

-- Criar Database (caso não exista)
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'BibliotecaDB')
BEGIN
    CREATE DATABASE BibliotecaDB;
END
GO

USE BibliotecaDB;
GO

-- =============================================
-- Tabela: Autores (Master)
-- Descrição: Armazena informações dos autores
-- =============================================
CREATE TABLE Autores (
    Id INT IDENTITY(1,1) NOT NULL,
    Nome NVARCHAR(200) NOT NULL,
    Nacionalidade NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Autores PRIMARY KEY CLUSTERED (Id ASC)
);
GO

-- =============================================
-- Tabela: Livros (Detail)
-- Descrição: Armazena informações dos livros
-- =============================================
CREATE TABLE Livros (
    Id INT IDENTITY(1,1) NOT NULL,
    Titulo NVARCHAR(300) NOT NULL,
    AnoPublicacao INT NOT NULL,
    AutorId INT NOT NULL,
    CONSTRAINT PK_Livros PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_Livros_Autores FOREIGN KEY (AutorId) 
        REFERENCES Autores(Id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
GO

-- =============================================
-- Índices para otimização de consultas
-- =============================================
CREATE NONCLUSTERED INDEX IX_Livros_AutorId 
ON Livros(AutorId);
GO

CREATE NONCLUSTERED INDEX IX_Autores_Nome 
ON Autores(Nome);
GO

CREATE NONCLUSTERED INDEX IX_Livros_Titulo 
ON Livros(Titulo);
GO

-- =============================================
-- Dados de exemplo (opcional para testes)
-- =============================================
-- Inserir autores de exemplo
INSERT INTO Autores (Nome, Nacionalidade) VALUES 
('Machado de Assis', 'Brasileira'),
('Clarice Lispector', 'Brasileira'),
('Paulo Coelho', 'Brasileira');
GO

-- Inserir livros de exemplo
INSERT INTO Livros (Titulo, AnoPublicacao, AutorId) VALUES 
('Dom Casmurro', 1899, 1),
('Memórias Póstumas de Brás Cubas', 1881, 1),
('A Hora da Estrela', 1977, 2),
('O Alquimista', 1988, 3);
GO

-- =============================================
-- Script de validação
-- =============================================
-- Verificar estrutura das tabelas
SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    ty.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable
FROM sys.tables t
INNER JOIN sys.columns c ON t.object_id = c.object_id
INNER JOIN sys.types ty ON c.user_type_id = ty.user_type_id
WHERE t.name IN ('Autores', 'Livros')
ORDER BY t.name, c.column_id;
GO

-- Verificar Foreign Keys
SELECT 
    fk.name AS ForeignKeyName,
    tp.name AS ParentTable,
    cp.name AS ParentColumn,
    tr.name AS ReferencedTable,
    cr.name AS ReferencedColumn
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
INNER JOIN sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id
WHERE tp.name IN ('Autores', 'Livros') OR tr.name IN ('Autores', 'Livros');
GO

