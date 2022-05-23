-- |=| Criação das Tabelas:


CREATE TABLE IF NOT EXISTS gerente(
    idgerente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS cliente(
    idcliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(40) NOT NULL,
    cpf INT NOT NULL
);

CREATE TABLE IF NOT EXISTS contacorrente(
    idconta INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idgerente INT NOT NULL,
    idcliente INT NOT NULL,
    numero INT NOT NULL,
    saldo DOUBLE,
    limiteTotal DOUBLE NOT NULL DEFAULT 0,
    limiteUtilizado DOUBLE NOT NULL  DEFAULT 0,
    tipo CHAR NOT NULL DEFAULT 's',
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS poupanca(
    idpoupanca INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idgerente INT NOT NULL,
    idcliente INT NOT NULL,
    numero INT NOT NULL,
    saldo DOUBLE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    dtrendimento DATE
);

CREATE TABLE IF NOT EXISTS tipoconta(
    tipo VARCHAR(1) NOT NULL PRIMARY KEY,
    descricao VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS tipotransacao(
	tipo CHAR NOT NULL PRIMARY KEY,
	descricao VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS movimentacao(
    idmovimentacao INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idconta INT NOT NULL DEFAULT 0,
    idpoupanca INT NOT NULL DEFAULT 0,
    datamovimentacao DATE,
    tipoconta VARCHAR(1) NOT NULL,
    valor DOUBLE NOT NULL,
    tipotransacao VARCHAR(1) NOT NULL
);

-- |=| Criação das Restrições e Relações:

ALTER TABLE contacorrente
    ADD CONSTRAINT fkgerenteconta FOREIGN KEY(idgerente) REFERENCES gerente(idgerente) ON UPDATE CASCADE,
    ADD CONSTRAINT fkclienteconta FOREIGN KEY(idcliente) REFERENCES cliente(idcliente) ON UPDATE CASCADE
;

ALTER TABLE poupanca
    ADD CONSTRAINT fkgerentepoupanca FOREIGN KEY(idgerente) REFERENCES gerente(idgerente) ON UPDATE CASCADE,
    ADD CONSTRAINT fkclientepoupanca FOREIGN KEY(idcliente) REFERENCES cliente(idcliente) ON UPDATE CASCADE
;

ALTER TABLE movimentacao
    ADD CONSTRAINT fkidtipoconta FOREIGN KEY(tipoconta) REFERENCES tipoconta(tipo) ON UPDATE CASCADE,
    ADD CONSTRAINT fkidtipotransacao FOREIGN KEY(tipotransacao) REFERENCES tipotransacao(tipo) ON UPDATE CASCADE
;

-- |=| Alimentação de dados ao banco:

INSERT INTO cliente (nome, cpf) VALUES
("Larissa", 14785236),
("Carlos", 78512565)
;

INSERT INTO gerente (nome) VALUES
("Caio")
;

INSERT INTO contacorrente (idgerente ,idcliente, numero, saldo, limiteTotal) VALUES
(1 ,1, 35795125, 2000.00, 1500.00),
(1, 2, 98562147, 5000.00, 600.00)
;

INSERT INTO poupanca (idgerente ,idcliente, numero, saldo) VALUES
(1 ,1, 95165485, 500.50),
(1, 2, 36987412, 100.00)
;

INSERT INTO tipoconta (tipo, descricao) VALUES
(1, "Conta Corrente"),
(2, "Conta Poupanca")
;

INSERT INTO tipotransacao VALUES
(1, "Deposito"),
(2, "Saque"),
(3, "Trasferencia")
;

SELECT * FROM tipotransacao; 

-- |=| Criação das TRIGGERS

DELIMITER $$

    create trigger IF NOT EXISTS tglogCC
    after update ON contacorrente
    for each row 
    begin
        if(new.saldo > old.saldo) then
            insert into movimentacao (idconta, datamovimentacao, tipoconta, valor, tipotransacao) values
            (old.idconta, curdate(),1,new.saldo - old.saldo,1);
        else
            insert into movimentacao (idconta, datamovimentacao, tipoconta, valor, tipotransacao) values
            (old.idconta, curdate(),1,old.saldo - new.saldo,2);
        end if;
    END$$

DELIMITER ;

DELIMITER $$

    create trigger IF NOT EXISTS tglogCP
    after update ON poupanca
    for each row 
    begin
        if(new.saldo > old.saldo) then
            insert into movimentacao (idpoupanca, datamovimentacao, tipoconta, valor, tipotransacao) values
            (old.idpoupanca, curdate(),2,new.saldo - old.saldo,1);
        else
            insert into movimentacao (idpoupanca, datamovimentacao, tipoconta, valor, tipotransacao) values
            (old.idpoupanca, curdate(),2,old.saldo - new.saldo,2);
        end if;
    END$$

DELIMITER ;