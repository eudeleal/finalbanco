/*
DELIMITER $$

CREATE PROCEDURE SlctCC()
BEGIN

    SELECT * FROM cliente

END $$

DELIMITER;

DELIMITER $$
CREATE PROCEDURE selec(tebela VARCHAR)
DECLARE tabela VARCHAR
BEGIN
    SELECT * FROM tabela;
END $$
DELIMITER ;
*/

DELIMITER $$

CREATE PROCEDURE Transferencia (
    varIdcontaO int(11), 
    varIdcontaD int(11), 
    varValor double
)
BEGIN
    DECLARE saldoD int;
    saldoO = select contacorrente.saldo from contacorrente WHERE idconta = varIdcontaD
    
    if ((saldoO+limite)-varValor>0)

        UPDATE TABLE contacorrente SET
        saldo = saldo + varValor
        WHERE idconta = varIdcontaD;
    
    END IF

END$$
DELIMITER ;

DROP PROCEDURE verTipo;

CALL verTipo('3');

SELECT descricao FROM tipoconta WHERE tipo = '1';

DISABLE TRIGGER contacorrente.tglogCC ON contacorrente;

SHOW TRIGGERS;

UPDATE contacorrente
SET saldo = 10,2,
WHERE idconta = 1;

SELECT * FROM contacorrente;

ALTER TRIGGER